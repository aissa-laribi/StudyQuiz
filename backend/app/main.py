from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Welcome to StudyQuiz!"}

@app.get("/users/{user_id}")
def get_user(user_id: int, username: str = None):
    return {"user_id": user_id,"username": username}

@app.get("/users")
def get_users():
    users = [{"user_id": 1}, {"user_id": 2}] #mock data for testing
    return {"users": users}

@app.get("/users/{user_id}/modules/{module_id}")
def get_module(user_id: int, module_id: int, username: str = None, module_name: str = None):
    return {"user_id" : user_id, "username": username, "module_id": module_id, "module_name": module_name}

@app.get("/users/{user_id}/modules")
def get_modules(user_id: int):
    modules = [
        {"module_id": 1, "module_name": "Linear Algebra"},
        {"module_id": 2, "module_name": "Matrix Algebra"}
    ]   #mock data for testing
    return {"user_id": user_id,"modules": modules} ##All modules


@app.get("/users/{user_id}/modules/{module_id}/quizzes")
def get_quizzes(user_id: int, module_id: int):
    quizzes = [
        {"quiz_id": 1, "quiz_name":"Gauss-Jordan Algorithm"},
        {"quiz_id": 2, "quiz_name": "Modelling SLE"}
    ]
    return {"user_id" : user_id, "module_id": module_id, "quizzes": quizzes}

@app.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}")
def get_quiz(user_id: int, module_id: int, quiz_id: int):
    return {"user_id" : user_id, "module_id": module_id, "quiz_id": quiz_id}

@app.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions")
def get_quiz_questions(user_id: int, module_id: int, quiz_id: int):
    questions = [{"question_id": 1, "question": "Which of the following RREF matrices can be derived from the given matrix using the Gauss-Jordan algorithm?"},
                 {"question_id": 2, "question": "Which of the following sets of operations are valid ERO?"}]
    return {"user_id" : user_id, "module_id": module_id, "quiz_id": quiz_id, "questions": questions}

@app.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}/answers")
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
@app.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/performance")
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

@app.get("/users/{user_id}/follow-ups")
def get_follow_up_quizzes(user_id: int):
    follow_ups = [
        {"quiz_id": 1, "module_id": 1, "quiz_name": "Gauss-Jordan Algorithm", "due_date": "2025-01-20"},
        {"quiz_id": 2, "module_id": 2, "quiz_name": "Modelling SLE", "due_date": "2025-01-22"},
    ]
    return {"user_id": user_id, "follow_ups": follow_ups}

