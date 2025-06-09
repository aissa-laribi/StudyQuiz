import copy
import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy import select
import os
from app.main import app
from dotenv import load_dotenv
from app.models import Base, Module
from app.database import get_db
from fastapi import Depends

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


"""
@pytest.mark.anyio
async def test_post(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users", json=data)
    assert response.status_code == 200
"""



@pytest.mark.anyio
async def test_get_module_no_modules(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users", json=data)
    assert response.status_code == 200
    response = await async_app_client.get(f"/users")
    user_id = response.json()[0]
    response = await async_app_client.get(f"/users/{user_id}/modules/")
    assert response.status_code == 200
    assert len(response.json()) == 0


@pytest.mark.anyio
async def test_post_module(async_app_client):
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
    await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    modules = await async_app_client.get(f"/users/{user_id}/modules/")
    created = modules.json()[0]
    assert created['user_id'] == user_id
    assert created['module_name'] == 'Module 1'

@pytest.mark.anyio
async def test_post_existing_module(async_app_client):
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
    await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    modules = await async_app_client.get(f"/users/{user_id}/modules/")
    created = modules.json()[0]
    assert created['user_id'] == user_id
    assert created['module_name'] == 'Module 1'
    modules = await async_app_client.get(f"/users/{user_id}/modules/")
    assert len(modules.json()) == 1


@pytest.mark.anyio
async def test_patch_module(async_app_client, db: AsyncSession = Depends(get_db)):
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
    await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    modules = await async_app_client.get(f"/users/{user_id}/modules/")
    created = modules.json()[0]
    assert created['user_id'] == user_id
    assert created['module_name'] == 'Module 1'

    data = {

        "module_name": "Module 2",
    }

    result = await async_app_client.get(f"/users/{user_id}/modules/")
    modules = result.json()[0]
    module_id = modules['id']    
    result = await async_app_client.patch(f"/users/{user_id}/modules/{module_id}", json=data)
    assert result.status_code == 200
    result = await async_app_client.get(f"/users/{user_id}/modules/")
    modules = result.json()[0]
    #assert modules.json()[0]['id'] == 1
    #assert modules.json()[0]['user_id'] == 1
    assert modules['module_name'] == 'Module 2'


@pytest.mark.anyio
async def test_delete_module(async_app_client):
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
    await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    modules = await async_app_client.get(f"/users/{user_id}/modules/")
    created = modules.json()[0]
    assert created['user_id'] == user_id
    assert created['module_name'] == 'Module 1'

    data = {

        "module_name": "Module 2",
    }

    result = await async_app_client.get(f"/users/{user_id}/modules/")
    modules = result.json()[0]
    module_id = modules['id']

    await async_app_client.delete(f"/users/{user_id}/modules/{module_id}")
    result = await async_app_client.get(f"/users/{user_id}/modules/")
    modules = result.json()
    assert modules == []


@pytest.mark.anyio
async def test_batch_create_modules(async_app_client, db: AsyncSession = Depends(get_db)):
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
        "data": [
        {
            "name": "Module 1"
        },
        {
            "name": "Module 2"
        },
        {
            "name": "Module 3"
        }
        ]
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/batch-create", json=data)
    modules = await async_app_client.get(f"/users/{user_id}/modules/")
    modules = modules.json()
    assert len(modules) == 3
    assert modules[0]['module_name'] == 'Module 1'
    assert modules[1]['module_name'] == 'Module 2'
    assert modules[2]['module_name'] == 'Module 3'


@pytest.mark.anyio
async def test_delete_module_no_quizzes(async_app_client):
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
        "data": [
        {
            "name": "Module 1"
        },
        {
            "name": "Module 2"
        },
        {
            "name": "Module 3"
        }
        ]
    }
    response = await async_app_client.post(f"/users/{user_id}/modules/batch-create", json=data)
    modules = await async_app_client.get(f"/users/{user_id}/modules/")
    modules = modules.json()
    assert len(modules) == 3
    assert modules[0]['module_name'] == 'Module 1'
    assert modules[1]['module_name'] == 'Module 2'
    assert modules[2]['module_name'] == 'Module 3'
    response = await async_app_client.delete(f"/users/{user_id}/modules/batch-delete")
    assert response.status_code == 200
    modules = await async_app_client.get(f"/users/{user_id}/modules/")
    modules = modules.json()
    assert len(modules) == 0



"""
@pytest.mark.anyio
async def test_delete_module_quizzes_questions_answers(async_app_client):
    

@pytest.mark.anyio
async def test_delete_module_attempted_quizzes(async_app_client):
    #TODO
    pass


"""    