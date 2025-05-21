from fastapi import APIRouter
from sqlalchemy.future import select
from fastapi import FastAPI, APIRouter, Depends, HTTPException#
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from app.schemas import ModuleCreate,ModuleOut
from app.database import get_db
from app.models import User, Module


router = APIRouter()

"""
class Module(Base):
    __tablename__ = "module"
    id = Column(Integer, primary_key= True, index = True)
    module_name = Column(String(245), nullable=False, unique=True)
    user_id= Column(Integer, ForeignKey("user.id"), nullable = False, index=True)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)  
    owner = relationship("User", back_populates="modules")
    quizzes = relationship("Quiz", back_populates="module")
"""

router = APIRouter()

@router.post("/users/{user_id}/modules/")
async def create_module(user_id: int, module: ModuleCreate, db: AsyncSession = Depends(get_db)):
    new_module = Module(module_name=module.name, user_id=user_id)
    db.add(new_module)
    await db.commit()
    await db.refresh(new_module)
    return "Module successfully created"

@router.patch("/users/{user_id}/modules/{module_id}")
async def update_user(user_id: int, module_id: int, new_data: dict, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Module).where(Module.user_id == user_id).where(Module.id == module_id))
    module = result.scalars().first()

    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    for key, value in new_data.items():
        setattr(module, key, value)

    # Commit the changes
    db.add(module)
    await db.commit()
    await db.refresh(module)
    return module

@router.delete("/users/{user_id}/modules/{module_id}")
async def delete_module(user_id: int, module_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Module).where(User.id == user_id).where(Module.id == module_id))
    module = result.scalars().first()

    if not module:
        raise HTTPException(status_code=404, detail="Module not found for user" + str(user_id))
    await db.delete(module)
    await db.commit()
    
    return {"message": "Module deleted successfully", "module_id": module_id}

@router.get("/users/{user_id}/modules/{module_id}")
async def get_user(user_id: int,module_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Module).where(User.id == user_id).where(Module.id == module_id))
    module = result.scalars().first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found for user " + str(user_id))
    return module

@router.get("/users/{user_id}/modules/")
async def get_users(user_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Module).where(Module.user_id == user_id))
    modules = result.scalars().all()
    return modules