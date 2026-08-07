"""waiting_table

Revision ID: 95c185338c35
Revises: a402a2b24cc3
Create Date: 2026-08-07 14:57:21.972129

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '95c185338c35'
down_revision: Union[str, None] = 'a402a2b24cc3'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
