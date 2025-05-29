from fastapi import APIRouter, Depends, HTTPException
from app.models import User, Module, Quiz, Question, Answer
from app.schemas import QuestionCreate, BatchQuestionsCreate, BatchAnswersCreate, BatchQuestionsWithAnswersCreate
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db


"""
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
"""


router = APIRouter()

@router.post("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-create")
async def create_full_quiz(user_id: int, module_id: int, quiz_id: int, data: BatchQuestionsWithAnswersCreate, db: AsyncSession = Depends(get_db)):
    results = []
    for question in data.data:
        new_question = Question(question_name=question.name, user_id=user_id, module_id = module_id, quiz_id = quiz_id)
        db.add(new_question)
        await db.flush()
        await db.refresh(new_question)
        
        answer_names = []
        for answer in question.answers:
            new_answer = Answer(answer_name = answer.name,user_id=user_id, module_id = module_id, quiz_id = quiz_id, question_id = new_question.id,answer_correct = answer.correct)
            db.add(new_answer)
            await db.flush()
            await db.refresh(new_answer)
            answer_names.append(new_answer.answer_name)

        results.append({
            "question": new_question.question_name,
            "answers": answer_names
        })
    await db.commit()
    return results

@router.post("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/")
async def create_question(user_id: int, module_id: int, quiz_id: int, question: QuestionCreate ,db: AsyncSession = Depends(get_db)):
    new_question = Question(question_name= question.name, user_id=user_id, module_id=module_id, quiz_id=quiz_id)
    db.add(new_question)
    await db.commit()
    await db.refresh(new_question)
    return new_question.id

@router.patch("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
async def update_question(user_id: int, module_id: int, quiz_id: int, question_id: int, new_data: dict, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id).where(Question.id == question_id))
    question = result.scalars().first()

    if not question:
        raise HTTPException(status_code=404, detail="Question not found")

    for key, value in new_data.items():
        setattr(question, key, value)

    # Commit the changes
    db.add(question)
    await db.commit()
    await db.refresh(question)
    return question.id

@router.delete("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
async def delete_question(user_id: int, module_id: int, quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id).where(Question.id == question_id))
    question = result.scalars().first()

    if not question:
        raise HTTPException(status_code=404, detail="Question not found for user")
    await db.delete(question)
    await db.commit()
    
    return {"message": "question deleted successfully", "question_id": question_id}

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
async def get_question(user_id: int, module_id: int, quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Question).where(Question.user_idid == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id).where(Question.id == question_id))
    question = result.scalars().first()

    if not question:
        raise HTTPException(status_code=404, detail="Module not found for user" + str(user_id))
    return question

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/")
async def get_questions(user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id))
    questions = result.scalars().all()

    return questions