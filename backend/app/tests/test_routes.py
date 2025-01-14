from fastapi.testclient import TestClient
import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../../")))
from app.main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to StudyQuiz!"}

#Test unit not working without mocking data in the get_users()
def test_get_users():
    response = client.get("/users")
    mock_users = [{"user_id": 1}, {"user_id": 2}]
    assert response.status_code == 200
    assert response.json() == {"users":mock_users} 

def test_get_user():
    user_id = 1
    username = "Aissa"
    mock_user = {"user_id": user_id, "username": username}
    response = client.get(f"/users/{user_id}?username={username}")
    assert response.status_code == 200
    assert response.json() == mock_user

def test_get_module():
    user_id = 1
    username = "Aissa"
    module_id = 1
    module_name = "Matrix Algebra"
    mock_user = {"user_id": user_id, "username": username, "module_id": module_id, "module_name": module_name}
    response = client.get(f"/users/{user_id}/modules/{module_id}?username={username}&module_name={module_name}")
    assert response.status_code == 200
    assert response.json() == mock_user

def test_get_modules():
    user_id = 1
    mock_modules = [
        {"module_id": 1, "module_name": "Linear Algebra"},
        {"module_id": 2, "module_name": "Matrix Algebra"}
    ]
    mock_response = {"user_id": user_id, "modules": mock_modules}
    response = client.get(f"/users/{user_id}/modules")
    assert response.status_code == 200
    assert response.json() == mock_response

def test_get_quizzes():
    user_id = 1
    module_id = 1
    mock_quizzes = [
        {"quiz_id": 1, "quiz_name": "Gauss-Jordan Algorithm"},
        {"quiz_id": 2, "quiz_name": "Modelling SLE"}
    ]
    mock_response = {"user_id": user_id, "module_id": module_id, "quizzes": mock_quizzes}

    response = client.get(f"/users/{user_id}/modules/{module_id}/quizzes")
    assert response.status_code == 200
    assert response.json() == mock_response

def test_get_quiz_questions():
    user_id = 1
    module_id = 1
    quiz_id = 1
    mock_questions = [
        {"question_id": 1, "question": "Which of the following RREF matrices can be derived from the given matrix using the Gauss-Jordan algorithm?"},
        {"question_id": 2, "question": "Which of the following sets of operations are valid ERO?"}
    ]
    mock_response = {
        "user_id": user_id,
        "module_id": module_id,
        "quiz_id": quiz_id,
        "questions": mock_questions
    }

    response = client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions")
    assert response.status_code == 200
    assert response.json() == mock_response

def test_get_answers():
    user_id = 1
    module_id = 1
    quiz_id = 1
    question_id = 1
    mock_answers = [
        {"answer_id": 1, "correct": True},
        {"answer_id": 2, "correct": False},
        {"answer_id": 3, "correct": False},
        {"answer_id": 4, "correct": False},
        {"answer_id": 5, "correct": False}
    ]
    mock_response = {
        "user_id": user_id,
        "module_id": module_id,
        "quiz_id": quiz_id,
        "question_id": question_id,
        "answers": mock_answers
    }
    response = client.get(f"/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers")
    assert response.status_code == 200
    assert response.json() == mock_response


