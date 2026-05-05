import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from app.main import app
from dotenv import load_dotenv
from sqlalchemy import select
from app.models import User, Base
from app.database import get_db

# Load .env
load_dotenv(".env")

# Test Database Configuration
TEST_DATABASE_URL = os.getenv("TEST_DATABASE_URL")


# Async engine + session
engine = create_async_engine(TEST_DATABASE_URL, echo=False, pool_pre_ping=True)
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

@pytest.mark.order(4)
#Testing user creation on empty db
@pytest.mark.anyio
async def test_post(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    
    response = await async_app_client.post("/users", json=data)
    print(response.text)
    assert response.status_code == 405
    assert response.json() == {"detail":"Method Not Allowed"}
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

@pytest.mark.order(6)
@pytest.mark.anyio
async def test_login_correct_pwd(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users", json=data)
    assert response.status_code == 405
    
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

@pytest.mark.order(15)
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

@pytest.mark.order(16)
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
    