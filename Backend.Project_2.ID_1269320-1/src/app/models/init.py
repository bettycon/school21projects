# Импортируем все модели для корректного создания
from .address import Address
from .client import Client
from .supplier import Supplier
from .image import Image
from .product import Product

__all__ = ['Address', 'Client', 'Supplier', 'Image', 'Product']