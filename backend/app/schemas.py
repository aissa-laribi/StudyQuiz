from pydantic import BaseModel, EmailStr
from datetime import datetime

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

class ModuleCreate(BaseModel):
    name: str

class ModuleOut(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True

class QuizCreate(BaseModel):
    name: str

class QuizOut(BaseModel):
    id: int
    name: str
    module: str
    #questions: dict

    class Config:
        from_attributes = True

class QuestionCreate(BaseModel):
    name: str
    

class QuestionOut(BaseModel):
    id: int
    name: str
    module: str
    quiz: str
    #answers: dict

    class Config:
        from_attributes = True

class AnswerCreate(BaseModel):
    name: str
    correct: bool

class AnswerOut(BaseModel):
    id: int
    name: str
    module: str
    quiz: str
    answer: str

    class Config:
        from_attributes = True

class AttemptCreate(BaseModel):
    attempt_score: int
    created_at: datetime
