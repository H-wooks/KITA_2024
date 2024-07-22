"""migration

Revision ID: 7c5ca23e49d6
Revises: 
Create Date: 2024-07-16 10:05:58.407192

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = '7c5ca23e49d6'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.add_column(sa.Column('email', sa.String(length=120), nullable=False))
        batch_op.alter_column('username',
               existing_type=mysql.VARCHAR(length=150),
               type_=sa.String(length=80),
               existing_nullable=False)
        batch_op.create_unique_constraint(None, ['email'])

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.drop_constraint(None, type_='unique')
        batch_op.alter_column('username',
               existing_type=sa.String(length=80),
               type_=mysql.VARCHAR(length=150),
               existing_nullable=False)
        batch_op.drop_column('email')

    # ### end Alembic commands ###
