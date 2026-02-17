from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.schemas.supplier import Supplier, SupplierCreate, SupplierUpdate
from app.schemas.address import AddressCreate
from app.repositories.supplier import SupplierRepository

router = APIRouter()
repo = SupplierRepository()

@router.post("/", response_model=Supplier, status_code=status.HTTP_201_CREATED)
def create_supplier(supplier: SupplierCreate, db: Session = Depends(get_db)):
    return repo.create(db, supplier)

@router.get("/{supplier_id}", response_model=Supplier)
def get_supplier(supplier_id: int, db: Session = Depends(get_db)):
    supplier = repo.get(db, supplier_id)
    if not supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")
    return supplier

@router.get("/", response_model=List[Supplier])
def get_suppliers(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    return repo.get_all(db, skip, limit)

@router.put("/{supplier_id}/address", response_model=Supplier)
def update_supplier_address(supplier_id: int, address: AddressCreate, db: Session = Depends(get_db)):
    supplier = repo.update_address(db, supplier_id, address)
    if not supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")
    return supplier

@router.delete("/{supplier_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_supplier(supplier_id: int, db: Session = Depends(get_db)):
    if not repo.delete(db, supplier_id):
        raise HTTPException(status_code=404, detail="Supplier not found")