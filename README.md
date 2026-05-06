# StudyQuiz
[![Integration Tests](https://github.com/aissa-laribi/StudyQuiz/actions/workflows/integration-tests.yml/badge.svg)](https://github.com/aissa-laribi/StudyQuiz/actions/workflows/integration-tests.yml)

**StudyQuiz** is a web app that turns AI-assisted quizzes generated from study materials such as lecture slides into a **structured learning system**.  
It uses **spaced repetition** and **progress tracking**, which LLMs alone can’t offer, to help students retain information long-term instead of just cramming and forgetting.  

---

## Features
- **User Management**: Register, log in, reset passwords.
- **Quiz Management**: Create modules, add quizzes, and track progress.
- **Question Shuffling**: Display questions in random order.
- **Spaced Repetition**: Schedule follow-ups based on performance.
- **API-First**: Backend built as a clean, reusable API.
- **Web-Based Interface**: Accessible on desktop and mobile.
- **AI-Assisted Quiz Import**: Import structured quizzes generated from study materials.

## Planned Enhancements:
- Integrated AI inference for quiz generation 

---

## Tech Stack
- **Backend**: FastAPI, PostgreSQL, SQLAlchemy
- **Frontend**: Svelte
- **Testing/CI**: Pytest, GitHub Actions
- **Deployment**: Render, Uvicorn

---
## Roadmap
- ✅ Backend API for quiz logic
- ✅ SuperMemo 2 implementation
- ✅ CLI interaction via FastAPI
- ✅ Frontend development
- ✅ Hosted version
- ✅ AI-assisted quiz generation workflow
- ✅ Integration test workflow
- ⏳ Integrated AI inference for quiz generation
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







