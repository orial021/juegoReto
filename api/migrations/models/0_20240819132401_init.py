from tortoise import BaseDBAsyncClient


async def upgrade(db: BaseDBAsyncClient) -> str:
    return """
        CREATE TABLE IF NOT EXISTS "error_log" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "error_type" VARCHAR(100) NOT NULL,
    "message" TEXT NOT NULL,
    "traceback" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "status_code" VARCHAR(15),
    "username" INT,
    "method" VARCHAR(10),
    "headers" JSON,
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "user" (
    "id" CHAR(36) NOT NULL  PRIMARY KEY,
    "username" VARCHAR(100) NOT NULL UNIQUE,
    "score" INT NOT NULL  DEFAULT 0,
    "health" INT NOT NULL  DEFAULT 100,
    "global_position" VARCHAR(100),
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "aerich" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "version" VARCHAR(255) NOT NULL,
    "app" VARCHAR(100) NOT NULL,
    "content" JSON NOT NULL
);"""


async def downgrade(db: BaseDBAsyncClient) -> str:
    return """
        """
