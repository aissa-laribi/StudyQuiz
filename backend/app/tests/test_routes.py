import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from app.main import app
from dotenv import load_dotenv
from sqlalchemy import select
from app.models import User
from app.database import get_db

# Load .env
load_dotenv(".env")

# Test Database Configuration
TEST_DATABASE_URL = os.getenv("TEST_DATABASE_URL")


# Async engine + session
engine = create_async_engine(TEST_DATABASE_URL, echo=True, pool_pre_ping=True)
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

# Utility Function for Password Hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

# Tests
@pytest.mark.anyio
async def test_root(async_app_client):
    response = await async_app_client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to StudyQuiz!"}


@pytest.mark.anyio
async def test_delete(async_app_client):
    response = await async_app_client.delete("/users/441")

      
@pytest.mark.anyio
async def test_no_users(async_app_client):
    response = await async_app_client.get("/users")
    assert response.status_code in [200]
    #assert len(response.json()) == 0
    print("Get_Users1 " +str(response.json()))

#Testing user creation on empty db
@pytest.mark.anyio
async def test_post(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4g",
    }
    response = await async_app_client.post("/users", json=data)
    print("POST")
    print("Status code:", response.status_code)
    print("Response body:", response.json())
    assert response.status_code == 200
    result = await async_app_client.get("/users")
    last_id = result.json()[-1]
    print("GET_ANSWER_FROM_POST:" + str(result.json()))
    print(last_id)

    print("DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" + str(response.json())) 

@pytest.mark.anyio
async def test_get_users1(async_app_client):
    response = await async_app_client.get("/users")
    assert response.status_code in [200]
    assert len(response.json()) == 1

@pytest.mark.anyio
async def test_post_existing_username(async_app_client):
    data = {
        "user_name": "testuser1",
        "email": "user2@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4gx",
    }
    response = await async_app_client.post("/users", json=data)
    print("POST EXISTING USERNAME")
    print("Status code:", response.status_code)
    print("Response body:", response.json())
    assert response.json() == None

@pytest.mark.anyio
async def test_post_existing_email(async_app_client):
    data = {
        "user_name": "testuser2",
        "email": "user1@gmail.com",
        "password": "StrongPwd1234,,,,tewfw4gx",
    }
    response = await async_app_client.post("/users", json=data)
    print("POST EXISTING EMAIL")
    print("Status code:", response.status_code)
    print("Response body:", response.json())
    assert response.json() == None

@pytest.mark.anyio
async def test_patch_username(async_app_client):
    data = {
        "user_name": "testuser1",
        
    }
    result = await async_app_client.get("/users")
    last_id = result.json()[-1]
    response = await async_app_client.patch("/users/" + str(last_id), json=data)
    assert data["user_name"] == response.json()['user_name']

@pytest.mark.anyio
async def test_patch_email(async_app_client):
    data = {
        "email": "user2@gmail.com",
        
    }
    result = await async_app_client.get("/users")
    last_id = result.json()[-1]
    response = await async_app_client.patch("/users/" + str(last_id), json=data)
    assert data["email"] == response.json()['email']

@pytest.mark.anyio
async def test_password(async_app_client):
    data = {
        "password": "GJLEAwavebveRTY3244,",
        
    }
    result = await async_app_client.get("/users")
    last_id = result.json()[-1]
    async with async_session() as session:
        result = await session.execute(select(User).where(User.id == last_id))
        user = result.scalars().first()
        assert user is not None
        old_hashed = user.password
        
    response = await async_app_client.patch("/users/" + str(last_id), json=data)
    
    async with async_session() as session:
        result = await session.execute(select(User).where(User.id == last_id))
        user = result.scalars().first()
        new_hashed = user.password

    assert old_hashed != new_hashed
    

@pytest.mark.anyio
async def test_delete_new_user(async_app_client):
    result = await async_app_client.get("/users")
    last_id = result.json()[-1]
    print("PASSED to DELETE: " + str(last_id))
    response = await async_app_client.delete("/users/"+str(last_id))
    print("DELETE ANSWER: " +str(response.json()))

@pytest.mark.anyio
async def test_get_users2(async_app_client):
    response = await async_app_client.get("/users")
    assert response.status_code in [200]
    #assert last_id not in response.json()
    print("Get_Users_FINAL " +str(response.json()))


