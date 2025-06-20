import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from app.main import app
from app.routes.attempt import fgd_shuffling
from dotenv import load_dotenv
from app.models import Base
from app.database import get_db

# Load .env
load_dotenv(".env")

# Test Database Configuration
TEST_DATABASE_URL = os.getenv("TEST_DATABASE_URL")


# Async engine + session
engine = create_async_engine(TEST_DATABASE_URL, echo=False, pool_pre_ping=True)
# Create sessionmaker for AsyncSession
async_session = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)

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

@pytest.fixture(scope="function", autouse=True)
async def reset_test_db():
    # Drop all tables
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
    yield



# Utility Function for Password Hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

reset_test_db

@pytest.mark.anyio
async def test_shuffling(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users")
    user_id = response.json()[0]

    data = {

        "name": "Module 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    data = {
        "name": "Quiz 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    #print(response.json())
    assert response.status_code == 200
    assert response.json()['id'] == quiz_id
    assert response.json()['module_id'] == module_id
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "data": [
    {
      "name": "Question 1",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 2",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 3",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 4",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 5",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 6",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 7",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 8",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 9",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    {
      "name": "Question 10",
      "answers": [
        {
          "name": "Answer 1",
          "correct": True
        },
        {
          "name": "Answer 2",
          "correct": False
        },
      ]
    },
    ]
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-create", json=data)
    assert response.status_code == 200
    i = 1
    for i in range(1,11):
        response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{i}")
        assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/")
    assert response.status_code == 200
    response = fgd_shuffling(response.json(),len(response.json()))
    assert response[0]['id'] != 1 or response[1]['id'] != 2 or response[2]['id'] != 3



