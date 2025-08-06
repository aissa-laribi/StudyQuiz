from fastapi import APIRouter, Depends, HTTPException, status
from app.models import User, Module, Quiz, Question, Answer
from app.schemas import QuestionCreate, BatchQuestionsWithAnswersCreate, QuestionWithAnswersCreate
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.routes.user import router, get_current_active_user
from typing import Annotated


router = APIRouter()

@router.post("/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/batch-create")
async def create_full_quiz_from_names(
    current_user: Annotated[User, Depends(get_current_active_user)],
    module_name: str,
    quiz_name: str,
    questions: BatchQuestionsWithAnswersCreate,
    db: AsyncSession = Depends(get_db)
):
    user_id = current_user.id

    if current_user.role != "root" and current_user.id != user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

    module_result = await db.execute(
        select(Module).where(Module.module_name == module_name, Module.user_id == user_id)
    )
    module = module_result.scalars().first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    quiz_result = await db.execute(
        select(Quiz).where(
            Quiz.quiz_name == quiz_name,
            Quiz.module_id == module.id,
            Quiz.user_id == user_id
        )
    )
    quiz = quiz_result.scalars().first()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    results = []

    for question in questions.questions:
        new_question = Question(
            question_name=question.name,
            user_id=user_id,
            module_id=module.id,
            quiz_id=quiz.id
        )
        db.add(new_question)
        await db.flush()
        await db.refresh(new_question)

        answer_names = []
        for answer in question.answers:
            new_answer = Answer(
                answer_name=answer.name,
                answer_correct=answer.correct,
                user_id=user_id,
                module_id=module.id,
                quiz_id=quiz.id,
                question_id=new_question.id
            )
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

@router.post("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-create")
async def create_full_quiz(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, data: BatchQuestionsWithAnswersCreate, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
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
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")
    

@router.post("/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/with-answers")
async def create_question_answers_from_names(
    current_user: Annotated[User, Depends(get_current_active_user)],
    module_name: str,
    quiz_name: str,
    question: QuestionWithAnswersCreate,
    db: AsyncSession = Depends(get_db)
):
    user_id = current_user.id

    if current_user.role != "root" and current_user.id != user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

    module_result = await db.execute(
        select(Module).where(Module.module_name == module_name, Module.user_id == user_id)
    )
    module = module_result.scalars().first()
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    quiz_result = await db.execute(
        select(Quiz).where(
            Quiz.quiz_name == quiz_name,
            Quiz.module_id == module.id,
            Quiz.user_id == user_id
        )
    )
    quiz = quiz_result.scalars().first()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    new_question = Question(
        question_name=question.name,
        quiz_id=quiz.id,
        user_id=user_id,
        module_id=module.id
    )
    db.add(new_question)
    await db.flush()  # Needed to get new_question.id

    for ans in question.answers:
        new_answer = Answer(
            answer_name=ans.name,
            answer_correct=ans.correct,
            question_id=new_question.id,
            user_id=user_id,
            module_id=module.id,
            quiz_id=quiz.id
        )
        db.add(new_answer)

    await db.commit()
    await db.refresh(new_question)
    return new_question


@router.post("/users/me/modules/{module_name}/quizzes/{quiz_name}/questions")
async def create_question_from_name(
    current_user: Annotated[User, Depends(get_current_active_user)],
    module_name: str,
    quiz_name: str,
    question: QuestionCreate,
    db: AsyncSession = Depends(get_db)
):
    user_id = current_user.id

    if current_user.role != "root" and current_user.id != user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

    module_result = await db.execute(
        select(Module).where(Module.module_name == module_name, Module.user_id == user_id)
    )
    module = module_result.scalars().first()
    
    if not module:
        raise HTTPException(status_code=404, detail="Module not found")

    quiz_result = await db.execute(
        select(Quiz).where(
            Quiz.quiz_name == quiz_name,
            Quiz.module_id == module.id,
            Quiz.user_id == user_id
        )
    )
    quiz = quiz_result.scalars().first()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    new_question = Question(
        question_name=question.name,
        quiz_id=quiz.id,
        user_id=user_id,
        module_id=module.id
    )

    db.add(new_question)
    await db.commit()
    await db.refresh(new_question)
    return new_question


@router.post("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/")
async def create_question(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question: QuestionCreate ,db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        new_question = Question(question_name= question.name, user_id=user_id, module_id=module_id, quiz_id=quiz_id)
        db.add(new_question)
        await db.commit()
        await db.refresh(new_question)
        return new_question.id
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.patch("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
async def update_question(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question_id: int, new_data: dict, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
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
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.delete("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/batch-delete/")
async def delete_all_questions(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        print("WARNING!: All answers associated with the questions will be removed as well.")
        deleted_ids = []
        result = await db.execute(
            select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id))
        questions = result.scalars().all()
        for question in questions:
            print(question.question_name)
            if question is not None:
                answers_result = await db.execute(select(Answer).where(Answer.user_id == user_id).where(Answer.module_id == module_id).where(Answer.quiz_id == quiz_id).where(Answer.question_id == question.id))
                answers = answers_result.scalars().all()
                for answer in answers:
                    await db.delete(answer)
                await db.delete(question)
                deleted_ids.append(question.id)
            else:
                print("None")
        await db.commit()
        return {"deleted": deleted_ids}
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.delete("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
async def delete_question(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id).where(Question.id == question_id))
        question = result.scalars().first()

        if not question:
            raise HTTPException(status_code=404, detail="Question not found for user")
        await db.delete(question)
        await db.commit()
    
        return {"message": "question deleted successfully", "question_id": question_id}
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/{question_id}")
async def get_question(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id).where(Question.id == question_id))
        question = result.scalars().first()

        if not question:
            raise HTTPException(status_code=404, detail="Module not found for user" + str(user_id))
        return question
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

@router.get("/users/me/modules/{module_name}/quizzes/{quiz_name}/questions/")
async def get_questions_from_name(
    current_user: Annotated[User, Depends(get_current_active_user)],
    module_name: str,
    quiz_name: str,
    db: AsyncSession = Depends(get_db)
):
    user_id = current_user.id

    result = await db.execute(
        select(Question)
        .join(Question.quiz)
        .join(Quiz.module)
        .where(Question.user_id == user_id)
        .where(Quiz.quiz_name == quiz_name)
        .where(Module.module_name == module_name)
        .order_by(Question.id)
    )
    return result.scalars().all()

@router.get("/users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/questions/")
async def get_questions(current_user: Annotated[User, Depends(get_current_active_user)],user_id: int, module_id: int, quiz_id: int, db: AsyncSession = Depends(get_db)):
    if current_user.role == "root" or current_user.id == user_id:
        result = await db.execute(select(Question).where(Question.user_id == user_id).where(Question.module_id == module_id).where(Question.quiz_id == quiz_id))
        questions = result.scalars().all()

        return questions
    else:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")