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
  let user_name = "";
  const apiURL = import.meta.env.VITE_API_URL;
  const imgModuleIndex = writable(null);
  const moduleName = writable(null);


  function moduleHandler(index, name){
    localStorage.setItem(`imgModuleIndex`, index+1);
    localStorage.setItem(`moduleName`, name);
    //console.log("MOdule name:", moduleName);
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
      //console.log("FOLLOW:", followups);
    } else {
      message = "Failed to fetch quizzes";
    }
  }

  onMount(() => {
    getUsername();
    loadModulesAndFollowups();
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
    .profile {
      text-decoration: none;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 2em;
      color:rgb(18, 105, 192);
      margin-right:0.5em; 
      
    }
    .menu-box a{
      cursor: touch;
    }
    .menu-box a:hover{
      border-top: 0.1rem solid rgb(18, 105, 192);
      color:rgb(18, 105, 192);
      
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
        grid-template-rows: 1fr 9fr;
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
      line-height: 1.4;
    }

    #spacer{
        grid-area: spacer;
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

    #my-modules h2 {
      font-family: 'Montserrat', sans-serif;
      font-size: 2rem;

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
    grid-template-rows: 1fr 9fr;
    grid-template-areas:
    'col-quizzes'
    'col-modules';
    gap: 0;
  }
  #col-quizzes {
    grid-area: col-quizzes;
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
  <div class="menu-box">
      <p class="profile">{user_name}</p>
  </div>
  </nav>
  <main>
    <div id="spacer"></div>
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
