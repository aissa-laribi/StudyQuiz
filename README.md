# StudyQuiz

[![Integration Tests](https://github.com/aissa-laribi/StudyQuiz/actions/workflows/integration-tests.yml/badge.svg)](https://github.com/aissa-laribi/StudyQuiz/actions/workflows/integration-tests.yml)

**StudyQuiz** is a web application that turns study materials such as lecture slides and PDF notes into **AI-assisted quizzes within a structured learning system**.

Unlike using an LLM alone, StudyQuiz combines quiz generation with **spaced repetition**, scheduled reviews, and progress tracking to help students retain concepts over time instead of relying on short-term cramming.

🌐 Live version: https://studyquiz.co

---

## Features

* **User management**: Register, verify an account, log in, and manage access.
* **Module and quiz management**: Create modules, quizzes, questions, and answers.
* **AI-assisted quiz generation**: Upload study materials and generate structured quizzes.
* **Question shuffling**: Display questions in a different order between attempts.
* **Spaced repetition**: Schedule follow-up reviews based on quiz performance.
* **Progress tracking**: Record attempts, results, and upcoming review dates.
* **API-first architecture**: Reusable backend API built with FastAPI.
* **Responsive web interface**: Accessible on desktop and mobile.

## Planned Enhancements

* User profile management
* Account plans and usage limits
* Support for non-PDF materials
* Manual quiz creation
* Additional AI inference options

---

## Tech Stack

* **Backend**: FastAPI, PostgreSQL, SQLAlchemy
* **Frontend**: Svelte
* **Testing/CI**: Pytest, GitHub Actions
* **Deployment**: FastAPI Cloud, Render, Uvicorn

---

## Roadmap

* ✅ Backend API for quiz logic
* ✅ SuperMemo 2 spaced-repetition implementation
* ✅ FastAPI interactive API documentation
* ✅ Svelte frontend
* ✅ Hosted production version
* ✅ AI-assisted quiz generation from uploaded study materials
* ✅ Email verification workflow
* ✅ Integration test workflow
* ⏳ User profile management
* ⏳ Account plans and usage limits

---

## Setup Instructions

### Clone the repository

```
git clone https://github.com/aissa-laribi/StudyQuiz.git
cd StudyQuiz
```

### Backend

1. Navigate to the backend directory.

```
cd backend
```

2. (Optional but recommended) Create and activate a virtual environment:

```bash
# Create virtual environment
python3 -m venv venv

# Activate it (Linux/macOS)
source venv/bin/activate

# OR on Windows (cmd)
venv\Scripts\activate.bat
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

4. Development environment variables

Create an `.env` file and add the following:

```env
DATABASE_URL=postgresql+asyncpg://studyquiz_user:password@localhost/studyquiz_local
TEST_DATABASE_URL=postgresql+asyncpg://studyquiz_user:password@localhost/test_studyquiz_local

SECRET_KEY="local-development-secret"
ALGORITHM="HS256"
ACCESS_TOKEN_EXPIRE_MINUTES=120

AI_SYSTEM=""
SEND_CONFIRMATION=""
FRONTEND_URL="http://localhost:5173"
FRONTEND_PATH=../frontend
```

5. Create the development databases

Make sure PostgreSQL is installed and running.

Create a PostgreSQL user and the development databases using your local PostgreSQL administration tools:

Open PostgreSQL using an administrator account. On Ubuntu or Debian:

```bash
sudo -u postgres psql
```

Then create the PostgreSQL user and databases:

```sql
CREATE USER studyquiz_user WITH PASSWORD 'password';
CREATE DATABASE studyquiz_local OWNER studyquiz_user;
CREATE DATABASE test_studyquiz_local OWNER studyquiz_user;
\q
```
Then import the schema:

```bash
cd ..
psql "postgresql://studyquiz_user:password@localhost/studyquiz_local" -f dbschema.sql
psql "postgresql://studyquiz_user:password@localhost/test_studyquiz_local" -f dbschema.sql
```
Open PostgreSQL again and add the users required by the integration tests:

```bash
sudo -u postgres psql
```

```sql
\c test_studyquiz_local
INSERT INTO public."user" (user_name, email, password, role, verified) VALUES ('testuser1', 'user1@gmail.com', '$2b$12$3jF.2woCsTQaie.tYorJR.YTe/F6TZC/dJf8.g9Bb0BZIXEo77cn6', 'root', true);
INSERT INTO public."user" (user_name, email, password, role, verified) VALUES ('testuser2', 'user2@gmail.com', '$2b$12$zzKJod0KMg79oNxugy4Uh.NcMEE/rzaDet1v/7dJSNvmGHgTqM/z2', 'user', false);
INSERT INTO public."user" (user_name, email, password, role, verified) VALUES ('test_user3', 'user3@gmail.com', '$2b$12$aYHuJm/kmuLORvDMbhf/eucpdu7CcV7V36qluB8H/YKK0piszRFQ6', 'user', false);
\q
```

6. Run the FastAPI server:

```bash
cd backend
uvicorn app.main:app --reload
```

### Frontend

1. Navigate to the frontend directory:

Open a new Terminal window

```bash
cd /path/to/StudyQuiz/frontend
```

2. Install Node.js dependencies:

```bash
npm install
```

3. Create an `.env.development` file and add:
```
VITE_API_URL=http://localhost:8000
```

4. Start the frontend development server:

```bash
npm run dev
```

## License

The code in this repository is licensed under the **Mozilla Public License 2.0 (MPL-2.0)** unless stated otherwise.

StudyQuiz may include or integrate with separate commercial, hosted, AI-powered, billing, infrastructure, or deployment features in the future. These features are not automatically included in the MPL-licensed codebase unless they are explicitly added to this repository under the MPL-2.0 license.

See the `LICENSE` file for details.

---

## Contributing

StudyQuiz welcomes selected open-source contributions within clearly defined boundaries.

Contributions can help improve test coverage, accessibility, user experience, and selected backend or frontend features.

Not every open issue is available for external contribution. Issues open to contributors will be labelled with one of the following:

* `open-to-contributors`
* `good first issue`
* `help wanted`

If an issue does not have one of these labels, please assume it is not currently open for contributors.

Please comment on an issue before starting work so that the scope can be confirmed and duplicated work can be avoided.

Contributors whose pull requests are accepted and successfully merged may be acknowledged in the project contributors list.

For detailed contribution rules, see `CONTRIBUTING.md`.
