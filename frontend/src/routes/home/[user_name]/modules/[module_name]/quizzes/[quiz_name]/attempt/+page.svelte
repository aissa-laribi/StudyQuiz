<script>
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { writable } from 'svelte/store';
  import { page } from '$app/stores';
  import { get } from 'svelte/store';

  const { module_name, quiz_name} = get(page).params;
  console.log("Module:", module_name);
  console.log("Quiz:", quiz_name);
  let message = "";
  let login = "Login";
  let logged = false;
  let questions = [];
  let answers = [];
  let user_name = "";
  let module_id = 0;
  let answersByQuestionId = {};
  let newQuizName = "";
  const moduleName = module_name;
  let selectedAnswers = {};
  let wrongAnswers = {};
  let attempted = false;
  let quiz_attempt = -1;
  let attempt_score = 0;
  let next_due = Date;

  $: login = logged ? "Logged in" : "Login";
  
  console.log(window.location.href);
  
  /*async function getUsername(){
    const token = await localStorage.getItem("access_token");
    if(!token) return;

    const userQuery = await fetch(`http://localhost:8000/users/me`, {
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
  }*/

  async function loadQuestions() {
    const token = await localStorage.getItem("access_token");
    if(!token) return;

    //Load questions
    const questionQuery = await fetch(`http://localhost:8000/users/me/modules/${moduleName}/quizzes/${quiz_name}/questions/attempts/shuffled-questions` , {
      method : 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });
    if(questionQuery.ok) {
      questions = await questionQuery.json();
      console.log("Q: ",questions);
    } else {
      message = "Failed to fetch questions";
    }
  }

  
async function loadAnswers(question) {
  const token = await localStorage.getItem("access_token");
  if (!token) return;

  const ansQuery = await fetch(
    `http://localhost:8000/users/me/modules/${moduleName}/quizzes/${quiz_name}/questions/${encodeURIComponent(question.question_name)}/answers`,
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
    answersByQuestionId[question.id] = answers;
  } else {
    console.error("Failed to fetch answers for", question.question_name);
  }
}

async function loadQuestionsAndAnswers() {
  //await getUsername();
  await loadQuestions(); // loads `questions` array
  for (const q of questions) {
    await loadAnswers(q);
  }
  initializeSelectedAnswers();
}

function initializeSelectedAnswers() {
  for (const q of questions) {
    // Only initialize if not already set
    if (!(q.id in selectedAnswers)) {
      selectedAnswers[q.id] = null;
    }
  }
}

async function registerAttempt(event) {
  event.preventDefault();
  const token = localStorage.getItem("access_token");
  if (!token) return;

  const payload = {
    created_at: new Date().toISOString(),
    answers: Object.entries(selectedAnswers).map(([questionId, answerId]) => ({
      question_id: parseInt(questionId),
      answer_id: answerId
    }))
  };

  const res = await fetch(`http://localhost:8000/users/me/modules/${module_name}/quizzes/${quiz_name}/attempts/`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });

  if (res.ok) {
    attempted = true;
    const result = await res.json();
    console.log("Atempts:", result.repetition);
    attempt_score = result.score;
    console.log("Score:", result.score);
    next_due = result.next_due;
    console.log("Next Due:", result.next_due);
    console.log("Wrong Answers:", result.wrong_answers);
    wrongAnswers = result.wrong_answers;
  } else {
    message = "Attempt submission failed.";
  }
}

async function getQuizAtempt(){
  const token = await localStorage.getItem("access_token");
  if (!token) return;

  const res = await fetch(`http://localhost:8000/users/me/modules/${module_name}/quizzes/${quiz_name}/attempts`, {
    method: "GET",
    headers: {
      "Authorization": `Bearer ${token}`,
      "Content-Type": "application/json"
    }
  });
    if (res.ok) {
      console.log("Mes", res.json());
      quiz_attempt = await res.json();
  } else {
    message = "Quiz attempt retrieval failed";
  }
}

onMount(() => {
  (async () => {
    const token = localStorage.getItem("access_token");
    if (!token) {
      message = "You are not logged in.";
      goto("/login");
      return;
    }

    const res = await fetch("http://localhost:8000/users/me", {
      method: "GET",
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });

    if (res.status === 401) {
      message = "Session expired. Please log in again.";
      goto("/login");
      return;
    }

    await loadQuestionsAndAnswers();
  })();
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
        align-items: center;
        grid-template-columns: 2fr 8fr;
        grid-template-areas:
        'logo-box menu-box'
        ;
    }
    .logo-box{
        grid-area: logo-box;
        //background-color: yellow;
        display: flex;
        justify-content: flex-end;
        
        

    }
    .logo-box img {
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
        grid-template-columns: 1fr 3fr;
        grid-template-rows: 2fr 9fr;
        gap: 2rem;
        padding-bottom: 10vh;
        grid-template-areas:
        'spacer spacer'
        'question-index question-page'
        ;
    }

    main * {
      margin-left: 4vh;
    }
    main h1 {
      font-family: 'Montserrat', sans-serif;
      text-align: center;
      font-weight: 700;
      font-size: 2.5rem;
    }
    main p {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      min-height: 1.5rem;
      text-align: left;
      font-weight: 400;
      font-size: 1.5rem;
      //line-height: 1.4;
    }

    main form {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 1.2rem;
    }
    #spacer{
      grid-area: spacer;
      width: 100%;
      height: 8vh;
      vertical-align: middle;
    }

    #spacer h3{
      font-family: 'Montserrat', sans-serif;
      font-size: 2rem;
      color: black;
      border-bottom: 1px #b3b3b3ff solid;
      
    }  
    
    #question-index{
      grid-area: question-index;
      border-radius: 1em;
      border-radius: 1em;
      justify-content: center;     
      align-items: flex-start;     
      flex-direction: column;
      padding-top: 2vh;
      height: fit-content;
      background-color: white;
      
    }
    #question-index-content {
      max-width: 30vh;
      margin: 0 auto;
      display: flex;
      flex-wrap: wrap;
      justify-content: flex-start;
      height: auto;
    }


    .question-check-box {
      width: 7vh;
      height: 7vh;
      border: 1px black solid;
      margin: 0.5vh;
      display: flex;
      justify-content: center;
      align-items: center;
      font-weight: bold;
      border-radius: 0.5vh;
      font-size: 1.2vh;
    }

    .question-check-box.answered {
      background-color: #e0f0ff;
      color: white;
      font-size: 0.9vh;
      font-family: 'Montserrat', sans-serif;
    }

    .question-box-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      margin: 0.5vh;
    }

  .question-index-number {
    font-family: 'Montserrat', sans-serif;
    font-size: 1.4vh;
    font-weight: 500;
    margin-top: 0.5vh;
    text-align: center;
  }

  .question-check-box.answered {
    background-color: rgb(18, 105, 192);
    text-align: center;
  }

  .question-check-box.unanswered {
    background-color: #ccc;
  }
    #question-page{
      grid-area: question-page;
      border-radius: 1em;
      border-radius: 1em;
      height: 80vh;
      background-color: white;
      overflow-y: auto;
      max-height: 85vh;
      padding: 2vh;
      
    }

    #sidebar1 {
        grid-area : sidebar1;
        background-color: #f6f7fb;
    }
    #sidebar2 {
        grid-area : sidebar2;
        background-color: #f6f7fb;
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
    <h3>{moduleName} - {quiz_name}</h3>
  </div>
  <div id="question-index">
  <p>Page</p>
  <div id="question-index-content">
  {#each questions as question, i}
  <div class="question-check-box {selectedAnswers[question.id] ? 'answered' : 'unanswered'}">
  {#if selectedAnswers[question.id]}ANSWER SAVED{/if}
</div>

{/each}

  </div>
  </div>
  <div id="question-page">
  {#if !attempted}
  <form  onsubmit={registerAttempt}>
  {#each questions as question, i}
  <div>
    <p>Question {i + 1}: {question.question_name}</p>
    {#each answersByQuestionId[question.id] || [] as answer, j}
      <input type="radio" id={`q${question.id}-a${j}`} name={`question-${question.id}`} value={answer.id}
        bind:group={selectedAnswers[question.id]} />
      <label for={`q${question.id}-a${j}`}>{answer.answer_name}</label><br>
    {/each}
  </div>
{/each}
  <div id="form-button-section">
    <button type="submit">
      <p>Submit</p>
    </button> 
  </div>
  </form>
  {/if}
  {#if attempted}
  <h2>{quiz_name} - Results</h2>
  <p> Score: {attempt_score} % | Next due date: {next_due}</p>
  <p>Wrong answers:</p>
  {#each Object.entries(wrongAnswers) as ans}
    <p>Question: {ans[0]}</p> 
    <p>Selected Answer: {ans[1]}</p>
  {/each}
  {/if}
  </main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
