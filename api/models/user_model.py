from tortoise import fields
from tortoise.models import Model
import uuid
import bcrypt

class User(Model):
    id = fields.UUIDField(pk=True, default=uuid.uuid4)
    username = fields.CharField(max_length=100, unique=True)
    score = fields.IntField(default=0)
    health = fields.IntField(default=100)
    global_position = fields.CharField(max_length=100, default="(0,0)")
    
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)
    deleted_at = fields.DatetimeField(null = True)
    

    def __str__(self):
        return self.username
    
    class Meta:
        table = "user"
