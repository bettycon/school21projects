from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.supplier import Supplier
from app.schemas.supplier import SupplierCreate, SupplierUpdate
from app.schemas.address import AddressCreate
from app.repositories.address import AddressRepository
from .base import BaseRepository

class SupplierRepository(BaseRepository[Supplier]):
    def __init__(self):
        super().__init__(Supplier)
    
    def update_address(self, db: Session, supplier_id: int, address_data: AddressCreate) -> Optional[Supplier]:
        supplier = self.get(db, supplier_id)
        if supplier:
            address_repo = AddressRepository()
            address = address_repo.create(db, address_data)
            supplier.address_id = address.id
            db.commit()
            db.refresh(supplier)
            return supplier
        return None