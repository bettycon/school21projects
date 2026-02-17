from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.base import Base
from app.models.address import Address
from app.models.supplier import Supplier
from app.models.client import Client
from app.models.image import Image
from app.models.product import Product

# PostgreSQL connection string
SQLALCHEMY_DATABASE_URL = "postgresql://shopuser:123@localhost/shopapi"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def create_tables():
    # Создаем таблицы в правильном порядке
    Base.metadata.create_all(bind=engine, tables=[
        Address.__table__,
        Supplier.__table__,
        Client.__table__,
        Image.__table__,
        Product.__table__
    ])