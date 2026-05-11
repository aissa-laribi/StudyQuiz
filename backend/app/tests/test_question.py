import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy import NullPool, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from app.main import app
from dotenv import load_dotenv
from app.models import Base, Quiz
from app.database import get_db

# Load .env
load_dotenv(".env")

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
#Drop all tables except users
@pytest.fixture(scope="function", autouse=True)
async def reset_test_db():
    async with engine.begin() as conn:
        await conn.execute(text("DELETE FROM answer;"))
        await conn.execute(text("DELETE FROM question;"))
        await conn.execute(text("DELETE FROM quiz;"))
        await conn.execute(text("DELETE FROM module;"))
        await conn.run_sync(Base.metadata.create_all)
    yield

reset_test_db


# Utility Function for Password Hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

@pytest.mark.anyio
async def test_get_questions_no_questions(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/", headers=headers)
    print(response.json())
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}", headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", headers=headers)
    assert response.status_code == 200
    assert len(response.json()) == 0

@pytest.mark.anyio
async def test_post_question(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1",
    }

    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/",headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/",headers=headers)
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data,headers=headers)
    assert response.status_code == 200
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}",headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"

@pytest.mark.anyio
async def test_patch_question(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/", headers=headers)
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data, headers=headers)
    assert response.status_code == 200
    
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"

    data = {
        "question_name": "Question 2",
    }
    response = await async_app_client.patch(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 2"
    
@pytest.mark.anyio
async def test_create_question(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    
    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/", headers=headers)
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data, headers=headers)
    assert response.status_code == 200
    
    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    response = await async_app_client.delete(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 404

@pytest.mark.anyio
async def test_create_full_quiz(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']

    assert response.json()[0]['module_name'] == 'Module 1'
    data = {
        "name": "Quiz 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}", headers=headers)
    #print(response.json())
    assert response.status_code == 200
    assert response.json()['id'] == quiz_id
    assert response.json()['module_id'] == module_id
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
    "questions": [
        {
            "name": "Question 1",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
        {
            "name": "Question 2",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
        {
            "name": "Question 3",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
    ]
}
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-create", json=data, headers=headers)
    questions = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", headers=headers)
    print(questions.json())
    i = 0
    question_id = questions.json()[i]['id']
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    i+=1
    question_id = questions.json()[i]['id']
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 2"
    i += 1
    question_id = questions.json()[i]['id']
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 3"
    assert response.status_code == 200

  
@pytest.mark.anyio
async def test_delete_question(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']

    assert response.json()[0]['module_name'] == 'Module 1'
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/", headers=headers)
    assert response.status_code == 200
    data = {
        "name": "Quiz 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200

    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
        "name": "Question 1",
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", json=data, headers=headers)
    assert response.status_code == 200

    question_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    response = await async_app_client.delete(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 404

@pytest.mark.anyio
async def test_delete_quiz(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']

    assert response.json()[0]['module_name'] == 'Module 1'
    data = {
        "name": "Quiz 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}", headers=headers)
    #print(response.json())
    assert response.status_code == 200
    assert response.json()['id'] == quiz_id
    assert response.json()['module_id'] == module_id
    assert response.json()['quiz_name'] == "Quiz 1"
    data = {
    "questions": [
        {
            "name": "Question 1",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
        {
            "name": "Question 2",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
        {
            "name": "Question 3",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
    ]
}
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-create", json=data, headers=headers)
    questions = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/", headers=headers)
    print(questions.json())
    i = 0
    question_id = questions.json()[i]['id']
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 1"
    i+=1
    question_id = questions.json()[i]['id']
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 2"
    i += 1
    question_id = questions.json()[i]['id']
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()['question_name'] == "Question 3"
    assert response.status_code == 200

    response = await async_app_client.delete(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-delete/",headers=headers)
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/1",headers=headers)
    assert response.status_code == 404
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/2",headers=headers)
    assert response.status_code == 404
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/3",headers=headers)
    assert response.status_code == 404

@pytest.mark.anyio
async def test_create_full_quiz_from_names(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']
    
    data = {

        "name": "Module 1"
    }
    response = await async_app_client.post(f"/users/me/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/me/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}",headers=headers)
    assert response.status_code == 200
    
    assert response.json()['module_name'] == 'Module 1'
    module_name = "Module 1"
    data = {
        "name": "Quiz 1"
    }
    quiz_name = "Quiz 1"
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    quiz_id = response.json()
    response = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/", headers=headers)
    assert response.status_code == 200
    
    response = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/", headers=headers)

    assert response.json()[0]['quiz_name'] == quiz_name
    data = {
    "questions": [
        {
            "name": "Question 1",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
        {
            "name": "Question 2",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
        {
            "name": "Question 3",
            "answers": [
                {"name": "Answer 1", "correct": True},
                {"name": "Answer 2", "correct": False},
            ],
        },
    ]
}
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/batch-create", json=data, headers=headers)
    questions = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/", headers=headers)
    i = 0
    print(questions.json()[i])
    assert questions.json()[i]['question_name'] == "Question 1"
    i += 1
    assert questions.json()[i]['question_name'] == "Question 2"
    i += 1
    assert questions.json()[i]['question_name'] == "Question 3"

@pytest.mark.anyio
async def test_create_question_from_name(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']

    assert response.json()[0]['module_name'] == 'Module 1'
    data = {
        "name": "Quiz 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    module_name = "Module 1"
    quiz_name = "Quiz 1"

    data = {
    "name": "Question 1",
    }
    
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions", json=data, headers=headers)
    print(response.json())
    assert response.json()['question_name'] == "Question 1"

@pytest.mark.anyio
async def test_create_question_answers_from_names(async_app_client):
    form_data = (
        "grant_type=password&username=testuser1"
        "&password=StrongPwd1234,,,,tewfw4g"
        "&scope=&client_id=string&client_secret=string"
    )
    response = await async_app_client.post(
        "/users/token",
        data=form_data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    response = await async_app_client.get(f"/users/me", headers=headers)
    user_id = response.json()['id']

    data = {

        "name": "Module 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/", json=data, headers=headers)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users/{user_id}/modules/", headers=headers)
    assert response.status_code == 200
    module_id = response.json()[0]['id']

    assert response.json()[0]['module_name'] == 'Module 1'
    data = {
        "name": "Quiz 1"
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/", json=data, headers=headers)
    assert response.status_code == 200
    module_name = "Module 1"
    quiz_name = "Quiz 1"

    data = {
    "name": "Question 1",
      "answers": [
          {"name": "Answer 1", "correct": True},
          {"name": "Answer 2", "correct": False},
        ],
      }
    
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/with-answers", json=data, headers=headers)
    assert response.json()['question_name'] == "Question 1"
    questions = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/", headers=headers)
    assert questions.status_code == 200
    question_id = questions.json()[0]['id']
    answers = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/{question_id}/answers", headers=headers)
    assert answers.status_code == 200
    print(answers.json()[0])
    assert len(answers.json()) == 2