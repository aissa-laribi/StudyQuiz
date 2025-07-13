<script>
  import { onMount } from 'svelte';
  let message = "";
  let users = [];
  let login = "";
  let logged = false;

  onMount(async () => {
    const res = await fetch("http://localhost:8000/");
    const data = await res.json();
    message = data.message;

    const query = await fetch("http://localhost:8000/users");
    const query_data = await query.json();  
    users = query_data; 
  });

  //Maybe a function will be more appropriated
  if(logged){
    login="Logged in";
  } else {
    login = "Login";
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
        height: 100%; 
        vertical-align: baseline;
        justify-content: center;
        vertical-align: baseline;
        //grid-template-columns: 1fr;
        grid-template-rows: 0.2fr 1fr 1fr;
        row-gap: 20px;
        grid-template-areas:
        'hero-spacer'
        'hero'
        'feature-grid'
        ;
    }
    main h1 {
      font-family: 'Montserrat' sans-serif;
      text-align: center;
      font-weight: 700;
      font-size: 2.5rem;
    }
    main p {
      font-family: 'Montserrat' sans-serif;
      min-height: 1.5rem;
      text-align: center;
      font-weight: 400;
      font-size: 1.35rem;
      line-height: 1.4;
    }
    main #hero-spacer {
      grid-area: hero-spacer;
    }

    main #hero {
      grid-area: hero;
    }

    main #hero .button-container{
      display: flex;
      justify-content: center;
      align-vertical: top;
      margin: 1em;
    }
    main #hero button {
      padding: 1.35rem 2.50rem;
      background-color: rgb(0, 80, 160);
      border-radius: 1.25em;
      border: 0;
      color: white;
      //font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
      //font: inherit;
      font-size: 2em;
      
      
    }

    main #hero button:hover {
      padding: 1.35rem 2.50rem;
      background-color: rgb(20, 128, 236);
      border-radius: 1.25em;
      border: 0;
      color: white;
      //font-family: 'Lato', 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;
      //font: inherit;
      font-size: 2em;
      justify-content: center;
    }

    
    #feature-grid {
      grid-area: feature-grid;
      background-color: #fdd19eff;
      padding : 1.25em;


    }
    #feature-grid-inner {
      
      background-color: #0c1642;
      
      display: grid;
      grid-template-columns: 1fr 1fr 1fr 1fr;
      grid-template-rows: 1fr;
      grid-template-areas:
      'feat-col1 feat-col2 feat-col3 feat-col4';
      text-align: center;
      color : white;
      font-family: 'Montserrat' sans-serif;
      font-size: 1.5em;
      border-radius: 1em;
  
    }

    #feature-grid #col1 {
      template-area: col1;
      
      
    }

    #feature-grid #col1 h3 {
      
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
  <div id="hero-spacer"></div>
  <div id="hero">
    <h1>Study smarter Learn faster No need to memorize</h1>
    <p>Leverage AI to craft chapter-specific quizzes, enhance retention through spaced repetition, and ensure
    progress with follow-up scheduling .</p>
    <div class="button-container">
      <button>Signup for free</button>
  </div>
  <div id="feature-grid">
  <div id="feature-grid-inner">
  <div id="col1"><h3>Spaced Repetition</h3><img src="spaced-repetition.png"></div>
  <div id="col2"><h3>Shuffled Questions</h3><img src="shuffling.png"></div>
  <div id="col3"><h3>Followup Schedule</h3><img src="followups-schedule.png"></div>
  <div id="col4"><h3>Web & API</h3><img src="web-api.png"></div>
  </div>
  </div>
  
</main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
