from datetime import datetime
from typing import List

from sqlalchemy import Column, Integer, String, ForeignKey, Boolean, func, DateTime, Float, UniqueConstraint
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import Mapped, mapped_column, relationship

Base = declarative_base()
#class enabling the creation of databases entities as objects(ORM)

class User(Base):
    __tablename__ = "user"
    id: Mapped[int] = mapped_column(primary_key=True)
    user_name: Mapped[str] = mapped_column(String(45), nullable=False, unique=True)
    email: Mapped[str] = mapped_column(String(245), nullable=False, unique=True)
    password: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[str] = mapped_column(String(4), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=func.now(), nullable=True)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime, onupdate=func.now(), nullable=True)
    modules: Mapped[List["Module"]] = relationship(back_populates="owner")
    
class Module(Base):
    __tablename__ = "module"
    __table_args__ = (UniqueConstraint('user_id', 'module_name', name='unique_module_per_user'),)
    id: Mapped[int] = mapped_column(primary_key= True)
    module_name: Mapped[str] = mapped_column(String(245), nullable=False, unique=True)
    user_id: Mapped[int ]= mapped_column(ForeignKey("user.id"), nullable = False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=func.now(), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(DateTime, onupdate=func.now(),nullable=True)  
    owner: Mapped["User"] = relationship(back_populates="modules")
    quizzes: Mapped[List["Quiz"]] = relationship(back_populates="module", cascade="all, delete-orphan")
    followups: Mapped[List["Followup"]] = relationship("Followup", back_populates="module")

class Quiz(Base):
    __tablename__ = "quiz"
    __table_args__ = (UniqueConstraint('user_id', 'quiz_name', name='unique_quiz_name_per_module'),)
    id: Mapped[int] = mapped_column(primary_key= True)
    quiz_name: Mapped[str] = mapped_column(String(245), nullable=False, unique=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"), nullable=False)
    module_id: Mapped[int] = mapped_column(ForeignKey("module.id", ondelete="CASCADE"),nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=func.now(), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(DateTime, onupdate=func.now(), nullable=True)
    repetitions: Mapped[int] = mapped_column(nullable=False,default=0)
    interval: Mapped[int] = mapped_column(nullable=False,default=0)
    ease_factor: Mapped[float] = mapped_column(nullable=False,default=2.5)
    next_due: Mapped[datetime] = mapped_column(DateTime,nullable=True)
    last_score: Mapped[int] =  mapped_column(nullable=False,default=0)   
    module: Mapped["Module"] = relationship(back_populates="quizzes")
    questions: Mapped[List["Question"]] = relationship(back_populates="quiz",cascade="all, delete-orphan")
    attempts: Mapped[List["Attempt"]] = relationship(back_populates="quiz", cascade="all, delete-orphan")
    followups: Mapped[List["Followup"]] = relationship(back_populates="quiz", cascade="all, delete-orphan")

class Question(Base):
    __tablename__ = "question"
    id: Mapped[int] = mapped_column(primary_key= True)
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"),nullable=False)
    module_id: Mapped[int] = mapped_column(ForeignKey("module.id"),nullable=False)
    quiz_id: Mapped[int] = mapped_column(ForeignKey("quiz.id",ondelete="CASCADE"),nullable=False)
    question_name: Mapped[str] = mapped_column(String(445), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=func.now(), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(DateTime, onupdate=func.now(), nullable=True)    
    quiz: Mapped["Quiz"] = relationship(back_populates="questions")
    answers: Mapped[List["Answer"]] = relationship(back_populates="question", cascade="all, delete-orphan")

class Answer(Base):
    __tablename__ = "answer"
    id: Mapped[int] = mapped_column(primary_key= True)
    answer_name: Mapped[str] = mapped_column(String(445), nullable=False)
    answer_correct: Mapped[bool] = mapped_column(nullable=False, default= False)
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"),nullable=False)
    module_id: Mapped[int] = mapped_column(ForeignKey("module.id"),nullable=False)
    quiz_id: Mapped[int] = mapped_column(ForeignKey("quiz.id",ondelete="CASCADE"),nullable=False)
    question_id: Mapped[int] = mapped_column(ForeignKey("question.id"), nullable=False, index=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=func.now(), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(onupdate=func.now(), nullable=True)
    question: Mapped["Question"] = relationship(back_populates="answers")

class Attempt(Base):
    __tablename__ = "attempt"
    id: Mapped[int] = mapped_column(primary_key= True)
    attempt_score: Mapped[int] = mapped_column(nullable=False)
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"),nullable=False, index=True)
    module_id: Mapped[int] = mapped_column(ForeignKey("module.id"),nullable=False, index=True)
    quiz_id: Mapped[int] = mapped_column(ForeignKey("quiz.id", ondelete="CASCADE"), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=func.now(), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(DateTime, onupdate=func.now(), nullable=True)
    quiz: Mapped["Quiz"] = relationship(back_populates="attempts")
    

class Followup(Base):
    __tablename__ = "followup"
    id: Mapped[int] = mapped_column(primary_key= True)
    followup_due_date: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"),nullable=False)
    module_id: Mapped[int] = mapped_column(ForeignKey("module.id"),nullable=False, index=True)
    quiz_id: Mapped[int] = mapped_column(ForeignKey("quiz.id",ondelete="CASCADE"),nullable=False, index=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=func.now(), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(DateTime, onupdate=func.now(), nullable=True)
    module: Mapped["Module"] = relationship(back_populates="followups")
    quiz: Mapped["Quiz"] = relationship(back_populates="followups")
    