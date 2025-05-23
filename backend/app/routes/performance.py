from fastapi import APIRouter, Depends, HTTPException
from app.database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models import User, Module, Quiz, Question,Answer
router = APIRouter()

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/performance")
async def get_quiz_performance(user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id))
    questions = result.scalars().all()
    quiz_size = len(questions)
    correct_answers = 0
    selected_answer = 0
    #answers_counter = 0
    print(quiz_size)
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
    print("Result: " + str((correct_answers/len(questions))*100) + "%")
    return 
    