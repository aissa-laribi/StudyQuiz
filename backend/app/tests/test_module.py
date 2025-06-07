import copy
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

@pytest.fixture(scope="module", autouse=True)
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
async def test_post(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users", json=data)
    assert response.status_code == 200


@pytest.mark.anyio
async def test_get_module(async_app_client):
    user_response = await async_app_client.get("/users")
    assert user_response.status_code == 200
    assert len(user_response.json()) == 1
    print(user_response.json())
    user_id = user_response.json()[0]
    print(user_id)
    user_modules = await async_app_client.get("/users/" + str(user_id) + "/modules/")
    assert user_modules.status_code == 200

@pytest.mark.anyio
async def test_post_module(async_app_client):
    user_response = await async_app_client.get("/users")
    user_id = user_response.json()[0]
    print(user_id)
    data = {

        "name": "Module 1",
    }
    await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    modules = copy.deepcopy(await async_app_client.get(f"/users/{user_id}/modules/"))
    created = copy.deepcopy(modules.json()[0])
    assert created['user_id'] == user_id
    assert created['module_name'] == 'Module 1'


@pytest.mark.anyio
async def test_post_existing_module(async_app_client):
    user_response = await async_app_client.get("/users")
    user_id = user_response.json()[0]
    print(type(user_id))
    request = await async_app_client.get(f"/users/{user_id}/modules/")
    modules = request.json()
    prev_modules_size = len(modules)
    print(prev_modules_size)
    data = {

        "name": "Module 1",
    }
    module_existing = await async_app_client.post(f"/users/{user_id}/modules/", json=data)
    new_modules = await async_app_client.get(f"/users/{user_id}/modules/")
    new_modules = new_modules.json()
    print(type(module_existing.json()))
    print(type(modules))
    assert len(new_modules) == prev_modules_size

@pytest.mark.anyio
async def test_patch_module(async_app_client):
    user_response = await async_app_client.get("/users")
    user_id = user_response.json()[0]
    print("USER" + str(user_id))
    result = copy.deepcopy(await async_app_client.get(f"/users/{user_id}/modules/"))
    modules = copy.deepcopy(result.json()[0])
    module_id = modules['id']
    print(modules['id'])
    
    data = {

        "module_name": "Module1",
    }
    
    await async_app_client.patch(f"/users/{user_id}/modules/{module_id}", json=data)
    #assert module.status_code == 200
    result2 = copy.deepcopy(await async_app_client.get(f"/users/{user_id}/modules/"))
    new_modules = copy.deepcopy(result2.json()[0])
    print(new_modules)
    #assert modules.json()[0]['id'] == 1
    #assert modules.json()[0]['user_id'] == 1
    assert new_modules['module_name'] == 'Module1'
    data = {

        "module_name": "Module 1",
    }
    await async_app_client.patch(f"/users/{user_id}/modules/{module_id}", json=data)#OTHERWISE test_post will fail


@pytest.mark.anyio
async def test_delete_module(async_app_client):
    user_response = await async_app_client.get("/users")
    user_id = user_response.json()[0]
    result = copy.deepcopy(await async_app_client.get(f"/users/{user_id}/modules/"))
    modules = copy.deepcopy(result.json()[0])
    print(modules)
    module_id = modules['id']
    print(module_id)
    await async_app_client.delete(f"/users/{user_id}/modules/{module_id}")
    result2 = copy.deepcopy(await async_app_client.get(f"/users/{user_id}/modules/"))
    new_modules = copy.deepcopy(result2.json())
    assert new_modules == []

@pytest.mark.anyio
async def test_delete_module_empty_quizzes(async_app_client):
    #TODO
    pass

@pytest.mark.anyio
async def test_delete_module_quizzes_questions_answers(async_app_client):
    #TODO
    pass

@pytest.mark.anyio
async def test_delete_module_attempted_quizzes(async_app_client):
    #TODO
    pass


    