<script>
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { form } from '$app/server';
  let animationContainer;
  let validToken=false;
  let user_email=null;
  let username=null;
  let organization = null;
  let city = null;
  let over16=false;
  let message="";

  
  
  
  

  const apiURL = import.meta.env.VITE_API_URL;
  async function handleConfirmation(event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    username = formData.get('Username');
    organization = formData.get('organization');
    city = formData.get('city');
    over16 = formData.get('over16');

    console.log(username);
    console.log(city);
    console.log(user_email)
    console.log(organization);
    console.log(over16);
    const payload = {
    user_name: username,
    email: user_email,
    token: window.location.href.slice(42),
    organization: organization,
    city: city,
    };
    const query = new URLSearchParams({
  user_name: username,
  email: user_email,
  token: window.location.href.slice(42),
  organization: organization || "",
  city: city || ""
});
    const req = await fetch(`${apiURL}/users/verification-email?${query.toString()}`, {
      method: "POST",
      headers: {
        accept: "application/json"
      }
    }); 
    if(req.ok) {
      message = "Email successfully confirmed";
      goto(`/login`);
    } else {
      message = "Unsuccessful";
    }
  }


  async function validTokenCheck() {
    const params = new URLSearchParams(window.location.search);
    const token = params.get("token");

    if (!token) {
      validToken = false;
      message = "Missing confirmation token.";
      return;
    }
    try{
      const req = await fetch(`${apiURL}/users/verification-email?token=${encodeURIComponent(token)}`, {
      method: "GET",
      headers: {
        accept: "application/json"
      }
      });
      if (req.ok){
        const result = await req.json();
        validToken = true;
        user_email = result.email;
      } else {
        console.log("Not")
        validToken = false;
      }
    } catch(error){
      console.error(error);
      validToken = false;
      message = "Could not check the confirmation link.";
      } finally {
        validToken = false;  
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
    #invalid-link-box{
      display: block;
      background-color: antiquewhite;
      text-align: center;
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
    {#if validToken}
    <div id="spacer"><h1>Confirm Your Account</h1></div>
    <div id="form-box">
        <form on:submit|preventDefault={handleConfirmation}>
            <input type="text" name="Username" placeholder="Choose a username" required>
            <input type="email" bind:value={user_email} readonly>
            <input name="organization" placeholder="School,college or organization">
            <input name="city" placeholder="City">
            <div id="over16-box">
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <input type="checkbox" id="over16" name="over16" required>
                            </td>
                            <td>
                                <label for="over16"> I confirm I am at least 16 years old</label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <button>Confirm</button>
            <p>{message}</p>
        </form>

    </div>
  {:else} 
  <div id="spacer"><h1>Invalid confirmation link</h1></div>
  <div id="invalid-link-box">
    <p>This confirmation link is invalid or has expired.</p>
    <p>Please log in and request a new confirmation email.</p>
  </div>
  {/if} 
  </main>
  <div id="sidebar2"></div>
</section>
