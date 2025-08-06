from fastapi import APIRouter, Depends, HTTPException, status
from app.models import User,Module, Quiz, Attempt, Followup
from app.schemas import QuizCreate, BatchQuizCreate, BatchQuizDelete
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.routes.question import delete_all_questions
from app.routes.user import router, get_current_active_user
from typing import Annotated

"""
class Quiz(Base):
    __tablename__ = "quiz"
    id = Column(Integer, primary_key= True, index = True)
    quiz_name = Column(String(245), nullable=False, unique=True)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False, index=True)
    module_id = Column(Integer, ForeignKey("module.id"),nullable=False, index=True)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)    
    module = relationship("Module", back_populates="quizzes")
    questions = relationship("Question", back_populates="quiz")
    attempts = relationship("Attempt", back_populates="quiz")
    followups = relationship("Followup", back_populates="quiz")
"""


router = APIRouter()
@router.post("/users/{user_id}/modules/{module_id}/quizzes/batch-create/")
async def create_quizzes(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quizzes: BatchQuizCreate, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        results = {}
        for quiz in quizzes.data:
            new_quiz = Quiz(user_id=user_id, module_id=module_id, quiz_name=quiz.name)
            db.add(new_quiz)
            await db.flush()
            await db.refresh(new_quiz)
            results[new_quiz.id] = new_quiz.quiz_name
        await db.commit()
        return results
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.post("/users/me/modules/{module_name}/quizzes/")
async def create_quiz_from_module_name(current_user: Annotated[User, Depends(get_current_active_user)], module_name: str, quiz: QuizCreate, db: AsyncSession = Depends(get_db)
):
    user_id = current_user.id
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(
            select(Module).where(Module.module_name == module_name, Module.user_id == user_id)
        )
        module = result.scalars().first()

        if module is None:
            raise HTTPException(status_code=404, detail="Module not found")

        new_quiz = Quiz(
            quiz_name=quiz.name,
            user_id=user_id,
            module_id=module.id
        )

        db.add(new_quiz)
        await db.commit()
        await db.refresh(new_quiz)

        return new_quiz

    raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")


@router.post("/users/{user_id}/modules/{module_id}/quizzes/")
async def create_quiz(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz: QuizCreate, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        new_quiz = Quiz(quiz_name=quiz.name, user_id=user_id, module_id=module_id)
        db.add(new_quiz)
        await db.commit()
        await db.refresh(new_quiz)
        return new_quiz.id
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.patch("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
async def update_quiz(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, new_data: dict, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Quiz).where(Quiz.user_id == user_id).where(Quiz.module_id == module_id).where(Quiz.id == quiz_id))
        quiz = result.scalars().first()

        if not quiz:
            raise HTTPException(status_code=404, detail="Quiz not found")

        for key, value in new_data.items():
            setattr(quiz, key, value)

        # Commit the changes
        db.add(quiz)
        await db.commit()
        await db.refresh(quiz)
        return quiz.id
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.delete("/users/{user_id}/modules/{module_id}/quizzes/batch-delete")
async def delete_quizzes(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        deleted_ids = []
        result = await db.execute(select(Quiz).where(Quiz.user_id == user_id).where(Quiz.module_id == module_id))
        quizzes = result.scalars().all()
        for quiz in quizzes:
            result = await db.execute(
                select(Quiz).where(Quiz.user_id == user_id,Quiz.module_id == module_id, Quiz.id == quiz.id)
            )
            quiz = result.scalars().first()
            await db.delete(quiz)
            deleted_ids.append(quiz.id)
            await db.commit()
        return {"deleted": deleted_ids}
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.delete("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
async def delete_quiz(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Quiz).where(Quiz.user_id == user_id).where(Quiz.module_id == module_id).where(Quiz.id == quiz_id))
        quiz = result.scalars().first()

        if not quiz:
            raise HTTPException(status_code=404, detail="Quiz not found for user" + str(user_id))
        result_followups = await db.execute(select(Followup).where(Followup.user_id == user_id,Followup.module_id == module_id,Followup.quiz_id == quiz_id))
        followups = result_followups.scalars().all()
        for followup in followups:
            await db.delete(followup) 
        result_attempts = await db.execute(select(Attempt).where(Attempt.user_id == user_id,Attempt.module_id == module_id,Attempt.quiz_id == quiz_id))
        attempts = result_attempts.scalars().all()
        for attempt in attempts:
            await db.delete(attempt)
        await delete_all_questions(user_id,module_id,quiz_id,db)
        await db.delete(quiz)
        await db.commit()
    
        return {"message": "Quiz deleted successfully"}
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/me/modules/{module_name}/quizzes/")
async def get_quizzes_by_module_name(current_user: Annotated[User, Depends(get_current_active_user)] ,module_name: str, db: AsyncSession = Depends(get_db)):
    user_id = current_user.id
    result = await db.execute(
        select(Quiz)
        .join(Module, Quiz.module_id == Module.id)
        .where(Module.module_name == module_name)
        .where(Quiz.user_id == user_id)
        .order_by(Quiz.id)
    )
    return result.scalars().all()

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
async def get_quiz(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Quiz).where(Quiz.user_id == user_id).where(Quiz.module_id == module_id).where(Quiz.id == quiz_id))
        quiz = result.scalar()
        if not quiz:
            raise HTTPException(status_code=404, detail="Module not found for user " + str(user_id))
        return quiz
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/{user_id}/modules/{module_id}/quizzes/")
async def get_quizzes(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Quiz).where(Quiz.user_id == user_id, Quiz.module_id == module_id))
        quizzes = result.scalars().all()
        return quizzes
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/{user_id}/quizzes/new")
async def get_quizzes_not_attempted(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:

        result = await db.execute(select(Quiz).where(Quiz.user_id == user_id, Quiz.next_due == None))
        quizzes = result.scalars().all()
        return quizzes
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
