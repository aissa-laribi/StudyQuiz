from fastapi import APIRouter, Depends, HTTPException
from app.models import User,Module, Quiz
from app.schemas import QuizCreate
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db


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

@router.post("/users/{user_id}/modules/{module_id}")
async def create_quiz(user_id: int, module_id: int, quiz: QuizCreate, db: AsyncSession = Depends(get_db)):
    new_quiz = Quiz(quiz_name=quiz.name, user_id=user_id, module_id=module_id)
    db.add(new_quiz)
    await db.commit()
    await db.refresh(new_quiz)
    return new_quiz.id

@router.patch("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
async def update_quiz(user_id: int, module_id: int, quiz_id: int, new_data: dict, db: AsyncSession = Depends(get_db)):
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

@router.delete("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
async def delete_quiz(user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Quiz).where(Quiz.user_id == user_id).where(Quiz.module_id == module_id).where(Quiz.id == quiz_id))
    quiz = result.scalars().first()

    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found for user" + str(user_id))
    await db.delete(quiz)
    await db.commit()
    
    return {"message": "Quiz deleted successfully"}

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
async def get_quiz(user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Quiz).where(Quiz.user_id == user_id).where(Quiz.module_id == module_id).where(Quiz.id == quiz_id))
    quiz = result.scalar()
    if not quiz:
        raise HTTPException(status_code=404, detail="Module not found for user " + str(user_id))
    return quiz

@router.get("/users/{user_id}/modules/{module_id}/quizzes/")
async def get_quizzes(user_id: int, modules_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Quiz).where(Quiz.user_id == user_id).where(Quiz.module_id == modules_id))
    quizzes = result.scalars().all()
    return quizzes