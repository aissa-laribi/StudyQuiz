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
  let user_id = 0;
  let module_id = 0;
  let moduleImgId = 0;
  let toastMessage = "";
  const imageIndex = localStorage.getItem(`imgModuleIndex`);
  const moduleName = localStorage.getItem(`moduleName`);
  const quizName = writable(null);
  const apiURL = import.meta.env.VITE_API_URL;


  $: login = logged ? "Logged in" : "Login";
  

  
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
      user_id = data['id'];
      user_name = data['user_name'];
    } else {
      message = "Failed to retrieve username";
    }
  }

  function goToPage(pageName){
    const url = `/home/me/modules/${moduleName}/quizzes/${pageName}`;
    goto(url);
  }

  function showToast(message) {
    toastMessage = message;

    setTimeout(() => {
      toastMessage = "";
    }, 3000);
  }

  async function deleteQuiz(module_id,quiz_id){
    const token = await localStorage.getItem("access_token");
    if(!token) return;
  
    const delQuery = await fetch(`${apiURL}/users/${user_id}/modules/${module_id}/quizzes/${quiz_id}`, {
      method: 'DELETE',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });

    if(delQuery.ok) {
      message = "Quiz successfully deleted";
      loadQuizzes();
    } else {
      message="Failed to delete the quiz";
    }
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
      goto(`/home/me/modules/${moduleName}/quizzes/${newQuiz.quiz_name}`);
      } else {
        message = "Module registration failed.";    
      }
    }

</script>


<style>
    .container {
        display: grid;
        min-height: 100vh;
        grid-template-columns: 1fr 10fr 1fr;
        grid-template-rows: auto 1fr;
        grid-template-areas:
        'nav nav nav'
        'sidebar1 main sidebar2';
        align-items: stretch;
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
        grid-template-rows: 2fr 1fr 9fr;
        gap: 0.5rem 2rem ;
        
        grid-template-areas:
        'spacer spacer'
        'breadcrumbs breadcrumbs'
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
      display: inline-flex;
      align-items: center;
    }

    #my-modules button .tooltiptext{
      text-align: center;
      border-radius: 0.25em;
      margin-left: 0.5rem
    }


    #new-module-button {
      cursor: pointer;
      border-radius: 1rem;
      padding: 0.5rem 0.5rem;
      font-family: 'Montserrat', sans-serif;
      font-size: 14pt;
      font-weight: 500;
    }
    
    
    #new-module-button:hover {
      background-color: rgb(18, 105, 192);
      color: white;
      cursor: pointer;
      border-radius: 1rem;
      padding: 0.5rem 0.5rem;
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
      display: grid;
      grid-template-columns: 8fr 1fr;
      grid-template-rows: 0fr 1fr 0.1fr;
      border: 1px #d6d9dc solid;
      border-radius: 0.51em;
      grid-template-areas: 'header-quiz header-quiz'
      'quiz-info quiz-info'
      'start-quiz quiz-modifiers';
      padding-bottom: 0.3rem;
    }



    .header-quiz{
      grid-area: header-quiz;
      margin-left:1em;
      margin-right: 1em;
      margin-top:-2rem;
      margin-bottom:-3rem;
    }

    .module-box .quiz-title{
      grid-area: quiz-title;
      font-size: 2rem;
      text-align: center;
    }

    .start-quiz{
      grid-area: start-quiz;
      display: inline-flex;
      justify-content: center;
      align-items: center;  
    }

    .quiz-info{
      grid-area: quiz-info;
      font-size:10pt;
      display:contents;
    }

    #start-quiz-btn{
      background-color: rgb(7, 7, 7);
      color: white;
      border-radius: 2em;
      border: 1px rgba(26, 16, 16, 1) solid;
      padding: 1em;
      font-size: 1rem;
      font-weight: 600;
      font-family: 'Montserrat', sans-serif;
      min-width: 180px;
      max-width: 320px;
      align-self:center;
      cursor: pointer;
      
    }

    #start-quiz-btn:hover{
        background-color: rgba(2, 180, 40, 1);
        color: black;
    }

    .quiz-modifiers {
      grid-area: quiz-modifiers;
      display: inline-flex;
    }

    .edit-quiz-btn {
      width: 2.6rem;
      height: 2.6rem;
      padding: 0;
      border: 0px;
      background-color: white;
      color: rgb(18, 105, 192);
      cursor: pointer;
  }

  .edit-quiz-btn:hover {
      background-color: rgb(18, 105, 192);
      color: white;
    }

  .edit-icon {
    width: 1.45rem;
    height: 1.45rem;
  }
  .toast {
    position: fixed;
    bottom: 2rem;
    left: 50%;
    transform: translateX(-50%);
    background: #222;
    color: white;
    padding: 0.9rem 1.2rem;
    border-radius: 0.75rem;
    font-size: 0.95rem;
    font-weight: 500;
    z-index: 1000;
  }

  .delete-quiz-btn {
    width: 2.6rem;
    height: 2.6rem;
    padding: 0;
    border: 0px;
    background-color: white;
    color: rgb(190, 30, 45);
    cursor: pointer;
  }

  .delete-quiz-btn:hover {
    background-color: rgb(190, 30, 45);
    color: white;
  }

  .delete-icon {
    width: 1.45rem;
    height: 1.45rem;
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
      min-width: 0;
    }

    #followups-container .quiz-title, .quiz-due-date {
      margin: 0;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      text-align: left;
    }

    #followups-container .quiz-title {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 500;
  line-height: 1.25;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: left;
}

#followups-container .module-name {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 700;
  line-height: 1.25;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: left;
}

#followups-container .quiz-due-date {
  margin: 0.25rem 0 0;
  font-size: 1.1rem;
  font-weight: 400;
  line-height: 1.2;
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
    <div id="breadcrumbs">
      <ul>
        <li><a href="/home/{user_name}">Home</a></li>
        <li>{moduleName}</li>
      </ul>
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
            <div class="header-quiz"><h3 class="quiz-title">{quiz.quiz_name}</h3></div>
            <div class="quiz-info">
              {#if new Date(quiz.next_due).toLocaleDateString().slice(6)!=1970}
                <p>Last score: {quiz.last_score}% <br> Next review: {new Date(quiz.next_due).toLocaleDateString()}</p>
              {:else}
                <p>Last score: None <br> Next review: Not attempted yet</p>
              {/if}
            </div>
            <div class="start-quiz">
              <button id="start-quiz-btn" onclick={() => goto(`/home/${user_name}/modules/${moduleName}/quizzes/${encodeURIComponent(quiz.quiz_name)}/attempt`)}>Start quiz</button>
            </div>
            <div class="quiz-modifiers">
            <button type="button" class="edit-quiz-btn" aria-label="Edit quiz" 
            onclick={() => {if (user_name === "Guest" || user_name === "Undefined") {
                              showToast("Editing is not available in guest mode.");
                            } else {
                              goToPage(quiz.quiz_name+`?from=edit-quiz`);
                            }
                          }
                        }
                      >
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
              </svg>     
              {#if toastMessage}
                <div class="toast">
                {toastMessage}
                </div>
              {/if}
            </button>
            <button type="button" class="delete-quiz-btn" aria-label="Delete quiz" onclick={() => 
            {if (user_name === "Guest" || user_name === "Undefined") {
                              showToast("Deleting is not available in guest mode.");
                            } else {
                              deleteQuiz(quiz.module_id, quiz.id);
                            }
                          }
            }>
              <svg
  class="delete-icon"
  xmlns="http://www.w3.org/2000/svg"
  width="24"
  height="24"
  viewBox="0 0 24 24"
  fill="none"
  stroke="currentColor"
  stroke-width="2"
  stroke-linecap="round"
  stroke-linejoin="round"
  aria-hidden="true"
>
  <path d="M3 6h18" />
  <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
  <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6" />
  <path d="M10 11v6" />
  <path d="M14 11v6" />
</svg>
              {#if toastMessage}
                <div class="toast">
                {toastMessage}
                </div>
              {/if}
            </button>
          </div>
        </div>
      {/each}
      </div> 
    </div>
    <div id="col-quizzes">
    <div id="followups-container">
      <div id="upcoming-quizzes">
        <h2>Upcoming Quizzes</h2>
        </div>
      {#each followups.filter(x => x.module.module_name == moduleName).slice(0,5) as followup}
          <a class="followup-box" href={`/home/${user_name}/modules/${followup.module.module_name}/quizzes/${followup.quiz.quiz_name}/attempt`}>
      <div class="quiz-icon">
      <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-clipboard-clock-icon lucide-clipboard-clock"><path d="M16 14v2.2l1.6 1"/><path d="M16 4h2a2 2 0 0 1 2 2v.832"/><path d="M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2"/><circle cx="16" cy="16" r="6"/><rect x="8" y="2" width="8" height="4" rx="1"/></svg>
      </div>

      <div class="quiz-details">
        <p class="quiz-title">{followup.quiz.quiz_name}</p>
        <p class="module-name">{followup.module.module_name}</p>
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
