<script>
  import { onMount } from 'svelte';
  import{ goto } from '$app/navigation';

  let user_name = "";
  const apiURL = import.meta.env.VITE_API_URL;

  async function turnOnAI(){
    const token = localStorage.getItem("access_token");
    if(!token) return;

    const query = await fetch(`${apiURL}/ai`, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });
  }

  async function getUsername(){
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
      user_name = data['user_name'];
      goto(`/home/${user_name}`);
    } else {
      localStorage.removeItem("access_token");
    }
  }

  onMount(async () => {
    await turnOnAI();
    await getUsername();
  });
</script>

<style>
    .container {
        display: grid;
        height: 100vh;
        grid-template-columns: 1fr 10fr 1fr;
        grid-template-rows: 0.6fr 0.1fr 10fr;
        grid-template-areas:
        'nav nav nav'
        'notice notice notice'
        'main main main';
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
        //max-height:4vh;
    }
    #notice {
      grid-area: notice;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #4190e01c;
      font-family: 'Inter', 'Segoe UI', Roboto, sans-serif;
      text-align: center;
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
        'menu-box-col1 menu-box-col2';
    }
    .menu-box a{
      text-decoration: none;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: 2rem;
      color:rgb(18, 105, 192);
      margin-right:0.5em;
      cursor: pointer;
      border-radius: 2rem;
      padding: 0.4rem 0.8rem;
      
    }
    
    .menu-box a:hover{
      background-color: rgb(20, 128, 236);
      color:white;
    }
    main {
        grid-area: main;
        background-color: white;
        display: grid;
        height: 100vh; 
        vertical-align: baseline;
        justify-content: center;
        vertical-align: baseline;
        grid-template-columns: 1fr;
        grid-template-rows: 0.5fr 2fr 2fr 2fr;
        row-gap: 20px;
        grid-template-areas:
        'hero-spacer'
        'hero'
        'showcase-container'
        'feature-grid';
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
      font-size: 1.5rem;
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
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      //font: inherit;
      font-size: 2em;
      justify-content: center;
      cursor:pointer;
    }

    main #hero button:hover {
      padding: 1.35rem 2.50rem;
      background-color: rgb(20, 128, 236);
      border-radius: 1.25em;
      border: 0;
      color: white;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      //font: inherit;
      font-size: 2em;
      justify-content: center;
      cursor: touch;
    }

    #showcase-container {
      grid-area: showcase-container;
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
      grid-template-areas: 'video-spacer1 video-player video-spacer2';

    }

    #video-player{
      grid-area: video-player;
      display: grid;
    }

    #video-player video {
      width: 90vh;
      border-radius: 2vh;
      border: 2rem black solid;
    }

    #video-spacer1 {
      grid-area: video-spacer1;
      
    }

    
    #feature-grid {
      grid-area: feature-grid;
      background-color: #f6f7fb;
      padding : 1.25em;


    }
    #feature-grid-inner {
      background-color: #f6f7fb;
      display: grid;
      grid-template-columns: 1fr 1fr 1fr 1fr;
      grid-template-rows: 1fr;
      grid-template-areas:
      'feat-col1 feat-col2 feat-col3 feat-col4';
      text-align: center;
      color : white;
      font-family: 'Montserrat', sans-serif;
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
        background-color:white;
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
      font-size: 1.5rem;
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
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      //font: inherit;
      font-size: 2em;
      justify-content: center;
    }

    main #hero button:hover {
      padding: 1.35rem 2.50rem;
      background-color: rgb(20, 128, 236);
      border-radius: 1.25em;
      border: 0;
      color: white;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      //font: inherit;
      font-size: 2em;
      justify-content: center;
      cursor: touch;
    }

    
    #feature-grid {
      grid-area: feature-grid;
      background-color: #f6f7fb
      padding : 1.25em;
    }
    
    #feature-grid-inner {
      background-color: #f6f7fb;
      display: grid;
      grid-template-columns: 1fr 1fr 1fr 1fr;
      grid-template-rows: 1fr;
      grid-template-areas:
      'feat-col1 feat-col2 feat-col3 feat-col4';
      text-align: center;
      color : black;
      font-family: 'Montserrat', sans-serif;
      font-size: 1.5em;
      border-radius: 1em;
      gap:1rem;
    }

    .feat-col {
      border: 0.1rem solid black;
      border-radius: 2rem;
      background-color: white;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
    }

    .feat-col img {
      width: 50%;
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
@media (max-width: 500px) {
  .container{
    display: block;
    background-color: #f6f7fb;
  }
  nav {
    display: grid;
    grid-template-columns: 2fr 2fr;
    grid-template-areas: 'logo-box menu-box';
  }
  .logo-box{
    grid-area: logo-box;
  }
  .logo-box img {
    max-width:30vh;
    margin-left: 1vh;
  }
  .menu-box {
    grid-area: menu-box;
  }
  #notice {
    font-size: 0.9rem;
    border-radius: 0.4em;
  }
  #notice p{
    display: flex;
    font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    font-size: 1em;
  }
  main {
    display: block;
  }
  #feature-grid-inner {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-areas:
      'feat-col1'
      'feat-col2'
      'feat-col3'
      'feat-col4';
  }

#video-player video{
  width: 40vh;
  border-radius: 2vh;
  border: 1rem black solid;
}

  #col1{
    display: block;
    grid-area: feat-col1;
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
      <a class="login-link" href="./login">
      {#if user_name.length == 0}
        Login
      {:else}
        {goto(`/home/${user_name}`)}
      {/if}
      </a>
  </div>
  </nav>
  <div id="notice" role="status" aria-live="polite">
    <p>Registration is limited for now but you can explore StudyQuiz as a guest.</p>
  </div>
  <main>
  <div id="hero-spacer">
  </div>
  <div id="hero">
    <h1>Turn your study material into quizzes. Review at the right time.</h1>
    <p>Create quizzes from your study material with AI, test your knowledge, and let StudyQuiz schedule your next review.</p>
    <div class="button-container">
      <a href="/login" class="signup-button"><button>Try the demo</button></a>
    </div>
    <p>No sign-up required</p>
  <div id="showcase-container">
    <div id="video-spacer"></div>
    <div id="video-player">
      <video autoplay muted loop playsinline>
        <source src="/showcase.mp4" type="video/mp4" />
      </video>
    </div>
    <div id="video-spacer"></div>
    </div>
  </div>
  <div id="feature-grid">
  <div id="feature-grid-inner">
    <div class="feat-col">
      <h3>AI-generated quizzes</h3>
      <p>Turn study material into quiz questions with AI support.</p>
      <img src="spaced-repetition.png">
    </div>
    <div class="feat-col">
      <h3>Manual quiz builder</h3>
      <p>Create and edit your own quizzes when you want full control.</p>
      <img src="shuffling.png">
    </div>
    <div class="feat-col">
      <h3>Spaced repetition</h3>
      <p>Review at the right time when StudyQuiz schedules it.</p>
      <img src="followups-schedule.png">
    </div>
    <div class="feat-col">
      <h3>Progress and mistakes</h3>
      <p>Track scores, due reviews, and answers to revisit.</p>
      <img src="web-api.png">
    </div>
  </div>
  </div>
  
</main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
