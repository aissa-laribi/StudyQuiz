from fastapi import FastAPI
from app.routes import user, module, quiz, question, answer, followup, performance
import sys
print(sys.path)

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Welcome to StudyQuiz!"}

app.include_router(user.router, prefix="", tags=["Users"])
app.include_router(module.router, prefix="", tags=["Modules"])
app.include_router(quiz.router, prefix="", tags=["Quizzes"])
app.include_router(question.router, prefix="", tags=["Questions"])
app.include_router(answer.router, prefix="", tags=["Answers"])
app.include_router(performance.router, prefix="", tags=["Performances"])
app.include_router(followup.router, prefix="", tags=["Followups"])