from fastapi import FastAPI
from app.main import app
from app.routes import user, module, quiz, question, answer, followup, attempt,ai
from fastapi.middleware.cors import CORSMiddleware
import os
from dotenv import load_dotenv

load_dotenv(".env")  # Load variables from .env file

app = FastAPI()

app.add_middleware(  
    CORSMiddleware,
    allow_origins=["https://studyquiz.co", "https://www.studyquiz.co", "http://localhost:5173",os.getenv("AI_SYSTEM")],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Welcome to StudyQuiz!"}

app.include_router(user.router, prefix="", tags=["Users"])
app.include_router(module.router, prefix="", tags=["Modules"])
app.include_router(quiz.router, prefix="", tags=["Quizzes"])
app.include_router(question.router, prefix="", tags=["Questions"])
app.include_router(answer.router, prefix="", tags=["Answers"])
app.include_router(attempt.router, prefix="", tags=["Attempts"])
app.include_router(followup.router, prefix="", tags=["Followups"])
app.include_router(ai.router, prefix="", tags=["AI"])