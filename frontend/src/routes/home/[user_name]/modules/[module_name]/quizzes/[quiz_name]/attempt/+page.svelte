<script>
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { writable } from 'svelte/store';
  import { page } from '$app/stores';
  import { get } from 'svelte/store';

  const {user_name: me, module_name, quiz_name} = get(page).params;
  //console.log("Module:", module_name);
  //console.log("Quiz:", quiz_name);
  let message = "";
  let login = "Login";
  let logged = false;
  let currentQuestion = 0;
  let questions = [];
  let answers = [];
  let user_name = me;
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
  const apiURL = import.meta.env.VITE_API_URL;

  $: login = logged ? "Logged in" : "Login";
  
  /*async function getUsername(){
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
  }*/

  async function loadQuestions() {
    const token = await localStorage.getItem("access_token");
    if(!token) return;

    //Load questions
    const questionQuery = await fetch(`${apiURL}/users/me/modules/${moduleName}/quizzes/${quiz_name}/questions/attempts/shuffled-questions` , {
      method : 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });
    if(questionQuery.ok) {
      questions = await questionQuery.json();
      //console.log("Q: ",questions);
    } else {
      message = "Failed to fetch questions";
    }
  }

  
async function loadAnswers(question) {
  const token = await localStorage.getItem("access_token");
  if (!token) return;

  const ansQuery = await fetch(
    `${apiURL}/users/me/modules/${moduleName}/quizzes/${quiz_name}/questions/${question.id}/answers`,
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
    console.error("Failed to fetch answers for", question.id);
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

  const res = await fetch(`${apiURL}/users/me/modules/${module_name}/quizzes/${quiz_name}/attempts/`, {
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
    //console.log("Atempts:", result.repetition);
    attempt_score = result.score;
    console.log("Score:", result.score);
    next_due = result.next_due;
    //console.log("Next Due:", result.next_due);
    //console.log("Wrong Answers:", result.wrong_answers);
    wrongAnswers = result.wrong_answers;
  } else {
    message = "Attempt submission failed.";
  }
}

async function getQuizAtempt(){
  const token = await localStorage.getItem("access_token");
  if (!token) return;

  const res = await fetch(`${apiURL}/users/me/modules/${module_name}/quizzes/${quiz_name}/attempts`, {
    method: "GET",
    headers: {
      "Authorization": `Bearer ${token}`,
      "Content-Type": "application/json"
    }
  });
    if (res.ok) {
      //console.log("Mes", res.json());
      quiz_attempt = await res.json();
  } else {
    message = "Quiz attempt retrieval failed";
  }
}

function tryAgain() {
  attempted = false;
  currentQuestion = 0;
  selectedAnswers = {};
  wrongAnswers = {};
  attempt_score = 0;
  next_due = null;
  initializeSelectedAnswers();
}

onMount(() => {
  (async () => {
    const token = localStorage.getItem("access_token");
    if (!token) {
      message = "You are not logged in.";
      goto("/login");
      return;
    }

    const res = await fetch(`${apiURL}/users/me`, {
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
        //height: 100vh; 
        //vertical-align: baseline;
        //justify-content: center;
        vertical-align: baseline;
        grid-template-columns: 1fr 3fr;
        grid-template-rows: 0.1fr 1fr 9fr;
        gap: 0 2rem;
        padding-bottom: 10vh;
        grid-template-areas:
        'breadcrumbs breadcrumbs'
        'spacer spacer'
        'question-index question-page'
        ;
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

    #breadcrumbs {
      grid-area: breadcrumbs;
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
      font-size: 14pt;
      
    }

    #breadcrumbs ul li+li:before {
      padding: 8px;
      color: #3174ec;
      content: ">>>";
    }  
    
    #question-index{
      grid-area: question-index;
      border-radius: 1em;
      border-radius: 1em;
      justify-content: center;     
      align-items: flex-start;     
      flex-direction: column;
      padding-bottom: 3vh;
      height: fit-content;
      background-color: white;
      
    }
    #question-index-content {
      max-width: 30vh;
      margin: 0 auto;
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      height: auto;
    }

    #question-index p {
      text-align: center;
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
      cursor: pointer;
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
    color: white
  }

  .question-check-box.unanswered {
    background-color: #e9e9e9;
  }
  .question-check-box.current {
    outline: 0.4vh solid black;
    outline-offset: 0.15vh;
  }

  .question-check-box p {
    margin : 0;
  }

.current-question{
  font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
}
.question-box {
  display: grid;
  justify-content: center;
  
}  

.answers-list {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
  margin-top: 1rem;
  margin-bottom: 1.5rem;
}

.answer-option {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  width: 100%;
  cursor: pointer;
  font-size: 1.5rem;
}

.answer-option:hover {
  background-color:  #e9e9e9;
  width: 100%;
}

.answer-option input {
  margin: 0;
}

.answer-option span {
  line-height: 1.4;
}


.questions-iter {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;

  margin-top: 2rem;
  margin-left: auto;
  margin-right: auto;

  width: 100%;
  max-width: 32rem;
}

.questions-iter button {
  padding: 0.9rem 2rem;
  border-radius: 0.5rem;
  border: 1px solid #bbb;
  font-size: 1.1rem;
  cursor: pointer;
}

.questions-iter button:hover{
  background-color: #0f0f0f;
  color: white;
}

    #question-page{
      grid-area: question-page;
      padding: 2rem 2.5rem;
      background: white;
      border-radius: 1rem;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);  
}
.quiz-submission {
  display: grid;
  justify-content: center;
}

.result-actions {
  margin-top: 2rem;
  margin-bottom: 2rem;
}

  .result-actions button {
  min-width: 9rem;
  min-height: 3.5rem;
}

#try-again-btn button {
  background-color: rgb(18, 105, 192);
  color: white;
  border-color: rgb(18, 105, 192);
}

#try-again-btn button:hover {
  background-color: rgb(13, 86, 160);
}

#back-to-module-btn button {
  background-color: white;
  color: #222;
}

#back-to-module-btn button:hover {
  background-color: #e9e9e9;
}

.create-quiz-card {
  border: 1px solid #ddd;
  border-radius: 0.75rem;
  padding: 1rem 1.25rem;
  margin-top: 1rem;
  background-color: #fafafa;
}

.create-quiz-card h2{
  text-justify : center;
}

.mistake-card {
  border: 1px solid #ddd;
  border-radius: 0.75rem;
  padding: 1rem 1.25rem;
  margin-top: 1rem;
  background-color: #fafafa;
}

.mistake-card p {
  margin: 0.35rem 0;
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

  main * {
      margin-left: 0;
    }

  main {
    display: block;
    margin: 0;
    
  }
  #spacer {
    display: none;
  }
  #question-index{
    display: none;
  }
  #question-page{
    margin: 0;
    
  }
  #question-page form{
    margin: 0;
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
  <div id="breadcrumbs">
      <ul>
        <li><a href="/home/{user_name}">Home</a></li>
        <li><a href="/home/{user_name}/modules/{module_name}">{module_name}</a></li>
      <li>{quiz_name}</li>
    </ul>
  </div> 
  <div id="spacer">
    <h3>{moduleName} - {quiz_name}</h3>
  </div>
  <div id="question-index">
    <p>Questions</p>
  <div id="question-index-content">
    {#each questions as question, i}
  <div
  class="question-check-box"
  class:answered={selectedAnswers[question.id]}
  class:unanswered={!selectedAnswers[question.id]}
  class:current={currentQuestion === i}
  onclick= {currentQuestion = i}>
    <p>{i + 1}</p>
  </div>
  {/each}
  </div>
  </div>
  <div id="question-page">
  {#if !attempted}
  <form  onsubmit={registerAttempt}>
  {#each questions as question, i}
  <div>
    {#if i == currentQuestion}
    <p class="current-question">Question {i+1} of {questions.length}</p>
    <div class="question-box">
    <h2>{question.question_name}</h2>
      <div class="answers-list">
        {#each answersByQuestionId[question.id] || [] as answer, j}
          <label class="answer-option" for={`q${question.id}-a${j}`}>
            <input
              type="radio"
              id={`q${question.id}-a${j}`}
              name={`question-${question.id}`}
              value={answer.id}
              bind:group={selectedAnswers[question.id]}
            />
            <span>{answer.answer_name}</span>
          </label>
        {/each}
      </div>
    </div>  
      <br>
      <div class="questions-iter">
        {#if i > 0}
          <div id="prev-question-btn">
            <button type="submit" onclick = {currentQuestion--}>
              <p>Previous</p>
            </button> 
          </div> 
        {/if} 
        <div id="next-question-btn">
          <button type="button" onclick = {currentQuestion++}>
            <p>Next</p>
          </button>   
        </div>
      </div>   
    {/if}
    </div>
{/each}
  {#if currentQuestion == questions.length}
  <div class="quiz-submission">
    <h2>Ready to submit?</h2>
    <p>You answered {Object.values(selectedAnswers).filter(answerId => answerId !== null).length} of {questions.length} questions.<br>
    You can go back and review your answers before submitting.</p>
    <div class="questions-iter">
      <div id="prev-question-btn">
        <button type="button" onclick = {currentQuestion--}>
          <p>Previous</p>
        </button> 
      </div>
      <div id="form-button-section">
        <button type="submit">
          <p>Submit</p>
        </button> 
      </div>
    </div>
  </div>  
  {/if}
  </form>
  {/if}
  {#if attempted}
  <p><strong> Score: {attempt_score}%</p>
  <p><strong>Next review: {new Date(next_due).toLocaleDateString()}</strong></p>
  <div class="questions-iter result-actions">
  <div id="try-again-btn">
    <button type="button" onclick={tryAgain}>
      <p>Try again</p>
    </button>
  </div>

  <div id="back-to-module-btn">
    <button
      type="button"
      onclick={() => goto(`/home/${user_name}/modules/${moduleName}`)}
    >
      <p>Back to module</p>
    </button>
  </div>
</div>
<div class="create-quiz-card">
    <h2>Want to create your own quiz with AI?</h2>
    <p>Go back to this module, click + to create a new quiz, then import AI-generated questions.</p>
</div>
  {#if Object.entries(wrongAnswers).length === 0}
  <p>Great work — no mistakes to review.</p>
{:else}
  <p>Review your mistakes</p>

  {#each Object.entries(wrongAnswers) as ans}
    <div class="mistake-card">
      <p><strong>Question:</strong> {ans[0]}</p>
      <p><strong>Your answer:</strong> {ans[1]}</p>
    </div>
  {/each}
{/if}
  {/if}
  </main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
