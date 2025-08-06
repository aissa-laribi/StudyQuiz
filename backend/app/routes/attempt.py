from fastapi import APIRouter, Depends, HTTPException,status
from app.database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models import User, Module, Quiz, Question,Answer, Attempt, Followup
from app.schemas import AttemptCreate, FollowupCreate, AttemptCreateClient
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

@router.get("/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/attempts/shuffled-questions")
async def get_questions_from_name_shuffled(
    current_user: Annotated[User, Depends(get_current_active_user)],
    module_name: str,
    quiz_name: str,
    db: AsyncSession = Depends(get_db)
):
    user_id = current_user.id
    result = await db.execute(select(Module).where(Module.user_id == user_id).where(Module.module_name == module_name))
    module = result.scalars().first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found for user " + str(user_id))
    module_id = module.id
    result = await db.execute(select(Quiz).where(Quiz.user_id == user_id).where(Quiz.module_id == module_id).where(Quiz.quiz_name == quiz_name))
    quiz = result.scalars().first()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found for user " + str(user_id))
    result = await get_questions(current_user, user_id, module_id, quiz.id,db)
    questions = fgd_shuffling(result,len(result))
    return questions

@router.post("/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/")
async def post_quiz_attempt(
    current_user: Annotated[User, Depends(get_current_active_user)],
    module_name: str,
    quiz_name: str,
    attempt: AttemptCreateClient,
    db: AsyncSession = Depends(get_db)
):
    user_id = current_user.id

    # Fetch module
    module_result = await db.execute(
        select(Module).where(Module.module_name == module_name, Module.user_id == user_id)
    )
    module = module_result.scalar_one_or_none()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    # Fetch quiz
    quiz_result = await db.execute(
        select(Quiz).where(Quiz.quiz_name == quiz_name, Quiz.user_id == user_id, Quiz.module_id == module.id)
    )
    quiz = quiz_result.scalar_one_or_none()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    # Score computation
    total_questions = len(attempt.answers)
    correct_answers = 0
    wrong_answers = {}

    for ans in attempt.answers:
        answer = await db.get(Answer, ans.answer_id)
        if answer and answer.answer_correct:
            correct_answers += 1
        else:
            result = await db.execute(select(Question).where(Question.user_id == user_id, Question.id == answer.question_id))
            question = result.scalars().first()
            result2 = await db.execute(select(Answer).where(Answer.user_id == user_id, Answer.id == ans.answer_id))
            answer_fetched = result2.scalars().first()
            print(question.question_name + " " + "Selected answer:" + str(answer_fetched.answer_name))
            wrong_answers[question.question_name] = answer_fetched.answer_name
    score = round((correct_answers / total_questions) * 100)

    # Create Attempt
    if attempt.created_at.tzinfo is not None:
        attempt.created_at = attempt.created_at.replace(tzinfo=None)
    
    new_attempt = Attempt(
        user_id=user_id,
        module_id=module.id,
        quiz_id=quiz.id,
        created_at=attempt.created_at,
        attempt_score=score
    )
    db.add(new_attempt)
    await db.commit()
    await db.refresh(new_attempt)

    # Apply SM-2 logic
    if quiz.repetitions is None:
        quiz.repetitions = 0
        quiz.interval = 0
        quiz.ease_factor = 2.5

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

    quality = (
        5 if score >= 90 else
        4 if score >= 80 else
        3 if score >= 70 else
        2 if score >= 60 else
        0
    )

    quiz.ease_factor += (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    quiz.ease_factor = max(1.3, quiz.ease_factor)
    quiz.next_due = datetime.now() + timedelta(days=quiz.interval)
    quiz.last_score = score

    db.add(quiz)
    await db.commit()
    await db.refresh(quiz)

    # Update or insert followup
    followup_result = await db.execute(
        select(Followup).where(
            Followup.user_id == user_id,
            Followup.module_id == module.id,
            Followup.quiz_id == quiz.id
        )
    )
    followup = followup_result.scalar_one_or_none()
    if followup:
        followup.followup_due_date = quiz.next_due
    else:
        followup = Followup(
            followup_due_date=quiz.next_due,
            user_id=user_id,
            module_id=module.id,
            quiz_id=quiz.id
        )
    db.add(followup)
    await db.commit()
    print(quiz.repetitions)
    print(wrong_answers)
    return {
        "attempt_id": new_attempt.id,
        "score": score,
        "correct_answers": correct_answers,
        "total_questions": total_questions,
        "next_due": quiz.next_due,
        "repetitions": quiz.repetitions,
        "interval": quiz.interval,
        "ease_factor": round(quiz.ease_factor, 2),
        "wrong_answers": wrong_answers
    }

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