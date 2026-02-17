from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.schemas.client import Client, ClientCreate, ClientUpdate
from app.schemas.address import AddressCreate
from app.repositories.client import ClientRepository

router = APIRouter()
repo = ClientRepository()

@router.post("/", response_model=Client, status_code=status.HTTP_201_CREATED)
def create_client(client: ClientCreate, db: Session = Depends(get_db)):
    return repo.create(db, client)

@router.get("/{client_id}", response_model=Client)
def get_client(client_id: int, db: Session = Depends(get_db)):
    client = repo.get(db, client_id)
    if not client:
        raise HTTPException(status_code=404, detail="Client not found")
    return client

@router.get("/", response_model=List[Client])
def get_clients(
    name: Optional[str] = None,
    surname: Optional[str] = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    if name and surname:
        return repo.get_by_name(db, name, surname)
    return repo.get_all(db, skip, limit)

@router.put("/{client_id}/address", response_model=Client)
def update_client_address(client_id: int, address: AddressCreate, db: Session = Depends(get_db)):
    client = repo.update_address(db, client_id, address)
    if not client:
        raise HTTPException(status_code=404, detail="Client not found")
    return client

@router.delete("/{client_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_client(client_id: int, db: Session = Depends(get_db)):
    if not repo.delete(db, client_id):
        raise HTTPException(status_code=404, detail="Client not found")