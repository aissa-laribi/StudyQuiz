import os
from logging.config import fileConfig
from sqlalchemy import engine_from_config, pool, create_engine
from alembic import context
from app.models import Base
from dotenv import load_dotenv

load_dotenv()

if os.getenv("USE_TEST_DB") == "1":
    database_url = os.getenv("TEST_DATABASE_URL")
else:
    database_url = os.getenv("DATABASE_URL")

if not database_url:
    raise RuntimeError("Database URL is not set")

database_url = database_url.replace(
    "postgresql+asyncpg://",
    "postgresql://",
    1
)

# Load the Alembic config and database URL from the environment variable
config = context.config
config.set_main_option('sqlalchemy.url', database_url)


# Setup logging
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# Add your SQLAlchemy metadata for migrations
target_metadata = Base.metadata


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode."""
    connectable = create_engine(
        config.get_main_option("sqlalchemy.url"),
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
