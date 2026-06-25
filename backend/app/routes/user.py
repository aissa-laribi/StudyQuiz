import sys

from sqlalchemy.future import select
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import DBAPIError, IntegrityError, SQLAlchemyError
from app.schemas import TokenData, Token
from app.database import get_db
from app.models import User
from passlib.context import CryptContext
import jwt
from datetime import datetime, timedelta, timezone
from typing import Annotated,Optional
from app.schemas import UserCreate
import os
from fastapi.security import OAuth2PasswordBearer,OAuth2PasswordRequestForm
from jwt.exceptions import InvalidTokenError
import resend

#load_dotenv("../.env")
SECRET_KEY= os.getenv("SECRET_KEY")
ALGORITHM= os.getenv("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = 180
SEND_EMAIL= os.getenv("SEND_CONFIRMATION")
FRONTEND_URL = os.getenv("FRONTEND_URL")

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/users/token")

# Set up password hashing context
# Why Passlib over Python Hashlib? 
# Hashlib support fast algorithm such as SHA and does not salt by default
# passlib uses hashlib (and other crypto libraries) underneath
# and adds salting, slow algorithms, and secure password handling 
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

def confirmation_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(hours=24)
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
    result = await db.execute(select(User).where(User.user_name == token_data.username))
    user = result.scalars().first()
    if user is None:
        raise credentials_exception
    return user


async def get_current_active_user(
    current_user: Annotated[User, Depends(get_current_user)],
):
    return current_user

@router.get("/users/me")
async def get_user_info(current_user: Annotated[User, Depends(get_current_active_user)], db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.id == current_user.id))
    user = result.scalars().first()
    return {"user_name": user.user_name,"email": user.email,"role":user.role, "id":user.id}

@router.get("/users")
async def get_users(current_user: Annotated[User, Depends(get_current_active_user)], db: AsyncSession = Depends(get_db)):
    if current_user.role == "root":
        result = await db.execute(select(User))
        users = result.scalars().all()
        return users
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/{user_id}")
async def get_user(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(User).where(User.id == user_id))
        user = result.scalars().first()

        if user is None:
            raise HTTPException(status_code=404, detail="User not found")

        return {
        "user_id": user_id,
        "user_name": user.user_name,
        "email": user.email,
        "role":user.role
        }
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.post("/users/token")
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
    query  = select(User.id) #select the id column of the User model 
    result = await db.execute(query) #Query db `SELECT USER.ID FROM USER`
    users = result.scalars().all() #Return all users id in a list
    if len(users) == 0:
        role_str = "root"
        verified = True
    else:
        role_str= "user"
        verified = False
    new_user = User(user_name=user.email, #create an instance of the ORM Userand initialising with the request body converted as a dictionary
                    email=user.email, 
                    password=hashed_pw, role=role_str, 
                    created_at=datetime.now(),
                    updated_at=datetime.now(),
                    verified=verified,
                    #plan=1,
                )    
    try:
        db.add(new_user) #Add the instance of the ORM User to the db session
        await db.commit() #Commits the transaction, and saves the changes to the database(user details saved)
        await db.refresh(new_user) #Refreshes the new_user instance with data from the database (e.g., auto-generated IDs)
        resend.api_key = SEND_EMAIL
        email_html=open("/frontend/static/confirmation-email.html","r")
        confirmation_url = f"{FRONTEND_URL}/users/{new_user.user_name}?from=confirmation-email"
        attachment: resend.RemoteAttachment = {
            "path": "https://studyquiz.co/logo.png",
            "filename": "logo.png",
            "content_id": "logo-image",
        }
         
        email_content=""
        c = 0
        for i in email_html.readlines():
            if '{{ confirmation_url }}' in i:
                print("True")
                i = i.replace('{{ confirmation_url }}', confirmation_url)
                print(i)
            email_content+=str(i)
        email_html.close()
        params: resend.Emails.SendParams = {
        "from": "hello@studyquiz.co",
        "to": f"{user.email}",
        "subject": "Welcome to StudyQuiz!",
        "html": f"{email_content}",
        }
        resend.Emails.send(params)

        return {
            "message": "User successfully created",
            "user_id": new_user.id,
            "email": new_user.email,
            "verified": new_user.verified
        }
    except IntegrityError as e:
        await db.rollback()
        print("IntegrityError type:", type(e).__name__)
        print("Original database error:", e.orig)

        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Account creation conflicts with existing database data."
    )
    except DBAPIError as e:  # Handle general databases error
        await db.rollback()  # Rollback the transaction to clean up the session
        print(e)
        raise HTTPException(
            status_code=500,
            detail={
                "error_type": type(e).__name__,
                "message": "A database operation failed."
        }
        )
    
    #TODOS:  
    #        Force the user to enter a secure password on client side and serverside as well
"""
@router.patch("/users/{user_id}")
async def update_user(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, new_data: dict, db: AsyncSession = Depends(get_db)):
    
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(User).where(User.id == user_id))
        user = result.scalars().first()
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
    
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    
    if 'password' in new_data:
        user.password = hash_password(new_data['password'])
        del new_data['password']
    
    allowed_fields = {"user_name", "email", "password"}
    for key, value in new_data.items():
        if key in allowed_fields:
            setattr(user, key, value)
    
    # Commit the changes
    print(type(User))
    db.add(user)
    await db.commit()
    await db.refresh(user)

    return {
        "user_id": user.id,
        "user_name": user.user_name,
        "email": user.email,
        "role": user.role
    }
    
    #TODOS: Not return password in bodyresponse if password not updated
    
"""
@router.delete("/users/{user_id}")
async def delete_user(
    current_user: Annotated[User, Depends(get_current_active_user)],user_id: int,
    db: AsyncSession = Depends(get_db), 
):
    
    if current_user.role == "root":
        result = await db.execute(select(User).where(User.id == user_id))
        user = result.scalars().first()
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")
        if user.role == "root":
            raise HTTPException(status_code=403, detail="Root user cannot delete itself.")
        else:
            result = await db.execute(select(User).where(User.id == user_id))
            user = result.scalars().first()
            
            try:
                await db.delete(user)
                await db.commit()
                return {"message": "User deleted successfully", "user_id": user_id}
            except AttributeError:
                await db.rollback()
                raise HTTPException(
                    status_code=status.HTTP_409_CONFLICT,
                    detail="No account with this username exists."
                )
            except DBAPIError as e:  # Handle general databases error
                await db.rollback()  # Rollback the transaction to clean up the session
                print(e)
                raise HTTPException(
                    status_code=500,
                    detail={
                        "error_type": type(e).__name__,
                        "message": "A database operation failed."
                    }
                )
    elif current_user.id == user_id:
        result = await db.execute(select(User).where(User.id == user_id))
        user = result.scalars().first()
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")
        try:
            await db.delete(user)
            await db.commit()
            return {"message": "User deleted successfully", "user_id": user_id}
        except AttributeError:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
