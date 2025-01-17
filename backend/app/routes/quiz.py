from fastapi import APIRouter

router = APIRouter()

@router.get("/users/{user_id}/modules/{module_id}/quizzes")
def get_quizzes(user_id: int, module_id: int):
    quizzes = [
        {"quiz_id": 1, "quiz_name":"Gauss-Jordan Algorithm"},
        {"quiz_id": 2, "quiz_name": "Modelling SLE"}
    ]
    return {"user_id" : user_id, "module_id": module_id, "quizzes": quizzes}

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
def get_quiz(user_id: int, module_id: int, quiz_id: int):
    return {"user_id" : user_id, "module_id": module_id, "quiz_id": quiz_id}