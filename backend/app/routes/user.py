from fastapi import FastAPI

app = FastAPI()


@app.get("/users/{user_id}")
def get_user(user_id: int, username: str = None):
    return {"user_id": user_id,"username": username}

@app.get("/users")
def get_users():
    users = [{"user_id": 1}, {"user_id": 2}] #mock data for testing
    return {"users": users}