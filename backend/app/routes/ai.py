from datetime import date
import json
import os
import requests
from dotenv import load_dotenv
from fastapi import APIRouter, HTTPException,UploadFile,File,Depends
from typing import Annotated
import tempfile
from app.models import User, Plan, AIUsage
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.routes.user import get_current_active_user
from sqlalchemy import select



load_dotenv(".env")
router = APIRouter()

@router.get("/ai")
async def wake_ai():
    x = requests.get(os.getenv("AI_SYSTEM"))
    return x.status_code



#need user session, AIUsage
@router.post("/ai")
async def receive_from_sq(current_user: Annotated[User, Depends(get_current_active_user)],file: Annotated[bytes, File()],db: AsyncSession = Depends(get_db)):
    #Check Usage
    try:
        #Get plan
        result = await db.execute(select(Plan).where(Plan.id==current_user.plan_id))
        plan = result.scalar_one_or_none()
        if plan is None:
            raise HTTPException(
                status_code=500,
                detail="The user's plan could not be found.",
            )
        result = await db.execute(select(AIUsage).where(AIUsage.user_id==current_user.id).where(AIUsage.usage_date == date.today()))
        usage = result.scalar_one_or_none()
        daily_usage = usage.consumption if usage else 0

        #Get AIUsage
        if daily_usage < plan.ai_daily_allowance:
            fp = tempfile.NamedTemporaryFile()
            fp.write(file)
            files = {'file': open(fp.name, 'rb')}
            x = requests.post(os.getenv("AI_SYSTEM"), files=files)
            if x.status_code == 200:
                fp.close()

                data = x.json()
                if usage:
                    usage.consumption +=1
                else:
                    new_usage = AIUsage(user_id=current_user.id,usage_date=date.today(),consumption=1)
                    db.add(new_usage)
                await db.commit()
                return data
            
            raise HTTPException(
            status_code=419,
            detail="Unprocessable Query")

        raise HTTPException(
            status_code=429,
            detail="You used all your AI allowance. Please try again tomorrow.")

    except HTTPException:
        raise

    except Exception as e:
        print("ERROR:", repr(e))
        raise HTTPException(
            status_code=502,
            detail="AI provider rejected the request. This may be a network or provider permission issue."
        )
    