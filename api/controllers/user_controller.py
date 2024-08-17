from services.user_service import user_service as service
from schemas.user_schema import UserCreateSchema
from fastapi import HTTPException

async def create_controller(data: UserCreateSchema):
    print(data)
    return await service.create(data)

async def get_all_controller(offset = 0, limit = 10, order_by = "username"):
    return await service.get_all(offset, limit, order_by)

async def get_controller(id: int):
    entity = await service.get_by_id(id)
    if entity is None:
        raise HTTPException(status_code=404, detail='not found')
    return entity

async def get_by_user_controller(username: str):
    entity = await service.get_by_user(username)
    if entity is None:
        raise HTTPException(status_code=404, detail='not found')
    return entity

async def update_controller(id: int, data: UserCreateSchema):
    entity = await service.update(id, data)
    if entity is None:
        raise HTTPException(status_code=404, detail='not found')
    return entity

async def delete_controller(id: int):
    entity = await service.delete(id)
    if entity is None:
        raise HTTPException(status_code=404, detail='not found')
    return entity