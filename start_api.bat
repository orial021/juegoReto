@echo off
cd api
pip3 install -r requirements.txt
aerich init -t tortoise_conf.TORTOISE_ORM
aerich init-db
aerich migrate
aerich upgrade
fastapi dev --reload