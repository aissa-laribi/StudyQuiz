from fastapi import APIRouter, Depends, HTTPException
from app.models import User, Module, Quiz, Question, Followup
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db

router = APIRouter()



@router.get("/users/{user_id}/followups")
async def get_follow_up_quizzes(user_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Followup).where(Followup.user_id == user_id).order_by(Followup.followup_due_date))
    followups = result.scalars().all()
    return followups

@router.get("/users/{user_id}/followups/{module_id}/{quiz_id}")
async def get_follow_up_quiz(user_id: int,module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Followup).where(Followup.user_id == user_id).where(Followup.module_id == module_id).where(Followup.quiz_id == quiz_id).order_by(Followup.followup_due_date))
    followup = result.scalars().all()
    return followup