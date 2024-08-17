from typing import List
from fastapi import APIRouter
from schemas.user_schema import UserCreateSchema, UserResponseSchema
from controllers.user_controller import get_by_user_controller, create_controller, get_all_controller, get_controller, update_controller, delete_controller
import uuid

user_router = APIRouter()

@user_router.get('/all', name="User_all", tags=['User'], response_model=List[UserResponseSchema])
async def all(offset: int = 0, limit: int = 12, order_by: str = "username"):
    return await get_all_controller(offset, limit, order_by)

@user_router.get('/show/{id}', tags=['User'], response_model=UserResponseSchema)
async def show(id: uuid.UUID):
    return await get_controller(id)

@user_router.get('/show_by_user/{username}', tags=['User'], response_model=UserResponseSchema)
async def show_by_user(username: str):
    return await get_by_user_controller(username)


@user_router.post('/create', tags=['User'], response_model=UserResponseSchema)
async def creater(data: UserCreateSchema):
    print(data)
    return await create_controller(data)

@user_router.put('/update/{id}', tags=['User'], response_model=UserResponseSchema)
async def updater(id: uuid.UUID, data: UserCreateSchema):
    print(id, data)
    return await update_controller(id, data)

@user_router.delete('/delete/{id}', tags=['User'], response_model=UserResponseSchema)
async def deleter(id: uuid.UUID):
    return await delete_controller(id)