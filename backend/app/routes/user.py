from sqlalchemy.future import select
from fastapi import FastAPI, APIRouter, Depends, HTTPException#
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
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
    new_user = User(user_name=user.user_name, email=user.email, password=hashed_pw) #create an instance of the ORM Userand initialising with the request body converted as a dictionary
    try:
        db.add(new_user) #Add the instance of the ORM User to the db session
        await db.commit() #Commits the transaction, and saves the changes to the database(user details saved)
        await db.refresh(new_user) #Refreshes the new_user instance with data from the database (e.g., auto-generated IDs)
        return {"User " + str(new_user.user_name) + "successfully added"}
    except IntegrityError:  # Handle unique constraint violations
        await db.rollback()  # Rollback the transaction to clean up the session

    """
    TODOS:  
            Force the user to enter a secure password on client side and serverside as well
    """

@router.patch("/users/{user_id}")
async def update_user(user_id: int, new_data: dict, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if 'password' in new_data:
        user.password = hash_password(new_data['password'])
        del new_data['password']
    
    for key, value in new_data.items():
        setattr(user, key, value)

    # Commit the changes
    print(type(User))
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user
    """
    TODOS: Not return password in bodyresponse if password not updated
    """

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
async def get_user(user_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {
    "user_id": user_id,
    "user_name": user.user_name,
    "email": user.email,
    }

@router.get("/users")
async def get_users(db: AsyncSession = Depends(get_db)):
    query  = select(User.id)
    print("DEBUG")
    print(query)
    result = await db.execute(query)
    users = result.scalars().all()
    return users
    