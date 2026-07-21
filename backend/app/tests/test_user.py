from datetime import datetime, timedelta, timezone
import hashlib

import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import NullPool
from sqlalchemy import delete, select,update
import os
from app.main import app
from dotenv import load_dotenv
from app.database import get_db
from app.models import User, VerificationToken
from app.user import hash_password, verify_password

# Load .env
load_dotenv(".env")

# Test Database Configuration
TEST_DATABASE_URL = os.getenv("TEST_DATABASE_URL")


# Async engine + session
engine = create_async_engine(TEST_DATABASE_URL,echo=False,poolclass=NullPool,)
# Create sessionmaker for AsyncSession
async_session = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)

@pytest.fixture(scope="module")
def anyio_backend():
    return "asyncio"

# Override get_db
async def override_get_db():
    async with async_session() as session:
        yield session

# Tell FastAPI to use the test `get_db`
app.dependency_overrides[get_db] = override_get_db

# HTTP Client Fixture
@pytest.fixture(scope="module")
async def async_app_client():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        yield client

# Dispose of the Engine After Tests
@pytest.fixture(scope="module", autouse=True)
async def close_engine():
    yield
    await engine.dispose()


# Utility Function for Password Hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

# Tests
@pytest.mark.order(1)
@pytest.mark.anyio
async def test_root(async_app_client):
    response = await async_app_client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to StudyQuiz!"}

@pytest.mark.order(2)
@pytest.mark.anyio
async def test_no_users(async_app_client):
    response = await async_app_client.get("/users")
    assert response.status_code == 401
    assert response.json() == {'detail': 'Not authenticated'} 
    #print("Get_Users1 " +str(response.json()))

@pytest.mark.order(3)
@pytest.mark.anyio
async def test_get_users1_not_logged(async_app_client):
    response = await async_app_client.get("/users")
    assert response.status_code == 401
    assert response.json() == {'detail': 'Not authenticated'}

#Testing user creation on empty db
@pytest.mark.order(4)
@pytest.mark.anyio
async def test_post(async_app_client):
    data = {
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    
    response = await async_app_client.post("/users", json=data)
    assert response.status_code == 409
    assert response.json() == {'detail':'Account creation conflicts with existing database data.'}
    return data

@pytest.mark.order(5)
@pytest.mark.anyio
async def test_login_wrong_pwd(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g1"
        "&scope=&client_id=string&client_secret=string"
    )

    response = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert response.status_code == 401 
    assert response.json()['detail'] == "Incorrect username or password"

@pytest.mark.order()
@pytest.mark.anyio
async def test_login_correct_pwd(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users", json=data)
    assert response.status_code == 409
    assert response.json()['detail'] == "Account creation conflicts with existing database data."
    
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    response = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )

    assert response.status_code == 200
    assert "access_token" in response.json()

@pytest.mark.order(7)    
@pytest.mark.anyio
async def test_get_users1_logged(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]

    response = await async_app_client.get("/users",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert len(response.json()) == 3
    assert response.json()[0]["id"] == 1 #Hard-coded ID might fail in a workflow
    assert response.json()[1]["id"] == 2
    assert response.json()[0]["role"] == "root"
    assert response.json()[1]["role"] == "user"

@pytest.mark.order(8)
@pytest.mark.anyio
async def test_login_wrong_pwd2(async_app_client):
    form_data = (
        "grant_type=password&username=testuser2"
        "&password=StrongPwd1234,,,,tewfw4g21"
        "&scope=&client_id=string&client_secret=string"
    )

    response = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )

    assert response.status_code == 401
    assert response.json()['detail'] == "Incorrect username or password"

@pytest.mark.order(9)
@pytest.mark.anyio
async def test_login_correct_pwd2(async_app_client):
    form_data = (
        "grant_type=password&username=testuser2"
        "&password=StrongPwd1234,,,,tewfw4g2"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]
    assert token.status_code == 200

@pytest.mark.order(10)
@pytest.mark.anyio
async def test_one_root_only(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]

    response = await async_app_client.get("/users",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert len(response.json()) == 3
    assert len(list(filter(lambda x : x["role"] == "root",response.json()))) == 1
    data = {
        "email": "testsstudyquiz@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g"
    }
    response = await async_app_client.post("/users?prod=false",json=data)
    assert response.status_code == 200
    response = await async_app_client.get("/users",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert len(response.json()) == 4
    assert response.json()[3]['role'] == 'user'
    assert response.json()[3]['verified'] == False
    response = await async_app_client.delete(f"/users/{response.json()[3]['id']}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200

@pytest.mark.order(11)
@pytest.mark.anyio
async def test_new_user_not_verified(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]

    response = await async_app_client.get("/users",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert len(response.json()) == 3
    data = {
        "email": "testsstudyquiz@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g"
    }
    response = await async_app_client.post("/users?prod=false",json=data)
    assert response.status_code == 200
    response = await async_app_client.get("/users",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert len(response.json()) == 4
    assert response.json()[3]['role'] == 'user'
    assert response.json()[3]['verified'] == False
    response = await async_app_client.delete(f"/users/{response.json()[3]['id']}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200

@pytest.mark.order(12)
@pytest.mark.anyio
async def test_verification_email(async_app_client):
    data = {
        "email": "testsstudyquiz@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users?prod=false",json=data)
    assert response.status_code == 200
    assert f"/confirm-email?token=" in response.json()
    assert len(response.json().split('\n')) == 4
    token = str(response.json().split('\n')[2].split('=')[1])
    data = {
        "user_name": "testsstudyquiz@gmail.com",
        "email": "testsstudyquiz@gmail.com",
        "token": token,
    }
    response = await async_app_client.post("/users/verification-email",params=data)
    assert response.status_code == 200
    assert response.json()['message'] == "Account verified successfully"
    assert response.json()['user_name'] == 'testsstudyquiz@gmail.com'
    assert response.json()['email'] == 'testsstudyquiz@gmail.com'
    assert response.json()['verified'] == True
    user_id = int(response.json()['user_id'])
    form_data = (
        "grant_type=password&username=testsstudyquiz@gmail.com"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]
    response = await async_app_client.delete(f"/users/{user_id}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert response.json() == {"message": "User deleted successfully", "user_id": user_id}

@pytest.mark.order(13)
@pytest.mark.anyio
async def test_expired_token(async_app_client):
    data = {
        "email": "testsstudyquiz@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users?prod=false",json=data)
    assert response.status_code == 200
    assert f"/confirm-email?token=" in response.json()
    assert len(response.json().split('\n')) == 4
    token = str(response.json().split('\n')[2].split('=')[1])
    async with async_session() as session:
        result = await session.execute(select(User).where(User.email == "testsstudyquiz@gmail.com"))
        user = result.scalar_one_or_none()
        assert user is not None
        assert user.email == "testsstudyquiz@gmail.com"
        result = await session.execute(select(VerificationToken).where(VerificationToken.user_id == user.id))
        token_object = result.scalar_one_or_none()
        assert token_object is not None
        result=await session.execute(update(VerificationToken).where(VerificationToken.user_id == user.id).values(expires_at=datetime.now(timezone.utc)- timedelta(minutes=5)))    
        await session.commit()

    data = {
        "user_name": "testsstudyquiz@gmail.com",
        "email": "testsstudyquiz@gmail.com",
        "token": token,
    }
    form_data = (
        "grant_type=password&username=testsstudyquiz@gmail.com"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post("/users/verification-email",params=data)
    print("Response status:", response.status_code)
    print("Response body:", response.json())
    assert response.status_code == 401
    assert response.json() == {"detail":"Expired verification token"}
    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]
    response = await async_app_client.delete(f"/users/{user.id}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert response.json() == {"message": "User deleted successfully", "user_id": user.id}
    

@pytest.mark.order(14)
@pytest.mark.anyio
async def test_root_delete_user(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]

    response = await async_app_client.get("/users",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert len(response.json()) == 3
    data = {
        "email": "testsstudyquiz@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g"
    }
    response = await async_app_client.post("/users?prod=false",json=data)
    assert response.status_code == 200
    response = await async_app_client.get("/users",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert len(response.json()) == 4
    assert response.json()[3]['role'] == 'user'
    assert response.json()[3]['verified'] == False
    user_id = (list(filter(lambda x: x['email'] == 'testsstudyquiz@gmail.com',response.json()))[0])['id']
    response = await async_app_client.delete(f"/users/{user_id}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert response.json() == {"message": "User deleted successfully", "user_id": user_id}

@pytest.mark.order(15)
@pytest.mark.anyio
async def test_user_delete_itself(async_app_client):
    data = {
        "email": "testsstudyquiz@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g"
    }
    response = await async_app_client.post("/users?prod=false",json=data)
    assert response.status_code == 200
    form_data = (
        "grant_type=password&username=testsstudyquiz@gmail.com"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]
    response = await async_app_client.get("/users/me",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    user_id = response.json()['id']
    response = await async_app_client.delete(f"/users/{user_id}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert response.json() == {"message": "User deleted successfully", "user_id": user_id}

@pytest.mark.order(16)
@pytest.mark.anyio
async def test_user_not_delete_another_user(async_app_client):
    data = {
        "email": "testsstudyquiz@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g"
    }
    response = await async_app_client.post("/users?prod=false",json=data)
    assert response.status_code == 200
    data = {
        "email": "user@example.com",
        "password": "StrongPwd1234,,,,tewfw4g"
    }
    response = await async_app_client.post("/users?prod=false",json=data)
    assert response.status_code == 200
    form_data = (
        "grant_type=password&username=testsstudyquiz@gmail.com"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]
    response = await async_app_client.get("/users/me",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    user1_id = response.json()['id']
    form_data = (
        "grant_type=password&username=user@example.com"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )

    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]
    response = await async_app_client.get("/users/me",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    user2_id = response.json()['id']
    response = await async_app_client.delete(f"/users/{user1_id}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert response.json() == None
    response = await async_app_client.delete(f"/users/{user2_id}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert response.json() == {"message": "User deleted successfully", "user_id": user2_id}
    form_data = (
        "grant_type=password&username=testsstudyquiz@gmail.com"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    
    token = await async_app_client.post(
        "/users/token", 
        data=form_data, 
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    assert token.status_code == 200
    access_token = token.json()["access_token"]
    response = await async_app_client.get("/users/me",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    response = await async_app_client.delete(f"/users/{user1_id}",headers={"Authorization": f"Bearer {access_token}"})
    assert response.status_code == 200
    assert response.json() == {"message": "User deleted successfully", "user_id": user1_id}
    #if user1 was deleted by user2 the response.json would have been None
