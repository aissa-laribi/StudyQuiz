# StudyQuiz

**StudyQuiz** is a web app that turns AI-generated quizzes (e.g., from ChatGPT based on lecture slides) into a **structured learning system**.  
It uses **spaced repetition** and **progress tracking**, which LLMs alone can’t offer, to help students retain information long-term instead of just cramming and forgetting.  

---

## Features
- **User Management**: Register, log in, reset passwords.
- **Quiz Management**: Create modules, add quizzes, and track progress.
- **Question Shuffling**: Display questions in random order.
- **Spaced Repetition**: Schedule follow-ups based on performance.
- **API-First**: Backend built as a clean, reusable API.
- **Web-Based Interface**: Accessible on desktop and mobile.
- **AI-Powered Quiz Import**: Generate quizzes from slides via ChatGPT.

## Planned Enhancements:
- Embedded LLMs within the website  
- Domain-specific LLMs (e.g., Medicine, Computer Science, etc.)  

---

## Tech Stack
- **Backend**: FastAPI, PostgreSQL, SQLAlchemy
- **Frontend**: Svelte
- **Deployment**: Uvicorn

---
## Roadmap
- ✅ Backend API for quiz logic
- ✅ SuperMemo 2 implementation
- ✅ CLI interaction via FASTAPI
- ✅ Frontend development
- ✅ Hosted version
- ✅ AI-powered quiz generation 
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







