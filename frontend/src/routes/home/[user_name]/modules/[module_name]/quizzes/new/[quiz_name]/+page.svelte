<script>
  import { onMount } from 'svelte';
  import Modal from './Modal.svelte';
  import { page } from '$app/stores';
  import { get } from 'svelte/store';
  import Tabs from './Tabs.svelte'; 
  import Tab1 from "./Tab1.svelte";
	import Tab2 from "./Tab2.svelte";

  const { module_name, quiz_name } = get(page).params;
  let message = "";
  let login = "Login";
  let logged = false;
  let questionOpen = false;
  let questionNameOpen = "";
  let questionEdited = "";
  let answerEdited = "";
  let editing = false;
  let correctAnswer = false;
  let newQuestionName = "";
  let showModal = false;
  let questions = [];
  let followups = [];
  let user_name = "";
  let answersByQuestionId = {};
  let module_id = 0;
  let quizData = "";
  let moduleImgId = 0;
  let imageIndex;
  let answers = [{ name: "", correct: false }];
  const apiURL = import.meta.env.VITE_API_URL;

  let items = [{
                label:"AI-Assisted Quiz Creation",
                value: 1,
                component: Tab1
              },
              {
                label:"Manual Quiz Creation",
                value: 2,
                component: Tab2
              }
            ];
  
  if (typeof localStorage !== 'undefined') {
    imageIndex = localStorage.getItem(`imgModuleIndex`);
  } else if (typeof sessionStorage !== 'undefined') {
  // Fallback to sessionStorage if localStorage is not supported
    imageIndex = sessionStorage.getItem(`imgModuleIndex`);
  } else {
  // If neither localStorage nor sessionStorage is supported
    console.log('Web Storage is not supported in this environment.');
  }

  const aiPrompt = `Generate a StudyQuiz-compatible quiz from my study material.

  Return valid JSON only.
  Do not include markdown fences, explanations, title, description, or extra text.

  The JSON must use this exact structure:

  {
    "questions": [
      {
        "name": "Question text here",
        "answers": [
          {"name": "Answer 1", "correct": true},
          {"name": "Answer 2", "correct": false},
          {"name": "Answer 3", "correct": false},
          {"name": "Answer 4", "correct": false},
          {"name": "Answer 5", "correct": false}
        ]
      }
    ]
  }

  Rules:
  - Create 10 questions by default.
  - Use fewer if the material is short, up to 15 if dense.
  - Each question must use "name" and "answers".
  - Each answer must use "name" and "correct".
  - Each question must have exactly 5 answers.
  - Exactly one answer per question must have "correct": true.
  - Use plausible but wrong distractors.
  - Keep answers concise.
  - Use the same language as the study material.`;

  
  $: login = logged ? "Logged in" : "Login";
  
  function addAnswerField() {
  if (answers.length < 5) {
    answers = [...answers, { name: "", correct: false }];
    }
  }

  function removeAnswer(index) {
    answers = answers.filter((_, i) => i !== index);
  }

  async function registerQuestion(event) {
  event.preventDefault();
  const token = localStorage.getItem("access_token");
  if (!token || !newQuestionName.trim()) return;

  const payload = {
    name: newQuestionName,
    answers: answers
      .filter(a => a.name.trim() !== "")
      .map(a => ({
        name: a.name,
        correct: a.correct
      }))
  };

  const res = await fetch(`${apiURL}/users/me/modules/${module_name}/quizzes/${quiz_name}/questions/with-answers`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });

  if (res.ok) {
    showModal = false;
    loadQuestions();
    newQuestionName = "";
    answers = [{ name: "", correct: false }];
  } else {
    message = "Error saving question.";
  }
}

  async function getUsername(){
    const token = await localStorage.getItem("access_token");
    if(!token) return;

    const userQuery = await fetch(`${apiURL}/users/me`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });

    if(userQuery.ok){
      const data = await userQuery.json();
      user_name = data['user_name'];
    } else {
      message = "Failed to retrieve username";
    }
  }

  async function loadQuestions() {
    const token = localStorage.getItem("access_token");
    if (!token) return;

    const { module_name, quiz_name } = get(page).params;

  const questionQuery = await fetch(
    `${apiURL}/users/me/modules/${module_name}/quizzes/${quiz_name}/questions/`,
    {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    }
  );

  if (questionQuery.ok) {
    questions = await questionQuery.json();
    //await loadQuestions();
  } else {
    message = "Failed to fetch questions";
  }
}

  onMount(() => {
    getUsername();
    loadQuestions();
  });


  
async function loadAnswers(question) {
  const token = localStorage.getItem("access_token");
  if (!token) return;

  const ansQuery = await fetch(
    `${apiURL}/users/me/modules/${module_name}/quizzes/${quiz_name}/questions/${question.id}/answers`,
    {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    }
  );

  if (ansQuery.ok) {
    const answers = await ansQuery.json();

    answersByQuestionId = {
      ...answersByQuestionId,
      [question.id]: answers
    };
  } else {
    console.error("Failed to fetch answers for", question.id);
  }
}
async function loadQuestionsAndAnswers() {
  //await getUsername();
  await loadQuestions(); // loads `questions` array
  for (const q of questions) {
    await loadAnswers(q);
  }
}

async function deleteQuestion(user_id, module_id,quiz_id,question_id){
  const token = localStorage.getItem("access_token");
  if (!token) return;


  const delQuery = await fetch(
    `${apiURL}/users/${user_id}/modules/${module_id}/quizzes/${quiz_id}/questions/${question_id}`,
    {
      method: 'DELETE',
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    }
  );
  if(!delQuery.ok) console.log("Failed to delete", question_id);
  loadQuestionsAndAnswers();
}

async function updateQuestion(user_id, module_id,quiz_id,question_id){
  const newQuestion = document.getElementById('updated-question').value;
  const token = localStorage.getItem("access_token");
  if (!token) return;

  const editQuery = await fetch(
    `${apiURL}/users/${user_id}/modules/${module_id}/quizzes/${quiz_id}/questions/${question_id}`,
    {
      method: 'PATCH',
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        "question_name": newQuestion,
      })
    }
  );

  if(!editQuery.ok) console.log("Failed to update QUESTION ", question_id);
  loadQuestionsAndAnswers();
  editing = false;
  questionEdited = "";

}

async function updateAnswer(user_id, module_id, quiz_id, question_id,answer_id,correct_answer){
  const newAnswer = document.getElementById('updated-answer').value;
  console.log(newAnswer);
  const token = localStorage.getItem("access_token");
  if (!token) return;

  const editQuery = await fetch(
    `${apiURL}/users/${user_id}/modules/${module_id}/quizzes/${quiz_id}/questions/${question_id}/answers/${answer_id}`,
    {
      method: 'PATCH',
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        "answer_name": newAnswer,
        "answer_correct": correctAnswer,
      })
    }
  );

  if(!editQuery.ok) console.log("Failed to update QUESTION ", question_id);
  loadQuestionsAndAnswers();
  editing = false;
  answerEdited = "";
  correctAnswer = false;
}

onMount(async () => {
    await loadQuestionsAndAnswers();
  });

</script>


<style>
    .container {
        display: grid;
        height: 100vh;
        grid-template-columns: 1fr 10fr 1fr;
        grid-template-rows: 0.6fr 10fr;
        grid-template-areas:
        'nav nav nav'
        'sidebar1 main sidebar2';
        }
    nav {
        grid-area : nav;
        background-color: white; 
        display: grid;
        //align-items: center;
        grid-template-columns: 2fr 8fr;
        grid-template-areas:
        'logo-box menu-box'
        ;
        max-height: 8vh;
    }
    .logo-box{
        grid-area: logo-box;
        //background-color: yellow;
        display: flex;
        justify-content: flex-end;
        

    }
    .logo-box img {
      grid-area: logo-box;
      display: flex;
      justify-content: flex-end;
    }
    .menu-box 
    {
      display: flex;
      justify-content: flex-end;
      grid-area: menu-box;
      grid-template-columns: 8fr 2fr;
      grid-template-areas:
        'menu-box-col1 menu-box-col2'
        ;

    }
    .menu-box a{
      text-decoration: none;
      font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
      font-size: 2em;
      color:rgb(18, 105, 192);
      margin-right:0.5em;
      
    }
    
    .menu-box a:hover{
      border-top: 0.1rem solid rgb(18, 105, 192);
    }

    .profile {
      text-decoration: none;
      font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
      font-size: 2em;
      color:rgb(18, 105, 192);
      margin-right:0.5em; 
    }
    
    main {
        grid-area: main;
        background-color: #f6f7fb;
        display: grid;
        height: 100vh; 
        //vertical-align: baseline;
        //justify-content: center;
        vertical-align: baseline;
        grid-template-columns: 1fr 2fr;
        grid-template-rows: 1fr 1fr 1fr 100fr;
        gap: 0.2rem 2rem;  
        grid-template-areas:
        'spacer spacer'
        'breadcrumbs breadcrumbs'
        'edit-questions edit-questions'
        'col-modules col-quizzes'
    }
    main h1 {
      font-family: 'Montserrat', sans-serif;
      text-align: center;
      font-weight: 700;
      font-size: 2.5rem;
    }
    main p {
      font-family: 'Montserrat', sans-serif;
      min-height: 1.5rem;
      text-align: center;
      font-weight: 400;
      font-size: 1.35rem;
      line-height: 1.4;
    }

    #spacer{
      grid-area: spacer;
      width: 100%;
      height: 30vh;
      overflow: hidden;
      position: relative;  
    }

    #spacer img {
      width: 100%;
      height: 100%;
      object-fit: cover;           
      object-position: center top;
      display: block;
      opacity: 1;
    }

    #spacer .overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.3); /* Adjust darkness */
      z-index: 1;
    }

    #spacer h3{
      font-family: 'Montserrat', sans-serif;
      font-size: 4rem;
      color:white;
      position: absolute;
      top: 50%;
      //left: 12%;
      transform: translate(5%, -50%);
      z-index: 2;
    }

    #breadcrumbs {
      grid-area: breadcrumbs;
      margin-left: 1.5rem;
    }

    #breadcrumbs a{
      text-decoration: none;
      color: #3174ec;
      font-weight: 700;
    }

    #breadcrumbs ul{
      padding: 0px 5px;
      list-style: none;
      
    }

    #breadcrumbs ul li {
      display: inline;
      font-size: 18pt;
      
    }

    #breadcrumbs ul li+li:before {
      padding: 8px;
      color: #3174ec;
      content: ">>>";
    }  

    #form-navbar {
      display: flex;
      border-radius: 1em;
      max-width: 100%;
      height: 30%;
      //padding: 1vh;
      color: rgb(18, 105, 192);
      display: flex;
      justify-content: space-between;  
      align-items: center;
      background-color: white;
    }

    #form-navbar h2{
      color: rgb(18, 105, 192);
      font-family: 'Montserrat', sans-serif;
      font-weight: 600;
      font-size: 2rem;
    }

    form span {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 1rem;      
    }

    #form-navbar button{
      color: white;
      background-color: rgb(18, 105, 192);
      border: 0;
      font-size: 2rem;
    }

    #form-fields {
      padding: 1vh;
      height: 30%;
      display: flex;
      gap: 1em;
    }

    #form-fields input {
      border-radius: 0.2em;
      border: 0.01em solid black;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 1.75em;
      letter-spacing: -0.02em;
    }

    #form-button-section{
      height: 40%;
      padding: 1vh;
      display: inline-flex;
      gap: inherit;
      //align-items: center;
      //justify-content: flex-end;  /* <-- pushes button to the right */
      //padding: 1em;
      //border-radius: 1em;
      //align-items: center;
    }


    #form-button-section button:hover{
      background-color:green;
    }


    #form-button-section button p{
      color:white;
      font-family: 'Montserrat', sans-serif;
      font-weight: 600;      
    }

    .answer-row span {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 1.5rem;
    }

  .edit-questions {
    grid-area: edit-questions;
    display:grid;
  }


  #questions-table td button{
    border: 1px black solid;
    width:100%;
    height: 5rem;
    text-align: left;
    font-size: 16pt;
    background-color: #f3f3f3;
    border-radius: 0.3rem;
    
  }

  .question-button{
    display:grid;
    grid-template-areas: 'question-button-description question-button-triangle';
    grid-template-columns: 99fr 1fr;
  }

  #questions-table td button:hover{
    cursor:pointer;
    color:white;
    background-color:black;
  }
  .question-button-description{
    grid-area : question-button-description;
    text-align: left;
  }
  .question-button-triangle{
    grid-area : question-button-triangle;
  }

  .action-button {
    padding: 0.9rem 2rem;
    border-radius: 0.5rem;
    border: 1px solid #bbb;
    font-size: 1.1rem;
    cursor: pointer;
}

  .action-button:hover{
    background-color: #0f0f0f;
    color: white;
  }

  .editing-form{
    display:grid;
    grid-template-columns: 99fr 1fr 1fr;
    gap: 1rem;
  }

  .editing-form textarea{
    border-radius: 0.4rem;
  }

  .table-answers th {
    width:100%;
    font-size: 18pt;
  }

  .table-answers td {
    border: 1px black solid;
    font-size: 16pt;
    text-align: center;
    align-content: center;
  }
  
  #sidebar1 {
    grid-area : sidebar1;
    background-color: #f6f7fb;
  }
  #sidebar2 {
    grid-area : sidebar2;
    background-color: #f6f7fb;
  }
  @media (max-width: 500px) {
  .container{
    display: block;
  }
  nav {
    display: grid;
    grid-template-columns: 1fr 2fr;
    grid-template-areas: 'logo-box menu-box';
    max-height: 8vh;
  }
  .logo-box {
    grid-area: logo-box;
  }

  .menu-box{
    grid-area: menu-box;
    max-height: inherit;

  }

  .profile {
    align-self: center;
  }

  .logo-box img{
    max-width:30vh;
    margin-left: 1vh;
  }

  main {
    display: grid;
    grid-template-columns:1fr;
    grid-template-rows: 1fr 9fr;
    grid-template-areas:
    'col-quizzes'
    'col-modules';
    gap: 0;
  }
  #spacer {
    display : none;
  }

  #sidebar1{
    display: none;
  }
}

</style>

<section class="container">
  <nav>
  <div class="logo-box"><a href="/"><img src="/logo.png"></a></div>
  <div class="menu-box">
      <p class="profile">{user_name}</p>
  </div>
  </nav>
  <main>
    <div id="spacer">
    <div class="overlay"></div>
      <img src="/modules/{imageIndex}.jpg" alt="Module Banner">
      <h3>{module_name} - {quiz_name}</h3>
    </div>
    <div id="breadcrumbs">
      <ul>
        <li><a href="/home/{user_name}">Home</a></li>
        <li><a href="/home/{user_name}/modules/{module_name}">{module_name}</a></li>
        <li>{quiz_name}</li>
      </ul>
    </div> 
  <div class="edit-questions">
    <Tabs {items} />
  </div>
 
    {#if showModal}
      <Modal bind:showModal>
  <form onsubmit={registerQuestion}>
    <nav id="form-navbar">
      <h2>Add a New Question</h2>
      <button type="button" onclick={() => (showModal = false)}>✖</button>
    </nav>

    <div id="form-fields" style="flex-direction: column;">
      <input
        id="question-name"
        bind:value={newQuestionName}
        type="text"
        placeholder="Question text"
        required
      />

      {#each answers as answer, index}
        <div class="answer-row" style="display: flex; align-items: center; gap: 0.5rem;">
          <input
            type="text"
            placeholder="Answer"
            bind:value={answer.name}
            required={index === 0}
          />
          <input
  type="checkbox"
  checked={answer.correct}
  onchange={(e) => {
    answers = answers.map((a, i) =>
      i === index ? { ...a, correct: e.target.checked } : a
    );
  }}
/>

          <span>Correct?</span>
          {#if answers.length > 1}
            <button type="button" onclick={() => removeAnswer(index)}>✖</button>
          {/if}
        </div>
      {/each}
      <div id="form-button-section">
      {#if answers.length < 5}
        <button type="button" id="add-new-answer" onclick={addAnswerField}>Add an answer</button>
      {/if}

    
      <button type="submit">
        <p>Save Question</p>
      </button>
      </div>
    </div>
  </form>
</Modal>
    {/if}

  
</main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
