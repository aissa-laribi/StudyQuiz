## [0.1.0] – 2025-06-05
### Added
- Full quiz creation via JSON
- Fisher-Yates question shuffling
- SuperMemo 2 spaced repetition
- Follow-up scheduling
- Quiz attempt execution via CLI after triggering HTTP POST

### 📝 Notes
- App runs locally via FastAPI: uvicorn app.main:app --reload
- To take a quiz:
- Trigger the POST /users/{user_id}/modules/{module_id}/quizzes/{quiz_id}/attempts/ endpoint (e.g. via Swagger UI at http://127.0.0.1:8000/docs)
- The quiz then runs interactively in the terminal
- No browser-based UI yet — CLI interaction only
