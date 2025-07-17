from fastapi import APIRouter, Depends, HTTPException, status
from app.models import User, Module, Quiz, Question, Followup
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.routes.user import router, get_current_active_user
from typing import Annotated

router = APIRouter()



@router.get("/users/{user_id}/followups")
async def get_follow_up_quizzes(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Followup).where(Followup.user_id == user_id).order_by(Followup.followup_due_date))
        followups = result.scalars().all()
        return followups
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/{user_id}/followups/{module_id}/{quiz_id}")
async def get_follow_up_quiz(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int,module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Followup).where(Followup.user_id == user_id).where(Followup.module_id == module_id).where(Followup.quiz_id == quiz_id).order_by(Followup.followup_due_date))
        followup = result.scalars().all()
        return followup
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")