import dotenv
import os

dotenv.load_dotenv()

DB_conection = os.getenv("DB_key")

TORTOISE_ORM = {
    "connections": {
        "default": DB_conection,
    },
    "apps": {
        "models": {
            "models": ["models", "aerich.models"], 
            "default_connection": "default",
        },
    },
}

