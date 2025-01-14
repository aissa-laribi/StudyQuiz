# StudyQuiz

StudyQuiz is a web application designed for students to create quizzes, take them, and schedule follow-ups based on spaced repetition. This project emphasizes understanding over rote memorization, offering features like question shuffling, progress tracking, and a responsive UI.

---

## Features
- **User Management**: Register, log in, reset passwords.
- **Quiz Management**: Create modules, add quizzes, and track progress.
- **Question Shuffling**: Display questions in a random order.
- **Spaced Repetition**: Schedule follow-ups based on performance.
- **Future Enhancements**:
  - AI-powered quiz generation from slides.
  - AI-assisted answer suggestions.

---

## Tech Stack
- **Backend**: FastAPI, PostgreSQL, SQLAlchemy
- **Frontend**: Svelte, TailwindCSS
- **Deployment**: Docker (optional), Uvicorn

---

## Setup Instructions

### Backend
1. Install dependencies:
```
   pip install -r requirements.txt
```
2. Run the FastAPI server:
```
    uvicorn backend.app.main:app --reload
```
### Frontend
1. Navigate to the frontend directory:
```
    cd frontend
```
2. Install Node.js dependencies:
```
    npm install
```
3. Start the frontend development server:
```
    npm run dev
```

### License
This project is licensed under the **Mozilla Public License 2.0**. Certain features (e.g., AI-powered tools) may be proprietary in the future.








