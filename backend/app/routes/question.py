from fastapi import APIRouter

router = APIRouter()

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions")
def get_quiz_questions(user_id: int, module_id: int, quiz_id: int):
    questions = [{"question_id": 1, "question": "Which of the following RREF matrices can be derived from the given matrix using the Gauss-Jordan algorithm?"},
                 {"question_id": 2, "question": "Which of the following sets of operations are valid ERO?"}]
    return {"user_id" : user_id, "module_id": module_id, "quiz_id": quiz_id, "questions": questions}