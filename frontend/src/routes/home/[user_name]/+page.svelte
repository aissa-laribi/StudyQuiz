<script>
  import Modal from './Modal.svelte';
  import { onMount } from 'svelte';

  let message = "";
  let login = "Login";
  let logged = false;
  let newModuleName = "";
  let showModal = false;
  let modules = [];
  let followups = [];
  let user_name = "";

  $: login = logged ? "Logged in" : "Login";

  async function getUsername(){
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
  }
  async function loadModulesAndFollowups() {
    const token = localStorage.getItem("access_token");
    if (!token) return;

    // Load modules
    const modQuery = await fetch(`http://localhost:8000/users/me/modules/`, {
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
    const folQuery = await fetch(`http://localhost:8000/users/me/followups/`, {
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
    loadModulesAndFollowups();
  });

  async function registerModule(event) {
    event.preventDefault();

    const token = localStorage.getItem("access_token");
    if (!token || !newModuleName.trim()) return;

    const res = await fetch("http://localhost:8000/users/me/modules/", {
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
      font-family: 'Montserrat', sans-serif;
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
      justify-content: space-between;  /* Pushes h2 left, button right */
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
      font-family: 'Montserrat', sans-serif;
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
      width: auto;
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
      font-family: 'Montserrat', sans-serif;
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
      border: 1px black solid;
      flex: 1 1 calc(33.333% - 1em); 
      max-width: calc(33.333% - 1em); /* prevent growing beyond 3 per line */
      box-sizing: border-box;
      height: 20vh;
      border-radius: 0.51em;
    }

    .module-box img{
      width: 100%;
      height: 70%;
      display: grid;
      border-bottom: 1px solid black;
    }

    .module-box p {
      font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
      text-align: center;
      font-size: 1.15em;
      line-height: 1em;
    }

    #col-modules h2{
      font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
      font-size: 1.5rem;
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
      max-width: 100%;
      height: auto;
      background-color: white;
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

</style>

<section class="container">
  <nav>
  <div class="logo-box"><img src="/logo.png"></div>
  <div class="menu-box">
      <a href="./pagetogo">{login}</a>
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
        <p><a href={`/home/${user_name}/modules/${module}`}>{module}</a></p>
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
        <div class="followup-box">
        <p>{new Date(followup.followup_due_date).toLocaleString()}<br>{followup.module}, {followup.quiz}</p>
        </div>
      {/each}
      </div>
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
