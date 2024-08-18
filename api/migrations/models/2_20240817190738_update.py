from tortoise import BaseDBAsyncClient


async def upgrade(db: BaseDBAsyncClient) -> str:
    return """
        CREATE TABLE IF NOT EXISTS "error_log" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "error_type" VARCHAR(100) NOT NULL,
    "message" TEXT NOT NULL,
    "traceback" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "status_code" VARCHAR(15),
    "username" INT,
    "method" VARCHAR(10),
    "headers" JSONB,
    "created_at" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP
);"""


async def downgrade(db: BaseDBAsyncClient) -> str:
    return """
        DROP TABLE IF EXISTS "error_log";"""
