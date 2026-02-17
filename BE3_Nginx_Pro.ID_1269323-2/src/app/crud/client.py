from typing import Optional
from uuid import UUID
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.crud.base import CRUDBase
from app.models.client import Client
from app.schemas.client import ClientCreate, ClientUpdate

class CRUDClient(CRUDBase[Client, ClientCreate, ClientUpdate]):
    async def get_by_name(
        self, db: AsyncSession, *, name: str, surname: str
    ) -> Optional[Client]:
        result = await db.execute(
            select(Client).where(
                Client.client_name == name, 
                Client.client_surname == surname
            )
        )
        return result.scalars().first()

client = CRUDClient(Client)