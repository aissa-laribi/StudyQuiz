<script>
  import Modal from './Modal.svelte';
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';

  let message = "";
  let login = "Login";
  let logged = false;
  let newModuleName = "";
  let showModal = false;
  let modules = [];
  let followups = [];
  let notAttempted = []
  let user = Object;
  let notAttempted = []
  let user = Object;
  let user_name = "";
  let user_id = 0;
  let module_name = "";
  let quiz_name = "";
  
  const apiURL = import.meta.env.VITE_API_URL;
  const imgModuleIndex = writable(null);
  const moduleName = writable(null);


  function moduleHandler(index, name){
    localStorage.setItem(`imgModuleIndex`, index+1);
    localStorage.setItem(`moduleName`, name);
  }

  function logout(){
    localStorage.removeItem("token");
    localStorage.removeItem("user_name")
    window.location.href = "/";
  }

  async function getUsername(){
    const token = localStorage.getItem("access_token");
    const token = localStorage.getItem("access_token");
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
      user = data;
      user = data;
      user_name = data['user_name'];
      user_id = data['id'];
      user_id = data['id'];
    } else {
      message = "Failed to retrieve username";
    }
  }


  async function loadModulesAndFollowups() {
    const token = localStorage.getItem("access_token");
    if (!token) return;

    // Load modules
    const modQuery = await fetch(`${apiURL}/users/me/modules/`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });
    if (modQuery.ok) {
      const data = await modQuery.json();
      modules = data.map(mod => [mod.module_name]);
    } else {
      message = "Failed to fetch modules";
    }

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

  async function getNotAttempted(){
    const token = localStorage.getItem("access_token");
    if (!token) return;

    // Load not attempted
    const q = await fetch(`${apiURL}/users/me/quizzes/new`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
        }
    });
    if (q.ok) {
      notAttempted = await q.json();
    } else {
      message = "Failed to fetch quizzes";
    }
  }

  async function getNotAttempted(){
    const token = localStorage.getItem("access_token");
    if (!token) return;

    // Load not attempted
    const q = await fetch(`${apiURL}/users/me/quizzes/new`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
        }
    });
    if (q.ok) {
      notAttempted = await q.json();
    } else {
      message = "Failed to fetch quizzes";
    }
  }

  async function getModuleName(id){
    const token = localStorage.getItem("access_token");
    if (!token || !id || !user_id) return "Unknown module";
    const q = await fetch(`${apiURL}/users/${user_id}/modules/${id}`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
        }
    });

    if (q.ok) {
      const data = await q.json();
      return data.module_name;
    } else {
        return "Unkown module";
    }
  }

  async function getQuizname(module_id,id){
    const token = localStorage.getItem("access_token");
    if (!token || !module_id || !id || !user_id) return "Unknown quiz";
    const q = await fetch(`${apiURL}/users/${user_id}/modules/${module_id}/quizzes/${id}`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
        }
    });

    if (q.ok) {
      const data = await q.json();
      return data.quiz_name;
    } else {
        return "Unkown quiz";
    }
  }

  async function getModuleName(id){
    const token = localStorage.getItem("access_token");
    if (!token || !id || !user_id) return "Unknown module";
    const q = await fetch(`${apiURL}/users/${user_id}/modules/${id}`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
        }
    });

    if (q.ok) {
      const data = await q.json();
      return data.module_name;
    } else {
        return "Unkown module";
    }
  }

  async function getQuizname(module_id,id){
    const token = localStorage.getItem("access_token");
    if (!token || !module_id || !id || !user_id) return "Unknown quiz";
    const q = await fetch(`${apiURL}/users/${user_id}/modules/${module_id}/quizzes/${id}`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
        }
    });

    if (q.ok) {
      const data = await q.json();
      return data.quiz_name;
    } else {
        return "Unkown quiz";
    }
  }

  onMount(() => {
    getUsername();
    loadModulesAndFollowups();
    getNotAttempted();
    getNotAttempted();
  });

  async function registerModule(event) {
    event.preventDefault();

    const token = localStorage.getItem("access_token");
    if (!token || !newModuleName.trim()) return;

    const res = await fetch(`${apiURL}/users/me/modules/`, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ name: newModuleName })
    });

    if (res.ok) {
      showModal = false;
      newModuleName = "";
      await loadModulesAndFollowups();
    } else {
      message = "Module registration failed.";
    }
  }
</script>


<style>
    .container {
        display: grid;
        grid-template-columns: 1fr 10fr 1fr;
        grid-template-rows: 0.6fr 10fr;
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
      cursor: touch;
    }
    .menu-box a:hover{
      border-top: 0.1rem solid rgb(18, 105, 192);
      color:rgb(18, 105, 192);
    }

    .user-menu {
      gap: 0.01rem;
      position: relative;
      display: inline-block;
    }

    .user-menu:hover{
      background-color: #f6f7fb;
    }

    .user-menu button {
      text-decoration: none;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 1.5em;
      color:rgb(18, 105, 192);
      margin-top: 1rem;
      margin-right:2rem;
      border: 0px;
      cursor: pointer;
      background-color: transparent;
    }

    .user-menu button:hover{
      background-color: rgb(18, 105, 192);
      color: white;
      
    }


    .dropdown {
      position: absolute;
      top: 100%;
      left: 0;
      width: 100%;
      background-color: #f6f7fb;
      border: 1px solid #ddd;
      padding: 0.5rem;
      box-sizing: border-box;
    }

    .dropdown button{
      background-color: #f6f7fb;
      font-size: 1em;
      margin: 0;
      color: rgb(18, 105, 192);
    }

    main {
        grid-area: main;
        background-color: #f6f7fb;
        display: grid;
        //vertical-align: baseline;
        //justify-content: center;
        vertical-align: baseline;
        grid-template-columns: 2fr 1fr;
        grid-template-rows: auto auto;
        grid-template-rows: auto auto;
        gap: 2rem;
        grid-template-areas:
        'spacer spacer'
        'col-modules col-quizzes'
        ;
        padding-bottom: 3rem;
        padding-bottom: 3rem;
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
      line-height: 1.4;
    }

    #spacer{
        grid-area: spacer;
    }

    .welcome-banner {
      margin: 2rem auto;
      padding: 0.75rem 1rem;
      background: white;
      border: 2px solid #0b66c3;
      border-radius: 12px;
      text-align: center;
    }

.welcome-banner h1 {
  margin: 0 0 0.4rem;
  font-size: 26pt;
  color: #0b66c3;
  font-weight: 700;
  font-family: 'Montserrat', sans-serif;
}

.welcome-banner h2 {
  margin: 0 0 0.4rem;
  font-size: 20pt;
  font-weight: 700;
  font-family: 'Montserrat', sans-serif;
}

.welcome-steps {
  display: inline-block;
  text-align: left;
  margin: 0;
  padding-left: 1.5rem;
  font-size: 14pt;
  font-weight: 600;
  color: #222;
  line-height: 1.5;
  font-family: 'Montserrat', sans-serif;
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
      display: inline-flex;
      align-items: center;
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

    #my-modules h2 {
      font-family: 'Montserrat', sans-serif;
      font-size: 2rem;

    }
    #my-modules button .tooltiptext{
      text-align: center;
      border-radius: 0.25em;
      margin-left: 0.5rem
    }

    #my-modules button:hover .tooltiptext{

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
      max-width: 100%;
      height: 30%;
      //padding: 1vh;
      color: rgb(18, 105, 192)
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
      font-size: 1.5em;
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
      width: auto;
      border: 0.1em solid transparent;
      background-color: rgb(18, 105, 192);
      display: flex;
      align-items: center;
      padding: 1em;
    }

    #form-button-section button:hover{
      background-color:green;
      padding: 1em;
      cursor: pointer;
    }


    #form-button-section button p{
      color:white;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-weight: 600;
      //border: 1em solid transparent;
      //height: 50%;
      //font-size: 1.35rem;
      //margin-top: 1em;
      
    }


    #modules-container{
      display:flex;
      flex-wrap: wrap;
      margin: 0 2em 0 2em;
      gap: 1em;
      max-width: 100%;
      height: auto;
    }
    .module-box{
      display: flex;
      flex-direction: column;
      align-items: center;
      border: 1px black solid;
      flex: 1 1 calc(33.333% - 1em); 
      max-width: calc(33.333% - 1em); /* prevent growing beyond 3 per line */
      box-sizing: border-box;
      height: 20vh;
      border-radius: 0.51em;
      justify-content: flex-start;
    }

    .module-box img{
      width: 100%;
      height: 65%;
      display: grid;
      border-bottom: 1px solid black;
    }

    .module-box p {
      font-family: 'Montserrat', sans-serif;
      text-align: center;
      font-size: 1.2em;
      line-height: 1em;
      font-weight: 800;
    }

    .module-box a{
      text-decoration: none;
      color:rgb(18, 105, 192);
    }

    .module-box a:hover {
      color: rgb(20, 128, 236);
    }
    
    #col-quizzes{
      grid-area: col-quizzes;
      border-radius: 1em;
      border-radius: 1em;
      height: fit-content;
      display: grid;
      gap: 3rem;
      display: grid;
      gap: 3rem;
    }
    #col-quizzes h2{
      //font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
      //font-size: 1.5rem;
      //font-weight: 600;
     
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
      height: 6vh;
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

    #not-attempted-quizzes{
      background-color: white;      
    }
    #not-attempted-quizzes h2{
      text-align: left;
      //margin: 0 2em 0em 2em;
      //gap: 1em;
      font-family: 'Montserrat', sans-serif;      
      max-width: 100%;
      font-size: 2rem;
      height: 6vh;
      background-color: white;
      border-bottom: 3px solid #eff0f3;
    }

    #not-attempted-container{
      background-color: white;
      padding: 1em;
      //display:flex;
      //flex-wrap: wrap;
      //margin: 2em 2em 2em 2em;
      gap: 1em;
      max-width: 100%;
      height: auto;
    }



    #not-attempted-quizzes{
      background-color: white;      
    }
    #not-attempted-quizzes h2{
      text-align: left;
      //margin: 0 2em 0em 2em;
      //gap: 1em;
      font-family: 'Montserrat', sans-serif;      
      max-width: 100%;
      font-size: 2rem;
      height: 6vh;
      background-color: white;
      border-bottom: 3px solid #eff0f3;
    }

    #not-attempted-container{
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
    grid-template-columns: 2fr 2fr;
    grid-template-areas: 'logo-box menu-box';
    max-height: unset;
  }
  .logo-box {
    grid-area: logo-box;
    align-items: center;
  }
  .logo-box img {
    max-width:30vh;
    margin-left: 1vh;
  }
  .menu-box{
    grid-area: menu-box;
  }

  .profile {
    align-self: center;
  }

  .logo-box img{
    display:flex;
    align-items: left;
    margin-left: 1vh;
  }

  main {
    display: grid;
    grid-template-columns:1fr;
    grid-template-rows: 1fr 9fr 1fr;
    grid-template-areas:
    'spacer'
    'col-modules'
    'col-quizzes';
    gap: 0;
  }
  #col-modules {
    grid-area: col-modules;
    border-radius: 1em;
    border-radius: 1em;
    height: fit-content;
    }
  .module-box {
    display: contents;
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
  <div class="menu-box" on:mouseenter={() => toggledProfile = true}
  on:mouseleave={() => toggledProfile = false}>
    <div class="user-menu">
      <button>
        {user_name} ▼
      </button>
    {#if toggledProfile}
      <div class="dropdown">
        <button on:click={logout}>Logout</button>
      </div>
    {/if}
</div>
  </div>
  </nav>
  <main>
    <div id="spacer">
    <section class="welcome-banner">
      <h1>Welcome to StudyQuiz</h1>
      <h2>Try the demo learning flow:</h2>
      <ol class="welcome-steps">
        <li>Choose a sample module below</li>
        <li>Take a quiz</li>
        <li>See how StudyQuiz schedules your next review</li>
      </ol>
</section>
    </div>
    <div id="col-modules">
    <div id="my-modules">
    <h2>My Modules
    <button id="new-module-button" on:click={() => (showModal = true)}>
    <svg  xmlns="http://www.w3.org/2000/svg"  width="32"  height="32"  viewBox="0 0 20 20"  fill="none"  stroke="currentColor"  stroke-width="1"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-plus"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 5l0 14" /><path d="M5 12l14 0" /></svg>
    <span class="tooltiptext">Add a New Module</span>
    </button>
    </h2>
    </div>
    <div id="modules-container">
      {#each modules as module, i}
        <div class="module-box"><img src="/modules/{i+1}.jpg">
        <p><a href={`/home/${user_name}/modules/${module}`} 
        on:click={() => moduleHandler(i, module)}>{module}</a></p>
        </div>
      {/each}
    </div> 
    </div>
    <div id="col-quizzes">
    <div id="followups-container">
  <div id="upcoming-quizzes">
    <h2>Upcoming Quizzes</h2>
  </div>

  {#each followups.slice(0, 3) as followup}
    <a class="followup-box" href={`/home/${user_name}/modules/${followup.module.module_name}/quizzes/${followup.quiz.quiz_name}/attempt`}>
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
  {#if notAttempted.length > 0}
  <div id="not-attempted-container">
  <div id="not-attempted-quizzes">
    <h2>Not Attempted Quizzes</h2>
  </div>
  {#each notAttempted.slice(0, 3) as n}
  {#await getModuleName(n.module_id)}
    <div class="followup-box">
      <p>Loading module...</p>
    </div>
  {:then moduleName}
    {#await getQuizname(n.module_id, n.id)}
      <div class="followup-box">
        <p>{moduleName} — Loading quiz...</p>
      </div>
    {:then quizName}
      <a
        class="followup-box"
        href={`/home/me/modules/${moduleName}/quizzes/${quizName}/attempt`}
      >
        <div class="quiz-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M16 14v2.2l1.6 1"/>
            <path d="M16 4h2a2 2 0 0 1 2 2v.832"/>
            <path d="M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2"/>
            <circle cx="16" cy="16" r="6"/>
            <rect x="8" y="2" width="8" height="4" rx="1"/>
          </svg>
        </div>

        <div class="quiz-details">
          <p class="quiz-title">{moduleName} — {quizName}</p>
        </div>
      </a>
    {:catch}
      <div class="followup-box">
        <p>{moduleName} — Unknown quiz</p>
      </div>
    {/await}
  {:catch}
    <div class="followup-box">
      <p>Unknown module — Unknown quiz</p>
    </div>
  {/await}
{/each}
  </div>
  {/if}
  </div>
  {#if notAttempted.length > 0}
  <div id="not-attempted-container">
  <div id="not-attempted-quizzes">
    <h2>Not Attempted Quizzes</h2>
  </div>
  {#each notAttempted.slice(0, 3) as n}
  {#await getModuleName(n.module_id)}
    <div class="followup-box">
      <p>Loading module...</p>
    </div>
  {:then moduleName}
    {#await getQuizname(n.module_id, n.id)}
      <div class="followup-box">
        <p>{moduleName} — Loading quiz...</p>
      </div>
    {:then quizName}
      <a
        class="followup-box"
        href={`/home/me/modules/${moduleName}/quizzes/${quizName}/attempt`}
      >
        <div class="quiz-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M16 14v2.2l1.6 1"/>
            <path d="M16 4h2a2 2 0 0 1 2 2v.832"/>
            <path d="M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2"/>
            <circle cx="16" cy="16" r="6"/>
            <rect x="8" y="2" width="8" height="4" rx="1"/>
          </svg>
        </div>

        <div class="quiz-details">
          <p class="quiz-title">{moduleName} — {quizName}</p>
        </div>
      </a>
    {:catch}
      <div class="followup-box">
        <p>{moduleName} — Unknown quiz</p>
      </div>
    {/await}
  {:catch}
    <div class="followup-box">
      <p>Unknown module — Unknown quiz</p>
    </div>
  {/await}
{/each}
  </div>
  {/if}
</div>
  
  

    {#if showModal}
      <Modal bind:showModal>
        <form on:submit={registerModule}>
        <nav id="form-navbar">
          <h2>Register a New Module</h2>
          <button on:click={() => (showModal = false)}>
            <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-x"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M18 6l-12 12" /><path d="M6 6l12 12" /></svg>
          </button>
        </nav>
        <div id="form-fields">
          <input id="module-name" bind:value={newModuleName} type="text" placeholder="Module Name">
        </div>
        <div id="form-button-section">
          <button>
            <p>Register</p>
          </button>
        </div>
        </form>

      </Modal>
    {/if}

</main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
