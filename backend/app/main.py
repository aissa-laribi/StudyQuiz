from fastapi import FastAPI
from app.routes import user, module, quiz, question, answer, followup, attempt
import sys
from fastapi.middleware.cors import CORSMiddleware



print(sys.path)

app = FastAPI()

"""
# Allow frontend requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://studyquiz.co", "https://www.studyquiz.co"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
"""

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  #Debugging
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