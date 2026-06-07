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
        grid-template-rows: 0.6fr 10fr;
        grid-template-areas:
        'nav nav nav'
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
        grid-template-rows: 0.1fr 0.1fr 1fr;
    }

    main h2 {
      font-family: 'Montserrat', sans-serif;
      text-align: center;
    }


    #content {
      padding: 5rem;
    }

    #content p{
      text-align:left;
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

  main {
    display: block;
  }


  #sidebar1{
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

<main>
  <div id="title"><h1>Privacy Policy</h1></div>
  <div id="subtitle"><h2>AI-Assisted Quiz Generation</h2></div>
  <div id="content">
  <p>
    StudyQuiz allows users to upload study materials so that quiz questions can be generated automatically.
    Uploaded documents are processed temporarily for the purpose of quiz generation. The original uploaded document is not stored permanently after generation.
    Only text is extracted from uploaded documents. The original document is not sent to the AI inference provider; only the extracted text is used for AI-assisted quiz generation.
    Generated quiz questions and answers may be stored in StudyQuiz so that users can take, review, and manage their quizzes.
    StudyQuiz uses third-party cloud hosting and AI inference infrastructure to provide this feature. Our AI inference provider is configured not to retain customer input or output data for model training or long-term storage.
    Uploaded material may be processed using infrastructure outside the EEA under appropriate data-processing safeguards.
    Users should not upload documents containing sensitive, confidential, or personally identifiable information.
  </p>
  </div>
</main>
  <div id="sidebar1"></div>
  <div id="sidebar2"></div>
  
</section>
