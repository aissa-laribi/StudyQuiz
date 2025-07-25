from fastapi import APIRouter, Depends, HTTPException,status
from app.database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models import User, Module, Quiz, Question,Answer, Attempt, Followup
from app.schemas import AttemptCreate, FollowupCreate
from app.routes.question import get_questions
from app.routes.quiz import get_quiz
import random
from datetime import datetime, timedelta
from app.routes.user import router, get_current_active_user
from typing import Annotated
router = APIRouter()

def fgd_shuffling(array: list, size: int):
    """Pseudocode from https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
    -- To shuffle an array a of n elements (indices 0..n-1):
    for i from 0 to n−2 do
        j ← random integer such that i ≤ j ≤ n-1
        exchange a[i] and a[j]
    """
    i = 0
    j = 0

    while i < size - 1:
        j = random.randint(i, size - 1)
        temp = array[i]
        array[i] = array[j]
        array[j] = temp
        i += 1
    return array


@router.post("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/attempts/")
async def take_quiz(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, attempt: AttemptCreate, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await get_questions(current_user,user_id, module_id, quiz_id, db)
        questions = fgd_shuffling(result,len(result))
        #print(questions)
        correct_answers = 0
        selected_answer = 0
        score = 0
        quiz = await get_quiz(current_user,user_id , module_id , quiz_id, db)
    
        if quiz.repetitions is None:
            quiz.repetitions = 0
            quiz.interval = 0
            quiz.ease_factor = 2.5
            db.add(quiz)
            await db.commit()
            await db.refresh(quiz)

        for question in questions:
            answers_result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question.id))
            answers = answers_result.scalars().all()
            print(question.question_name)
            array = [0] * len(answers)
            i = 0
            for answer in answers:
                print(str(i + 1) + ": " + answer.answer_name)
                array[i] = answer
                i += 1
            while(1):
                try:
                    selected_answer = int(input())
                    if selected_answer <= len(answers):
                        break
                    print("Please enter a value between 1 and " + str(len(answers)))
                except Exception:
                    print("Please enter a value between 1 and " + str(len(answers)))
            if array[selected_answer - 1].answer_correct:
                correct_answers += 1
            else:
                result = await db.execute(
                    select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question.id).where(Answer.answer_correct == True))
                correct_answer = result.scalars().first()
                if correct_answer == None:
                    print("Error: correct answer not in the db")
                else:
                    print("Wrong, correct answer is " + str(correct_answer.answer_name))
        print(len(questions))
        score = round((correct_answers/len(questions))*100)
        print("Result: " + str(round((correct_answers/len(questions))*100)) + "%")
        attempt = Attempt(attempt_score=score, created_at=datetime.now(), user_id=user_id, module_id=module_id, quiz_id=quiz_id)
        db.add(attempt)
        await db.commit()
        await db.refresh(attempt)
        if score < 60:
            quiz.interval = 1
            quiz.repetitions = 0
        else:
            quiz.repetitions += 1
            if quiz.repetitions == 1:
                quiz.interval = 1
            elif quiz.repetitions == 2:
                quiz.interval = 6
            else:
                quiz.interval = round(quiz.interval * quiz.ease_factor)
        if score >= 90:
            quality = 5
        elif score >= 80:
            quality = 4
        elif score >= 70:
            quality = 3
        elif score >= 60:
            quality = 2
        else:
            quality = 0
        quiz.ease_factor += (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
        if quiz.ease_factor < 1.3:
            quiz.ease_factor = 1.3
        quiz.next_due = datetime.now() + timedelta(days=quiz.interval)
        quiz.last_score = score
        db.add(quiz)
        await db.commit()
        await db.refresh(quiz)
        #await post_follow_up_quiz(quiz.user_id,quiz.module_id,quiz.id,AttemptCreate,quiz.next_due,db)
        print("Next due date: "+ str(quiz.next_due))
        result = await db.execute(
            select(Followup).where(
                Followup.user_id == user_id,
                Followup.module_id == module_id,
                Followup.quiz_id == quiz_id
            )
        )
        followup = result.scalar_one_or_none()
        if followup:
            followup.followup_due_date = quiz.next_due
        else:
            followup = Followup(followup_due_date = quiz.next_due, user_id = user_id, module_id = module_id, quiz_id = quiz.id)
        db.add(followup)
        await db.commit()
        await db.refresh(followup)
        return attempt.id
    else:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/attempts")
async def get_attempts(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Attempt).where(Attempt.user_id == user_id).where(Attempt.module_id == module_id).where(Attempt.quiz_id == quiz_id))
        attempts = result.scalars().all()
        return attempts
    else:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/attempts/{attempt_id}")
async def get_attempt(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, attempt_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Attempt).where(Attempt.user_id == user_id).where(Attempt.module_id == module_id).where(Attempt.quiz_id == quiz_id).where(Attempt.id == attempt_id))
        attempt = result.scalars().all()
        return attempt
    else:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")