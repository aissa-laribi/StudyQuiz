from fastapi import APIRouter

router = APIRouter()


@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers")
def get_answers(user_id: int, module_id: int, quiz_id: int, question_id: int):
    # Mock data for testing
    answers = [
        {"answer_id": 1, "correct": True},
        {"answer_id": 2, "correct": False},
        {"answer_id": 3, "correct": False},
        {"answer_id": 4, "correct": False},
        {"answer_id": 5, "correct": False}
    ]
    return {
        "user_id": user_id,
        "module_id": module_id,
        "quiz_id": quiz_id,
        "question_id": question_id,
        "answers": answers
    }