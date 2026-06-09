from fastapi import FastAPI
from app.main import app as imported_app

app: FastAPI = imported_app