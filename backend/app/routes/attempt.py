from fastapi import APIRouter, Depends, HTTPException
from app.database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models import User, Module, Quiz, Question,Answer, Attempt
from app.schemas import AttemptCreate
import random
from datetime import datetime
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
async def take_quiz(user_id: int, module_id: int, quiz_id: int, attempt: AttemptCreate, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id))
    questions = result.scalars().all()
    questions = fgd_shuffling(questions,len(questions))
    correct_answers = 0
    selected_answer = 0
    #answers_counter = 0
    print(questions[0])
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
    print("Result: " + str(round((correct_answers/len(questions))*100)) + "%")
    #attempt = await Attempt(attempt_score=round((correct_answers/len(questions))*100), created_at=datetime.now,user_id=user_id, module_id=module_id, quiz_id = quiz_id)
    db.add(attempt)
    await db.commit()
    await db.refresh(attempt)
    return attempt.id

    
    