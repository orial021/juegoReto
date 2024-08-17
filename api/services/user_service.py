from typing import Type, TypeVar, Generic
from pydantic import BaseModel
from tortoise.models import Model
from datetime import datetime
from schemas.user_schema import UserCreateSchema
from models.user_model import User

T = TypeVar('T', bound=BaseModel)
M = TypeVar('M', bound=Model)

class CRUDService(Generic[T, M]):
    def __init__(self, model: Type[M], schema: Type[T]):
        self.model = model
        self.schema = schema

    async def create(self, data: T):
        print(data)
        try:
            return await self.model.create(**data.model_dump())
        except Exception as e:
            print(f"Error creating instance: {e}")
            return None

    async def get_all(self, offset: int = 0, limit: int = 10, order_by : str = "username"):
        try:
            query = self.model.all().offset(offset).limit(limit).order_by(order_by)
            if order_by:
                query = query.order_by(order_by)
            return await query
        except Exception as e:
            print(f"Error getting all instances: {e}")
            return None

    async def get_by_id(self, id: int):
        return await self.model.get_or_none(id=id)
    
    async def get_by_user(self, username: str):
        return await self.model.get_or_none(username=username)

    async def update(self, id: int, data: T):
        instance = await self.get_by_id(id)
        if instance:
            try:
                await instance.update_from_dict(data.model_dump()).save()
                return instance
            except Exception as e:
                print(f"Error updating instance: {e}")
        return None

    async def delete(self, id: int):
        instance = await self.get_by_id(id)
        if instance:
            try:
                instance.deleted_at = datetime.now()
                await instance.save()
                return instance
            except Exception as e:
                print(f"Error deleting instance: {e}")
        return None


class UserService(CRUDService[UserCreateSchema, User]):
    pass


user_service = UserService(User, UserCreateSchema)
