from sqlalchemy.future import select
from fastapi import FastAPI, APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from app.schemas import UserCreate, TokenData, Token
from app.database import get_db
from app.models import User
from passlib.context import CryptContext
import jwt
from datetime import datetime, timedelta, timezone
from typing import Annotated
from dotenv import load_dotenv
import os
from fastapi.security import OAuth2PasswordBearer,OAuth2PasswordRequestForm
from jwt.exceptions import InvalidTokenError

load_dotenv("../.env")
SECRET_KEY= os.getenv("SECRET_KEY")
ALGORITHM= os.getenv("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = 30



router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Set up password hashing context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Utility function to hash passwords
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password,hashed_password)

async def authenticate_user(username: str, password: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.user_name == username))
    user = result.scalars().first()
    if not user:
        return False

    if not verify_password(password, user.password):
        return False
    return user

def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], db: AsyncSession = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        role = payload.get("role")
        if username is None or role is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except InvalidTokenError:
        raise credentials_exception
    user = get_user(token_data.user_id, get_db)
    if user is None:
        raise credentials_exception
    return user


async def get_current_active_user(
    current_user: Annotated[User, Depends(get_current_user)],
):
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user

@router.post("/token")
async def login_for_access_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],db: AsyncSession = Depends(get_db)
) -> Token:
    user = await authenticate_user(form_data.username, form_data.password, db)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.user_name, "role":user.role}, expires_delta=access_token_expires
    )
    return Token(access_token=access_token, token_type="bearer")






    
@router.post("/users")
async def create_user(user: UserCreate, db: AsyncSession = Depends(get_db)):
    #async: Defines this function as asynchronous, allowing non-blocking operations for the /users route.
    #user: the request body of this API call validated by the UserCreate schema
    #db: An asynchronous database session, injected using the Depends(get_db) dependency.
    hashed_pw = hash_password(user.password)  # Hash the raw password
    query  = select(User.id)
    result = await db.execute(query)
    users = result.scalars().all()
    if len(users) == 0:
        role_str = "root"
    else:
        role_str= "user"
    new_user = User(user_name=user.user_name, email=user.email, password=hashed_pw, role=role_str) #create an instance of the ORM Userand initialising with the request body converted as a dictionary
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
    "role":user.role
    }

@router.get("/users")
async def get_users(db: AsyncSession = Depends(get_db)):
    """if user.role != "root":
        raise HTTPException(status_code=403, detail="Website admin access only")
    """
    query  = select(User.id)
    print(query)
    result = await db.execute(query)
    users = result.scalars().all()
    return users
