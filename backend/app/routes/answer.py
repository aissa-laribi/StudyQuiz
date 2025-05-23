from fastapi import APIRouter, Depends, HTTPException
from app.models import User, Module, Quiz, Question, Answer
from app.schemas import AnswerCreate
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db

router = APIRouter()

@router.post("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id: int}/answers/")
async def create_answer(user_id: int, module_id: int, quiz_id: int, question_id: int, answer: AnswerCreate ,db: AsyncSession = Depends(get_db)):
    new_answer = Answer(answer_name= answer.name, answer_correct = answer.correct, user_id=user_id, module_id=module_id, quiz_id=quiz_id, question_id = question_id)
    db.add(new_answer)
    await db.commit()
    await db.refresh(new_answer)
    return new_answer.id

@router.patch("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id: int}/answers/{answer_id}")
async def update_answer(user_id: int, module_id: int, quiz_id: int, question_id: int, answer_id: int, answer_correct: bool ,new_data: dict, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question_id).where(Answer.id == answer_id))
    answer = result.scalars().first()

    if not answer:
        raise HTTPException(status_code=404, detail="Answer not found")

    for key, value in new_data.items():
        setattr(answer, key, value)

    # Commit the changes
    db.add(answer)
    await db.commit()
    await db.refresh(answer)
    return answer.id

@router.delete("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer_id}")
async def delete_answer(user_id: int, module_id: int, quiz_id: int, question_id: int, answer_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question_id).where(Answer.id == answer_id))
    answer = result.scalars().first()

    if not answer:
        raise HTTPException(status_code=404, detail="Answer not found for user")
    await db.delete(answer)
    await db.commit()
    
    return {"message": "answer deleted successfully", "answer_id": answer_id}

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer_id}")
async def get_answer(user_id: int, module_id: int, quiz_id: int, question_id: int, answer_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question_id).where(Answer.id == answer_id))
    answer = result.scalars().first()

    if not answer:
        raise HTTPException(status_code=404, detail="Module not found for user" + str(user_id))
    return answer


@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
async def get_answers(user_id: int, module_id: int, quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question_id))
    answers = result.scalars().all()

    return answers
