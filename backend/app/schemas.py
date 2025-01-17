from pydantic import BaseModel, EmailStr

class UserCreate(BaseModel):
    user_name: str
    email: EmailStr
    password: str #Plain text password entered from User

class UserResponse(BaseModel):
    id: int
    user_name: str
    email: EmailStr

    class Config:
        orm_mode = True  # Enables ORM model conversion to this schema