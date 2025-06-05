# StudyQuiz

StudyQuiz is a web application designed for students to create quizzes, take them, and schedule follow-ups based on spaced repetition. This project emphasizes understanding over rote memorization, offering features like question shuffling, progress tracking, and a responsive UI.

---

## Features
- **User Management**: Register, log in, reset passwords.
- **Quiz Management**: Create modules, add quizzes, and track progress.
- **Question Shuffling**: Display questions in a random order.
- **Spaced Repetition**: Schedule follow-ups based on performance.

## Planned Enhancements:
  - 🌐 Web-based user interface (in progress) 
  - AI-powered quiz generation from slides.
  - AI-assisted answer suggestions.

---

## Tech Stack
- **Backend**: FastAPI, PostgreSQL, SQLAlchemy
- **Frontend**: Svelte, TailwindCSS
- **Deployment**: Docker (optional), Uvicorn

---
## Roadmap
- ✅ Backend API for quiz logic
- ✅ SuperMemo 2 implementation
- ✅ CLI interaction via FASTAPI
- 🔲 Frontend development (in progress)
- 🔲 Hosted version (planned)
- 🔲 AI integration (future)
---

## Setup Instructions

### Backend
1. Navigate to the backend directory

2. (Optional but recommended) Create and activate a virtual environment:
```
    # Create virtual environment
    python3 -m venv venv

    # Activate it (Linux/macOS)
    source venv/bin/activate

    # OR on Windows (cmd)
    venv\Scripts\activate.bat
```

3. Install dependencies:
```
   pip install -r requirements.txt
```
4. Run the FastAPI server:
```
    uvicorn app.main:app --reload
```
### Frontend (Coming Soon)
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







