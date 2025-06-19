import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from app.main import app
from dotenv import load_dotenv
from app.models import Base, Quiz
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
async def test_get_answer_no_answers(async_app_client):
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

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/")
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
    assert response.status_code == 200
    assert len(response.json()) == 0
    print(response.json())

@pytest.mark.anyio
async def test_post_answer_get_answer(async_app_client):
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

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/")
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    
    data = {
        "name": "Answer 1",
        "correct": True
    }

    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer1 = response.json()

    data = {
        "name": "Answer 2",
        "correct": False
    }


    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer2 = response.json()

    
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 1"
    assert response.json()['answer_correct'] == True
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 2"
    assert response.json()['answer_correct'] == False


@pytest.mark.anyio
async def test_post_answer_patch_answer(async_app_client):
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

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/")
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    
    data = {
        "name": "Answer 1",
        "correct": True
    }

    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer1 = response.json()

    data = {
        "name": "Answer 2",
        "correct": False
    }


    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer2 = response.json()

    
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 1"
    assert response.json()['answer_correct'] == True
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 2"
    assert response.json()['answer_correct'] == False

    data = {
        "answer_name": "Answer1",
        "answer_correct": True
    }


    response = response = await async_app_client.patch(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer1"
    assert response.json()['answer_correct'] == True


    data = {
        "answer_name": "Answer1",
        "answer_correct": False
    }
    response = response = await async_app_client.patch(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer1"
    assert response.json()['answer_correct'] == False

    data = {
        "answer_name": "Answer 1",
        "answer_correct": True
    }
    response = response = await async_app_client.patch(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 1"
    assert response.json()['answer_correct'] == True

@pytest.mark.anyio
async def test_post_answer_delete_answer(async_app_client):
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

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/")
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    
    data = {
        "name": "Answer 1",
        "correct": True
    }

    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer1 = response.json()

    data = {
        "name": "Answer 2",
        "correct": False
    }


    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer2 = response.json()

    
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 1"
    assert response.json()['answer_correct'] == True
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 2"
    assert response.json()['answer_correct'] == False

    response = await async_app_client.delete(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code != 200

    response = await async_app_client.delete(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code != 200

@pytest.mark.anyio
async def test_get_answers_no_answers(async_app_client):
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

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/")
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    question_id = response.json()

    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
    assert response.status_code == 200
    assert response.json() == []


@pytest.mark.anyio
async def test_get_answers_post_answers(async_app_client):

    
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

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/")
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"

    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    
    data = {
        "name": "Answer 1",
        "correct": True
    }

    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer1 = response.json()

    data = {
        "name": "Answer 2",
        "correct": False
    }


    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer2 = response.json()

    
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 1"
    assert response.json()['answer_correct'] == True
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 2"
    assert response.json()['answer_correct'] == False

    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
    assert response.status_code == 200
    assert len(response.json()) == 2
    assert response.json()[0]['answer_name'] == "Answer 1"
    assert response.json()[0]['answer_correct'] == True
    assert response.json()[1]['answer_name'] == "Answer 2"
    assert response.json()[1]['answer_correct'] == False

@pytest.mark.anyio
async def test_get_answers_patched_answers(async_app_client):
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

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/")
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    
    data = {
        "name": "Answer 1",
        "correct": True
    }

    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer1 = response.json()

    data = {
        "name": "Answer 2",
        "correct": False
    }


    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer2 = response.json()

    
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 1"
    assert response.json()['answer_correct'] == True
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 2"
    assert response.json()['answer_correct'] == False

    data = {
        "answer_name": "Answer1",
        "answer_correct": True
    }


    response = response = await async_app_client.patch(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer1"
    assert response.json()['answer_correct'] == True


    data = {
        "answer_name": "Answer1",
        "answer_correct": False
    }
    response = response = await async_app_client.patch(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer1"
    assert response.json()['answer_correct'] == False

    data = {
        "answer_name": "Answer 1",
        "answer_correct": True
    }
    response = response = await async_app_client.patch(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 1"
    assert response.json()['answer_correct'] == True

    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
    assert response.status_code == 200
    assert len(response.json()) == 2
    assert response.json()[0]['answer_name'] == "Answer 1"
    assert response.json()[0]['answer_correct'] == True
    assert response.json()[1]['answer_name'] == "Answer 2"
    assert response.json()[1]['answer_correct'] == False

@pytest.mark.anyio
async def test_get_answers_delete_answers(async_app_client):

    
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

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert module_id == 1
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/")
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"

    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data)
    assert response.status_code == 200
    assert response.json() == 1
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    
    data = {
        "name": "Answer 1",
        "correct": True
    }

    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer1 = response.json()

    data = {
        "name": "Answer 2",
        "correct": False
    }


    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/", json=data)
    assert response.status_code == 200
    answer2 = response.json()

    
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 1"
    assert response.json()['answer_correct'] == True
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 200
    assert response.json()['answer_name'] == "Answer 2"
    assert response.json()['answer_correct'] == False

    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
    assert response.status_code == 200
    assert len(response.json()) == 2
    assert response.json()[0]['answer_name'] == "Answer 1"
    assert response.json()[0]['answer_correct'] == True
    assert response.json()[1]['answer_name'] == "Answer 2"
    assert response.json()[1]['answer_correct'] == False

    response = await async_app_client.delete(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer1}")
    assert response.status_code == 404
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
    assert response.status_code == 200
    assert len(response.json()) == 1

    response = await async_app_client.delete(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/{answer2}")
    assert response.status_code == 404
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers/")
    assert response.status_code == 200
    assert len(response.json()) == 0







