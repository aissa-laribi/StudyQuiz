<script>
  import { onMount } from 'svelte';
  import Modal from './Modal.svelte';
  import { goto } from '$app/navigation';
  import { writable } from 'svelte/store';

  let message = "";
  let login = "Login";
  let logged = false;
  let newQuizName = "";
  let showModal = false;
  let quizzes = [];
  let followups = [];
  let user_name = "";
  let module_id = 0;
  let moduleImgId = 0;
  const imageIndex = localStorage.getItem(`imgModuleIndex`);
  const moduleName = localStorage.getItem(`moduleName`);
  const quizName = writable(null);
  const apiURL = import.meta.env.VITE_API_URL;

  

  $: login = logged ? "Logged in" : "Login";
  

  //console.log(window.location.href);
  
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
  function goToPage(pageName){
    const url = `/home/${user_name}/modules/${moduleName}/quizzes/${pageName}`;
    goto(url);
  }

  async function loadQuizzes() {
    const token = localStorage.getItem("access_token");
    if(!token) return;

    //Load quizzes
    const quizQuery = await fetch(`${apiURL}/users/me/modules/${moduleName}/quizzes/` , {
      method : 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });
    if(quizQuery.ok) {
      quizzes = await quizQuery.json();
      //console.log("Q: ",quizzes);
    } else {
      message = "Failed to fetch quizzes";
    }
  }
  async function loadFollowups() {
    const token = localStorage.getItem("access_token");
    if (!token) return;

    // Load followups
    const folQuery = await fetch(`${apiURL}/users/me/followups/`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });
    if (folQuery.ok) {
      followups = await folQuery.json();
    } else {
      message = "Failed to fetch quizzes";
    }
  }
  onMount(() => {
    getUsername();
    loadQuizzes();
    loadFollowups();
  });

  async function registerQuiz(event) {
    event.preventDefault();
    const token = localStorage.getItem("access_token");
    if (!token || !newQuizName.trim()) return;

    const res = await fetch(`${apiURL}/users/me/modules/${moduleName}/quizzes/`, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ name: newQuizName })
    });

    if (res.ok) {
      const newQuiz = await res.json(); 
      showModal = false;
      //console.log("Saved quizName:", localStorage.getItem("quizName"));
      newQuizName = "";
      await loadQuizzes();
      let user_name = localStorage.getItem("user_name");
      //console.log(quizName);
      //localStorage.set(`quizName`, newQuiz.quiz_name);
      //console.log("Before Goto",user_name);
      goto(`/home/${user_name}/modules/${moduleName}/quizzes/${newQuiz.quiz_name}`);
      } else {
        message = "Module registration failed.";    
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
        align-items: top;
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
        cursor: touch;
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
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; 
      font-size: 2em;
      color:rgb(18, 105, 192);
      margin-right:0.5em;
      cursor: touch;
      
    }
    
    .menu-box a:hover{
      border-top: 0.1rem solid rgb(18, 105, 192);
    }

    .profile {
      text-decoration: none;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;      
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
        grid-template-columns: 2fr 1fr;
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
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      min-height: 1.5rem;
      text-align: center;
      font-weight: 400;
      font-size: 1.35rem;
      //line-height: 1.4;
    }

    #spacer{
      grid-area: spacer;
      //width: 100%;
      height: 30vh;
      overflow: hidden;
      position: relative;  
    }

    #spacer img {
      //width: 100%;
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
      //width: 100%;
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

    #col-modules h2{
      font-family: 'Montserrat', sans-serif;
      font-size: 2rem;
      font-weight: 700;
      
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
      cursor: touch;
    }

    #my-modules button .tooltiptext{
      visibility: hidden;
      //width: 6em;
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
    .modal-box form{
      border-radius: 1em;
    }

    #form-navbar {
      display: flex;
      border-radius: 1em;
      //max-width: 100%;
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
    }

    #form-navbar button{
      color: white;
      background-color: rgb(18, 105, 192);
      border: 0;
    }

    #form-fields {
      //padding: 1vh;
      height: 30%;
      display: flex;
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
      //padding: 1vh;
      display: flex;
      //align-items: center;
      justify-content: flex-end;  /* <-- pushes button to the right */
      //padding: 1em;
      //border-radius: 1em;
      align-items: center;
    }

    #form-button-section button{
      height: 80%;
      border-radius: 2em;
      //width: auto;
      border: 0.1em solid transparent;
      background-color: rgb(18, 105, 192);
      display: flex;
      align-items: center;
    }

    #form-button-section button:hover{
      background-color:green;
    }

    #form-button-section button p{
      color:white;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;      
      font-weight: 600;      
    }

    #modules-container{
      //display:inline-flex;
      //flex-wrap: wrap;
      margin: 0 2em 0 2em;
      gap: 1em;
      //max-width: 100%;
      height: auto;
      border: 1px #d6d9dc solid;
    }
    .module-box{
      border: 1px #d6d9dc solid;
      border-radius: 0.51em;
    }

    h3 {
      font-size: 1.6rem;
      font-weight: 600;
      font-family: 'Montserrat', sans-serif;
    }

    .header-quiz{
      display: grid;
      grid-template-columns: 3fr 1fr 1fr;
      margin-left:1em;
      margin-right: 1em;
      height: 8vh
    }

    .quiz-title{
      font-size: 1.2em;
      font-weight: 600;
      font-family: 'Montserrat', sans-serif;
      text-align: left;
      align-self: center;
  
      
    }

    #attempt-button{
      background-color: rgba(2, 180, 40, 1);
      color: white;
      border-radius: 2em;
      border: 1px rgba(26, 16, 16, 1) solid;
      padding: 1em;
      font-size: 0.85em;
      font-weight: 600;
      font-family: 'Montserrat', sans-serif;
      align-items: center;
      max-height: 80%;
      max-width: 14vh;
    }

    #attempt-button:hover{
      background-color: white;
      color: rgba(2, 180, 40, 1);
    }

    #update-button{
      background-color: rgb(18, 105, 192);
      color: white;
      border-radius: 2em;
      border: 1px rgba(26, 16, 16, 1) solid;
      padding: 1em;
      font-size: 0.85em;
      font-weight: 600;
      font-family: 'Montserrat', sans-serif;
      align-items: center;
      max-height: 80%;
      max-width: 14vh;
    }

    #update-button:hover{
      background-color: white;
      color: rgb(18, 105, 192);;
      border-radius: 2em;
      border: 1px rgba(26, 16, 16, 1) solid;
      padding: 1em;
      font-size: 0.85em;
      font-weight: 600;
      font-family: 'Montserrat', sans-serif;
      align-items: center;
      max-height: 80%;
      max-width: 14vh;
    }


    .module-box a {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      text-align: left;
      font-size: 1.15em;
      line-height: 1em;
      text-decoration: none;
      color: black;
    }

    
    #col-quizzes{
      grid-area: col-quizzes;
      border-radius: 1em;
      border-radius: 1em;
      height: fit-content;
    }
    #upcoming-quizzes{
      background-color: white;      
    }
    #upcoming-quizzes h2{
      text-align: left;
      //margin: 0 2em 0em 2em;
      //gap: 1em;
      font-family: 'Montserrat', sans-serif;      
      max-width: 100%;
      font-size: 2rem;
      height: 5vh;
      background-color: white;
      border-bottom: 3px solid #eff0f3;
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

    .followup-box {
      display: grid;
      grid-template-columns: 2fr 10fr;
      border-bottom: 1px black solid;
      grid-template-areas: 'quiz-icon quiz-details';
      align-items: center;
      text-decoration: none;
      color: black;
    }

    .followup-box:hover {
      background-color: rgb(20, 128, 236);
      cursor: touch;
      
    } 

    .quiz-icon {
      grid-area: quiz-icon;
      text-justify: center;
      color: black;
      color:rgb(18, 105, 192);
    }

    .quiz-details {
      grid-area: quiz-details;
      display: grid;
    }

    .quiz-title, .quiz-due-date {
      margin: 0;
      font-size: 1.1em;
      text-align: left;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-weight:600;
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
    
    }
  #attempt-button{
    background-color: #02b428;
    color: #fff;
    border-radius: 2em;
    border: 1px rgba(26, 16, 16, 1) solid;
    padding: 1em;
    font-size: .5em;
    font-weight: 600;
    font-family: 'Inter';
    align-items: center;
    max-height: 80%;
    max-width: 14vh;
  }
  #update-button {
    background-color: #1269c0;
    color: #fff;
    border-radius: 2em;
    border: 1px rgba(26, 16, 16, 1) solid;
    padding: 1em;
    font-size: .5em;
    font-weight: 600;
    font-family: Montserrat, sans-serif;
    align-items: center;
    max-height: 80%;
    max-width: 14vh;  
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
      <h3>{moduleName}</h3>
    </div>
    <div id="col-modules">
      <div id="my-modules">
      <h2>Quizzes
      <button id="new-module-button" onclick={() => (showModal = true)}>
      <svg  xmlns="http://www.w3.org/2000/svg"  width="32"  height="32"  viewBox="0 0 20 20"  fill="none"  stroke="currentColor"  stroke-width="1"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-plus"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 5l0 14" /><path d="M5 12l14 0" /></svg>
      <span class="tooltiptext">Add a New Quiz</span>
      </button>
      </h2>
      </div>
    
      <div id="modules-container">
        {#each quizzes as quiz, i}
        <div class="module-box">
            <h3 class="header-quiz"><p class="quiz-title">{quiz.quiz_name}</p>
            <button id="attempt-button" onclick={() => goto(`/home/${user_name}/modules/${moduleName}/quizzes/${encodeURIComponent(quiz.quiz_name)}/attempt`)}>Attempt</button>

            <button id="update-button" onclick={() => goToPage(quiz.quiz_name)}>Update</button></h3>
            <p>Created: {new Date(quiz.created_at).toLocaleString()} - <strong>Last score: {quiz.last_score}%</strong> <br> Attempts: {quiz.repetitions} - <strong>Next Due Date: {new Date(quiz.next_due).toLocaleString()}</strong> - Updated: {new Date(quiz.next_due).toLocaleString()}</p>
        </div>
      {/each}
      </div> 
    </div>
    <div id="col-quizzes">
    <div id="followups-container">
      <div id="upcoming-quizzes">
        <h2>Upcoming Quizzes</h2>
        </div>
      {#each followups.slice(0,3) as followup}
        <a
      class="followup-box"
      href={`/home/${user_name}/modules/${followup.module.module_name}/quizzes/${followup.quiz.quiz_name}/attempt`}
    >
      <div class="quiz-icon">
      <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-clipboard-clock-icon lucide-clipboard-clock"><path d="M16 14v2.2l1.6 1"/><path d="M16 4h2a2 2 0 0 1 2 2v.832"/><path d="M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2"/><circle cx="16" cy="16" r="6"/><rect x="8" y="2" width="8" height="4" rx="1"/></svg>
      </div>

      <div class="quiz-details">
        <p class="quiz-title">{followup.module.module_name} — {followup.quiz.quiz_name}</p>
        <p class="quiz-due-date">Due: {new Date(followup.followup_due_date).toLocaleDateString()}</p>
      </div>
    </a>
      {/each}
      </div>
    </div> 
    {#if showModal}
      <Modal bind:showModal>
        <form onsubmit={registerQuiz}>
        <nav id="form-navbar">
          <h2>Add a New Quiz</h2>
          <button onclick={() => (showModal = false)}>
            <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-x"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M18 6l-12 12" /><path d="M6 6l12 12" /></svg>
          </button>
        </nav>
        <div id="form-fields">
          <input id="module-name" bind:value={newQuizName} type="text" placeholder="Quiz Name">
        </div>
        <div id="form-button-section">
          <button type="submit">
            <p>Continue</p>
          </button>
        </div>
        </form>
      </Modal>
    {/if}
</main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
