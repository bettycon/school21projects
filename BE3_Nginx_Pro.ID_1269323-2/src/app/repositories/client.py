from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.client import Client
from app.schemas.client import ClientCreate, ClientUpdate
from app.schemas.address import AddressCreate
from app.repositories.address import AddressRepository
from .base import BaseRepository

class ClientRepository(BaseRepository[Client]):
    def __init__(self):
        super().__init__(Client)
    
    def get_by_name(self, db: Session, name: str, surname: str) -> List[Client]:
        return db.query(Client).filter(
            Client.client_name == name,
            Client.client_surname == surname
        ).all()
    
    def update_address(self, db: Session, client_id: int, address_data: AddressCreate) -> Optional[Client]:
        client = self.get(db, client_id)
        if client:
            address_repo = AddressRepository()
            address = address_repo.create(db, address_data)
            client.address_id = address.id
            db.commit()
            db.refresh(client)
            return client
        return None