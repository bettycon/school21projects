from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.address import Address
from app.schemas.address import AddressCreate, AddressUpdate
from .base import BaseRepository

class AddressRepository(BaseRepository[Address]):
    def __init__(self):
        super().__init__(Address)