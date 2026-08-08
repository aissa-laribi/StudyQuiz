<script>
  import { onMount } from 'svelte';
  import{ goto } from '$app/navigation';
  import { redirect } from '@sveltejs/kit';
  import { fade,fly } from 'svelte/transition';
  import IntersectionObserver from 'svelte-intersection-observer';

  let user_name = "";
  let menuOpen = false;
  const apiURL = import.meta.env.VITE_API_URL;

  let element1;
  let element2;
  let intersecting1 = false;
  let intersecting2 = false;
  let toEarlyAccessList = false;
  let toFreeList = false;
  let message = "";

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

  async function addToWaitingList(event,planName){
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    
    const payload = {
      email: formData.get("email"),
      subject: formData.get("subject"),
      usage: formData.get("usage"),
    };

    try {
      let plan_id;
      if(planName === "Early Birds"){
        plan_id = 2
      } else if(planName === "Free"){
        plan_id = 1;
      }
      const req = await fetch(`${apiURL}/users/waiting-list?prod=true&plan_id=${plan_id}`,{
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      }
      );
      const data = await req.json();
      console.log(payload)
      if(req.ok){
        message = "Successfully submitted, soon you will be invited"
        toEarlyAccessList = false;
        toFreeList = false;
      } else {
        message = "Unsuccessfully submitted"
      }
    } catch(error){
      message = "Error processing";
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
        min-height: 100vh;
        height: auto;
        overflow: visible;
        grid-template-columns: 1fr;
        grid-template-rows: auto 1fr;
        grid-template-areas:
          'nav'
          'main';
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
    /*#notice {
      grid-area: notice;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #4190e01c;
      font-family: 'Inter', 'Segoe UI', Roboto, sans-serif;
      text-align: center;
    }*/

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

    .hamburger {
      display: none;
      background: transparent;
      border: none;
      cursor: pointer;
      padding: 0.5rem;
    }

    .hamburger img {
      width: 40px;
      height: 40px;
      display: block;
    }

    .desktop-menu {
      display: flex;
    }

    .mobile-menu {
      display: none;
    }

    main {
        grid-area: main;
        background-color: white;
        display: grid;
        height: auto;
        min-height: 0;
        overflow: visible;
        /*vertical-align: baseline;
        justify-content: center;
        vertical-align: baseline;*/
        grid-template-columns: 1fr;
        grid-template-rows: 0.1fr 0.1fr auto auto auto;
        //row-gap: 20px;
        grid-template-areas:
        'hero-spacer'
        'hero'
        'showcase-container'
        'feature-grid'
        'plans-grid';
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
      min-height: 90vh;
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
      background-color: #f6f7fb;
      padding : 1.25em;
    }
    
    #feature-grid-inner {
      background-color: #f6f7fb;
      display: grid;
      grid-template-columns: 1fr 1fr 1fr 1fr;
      grid-template-rows: 1fr 0.2fr;
      grid-template-areas:
      'feat-col1 feat-col2 feat-col3 feat-col4'
      'plans-intro plans-intro plans-intro plans-intro'
      ;
      text-align: center;
      color : black;
      font-family: 'Montserrat', sans-serif;
      font-size: 1.5em;
      border-radius: 1em;
      gap:1rem;
      padding:1rem;
    }

    .feat-col {
      border: 0.1rem solid black;
      border-radius: 2rem;
      background-color: white;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
      padding: 1rem;
    }

    .feat-col img {
      width: 50%;
    }

    .plans-intro{
      grid-area: plans-intro;
      text-align: center;
      background-color:#f6f7fb;
    }

    .plans-intro h2{
      font-size:40pt;
      font-family: 'Montserrat', sans-serif;
    }

    #plans-grid{
      grid-area: plans-grid;
      background-color: #f6f7fb;
      padding : 1.25em;
    }

    #plans-grid-inner {
      background-color: #f6f7fb;
      display: grid;
      grid-template-columns: 1fr;
      grid-template-rows: 1fr;
      grid-template-areas:
      'plans-card'
      ;
      //text-align: center;
      color : black;
      font-family: 'Montserrat', sans-serif;
      font-size: 1.5em;
      border-radius: 1em;
      
    }

    .plans-card{
      display: inline-flex;
      margin: auto;
      gap:2rem;
      
    }

    .plan-col {
      border-radius: 2rem;
      background-color: white;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
      padding: 1rem;
      max-width: 500px;
      box-shadow:
      0 1px 1px hsla(0, 0%, 0%, 0.075),
      0 2px 2px hsl(0deg 0% 0% / 0.075),
      0 4px 4px hsl(0deg 0% 0% / 0.075),
      0 8px 8px hsl(0deg 0% 0% / 0.075),
      0 16px 16px hsl(0deg 0% 0% / 0.075)
    ;
    }

    .plan-col h3{
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    }

    .plan-col button {
      border: 0.1em solid transparent;
      border-radius: 0.4em;
      background-color: rgb(0, 80, 160);
      color: white;
      font-size: 1.4em;
      display: block;
      margin: 0 auto;
      padding: 1rem;
      cursor: pointer;
    }

    .plan-col button:hover {
      border: 0.1em solid transparent;
      border-radius: 0.4em;
      background-color: black;
      color: white;
      font-size: 1.4em;
      display: block;
      margin: 0 auto;
      padding: 1rem;
      cursor: pointer;
    }

    .plan-col ul{
      list-style: none;
      font-family: 'Open Sans';
    }

    .plan-col li::before{
      content: "";
      position: absolute;
      left: 0;
      top: 0.25em;
      width: 1.75rem;
      height: 1.75rem;
      background: url("/favicon.png") center / contain no-repeat;
    }

    .plan-col li{
      position: relative;
      padding-left: 1.5em;
      margin: auto;
    }

    #plans {
      scroll-margin-top: -10rem;
    }

    form {
      display: grid;
      gap: 1em;
      height:fit-content;
      margin: auto auto;
      padding: 2rem;
      border-radius: 2rem;
      margin-top: 1.25rem;
      padding-top: 1.25rem;
      border-top: 1px solid #ddd;
      box-shadow: none;
      border-radius: 0;
      background: transparent;
    }

    form input,textarea {
      border: 0.1em solid rgba(0, 0, 0, 0.486);
      border-radius: 0.4em;
      min-height: 5vh;
      font-size: 1.5rem;
    }

    form input::placeholder, textarea::placeholder {
      letter-spacing: 0.1em;
      color: #111111a1;
      text-indent: 0.6em;
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    }

    form button {
      border: 0.1em solid transparent;
      border-radius: 0.4em;
      background-color: rgb(0, 80, 160);
      color: white;
      font-size: 1.4em;
      min-height: 5vh; 
    }

    form button:hover{
      color:  rgb(0, 80, 160);
      background-color:white;
      cursor: pointer;
      
    }

    #sidebar1 {
        grid-area : sidebar1;
        background-color: #f6f7fb;
        
    }
    #sidebar2 {
        grid-area : sidebar2;
        background-color: #f6f7fb;
    }
    footer {
      grid-area: footer;
      background-color: aqua;
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
  /*#notice {
    font-size: 0.9rem;
    border-radius: 0.4em;
  }
  #notice p{
    display: flex;
    font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    font-size: 1em;
  }*/
  .desktop-menu {
  display: none;
}

.hamburger {
  display: block;
}

.menu-box {
  position: relative;
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.mobile-menu {
  position: absolute;

  top: 100%;
  right: 0;

  display: flex;
  flex-direction: column;

  background-color: white;

  min-width: 180px;
  padding: 0.5rem;

  border-radius: 0.5rem;

  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);

  z-index: 1000;
}

.mobile-menu a {
  display: block;
  font-size: 1.3rem;
  padding: 0.8rem 1rem;
  margin: 0;

  white-space: nowrap;
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

<IntersectionObserver element={element1} bind:intersecting={intersecting1}>
<IntersectionObserver element={element2} bind:intersecting={intersecting2}>
<section class="container">
  <nav>
  <div class="logo-box"><a href="/"><img src="/logo.png"></a></div>
  <div class="menu-box">

  <div class="desktop-menu">
    <a href="#feature-grid">Features</a>
    <a href="#plans">Plans</a>

    <a class="login-link" href="./login">
      {#if user_name.length == 0}
        Login
      {:else}
        {goto(`/home/${user_name}`)}
      {/if}
    </a>
  </div>

  <button class="hamburger" onclick={() => menuOpen = !menuOpen} aria-label="Toggle navigation menu" aria-expanded={menuOpen}>
    <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="48" height="48" viewBox="0,0,256,256">
      <defs><linearGradient x1="12.066" y1="0.066" x2="34.891" y2="22.891" gradientUnits="userSpaceOnUse" id="color-1_Rdp3AydLFY2A_gr1"><stop offset="0.237" stop-color="#3bc9f3"></stop><stop offset="0.85" stop-color="#1269c0"></stop></linearGradient><linearGradient x1="12.066" y1="12.066" x2="34.891" y2="34.891" gradientUnits="userSpaceOnUse" id="color-2_Rdp3AydLFY2A_gr2"><stop offset="0.237" stop-color="#3bc9f3"></stop><stop offset="0.85" stop-color="#1269c0"></stop></linearGradient><linearGradient x1="12.066" y1="24.066" x2="34.891" y2="46.891" gradientUnits="userSpaceOnUse" id="color-3_Rdp3AydLFY2A_gr3"><stop offset="0.237" stop-color="#3bc9f3"></stop><stop offset="0.85" stop-color="#1269c0"></stop></linearGradient></defs><g fill="none" fill-rule="nonzero" stroke="none" stroke-width="1" stroke-linecap="butt" stroke-linejoin="miter" stroke-miterlimit="10" stroke-dasharray="" stroke-dashoffset="0" font-family="none" font-weight="none" font-size="none" text-anchor="none" style="mix-blend-mode: normal"><g transform="scale(5.33333,5.33333)"><path d="M43,15h-38c-1.1,0 -2,-0.9 -2,-2v-2c0,-1.1 0.9,-2 2,-2h38c1.1,0 2,0.9 2,2v2c0,1.1 -0.9,2 -2,2z" fill="url(#color-1_Rdp3AydLFY2A_gr1)"></path><path d="M43,27h-38c-1.1,0 -2,-0.9 -2,-2v-2c0,-1.1 0.9,-2 2,-2h38c1.1,0 2,0.9 2,2v2c0,1.1 -0.9,2 -2,2z" fill="url(#color-2_Rdp3AydLFY2A_gr2)"></path><path d="M43,39h-38c-1.1,0 -2,-0.9 -2,-2v-2c0,-1.1 0.9,-2 2,-2h38c1.1,0 2,0.9 2,2v2c0,1.1 -0.9,2 -2,2z" fill="url(#color-3_Rdp3AydLFY2A_gr3)"></path></g></g>
    </svg>
  
  </button>

  {#if menuOpen}
    <div class="mobile-menu">
      <a href="#feature-grid" onclick={() => menuOpen = false}>
        Features
      </a>

      <a href="#plans" onclick={() => menuOpen = false}>
        Plans
      </a>

      <a href="./login" onclick={() => menuOpen = false}>
        Login
      </a>
    </div>
  {/if}

</div>
  </nav>
  <!--
  <div id="notice" role="status" aria-live="polite">
    <p>Registration is limited for now but you can explore StudyQuiz as a guest.</p>
  </div> -->
  <main>
  <div id="hero-spacer">
  </div>
  <div id="hero">
    <h1>Turn your study material into quizzes. Review at the right time.</h1>
    <p>Create quizzes from your study material with AI, test your knowledge, and let StudyQuiz schedule your next review.</p>
    <div class="button-container">
      <a href="/login" class="signup-button"><button>Try Guest mode</button></a>
    </div>
    <p><small>No account required</small></p>
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
  <div bind:this={element1} id="feature-grid-inner">
    {#if intersecting1}
    <div class="feat-col" transition:fly={{y:140,duration:2000,opacity:0}}>
      <h3>AI-generated quizzes</h3>
      <p>Turn study material into quiz questions with AI support.</p>
      <img src="spaced-repetition.png">
    </div>
    <div class="feat-col" transition:fly={{y:130,duration:1750,opacity:0}}>
      <h3>Manual quiz builder</h3>
      <p>Create and edit your own quizzes when you want full control.</p>
      <img src="shuffling.png">
    </div>
    <div class="feat-col" transition:fly={{y:120,duration:1500}}>
      <h3>Spaced repetition</h3>
      <p>Review at the right time when StudyQuiz schedules it.</p>
      <img src="followups-schedule.png">
    </div>
    <div class="feat-col" transition:fly={{y:100,duration:1000}}>
      <h3>Progress and mistakes</h3>
      <p>Track scores, due reviews, and answers to revisit.</p>
      <img src="web-api.png">
    </div>
    {/if}
    <div class="plans-intro" id="plans">
  <h2>Plans at launch</h2>
  <p>
    Both plans include the full StudyQuiz workflow, with different AI allowances.
</div>
  </div>
  </div> 
  <div id="plans-grid">
  <div id="plans-grid-inner">
   <div class="plans-card" bind:this={element2}>
   {#if intersecting2}
    <div class="plan-col" transition:fly={{x:-400,duration:1000}}>
      <h2>Early Access</h2>
      <p>Generous free access for six active early adopters.</p>
      <h3>$0 per month</h3>
      <p><strong>Limited to 6 users</strong></p>
      <button onclick={() => {toEarlyAccessList = !toEarlyAccessList}}>Register Your Interest</button>
      <ul>
        <li>60 AI-generated quizzes per month</li>
        <li>Up to 5 AI-generated quizzes per day</li>
        <li>Unlimited manual quizzes</li>
        <li>Unlimited scheduled reviews</li>
        <li>Unlimited quiz attempts</li>
        <li><strong>Regular use required*</strong></li>
      </ul>
            {#if toEarlyAccessList}
        <form onsubmit={(event)=>addToWaitingList(event,"Early Birds")}>
            <h3>Register your interest in Early Access</h3>
            <input name="email" type="email" placeholder="Email address" required>
            <input name="subject" placeholder="What are you studying?">
            <textarea name="usage" placeholder="How could StudyQuiz help you?" maxlength="1000" rows="5" cols="1"></textarea>
            <button>Send</button>
            <p>{message}</p>
        </form>
      {/if}
    </div>
    <div class="plan-col" transition:fly={{x:400,duration:1000}}>
      <h2>Free</h2>
      <p>Try the complete StudyQuiz workflow with a smaller AI allowance.</p>
      <h3>$0 per month</h3>
      <p><strong>No credit card required</strong></p>
      <button onclick={() => {toFreeList = !toFreeList}}>Notify me at launch</button>
      <ul>
        <li>5 AI-generated quizzes per month</li>
        <li>Up to 1 AI-generated quiz per day</li>
        <li>Unlimited manual quizzes</li>
        <li>Unlimited scheduled reviews</li>
        <li>Unlimited quiz attempts</li>
        </ul> 
      {#if toFreeList}
        <form onsubmit={(event)=>addToWaitingList(event,"Free")}>
            <h3>Notify me at launch</h3>
            <input name="email" type="email" placeholder="Email address" required>
            <button>Notify me</button>
        </form>
      {/if}   
    </div>
    {/if}
    </div>
    <p>{message}</p>
    <p id="plans"><small>*To keep Early Access, generate or complete at least two AI-generated quizzes every 10 days. Accounts that do not meet this requirement will move to the Free plan.<br>
    </small></p>
  </div>
  </div>
</main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
</IntersectionObserver>
</IntersectionObserver>