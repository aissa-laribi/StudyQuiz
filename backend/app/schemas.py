from pydantic import BaseModel, EmailStr

#Checks the validity of the data passed for user_name, email, and password
class UserCreate(BaseModel):
    user_name: str
    email: EmailStr
    password: str #Plain text password entered from User

#Ensuring password nost sent in the response
class UserResponse(BaseModel):
    id: int
    user_name: str
    email: EmailStr

    class Config:
        orm_mode = True  # Enables ORM model conversion to this schema