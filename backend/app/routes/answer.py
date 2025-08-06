from fastapi import APIRouter, Depends, HTTPException, status
from app.models import User, Module, Quiz, Question, Answer
from app.schemas import AnswerCreate
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.routes.user import router, get_current_active_user
from typing import Annotated
router = APIRouter()

@router.post("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
async def create_answer(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question_id: int, answer: AnswerCreate ,db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        new_answer = Answer(answer_name= answer.name, answer_correct = answer.correct, user_id=user_id, module_id=module_id, quiz_id=quiz_id, question_id = question_id)
        db.add(new_answer)
        await db.commit()
        await db.refresh(new_answer)
        return new_answer.id
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.patch("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer_id}")
async def update_answer(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question_id: int, answer_id: int ,new_data: dict, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
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
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.delete("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer_id}")
async def delete_answer(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question_id: int, answer_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question_id).where(Answer.id == answer_id))
        answer = result.scalars().first()

        if not answer:
            raise HTTPException(status_code=404, detail="Answer not found for user")
        await db.delete(answer)
        await db.commit()
    
        return {"message": "answer deleted successfully", "answer_id": answer_id}
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer_id}")
async def get_answer(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question_id: int, answer_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question_id).where(Answer.id == answer_id))
        answer = result.scalars().first()
        if not answer:
            raise HTTPException(status_code=404, detail="Module not found for user" + str(user_id))
        return answer
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/{question_name}/answers")
async def get_answers_from_question_name(
    current_user: Annotated[User, Depends(get_current_active_user)],
    module_name: str,
    quiz_name: str,
    question_name: str,
    db: AsyncSession = Depends(get_db)
):
    user_id = current_user.id

    result = await db.execute(
        select(Answer)
        .join(Answer.question)
        .join(Question.quiz)
        .join(Quiz.module)
        .where(Answer.user_id == user_id)
        .where(Question.question_name == question_name)
        .where(Quiz.quiz_name == quiz_name)
        .where(Module.module_name == module_name)
        .order_by(Answer.id)
    )
    return result.scalars().all()

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/")
async def get_questions(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id))
        questions = result.scalars().all()

        return questions
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
async def get_answers(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question_id))
        answers = result.scalars().all()
        return answers
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
