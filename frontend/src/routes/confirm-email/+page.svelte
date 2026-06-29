<script>
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  let animationContainer;
  let validToken=false;
  let email=null;
  

  const apiURL = import.meta.env.VITE_API_URL;

  async function validTokenCheck() {
    const req = await fetch(`${apiURL}/users/verification-email?token=${window.location.href.slice(42)}`,{
      headers: {
        method: "GET",
        accept: "application/json"
      }
    }
    );
    if (req.ok){
      const result = await req.json();
      validToken = true;
      email = result.email;
    } else {
      console.log("Not")
    }
  }

  onMount(() => {
    validTokenCheck()
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
      margin-left: 9vh;
    }

    main {
        grid-area: main;
        display: block;
        //vertical-align: baseline;
        //justify-content: center;
        vertical-align: baseline;
    }
    main p {
      font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      min-height: 1.5rem;
      font-weight: 400;
      font-size: 1.3rem;
      line-height: 1.4;
    }


    #spacer{
        display: block;
        text-align: center;
        font-size: 20pt;
    }

    form {
      display: grid;
      gap: 1em;
      width: 50%;
      height:50vh;
      margin: auto auto;
      padding: 2rem;
      border: 2px black solid;
      border-radius: 2rem;
    }

    form input {
      border: 0.1em solid black;
      border-radius: 0.4em;
      min-height: 5vh;
      font-size: 1.5rem;
    }

    #over16-box{
        display: inline-flex;
        min-height: 5vh;
    }

    #over16-box label{
        font-size: 20pt;
    }

    form input::placeholder {
      //letter-spacing: 0.1em;
      color: #111111a1;
      //text-indent: 0.6em;
      font-family: font-family: 'Inter', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
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
      max-width:30vh;
      margin-left: 1vh;
  }
  .login-img-section{
    display:none;
  }
  main {
    display: flex;
  }
  #login-col1 {
    display: none;
    
  }
  #login-spacer {
    display: none;
  }
  #login-form-section {
    padding: 1rem;
    //align-items: center;
  }

  form input,
  form button {
    font-size: 1.2rem;
  }
  
  #sidebar1{
    display: none;
  }
  #sidebar2{
    display: none;
  }

}



</style>

<section class="container">
  <nav>
  <div class="logo-box"><a href="/"><img src="/logo.png"></a></div>
  </nav>
  <div id="sidebar1"></div>
  <main>
    <div id="spacer"><h1>Confirm Your Account</h1></div> 
    <div id="form-box">
        <form>
            <input type="text" name="Username" placeholder="Choose a username" required>
            <input type="email" bind:value={email} readonly>
            <input name="organization" placeholder="School,college or organization">
            <input name="city" placeholder="City">
            <div id="over16-box">
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <input type="checkbox" id="over16" name="over16">
                            </td>
                            <td>
                                <label for="over16"> I confirm I am at least 16 years old</label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <button>Confirm</button>
        </form>
    </div>
  </main>
  <div id="sidebar2"></div>
</section>
