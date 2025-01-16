from fastapi import FastAPI

app = FastAPI()


@app.get("/users/{user_id}/followups")
def get_follow_up_quizzes(user_id: int):
    follow_ups = [
        {"quiz_id": 1, "module_id": 1, "quiz_name": "Gauss-Jordan Algorithm", "due_date": "2025-01-20"},
        {"quiz_id": 2, "module_id": 2, "quiz_name": "Modelling SLE", "due_date": "2025-01-22"},
    ]
    return {"user_id": user_id, "follow_ups": follow_ups}