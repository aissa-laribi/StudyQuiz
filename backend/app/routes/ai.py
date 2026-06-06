import json
import os
import requests
from dotenv import load_dotenv
from fastapi import APIRouter, HTTPException,UploadFile,File
from typing import Annotated
import tempfile



load_dotenv(".env")
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
    x = requests.post(os.environ.get("AI_SYSTEM"), files=files)
    print("DEBUG": + str(os.environ.get("AI_SYSTEM"))[:9])
    if x.status_code == 200:
        fp.close()

        try:
            data = x.json()
            return data
        except Exception as e:
            print("ERROR:", repr(e))
            raise HTTPException(
                status_code=502,
                detail="AI provider rejected the request. This may be a network or provider permission issue."
            )
    else:
        raise HTTPException(419,detail="Unprocessable Query")