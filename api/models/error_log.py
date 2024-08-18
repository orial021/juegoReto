from tortoise import fields
from tortoise.models import Model

class ErrorLog(Model):
    id = fields.IntField(pk=True)
    error_type = fields.CharField(max_length=100)
    message = fields.TextField()  # Mensaje de error
    traceback = fields.TextField()  # Traza del stack
    url = fields.TextField()  # URL solicitada cuando ocurrió el error
    status_code = fields.CharField(max_length=15, null = True)
    username = fields.IntField(null = True)  # ID del usuario que generó el error
    method = fields.CharField(max_length=10, null = True)  # Método HTTP
    headers = fields.JSONField(null = True)  # Cabeceras HTTP
    created_at = fields.DatetimeField(auto_now_add=True)  # Fecha y hora cuando ocurrió el error

    def __str__(self):
        return f"{self.error_type} - {self.message}"
    
    class Meta:
        table = "error_log"