from fastapi import APIRouter, Depends, HTTPException
from app.models import User, Module, Quiz, Question, Followup
from app.schemas import FollowupCreate
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from datetime import datetime

router = APIRouter()


@router.post("/users/{user_id}/followups/{module_id}/{quiz_id}")
async def post_follow_up_quiz(user_id: int,module_id: int, quiz_id: int, followup: FollowupCreate, due_date: datetime, db: AsyncSession = Depends(get_db)):
    followup = Followup(followup_due_date = due_date, user_id = user_id, module_id = module_id, quiz_id = quiz_id)
    db.add(followup)
    await db.commit()
    await db.refresh(followup)



@router.get("/users/{user_id}/followups")
async def get_follow_up_quizzes(user_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Followup).where(Followup.user_id == user_id))
    followups = result.scalars().all()
    return followups

@router.get("/users/{user_id}/followups/{module_id}/{quiz_id}")
async def get_follow_up_quiz(user_id: int,module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Followup).where(Followup.user_id == user_id).where(Followup.module_id == module_id).where(Followup.quiz_id == quiz_id))
    followup = result.scalars().all()
    return followup