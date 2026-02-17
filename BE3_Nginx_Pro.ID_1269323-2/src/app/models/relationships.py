from sqlalchemy.orm import relationship
from .client import Client
from .product import Product
from .supplier import Supplier
from .image import Image


Client.address = relationship("Address", backref="clients")
Supplier.address = relationship("Address", backref="suppliers")
Product.supplier = relationship("Supplier", backref="products")
Product.image = relationship("Image", backref="product")
Image.product = relationship("Product", backref="images")
