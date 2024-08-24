@echo off
cd api
pip3 install -r requirements.txt
fastapi dev --reload