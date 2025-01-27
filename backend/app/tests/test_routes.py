import pytest
from passlib.context import CryptContext
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
import os
from app.main import app
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Test Database Configuration
TEST_DATABASE_URL = os.getenv("TEST_DATABASE_URL")
engine = create_async_engine(TEST_DATABASE_URL, echo=True, pool_pre_ping=True)

# Create sessionmaker for AsyncSession
async_session = sessionmaker(
    autocommit=False,
    autoflush=False,
    class_=AsyncSession,
    bind=engine,
    expire_on_commit=False,
)

# Dependency Override for Tests
async def get_db():
    async with async_session() as session:
        try:
            yield session
        finally:
            await session.close()

# HTTP Client Fixture
@pytest.fixture(scope="module")
async def async_app_client():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        yield client

# Dispose of the Engine After Tests
@pytest.fixture(scope="module", autouse=True)
async def close_engine():
    yield
    await engine.dispose()  # Ensure cleanup of all pooled connections

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
async def test_get_users(async_app_client):
    response = await async_app_client.get("/users/64")
    assert response.status_code == 200
