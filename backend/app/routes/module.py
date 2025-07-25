from sqlalchemy.future import select
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from app.schemas import ModuleCreate, BatchModules, ModuleUpdate, BatchModulesDelete
from app.database import get_db
from app.models import Module, User
from app.routes.user import router, get_current_active_user
from typing import Annotated

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

@router.post("/users/me/modules/")
async def create_module(current_user: Annotated[User, Depends(get_current_active_user)], module: ModuleCreate, db: AsyncSession = Depends(get_db)):
    user_id = current_user.id
    try:
        if current_user.role == "root" or current_user.id == user_id:
            new_module = Module(module_name=module.name, user_id=user_id)
            db.add(new_module)
            await db.commit()
            await db.refresh(new_module)
            return new_module
        else:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
    except IntegrityError:
        await db.rollback()


@router.post("/users/{user_id}/modules/")
async def create_module(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module: ModuleCreate, db: AsyncSession = Depends(get_db)):
    try:
        if current_user.role == "root" or current_user.id == user_id:
            new_module = Module(module_name=module.name, user_id=user_id)
            db.add(new_module)
            await db.commit()
            await db.refresh(new_module)
            return new_module.id
        else:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
    except IntegrityError:
        await db.rollback()

@router.post("/users/{user_id}/modules/batch-create")
async def create_modules(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, modules: BatchModules,db: AsyncSession = Depends(get_db)):
    results = {}
    if current_user.role == "root" or current_user.id == user_id:
        for module in modules.data:
            new_module = Module(module_name=module.name, user_id=user_id)
            db.add(new_module)
            await db.flush()
            await db.refresh(new_module)
            results[new_module.id] = new_module.module_name
        await db.commit()
        return results
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")


@router.patch("/users/{user_id}/modules/{module_id}")
async def update_module(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, update: ModuleUpdate, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Module).where(Module.user_id == user_id).where(Module.id == module_id))
        module = result.scalars().first()

        if not module:
            raise HTTPException(status_code=404, detail="Module not found")

        update_data = update.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(module, key, value)

        # Commit the changes
        db.add(module)
        await db.commit()
        await db.refresh(module)
        return module.id
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.delete("/users/{user_id}/modules/batch-delete")
async def delete_modules(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        deleted_ids = []
        result = await db.execute(select(Module).where(Module.user_id == user_id))
        module_ids = result.scalars().all()
    
    
        for module_id in module_ids:
        
            result = await db.execute(
                select(Module).where(Module.user_id == user_id).where(Module.id == module_id.id)
            )
        
            await db.delete(module_id)
            deleted_ids.append(module_id)
        await db.commit()
        return {"deleted": deleted_ids}
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
    
@router.delete("/users/{user_id}/modules/{module_id}")
async def delete_module(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Module).where(Module.user_id == user_id).where(Module.id == module_id))
        module = result.scalars().first()

        if not module:
            raise HTTPException(status_code=404, detail="Module not found for user" + str(user_id))
        await db.delete(module)
        await db.commit()
    
        return {"message": "Module deleted successfully", "module_id": module_id}
    else: 
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")


@router.get("/users/{user_id}/modules/{module_id}")
async def get_module(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int,module_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Module).where(Module.user_id == user_id).where(Module.id == module_id))
        module = result.scalars().first()
        if not module:
            raise HTTPException(status_code=404, detail="Module not found for user " + str(user_id))
        return module
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")


@router.get("/users/me/modules/")
async def get_my_modules(current_user: User = Depends(get_current_active_user),db: AsyncSession = Depends(get_db)):
    user_id = current_user.id
    result = await db.execute(
        select(Module).where(Module.user_id == user_id)
    )
    return result.scalars().all()

@router.get("/users/{user_id}/modules/")
async def get_modules(current_user: Annotated[User, Depends(get_current_active_user)], user_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:    
        result = await db.execute(select(Module).where(Module.user_id == user_id))
        modules = result.scalars().all()
        return modules
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
    

    

