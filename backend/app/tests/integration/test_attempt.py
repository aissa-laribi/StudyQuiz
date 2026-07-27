from datetime import datetime

import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy import NullPool, text
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from app.main import app
from dotenv import load_dotenv
from app.models import Base
from app.database import get_db
from time import time_ns

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



# Utility Function for Password Hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

reset_test_db

@pytest.mark.anyio
async def test_get_questions_from_name_shuffled(async_app_client):
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
    assert response.status_code == 200
    module_name = "Module 1"
    quiz_name = "Quiz 1"
    question_name = "Question 1"
    c =0 
    i = 0
    while i < 20:
        questions = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/attempts/shuffled-questions", headers=headers)
        assert questions.status_code == 200
        print(questions.json())
        if questions.json()[0]['question_name'] == question_name:
            c += 1
        i += 1
    assert c != 0
    assert c != 19

@pytest.mark.anyio
async def test_post_quiz_attempt(async_app_client):
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
            "name": "Capital of Ireland?",
            "answers": [
                {"name": "Dublin", "correct": True},
                {"name": "Bamako", "correct": False},
            ],
        },
        {
            "name": "Capital of UK?",
            "answers": [
                {"name": "London", "correct": True},
                {"name": "Berlin", "correct": False},
            ],
        },
        {
            "name": "Capital of France?",
            "answers": [
                {"name": "Paris", "correct": True},
                {"name": "Lyon", "correct": False},
            ],
        },
    ]
}
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-create", json=data, headers=headers)
    assert response.status_code == 200
    module_name = "Module 1"
    quiz_name = "Quiz 1"
    response = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/attempts/shuffled-questions", headers=headers)
    assert response.status_code == 200
    questions = []
    for question in response.json():
        answers = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/{question['id']}/answers", headers=headers)
        questions.append([question['id'], answers.json()])
          
    data = {
        "created_at": str(datetime.now()),
        "answers": [
            {
                "question_id": questions[0][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[0][1] ))[0]['id']
                },
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[1][1] ))[0]['id']
                },      
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[2][1] ))[0]['id']
            }      
            ]
            }
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/",json=data,headers=headers)
    assert response.status_code == 200
    assert response.json()['score'] == 67
    assert response.json()['correct_answers'] == 2
    assert response.json()['total_questions'] == 3
    assert response.json()['repetitions'] == 1
    assert response.json()['interval'] == 1
    assert response.json()['ease_factor'] == 2.18

    data = {
        "created_at": str(datetime.now()),
        "answers": [
            {
                "question_id": questions[0][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[0][1] ))[0]['id']
                },
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[1][1] ))[0]['id']
                },      
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[2][1] ))[0]['id']
            }      
            ]
            }
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/",json=data,headers=headers)
    assert response.status_code == 200
    assert response.json()['score'] == 33
    assert response.json()['correct_answers'] == 1
    assert response.json()['total_questions'] == 3
    assert response.json()['repetitions'] == 0
    assert response.json()['interval'] == 1
    assert response.json()['ease_factor'] == 1.38

    data = {
        "created_at": str(datetime.now()),
        "answers": [
            {
                "question_id": questions[0][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[0][1] ))[0]['id']
                },
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[1][1] ))[0]['id']
                },      
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[2][1] ))[0]['id']
            }      
            ]
            }
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/",json=data,headers=headers)
    assert response.status_code == 200
    assert response.json()['score'] == 100
    assert response.json()['correct_answers'] == 3
    assert response.json()['total_questions'] == 3
    assert response.json()['repetitions'] == 1
    assert response.json()['interval'] == 1
    assert response.json()['ease_factor'] == 1.48

    data = {
        "created_at": str(datetime.now()),
        "answers": [
            {
                "question_id": questions[0][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[0][1] ))[0]['id']
                },
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[1][1] ))[0]['id']
                },      
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[2][1] ))[0]['id']
            }      
            ]
            }
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/",json=data,headers=headers)
    assert response.status_code == 200
    assert response.json()['score'] == 0
    assert response.json()['correct_answers'] == 0
    assert response.json()['total_questions'] == 3
    assert response.json()['repetitions'] == 0
    assert response.json()['interval'] == 1
    assert response.json()['ease_factor'] == 1.3

@pytest.mark.anyio
async def test_get_attempts(async_app_client):
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
            "name": "Capital of Ireland?",
            "answers": [
                {"name": "Dublin", "correct": True},
                {"name": "Bamako", "correct": False},
            ],
        },
        {
            "name": "Capital of UK?",
            "answers": [
                {"name": "London", "correct": True},
                {"name": "Berlin", "correct": False},
            ],
        },
        {
            "name": "Capital of France?",
            "answers": [
                {"name": "Paris", "correct": True},
                {"name": "Lyon", "correct": False},
            ],
        },
    ]
}
    response = await async_app_client.post(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-create", json=data, headers=headers)
    assert response.status_code == 200
    module_name = "Module 1"
    quiz_name = "Quiz 1"
    response = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/attempts/shuffled-questions", headers=headers)
    assert response.status_code == 200
    questions = []
    for question in response.json():
        answers = await async_app_client.get(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/{question['id']}/answers", headers=headers)
        questions.append([question['id'], answers.json()])
          
    data = {
        "created_at": str(datetime.now()),
        "answers": [
            {
                "question_id": questions[0][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[0][1] ))[0]['id']
                },
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[1][1] ))[0]['id']
                },      
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[2][1] ))[0]['id']
            }      
            ]
            }
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/",json=data,headers=headers)
    assert response.status_code == 200
    assert response.json()['score'] == 67
    assert response.json()['correct_answers'] == 2
    assert response.json()['total_questions'] == 3
    assert response.json()['repetitions'] == 1
    assert response.json()['interval'] == 1
    assert response.json()['ease_factor'] == 2.18

    data = {
        "created_at": str(datetime.now()),
        "answers": [
            {
                "question_id": questions[0][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[0][1] ))[0]['id']
                },
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[1][1] ))[0]['id']
                },      
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[2][1] ))[0]['id']
            }      
            ]
            }
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/",json=data,headers=headers)
    assert response.status_code == 200
    assert response.json()['score'] == 33
    assert response.json()['correct_answers'] == 1
    assert response.json()['total_questions'] == 3
    assert response.json()['repetitions'] == 0
    assert response.json()['interval'] == 1
    assert response.json()['ease_factor'] == 1.38

    data = {
        "created_at": str(datetime.now()),
        "answers": [
            {
                "question_id": questions[0][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[0][1] ))[0]['id']
                },
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[1][1] ))[0]['id']
                },      
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == True,questions[2][1] ))[0]['id']
            }      
            ]
            }
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/",json=data,headers=headers)
    assert response.status_code == 200
    assert response.json()['score'] == 100
    assert response.json()['correct_answers'] == 3
    assert response.json()['total_questions'] == 3
    assert response.json()['repetitions'] == 1
    assert response.json()['interval'] == 1
    assert response.json()['ease_factor'] == 1.48

    data = {
        "created_at": str(datetime.now()),
        "answers": [
            {
                "question_id": questions[0][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[0][1] ))[0]['id']
                },
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[1][1] ))[0]['id']
                },      
            {
                "question_id": questions[1][0],
                "answer_id": list(filter(lambda x:x['answer_correct'] == False,questions[2][1] ))[0]['id']
            }      
            ]
            }
    response = await async_app_client.post(f"/users/me/modules/{module_name}/quizzes/{quiz_name}/attempts/",json=data,headers=headers)
    assert response.status_code == 200
    assert response.json()['score'] == 0
    assert response.json()['correct_answers'] == 0
    assert response.json()['total_questions'] == 3
    assert response.json()['repetitions'] == 0
    assert response.json()['interval'] == 1
    assert response.json()['ease_factor'] == 1.3

    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/attempts", headers=headers)
    assert response.status_code == 200
    assert len(response.json()) == 4
    attempt_id = response.json()[0]['id']
    response = await async_app_client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/attempts/{attempt_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()[0]['attempt_score'] == 67
