<script>
  import { onMount } from 'svelte';
  import Modal from './Modal.svelte';
  import { page } from '$app/stores';
  import { get } from 'svelte/store';

  const { module_name, quiz_name } = get(page).params;
  //console.log("Module:", module_name);
  //console.log("Quiz in add question:", quiz_name);
  let message = "";
  let login = "Login";
  let logged = false;
  let newQuestionName = "";
  let showModal = false;
  let questions = [];
  let followups = [];
  let user_name = "";
  let module_id = 0;
  let moduleImgId = 0;
  const imageIndex = localStorage.getItem(`imgModuleIndex`);
  let answers = [{ name: "", correct: false }];
  const apiURL = import.meta.env.VITE_API_URL;


  $: login = logged ? "Logged in" : "Login";
  

  //console.log(window.location.href);

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

  let quizData = '';

async function quizFromJson() {
  try {
    const parsed = JSON.parse(quizData);
    //console.log(parsed);
    const token = localStorage.getItem("access_token");
    if (!token) return;
    const res = await fetch(`${apiURL}/users/me/modules/${module_name}/quizzes/${quiz_name}/questions/batch-create`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: quizData
  });

  if (res.ok) {
    showModal = false;
    loadQuestions();
    newQuestionName = "";
    answers = [{ name: "", correct: false }];
  } else {
    message = "Error saving question.";
  }

  } catch (err) {
    console.error("Invalid JSON", err);
  }
}

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
        grid-template-rows: 2fr 9fr;
        gap: 2rem;
        
        grid-template-areas:
        'spacer spacer'
        'col-modules col-quizzes'
        ;
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
    
    #col-modules{
      grid-area: col-modules;
      background-color: white;
      border-radius: 1em;
      height: fit-content;
    }

    #my-modules {
      border-bottom: 3px solid #eff0f3;
      margin: 2em; 
    
    }
    #my-modules button {
      border: 0px;
      background-color: white;
    }
    #my-modules button :hover{
      color:rgb(18, 105, 192);
    }

    #my-modules button .tooltiptext{
      visibility: hidden;
      width: 6em;
      background-color: rgb(18, 105, 192);
      color: #fff;
      text-align: center;
      border-radius: 0.25em;
      padding: 5px 0;
      position: absolute;
      margin: 0 1em 1em 1em;
    }

    #my-modules button:hover .tooltiptext{
      visibility: visible;
    }
    
    #module-name {
      font-size: 2em;
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

    #form-button-section button{
      //height: 80%;
      border-radius: 2em;
      //width: auto;
      border: 0.1em solid transparent;
      background-color: rgb(18, 105, 192);
      //display: flex;
      //align-items: center;
      width: 40%;
      color: white;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 1.4rem;
      font-weight: 600;
      
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

    #modules-container{
      //display:inline-flex;
      //flex-wrap: wrap;
      margin: 0 2em 0 2em;
      gap: 1em;
      max-width: 100%;
      height: auto;
      border: 1px #d6d9dc solid;
    }

    #modules-container button{
      display: none;
    }
    .module-box{
      border: 1px #d6d9dc solid;
      border-radius: 0.51em;
      
    }

    .module-box p {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      text-align: left;
      font-size: 1.15em;
      line-height: 1em;

    }

    #col-modules h2{
      font-family: 'Montserrat', sans-serif;
      font-size: 2rem;
      font-weight: 600;
      
    }
    
    #col-quizzes{
      grid-area: col-quizzes;
      border-radius: 1em;
      border-radius: 1em;
      height: fit-content;
    }
    #col-quizzes h2{
      //font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
      //font-size: 1.5rem;
      //font-weight: 600;
     
    }
    #upcoming-quizzes{
      //text-align: left;
      //gap: 1em;
      //max-width: 100%;
      //height: auto;
      background-color: white;
      //padding: 2em;
      
      
    }
    #upcoming-quizzes h2{
      text-align: left;
      //margin: 2em 2em 2em 2em;
      //gap: 1em;
      font-family: 'Montserrat', sans-serif;
      //max-width: 100%;
      //height: auto;
      background-color: white;
      font-size: 2.1rem;
    }

    #upcoming-quizzes {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 1.2rem;
      color: black;
    }

    ol li strong{

    }

    #followups-container{
      background-color: white;
      padding: 1em;
      //display:flex;
      //flex-wrap: wrap;
      //margin: 2em 2em 2em 2em;
      gap: 1em;
      max-width: 100%;
      height: auto;
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
    
    <div id="col-modules">
      <div id="my-modules">
      <h2>Questions
      <button id="new-module-button" onclick={() => (showModal = true)}>
      <svg  xmlns="http://www.w3.org/2000/svg"  width="32"  height="32"  viewBox="0 0 20 20"  fill="none"  stroke="currentColor"  stroke-width="1"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-plus"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 5l0 14" /><path d="M5 12l14 0" /></svg>
      <span class="tooltiptext">Add a New Question</span>
      </button>
      </h2>
      </div>
      <div id="modules-container">
      {#each questions as question}
        <div class="module-box">
            <p>{question.question_name}</p>
        </div>
      {/each}
      </div> 
    </div>
    <div id="col-quizzes">
    <div id="followups-container">
      <div id="upcoming-quizzes">
        
<h2>Import Quiz from ChatGPT</h2>
<ol>
  <li><strong>Get your slides ready</strong></li>

  <li><strong>Copy and paste the following prompt<strong><br>
  <pre class="pre1" style="background:#f4f4f4; padding:0.6em; border-radius:0.4em;">
Generate 20 quiz questions from these slides in JSON format for studyquiz.co. 
Each question must include 5 answer choices, 2 plausible distractors, and only 1 correct answer.
    </pre>
  </li>

  <li><strong>Copy ChatGPT’s reply</strong>
  </li>

  <li><strong>Paste it below and click “Upload Quiz”</strong>
  </li>
</ol>

<p style="font-size: 0.9em; color: #666;">
Example of what the answer should look like:
</p>

<pre class="pre2" style="background:#f8f8f8; padding:0.75em; border-radius:0.5em; font-size: 0.9em;">
{`
  "questions": [
    {
      "name": "What does CPU stand for?",
      "answers": [
        {"name": "Central Processing Unit", "correct": true},
        {"name": "Computer Power Unit", "correct": false},
        {"name": "Core Programming Utility", "correct": false},
        ...
      ]
    }
  ]
`}
</pre>


<textarea
  bind:value={quizData}
  rows="10"
  style="width: 100%; margin-top: 1em; font-family: monospace;"
  placeholder='Paste your JSON here...'
></textarea>

<button
  style="margin-top: 0.5em; background-color: green; color: white; padding: 0.5em 1em;"
  onclick={quizFromJson}
>
  Upload Quiz
</button>

        </div>
      </div>
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
