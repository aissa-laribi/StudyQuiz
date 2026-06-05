import json
import os
import requests
from dotenv import load_dotenv
from fastapi import APIRouter, HTTPException,UploadFile,File
from typing import Annotated
import tempfile



load_dotenv("env")
router = APIRouter()

@router.get("/ai")
async def wake_ai():
    x = requests.get(os.getenv("AI_SYSTEM"))
    return x.status_code

@router.post("/ai")
async def receive_from_sq(file: Annotated[bytes, File()]):
    fp = tempfile.NamedTemporaryFile()
    fp.write(file)
    
    files = {'file': open(fp.name, 'rb')}
    x = requests.post(os.getenv("AI_SYSTEM"), files=files)
    if(x.status_code == 200):
        fp.close()    
        data = x.json()
        return data
    else:
        raise HTTPException(419,detail="Unprocessable Query")