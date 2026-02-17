from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Shop API"
    API_V1_STR: str = "/api/v1"
    
    
    DATABASE_URL: str = "postgresql+asyncpg://postgres:password@localhost:5432/shop_db"
    
    class Config:
        case_sensitive = True
        env_file = ".env"

settings = Settings()
