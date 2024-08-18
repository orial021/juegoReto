from tortoise import BaseDBAsyncClient


async def upgrade(db: BaseDBAsyncClient) -> str:
    return """
        ALTER TABLE "user" ALTER COLUMN "global_position" DROP DEFAULT;
        ALTER TABLE "user" ALTER COLUMN "global_position" DROP NOT NULL;"""


async def downgrade(db: BaseDBAsyncClient) -> str:
    return """
        ALTER TABLE "user" ALTER COLUMN "global_position" SET NOT NULL;
        ALTER TABLE "user" ALTER COLUMN "global_position" SET DEFAULT '(93, 557)';"""
