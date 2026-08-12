<script>
    import { goto } from "$app/navigation";
    import { onMount } from "svelte";
    import { page } from '$app/stores';
    import { get } from 'svelte/store';
    import { tick } from "svelte";

    const apiURL = import.meta.env.VITE_API_URL;
    const { module_name} = get(page).params;
    let quiz_name = $state("");
    let user_name = $state("");
    let user_id;
    let module_id;

    async function getUser(){
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
        user_id = data['id'];
        console.log(user_id);
      } else {
        console.log("Failed to retrieve username");
      }
    }

    async function addNewQuiz() {
      const token = await localStorage.getItem("access_token");
      if(!token) return;

      const currentName = await localStorage.getItem(`moduleName`);
      if(!currentName) return;
      
      const idQuery = await fetch(`${apiURL}/users/me/modules/${encodeURIComponent(currentName)}`,{
        method: `GET`,
        headers : {
        "Authorization": `Bearer ${token}`
      }});
      if(!idQuery.ok) return;

      const data = await idQuery.json();
      module_id = data.id;

      const quizQuery = await fetch(`${apiURL}/users/${user_id}/modules/${module_id}/quizzes/`,
        {
          method: 'POST',
          headers: {
            "Authorization": `Bearer ${token}`,
            "Content-Type": "application/json"
          },
          body : JSON.stringify({ name: quiz_name.trim()})
        });

        if(quizQuery.ok){
          goto(`/home/me/modules/${encodeURIComponent(module_name)}/quizzes/edit/${quiz_name}`);
        }
    }

  onMount(() => {
      getUser();
    });
</script>
<style>
  #edit-questions{
    height: 100%;
    display: grid;
    grid-template-areas: "spacer spacer spacer"
                         "col1 col2 col3"
                         "spacer2 spacer2 spacer2";
    grid-template-rows: 1fr 1fr 1fr;
    grid-template-columns: 1fr 3fr 1fr;
  }
  #spacer {
    grid-area: spacer;
    text-align: center;
    font-size: 20pt;
  }
  #col2{
    grid-area: col2;
    background-color: #3172ec08;
    text-align: center;
    border-radius: 1rem;
    
  }
  #col2-box {
    border-radius: 1rem;
    height: 40vh;
    border: 1px solid #3174ec;
  }
  #col2-box {
    margin: auto;
    display:flex;
  }
  form {
    margin: auto;
    gap: 2rem;
    width: 90%;
  }
  label {
    font-size: 2rem;
    font-weight: 600;
    margin: 1rem;
  }

  input {
    width: 100%;
    height: 4rem;
    font-size: 18pt;
    border-radius: 0.3rem;
    border: 1px solid;
    margin: 1rem;
  }

  button {
    background-color: #3174ec;
    color: white;
    width: fit-content;
    padding: 1rem;
    font-size: 18pt;
    cursor: pointer;
    font-family: 'Inter';
    border-radius: 0.5rem;
    border: none;
  }

  button:hover {
    background-color: black;
  }

</style>
<div id="edit-questions">
        <div id="spacer"><h1>Manual Quiz Builder</h1></div>
        <div id="col1"></div>
        <div id="col2">
        <div id="col2-box">
        
          <form onsubmit={addNewQuiz}>
            <label for="new-quiz-input type">
              Enter the name of the quiz
            </label>
            <br>
            <input id="new-quiz-input" type="text" placeholder="Quiz Name" bind:value={quiz_name} required >
            <button type="submit">Continue</button>
          </form>
          </div>
        </div>
        <div id="col3"></div>
        <div id="spacer2"></div>
  </div>