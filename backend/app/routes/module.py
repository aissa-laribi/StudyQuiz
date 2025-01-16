from fastapi import FastAPI

app = FastAPI()

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