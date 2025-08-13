<script>
  
  let message = "";
  let login = "Login";
  let logged = false;

  $: if(logged === true){
    login="Logged in";
  } else {
    login = "Login";
  }
  
  async function handleLogin(event) {
    const formData = new FormData(event.target);
    const username = formData.get('username');
    const password = formData.get('password');

    const res = await fetch('https://studyquiz.onrender.com/users/token', {
      method: 'POST',
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        username: username,
        password: password,
        grant_type: "password",
        client_id: "string",
        client_secret: "string"
      })
    });
    if (!res.ok) {
        message = "Login failed";
        logged = false;
        return;
    }
    const token = await res.json();
    localStorage.setItem("access_token", token.access_token);
    window.location.href = `/home/${username}`;    
  }
</script>

<style>
    .container {
        display: grid;
        height: 100vh;
        grid-template-columns: 1fr 1fr;
        grid-template-rows: 0.6fr 10fr;
        grid-template-areas:
        'nav login-img-section'
        'main login-img-section';
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

    .login-img-section{
      grid-area: login-img-section;
      height: 100vh;
    }

    .login-img-section img{
      width: 100%;
      height: 100vh;
      //position: absolute;
      //max-height: 100%;
    }
    .logo-box{
        grid-area: logo-box;
        //background-color: yellow;
        display: flex;
        justify-content: flex-end;
    }
    .logo-box img {
      margin-left: 9vh;
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
      
    }
    
    .menu-box a:hover{
      border-top: 0.1rem solid rgb(18, 105, 192);
    }
    main {
        grid-area: main;
        background-color: #f6f7fb;
        display: grid;
        height: 100%; 
        //vertical-align: baseline;
        //justify-content: center;
        vertical-align: baseline;
        grid-template-columns: 1fr 3fr;
        grid-template-rows: 1fr;
        //row-gap: 20px;
        grid-template-areas:
        ' login-col1 login-col2'
        ;
    }
    main p {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      min-height: 1.5rem;
      font-weight: 400;
      font-size: 1.3rem;
      line-height: 1.4;
    }
    
    #login-col2 h3{
      font-family:'Montserrat', sans-serif;
      font-weight: 650;
      font-size: 2rem;
    }
    #login-spacer {
      height: 20%;
    }

    #login-intro {
      font-family:'Montserrat', sans-serif;
      text-align: left;
      font-weight: 500;
      font-size: 1.6rem;
    }
    #login-form-section{
        grid-area: login-form-section;
        height: 70%;
    }

    form {
      display: grid;
      gap: 1em;
      width: 50%;
      height:30%;
    }

    form input {
      border: 0.1em solid black;
      border-radius: 0.4em;
      display: flex;
      font-size: 1.5rem;
    }

    form input::placeholder {
      //letter-spacing: 0.1em;
      color: #111111a1;
      //text-indent: 0.6em;
      font-family: font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    }

    svg{
      position: absolute;
      right: 100px;
      top: 50%;
      //transform: translateY(-50%);
      //pointer-events: none; /* let user click through to input */
      color: green;
    }


    form button {
      border: 0.1em solid transparent;
      border-radius: 0.4em;
      background-color: rgb(0, 80, 160);
      color: white;
      font-size: 1.4em;
      
      
    }

    form button:hover{
      color:  rgb(0, 80, 160);
      background-color:white;
      
    }

    #login-img-section{
        grid-area: login-img-section;
        height: 100vh;
    }
    @media (max-width: 500px) {
  .container{
    display: block;
    background-color: #f6f7fb;
  }
  nav {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-areas: 'logo-box menu-box';
    
  }

  .logo-box {
    grid-area: logo-box;
    display: block;
    max-height: min-content;
    
  }
  .logo-box img{
    display:flex;
    align-items: left;
    margin-left: 0;
  }
  .login-img-section{
    display:none;
  }
  main {
    display: ruby-text;
  }
  #feature-grid-inner {
    display: block;
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
  </nav>
  <section class="login-img-section">
    <img src="pawel-czerwinski-unsplash.jpg">
  </section>
  <main>
    <div id="login-col1"></div>
    <div id="login-col2">
    <div id="login-spacer"></div>
    <div id="login-form-section">
        <p id="login-intro">Welcome Back!</p>
        <h3 class="login-title">Signin to Studyquiz</h3>
        <p>For guest user, enter Guest with no password</p>
        <form on:submit|preventDefault={handleLogin}>
        <i class="fa fa-envelope icon"></i>
        <input name="username" type="input" placeholder="username">
		    <input name="password" type="password" placeholder="password">
	    <button>Log in</button>
        </form>
        <p>Don't have an account? <a href="/signup">Sign up</a></p>
    </div>
    </div>  
</main>
  
</section>
