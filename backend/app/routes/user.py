from sqlalchemy.future import select
from fastapi import FastAPI, APIRouter, Depends, HTTPException #
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas import UserCreate
from app.database import get_db
from app.models import User
from passlib.context import CryptContext


router = APIRouter()

# Set up password hashing context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Utility function to hash passwords
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

@router.post("/users")
async def create_user(user: UserCreate, db: AsyncSession = Depends(get_db)):
    #async: Defines this function as asynchronous, allowing non-blocking operations for the /users route.
    #user: the request body of this API call validated by the UserCreate schema
    #db: An asynchronous database session, injected using the Depends(get_db) dependency.
    hashed_pw = hash_password(user.password)  # Hash the raw password
    new_user = User(user_name=user.user_name, email=user.email, hashed_password=hashed_pw) #create an instance of the ORM Userand initialising with the request body converted as a dictionary
    db.add(new_user) #Add the instance of the ORM User to the db session
    await db.commit() #Commits the transaction, and saves the changes to the database(user details saved)
    await db.refresh(new_user) #Refreshes the new_user instance with data from the database (e.g., auto-generated IDs)
    return new_user #Return the new user created

@router.patch("/users/{user_id}")
async def update_user(
    user_id: int,
    user_update: UserCreate,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if user_update.password:
        user.hashed_password = hash_password(user_update.password)

    db.add(user) #Add the instance of the ORM User to the db session
    await db.commit() #Commits the transaction, and saves the changes to the database(user details saved)
    await db.refresh(user) #Refreshes the new_user instance with data from the database (e.g., auto-generated IDs)
    return user #Return the new user created

@router.delete("/users/{user_id}")
async def delete_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    await db.delete(user)
    await db.commit()
    
    return {"message": "User deleted successfully", "user_id": user_id}

@router.get("/users/{user_id}")
def get_user(user_id: int, username: str = None):
    return {"user_id": user_id,"username": username}

@router.get("/users")
def get_users():
    users = [{"user_id": 1}, {"user_id": 2}] #mock data for testing
    return {"users": users}