<script>
  import { onMount } from 'svelte';
  import Modal from './Modal.svelte';
  import { page } from '$app/stores';
  import { get } from 'svelte/store';


  const { module_name, quiz_name } = get(page).params;
  let message = "";
  let login = "Login";
  let logged = false;
  let questionOpen = false;
  let questionNameOpen = "";
  let questionEdited = "";
  let answerEdited = "";
  let adding = false;
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
  let answers = [
    { name: "", correct: false },
    { name: "", correct: false },
    { name: "", correct: false },
    { name: "", correct: false },
    { name: "", correct: false }
];
  const apiURL = import.meta.env.VITE_API_URL;
  const from = get(page).url.searchParams.get("from");

  
  if (typeof localStorage !== 'undefined') {
    imageIndex = localStorage.getItem(`imgModuleIndex`);
  } else if (typeof sessionStorage !== 'undefined') {
  // Fallback to sessionStorage if localStorage is not supported
    imageIndex = sessionStorage.getItem(`imgModuleIndex`);
  } else {
  // If neither localStorage nor sessionStorage is supported
    console.log('Web Storage is not supported in this environment.');
  }

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
  console.log(answers);

  const res = await fetch(`${apiURL}/users/me/modules/${module_name}/quizzes/${quiz_name}/questions/with-answers`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });

  if (res.ok) {
    loadQuestionsAndAnswers()
    adding = false;
    newQuestionName = "";
    answers = [
        { name: "", correct: false },
        { name: "", correct: false },
        { name: "", correct: false },
        { name: "", correct: false },
        { name: "", correct: false }
    ];

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

async function isCorrect(){
  correctAnswer = true;
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
        min-height: 100vh;
        height:auto;
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
        min-height: 100vh; 
        //vertical-align: baseline;
        //justify-content: center;
        vertical-align: baseline;
        grid-template-columns: 1fr 2fr;
        grid-template-rows: auto auto auto auto auto;
        gap: 0.2rem 2rem;  
        grid-template-areas:
        'spacer spacer'
        'breadcrumbs breadcrumbs'
        'edit-questions edit-questions'
        'add-questions add-questions'
        'col-modules col-quizzes'
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
  
  .add-questions {
    grid-area: add-questions;
    width: 100%;
}

.add-questions form {
    width: 100%;
}

#add-questions-table {
    width: 100%;

}

#add-questions-table tr {
    width: 100%;
}

#add-questions-table td:first-child {
    width: 75%;
}

#add-questions-table td:last-child {
    width: 20%;
}

#correct {
  text-align: center;
}

#add-questions-table input {
    width: 100%;
    box-sizing: border-box;
    padding: 0.8rem;
    font-size: 1.1rem;
    height: 5rem;
    border: 1px black solid;
    border-radius: 0.3rem;
    font-size: 18pt;
}

#add-questions-table button {
    width: 100%;
    padding: 0.9rem 2rem;
    border-radius: 0.5rem;
    border: 1px solid #bbb;
    font-size: 1.1rem;
    cursor: pointer;
    height: 5rem;
}

#add-questions-table button:hover {
    width: 100%;
    padding: 0.9rem 2rem;
    border-radius: 0.5rem;
    border: 1px solid #bbb;
    font-size: 1.1rem;
    cursor: pointer;
    height: 5rem;
    background-color: black;
    color: white;
}
  .edit-questions {
    grid-area: edit-questions;
    width: 100%;
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
  #col-modules{
    
  }
  #col-quizzes {
    grid-area: col-quizzes;
    border-radius: 1em;
    border-radius: 1em;
    height: fit-content;
    display: grid;
    grid-template-columns: 1fr;
    background-color: red;
    }
  .pre1{
    background-color: #f4f4f4; 
    border: 1px solid #ccc; 
    white-space: pre-wrap;
    word-break: break-all;
    font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    font-size: 1rem; 
    font-weight: normal;
  }
  .pre2 {
    display: none;
  }
  #col-quizzes p {
    display:none;
  }
  .header-quiz{
    display: inline-block;
  }

  .modal-box {
    right: 1rem;
  }
  #sidebar1{
    display: none;
  }
  sidebar2{
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
    <table id="questions-table">
      <thead>
      </thead>
      <tbody>
        {#each questions as question}
        <tr>
          {#if !editing && !answerEdited}
          <td><button onclick={() => {questionOpen = !questionOpen; questionOpen ? questionNameOpen = question.question_name : questionNameOpen = "";}}>
            <div class="question-button">
              <p class ="question-button-description">{question.question_name}</p> 
              <p class ="question-button-triangle">{questionOpen && questionNameOpen == question.question_name ? "▲" : "▼"}</p> 
            </div>
            </button>
          </td>
          {/if}
          {#if editing && question.question_name == questionEdited && !questionOpen}
          <div class="editing-section">
            <form class="editing-form" method="patch">
            <textarea id="updated-question">{question.question_name}</textarea>
            <button class="action-button" onclick={() => updateQuestion(question.user_id, question.module_id, question.quiz_id, question.id)}>Update</button>
            <button class="action-button" onclick={() => {editing = false; questionEdited = "";}}>Cancel</button>
            </form>
          </div>
          {/if}
          {#if !editing && !questionOpen}
          <th></th>
          <th><button class="action-button" onclick={() => { editing = true; questionEdited = question.question_name;}}>
          Edit Question
          </button></th>
          <th><button class="action-button" onclick={() => deleteQuestion(question.user_id, question.module_id, question.quiz_id, question.id)}>Delete Question</button></th>
          {/if}
        </tr>
        <div class="table-answers">
        {#if questionOpen == true && questionNameOpen == question.question_name} 
        {#if !editing}
        <tr>
          {#if !answerEdited}
            <th>Answer</th>
            <th>Correct Answer</th>
            <th></th>
            <th></th>
          {/if}
        </tr>
        {#each answersByQuestionId[question.id] as ans}
        {#if answerEdited.length == 0}
          <tr>
          <td>{ans.answer_name}</td>
          <td>{#if ans.answer_correct == true}✔{/if}</td>
          <td><button class="action-button" onclick={() => answerEdited = ans.answer_name}> 
            <svg
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                class="edit-icon">
                <path d="M12 20h9" />
                <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z" />
              </svg></button></td>
          </tr>
          {:else if ans.answer_name == answerEdited}
          {#if answerEdited}
            <th>{questionNameOpen}</th>
            {#if ans.answer_correct == true}
            <th>Correct Answer</th>
            {:else}
            <th>Incorrect Answer</th>
            {/if}
          {/if}
            <div class="editing-section">
              <form class="editing-form" method="patch">
                <textarea id="updated-answer">{ans.answer_name}</textarea>
                <button class="action-button" onclick={() => updateAnswer(question.user_id, question.module_id, question.quiz_id, question.id,ans.id,ans.correct_answer)}>Update</button>
                <button class="action-button" onclick={() => {{editing = false; answerEdited = ""; correctAnswer = false;}}}>Cancel</button>
            </form>
          </div>
          {/if}
          {/each}
          {/if}
          {#if editing}
          <div class="editing-section">
            <form class="editing-form" method="patch">
            <textarea id="updated-answer">{ans.answer}</textarea>
            <button class="action-button" onclick={() => updateQuestion(question.user_id, question.module_id, question.quiz_id, question.id)}>Update</button>
            <button class="action-button" onclick={() => {editing = true; questionEdited = "";}}>Cancel</button>
            </form>
          </div>
          {/if}
        {/if}
        </div>
        {/each}
      </tbody>
    </table>
  </div>
  <div class="add-questions">
    <form onsubmit={registerQuestion}>
        <table id="add-questions-table">
            <thead>
            </thead>

            <tbody>
                <tr>
                    <td>
                        <input placeholder="New question name" bind:value={newQuestionName}>
                    </td>
                    <td>
                        <button type="button" onclick={() => { adding = !adding; }}>
                            Add Question
                        </button>
                    </td>
                </tr>

                {#if adding}
                    <tr>
                      <td></td>
                      <td id="correct">Correct answer</td>
                    </tr>
                    <tr>
                        <td>
                            <input placeholder="Answer 1" bind:value={answers[0].name}>
                        </td>
                        <td>
                            <input type="checkbox" bind:checked={answers[0].correct}>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input placeholder="Answer 2" bind:value={answers[1].name}>
                        </td>
                        <td>
                            <input type="checkbox" bind:checked={answers[1].correct}>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input placeholder="Answer 3" bind:value={answers[2].name}>
                        </td>
                        <td>
                            <input type="checkbox" bind:checked={answers[2].correct}>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <input placeholder="Answer 4" bind:value={answers[3].name}>
                        </td>
                        <td>
                            <input type="checkbox" bind:checked={answers[3].correct}>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <input placeholder="Answer 5" bind:value={answers[4].name}>
                        </td>
                        <td>
                            <input type="checkbox" bind:checked={answers[4].correct}>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <button type="submit">
                                Submit
                            </button>
                        </td>
                    </tr>
                {/if}
            </tbody>
        </table>
    </form>
</div> 
  
</main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
