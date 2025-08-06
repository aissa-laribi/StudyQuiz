from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import List, Optional

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
    role: str

    class Config:
        orm_mode = True  # Enables ORM model conversion to this schema

class ModuleCreate(BaseModel):
    name: str

class ModuleUpdate(BaseModel):
    module_name: Optional[str] = None

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
    repetitions: int
    interval: int
    ease_factor: float
    next_due: datetime
    last_score: int  

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

class AnswerSubmission(BaseModel):
    question_id: int
    answer_id: int

class AttemptCreateClient(BaseModel):
    created_at: datetime
    answers: List[AnswerSubmission]

class FollowupCreate(BaseModel):
    followup_due_date : datetime

class BatchModules(BaseModel):
    data: List[ModuleCreate]

class BatchModulesDelete(BaseModel):
    data: List[int]

class BatchQuizCreate(BaseModel):
    data: List[QuizCreate]

class BatchQuizDelete(BaseModel):
    data: List[int]

class BatchQuestionsCreate(BaseModel):
    data: List[QuestionCreate]

class BatchAnswersCreate(BaseModel):
    data: List[AnswerCreate]

class QuestionWithAnswersCreate(BaseModel):
    name: str
    answers: List[AnswerCreate]

class BatchQuestionsWithAnswersCreate(BaseModel):
    questions: List[QuestionWithAnswersCreate]

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: str | None = None
    role: str | None = None
    user_id: int | None = None

class TokenRequest(BaseModel):
    username: str
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str
