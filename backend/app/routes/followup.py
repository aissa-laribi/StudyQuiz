from fastapi import APIRouter, Depends, HTTPException
from app.models import User, Module, Quiz, Question, Followup
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db

router = APIRouter()




@router.get("/users/{user_id}/followups")
def get_follow_up_quizzes(user_id: int):
    follow_ups = [
        {"quiz_id": 1, "module_id": 1, "quiz_name": "Gauss-Jordan Algorithm", "due_date": "2025-01-20"},
        {"quiz_id": 2, "module_id": 2, "quiz_name": "Modelling SLE", "due_date": "2025-01-22"},
    ]
    return {"user_id": user_id, "follow_ups": follow_ups}

@router.get("/users/{user_id}/followups/{module_id}/{quiz_id}")
async def get_follow_up_quiz(user_id: int,module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Followup).where(Followup.user_id == user_id).where(Followup.module_id == module_id).where(Followup.quiz_id == quiz_id))
    followup = result.scalars().all()
    return followup