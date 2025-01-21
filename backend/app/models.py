from sqlalchemy import Column, Integer, String, ForeignKey, Boolean, func, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()
#class enabling the creation of databases entities as objects(ORM)

class User(Base):
    __tablename__ = "user"
    id = Column(Integer, primary_key= True, index = True)
    user_name = Column(String(45), nullable=False, unique=True)
    email = Column(String(245), nullable=False, unique=True)
    password = Column(String(255), nullable=False)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)
    modules = relationship("Module", back_populates="owner")
    
class Module(Base):
    __tablename__ = "module"
    id = Column(Integer, primary_key= True, index = True)
    module_name = Column(String(245), nullable=False, unique=True)
    user_id= Column(Integer, ForeignKey("user.id"), nullable = False, index=True)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)  
    owner = relationship("User", back_populates="modules")
    quizzes = relationship("Quiz", back_populates="module")

class Quiz(Base):
    __tablename__ = "quiz"
    id = Column(Integer, primary_key= True, index = True)
    quiz_name = Column(String(245), nullable=False, unique=True)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False, index=True)
    module_id = Column(Integer, ForeignKey("module.id"),nullable=False, index=True)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)    
    module = relationship("Module", back_populates="quizzes")
    questions = relationship("Question", back_populates="quiz")
    attempts = relationship("Attempt", back_populates="quiz")
    followups = relationship("Followup", back_populates="quiz")

class Question(Base):
    __tablename__ = "question"
    id = Column(Integer, primary_key= True, index = True)
    question_name = Column(String(445), nullable=False, unique=True)
    user_id = Column(Integer, ForeignKey("user.id"),nullable=False, index=True)
    module_id = Column(Integer, ForeignKey("module.id"),nullable=False, index=True)
    quiz_id = Column(Integer, ForeignKey("quiz.id"),nullable=False, index=True)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)    
    quiz = relationship("Quiz", back_populates="questions")
    answers = relationship("Answer", back_populates="question")

class Answer(Base):
    __tablename__ = "answer"
    id = Column(Integer, primary_key= True, index = True)
    answer_name = Column(String(445), nullable=False)
    answer_correct = Column(Boolean, nullable=False, default= False)
    user_id = Column(Integer, ForeignKey("user.id"),nullable=False, index=True)
    module_id = Column(Integer, ForeignKey("module.id"),nullable=False, index=True)
    quiz_id = Column(Integer, ForeignKey("quiz.id"),nullable=False, index=True)
    question_id = Column(Integer, ForeignKey("question.id"), nullable=False, index=True)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)
    question = relationship("Question", back_populates="answers")

class Attempt(Base):
    __tablename__ = "attempt"
    id = Column(Integer, primary_key= True, index = True)
    attempt_score = Column(Integer, nullable=False)
    user_id = Column(Integer, ForeignKey("user.id"),nullable=False, index=True)
    module_id = Column(Integer, ForeignKey("module.id"),nullable=False, index=True)
    quiz_id = Column(Integer, ForeignKey("quiz.id"),nullable=False)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)
    quiz = relationship("Quiz", back_populates="attempts")

class Followup(Base):
    __tablename__ = "followup"
    id = Column(Integer, primary_key= True, index = True)
    followup_due_date = Column(DateTime, nullable=False)
    user_id = Column(Integer, ForeignKey("user.id"),nullable=False, index=True)
    module_id = Column(Integer, ForeignKey("module.id"),nullable=False, index=True)
    quiz_id = Column(Integer, ForeignKey("quiz.id"),nullable=False, index=True)
    created_at = Column(DateTime, default=func.now(), nullable=True)
    updated_at = Column(DateTime, onupdate=func.now(), nullable=True)
    quiz = relationship("Quiz", back_populates="followups")