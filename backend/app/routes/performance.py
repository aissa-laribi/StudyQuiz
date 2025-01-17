from fastapi import APIRouter

router = APIRouter()

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/performance")
def get_quiz_performance(user_id: int, module_id: int, quiz_id: int):
    performance = {
        "attempts": [
            {"attempt_id": 1, "score": 80, "date": "2025-01-10"},
            {"attempt_id": 2, "score": 90, "date": "2025-01-12"}
        ],
        "average_score": 85,
        "last_score": 90,
        "total_attempts": 2
    }
    return {
        "user_id": user_id,
        "module_id": module_id,
        "quiz_id": quiz_id,
        "performance": performance
    }