from pydantic import BaseModel

class AddressBase(BaseModel):
    country: str
    city: str
    street: str

class AddressCreate(AddressBase):
    pass

class AddressUpdate(AddressBase):
    pass

class Address(AddressBase):
    id: int
    
    class Config:
        from_attributes = True