from datetime import datetime
from typing import Optional
from pydantic import BaseModel
import uuid


class User(BaseModel):
    id : uuid.UUID
    username : str
    score : Optional[int]
    health : Optional[int]
    global_position : Optional[str]
    
    class config:
        orm_mode = True 
        
class UserCreateSchema(BaseModel):
    username : str
    score : Optional[int]
    health : Optional[int]
    global_position : Optional[str]
    
    class config:
        orm_mode = True
        
class UserResponseSchema(BaseModel):
    id : uuid.UUID
    username : str
    score : Optional[int]
    health : Optional[int]
    global_position : Optional[str]
    created_at : datetime
    updated_at : datetime
    deleted_at : Optional[datetime]
    
    class config:
        orm_mode = True
    