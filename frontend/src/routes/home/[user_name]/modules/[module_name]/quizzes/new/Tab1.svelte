<script>
    import { goto } from "$app/navigation";
    import { onMount } from "svelte";
    import { page } from '$app/stores';
    import { get } from 'svelte/store';
    

    const { module_name} = get(page).params;
    let files = $state();
    let quiz = $state([]);
    let quiz_name = $state("");
    let user_name = $state("");
    let rateLimitMessage = $state("");

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
        console.log("Failed to retrieve username");
      }
  }
    async function getRateLimitMessage() {
      return rateLimitMessage;
    }

    async function sendSlides() {
      try {
        const token = localStorage.getItem("access_token");
        if (files) {
          const file = files[0];
        if (!token) return;
        const formData = new FormData();
        formData.append('file', file);
        
        const res = await fetch(`${apiURL}/ai`, {
            method: "POST",
            headers: {
            "Authorization": `Bearer ${token}`,

          }, body : formData,
          });

          if(res.ok){
            const data = await res.json();
            data['quiz']['questions'].forEach(element => {
              quiz.push(element)
            }); 
            /*console.log(JSON.stringify(data['quiz']));
            console.log("user_name: " + `${user_name}`)
            console.log("Module:" + `${module_name}`);
            console.log("Quiz:" + `${quiz_name}`);*/
            
            quiz_name = files[0].name.slice(0,files[0].name.length -3);
            console.log(quiz_name);
            const quizNameReq = await fetch(`${apiURL}/users/me/modules/${module_name}/quizzes/`,{
              method: "POST",
              headers : {
              "Authorization": `Bearer ${token}`,
              "Content-Type": "application/json"
            },
            body: JSON.stringify({ name: quiz_name })

            });

            if(!quizNameReq.ok) return;
            
            const quizRequest = await fetch(`${apiURL}/users/me/modules/${module_name}/quizzes/${quiz_name}/questions/batch-create`,{
            method: "POST",
            headers : {
              "Authorization": `Bearer ${token}`,
              "Content-Type": "application/json"
            },
            body: JSON.stringify(data['quiz']),
          });
            if(quizRequest.ok){
              console.log("Quiz created");
              goto(`/home/${user_name}/modules/${module_name}/quizzes/${quiz_name}/attempt`);
            } else {

            }
            console.log(data);
          } else if(res.status == 419){
            rateLimitMessage = "You have used the free daily limit.";
          }
        }} catch (err) {
          console.error("Invalid File", err);
        }
      }
  const apiURL = import.meta.env.VITE_API_URL;
  onMount(() => {
      getUsername();
      getRateLimitMessage();
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
    background-color: #3172ec25;
    text-align: center;
    border-radius: 1rem;
    
  }
  #col2-box {
    
    border-radius: 1rem;
    height: 40vh;
    border: 5px dashed #3174ec;
  }
  #col2-box form{
    margin: 10vh;
  }
  .hidden {
    display: none;
  }
  label{
    cursor: pointer;
  }
  .generate-quiz-btn{
    padding: 2rem;
    margin-bottom: 1rem;
    background-color: #3174ec;
    color: white;
  }
  svg:hover{
    cursor: pointer;
    border-radius: 2rem;
    background-color: #3172ec02;
    padding: 0.1rem;
  }
  .generate-quiz-btn{
    padding: 2rem;
    margin-bottom: 1rem;
    background-color: #3174ec;
    color: white;
    width: auto;
    font-size: 18pt;
    cursor: pointer;
    border-radius: 1rem;
    border: 1px solid #bbb;
  }
  .generate-quiz-btn:hover{
    padding: 2rem;
    margin-bottom: 1rem;
    background-color: black;
    color: white;
    width: auto;
    font-size: 18pt;
    cursor: pointer;
  }
  .file-info{
    font-family: 'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', Geneva, Verdana, sans-serif;
    font-weight: bold;
  }
</style>
<div id="edit-questions">
        <div id="spacer"><h1>AI Generated Quiz</h1></div>
        <div id="col1"></div>
        <div id="col2">
        <div id="col2-box">
          <form>
          <label>
            {#if !files}
            <input bind:files class="hidden" type="file" name="file" accept=".pdf"/>
                      <svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 512 512" fill="none" class="icon upload-ai-icon">
                        <path fill="#00ACEA" d="M315 465H37c-3 0-5-3-5-5V104c0-3 2-5 5-5h86V5c0-3 2-5 5-5h263c3 0 5 2 5 5v333c0 3-2 5-5 5-44 0-80 36-80 80 0 12 3 24 8 34 1 2 1 4 0 5-1 2-2 3-4 3z"/>

                        <path fill="#009BD3" d="M315 465h-10c-6-13-10-27-10-42 0-53 43-96 96-96h5v11c0 3-2 5-5 5-44 0-80 36-80 80 0 12 3 24 8 34 1 2 1 4 0 5-1 2-2 3-4 3z"/>

                        <path fill="#009BD3" d="M32 114v-10c0-3 2-5 5-5h86V5c0-3 2-5 5-5h9c1 2 2 3 2 5v99c0 6-5 11-11 11H37c-2 0-4-1-5-1z"/>

                        <path fill="#008CBE" d="M128 109H37c-2 0-4-1-5-3 0-2 0-4 1-6L124 2c1-2 3-2 5-2 2 1 4 3 4 5v99c0 3-3 5-5 5z"/>
                        
                        <path fill="#FFFFFF" d="M348 178H80c-3 0-5-3-5-5 0-3 2-5 5-5h268c2 0 5 2 5 5 0 2-3 5-5 5z"/>

                        <path fill="#FFFFFF" d="M348 222H80c-3 0-5-2-5-5 0-2 2-5 5-5h268c2 0 5 3 5 5 0 3-3 5-5 5z"/>

                        <path
                          fill="#FFFFFF"
                          d="M348 267H80c-3 0-5-2-5-5 0-3 2-5 5-5h268c2 0 5 2 5 5 0 3-3 5-5 5z"
                        />

                        <path
                            fill="#FFFFFF"
                            d="M348 312H80c-3 0-5-2-5-5 0-3 2-5 5-5h268c2 0 5 2 5 5 0 3-3 5-5 5z"
                        />

                        <path
                          fill="#D8ECF0"
                          d="M391 512c-49 0-90-40-90-89 0-50 41-90 90-90s89 40 89 90c0 49-40 89-89 89z"
                        />

                        <path
                          fill="#000000"
                        d="M391 372c2 0 4 1 5 2l42 42c2 2 2 5 0 7s-5 2-7 0l-35-35v76c0 3-2 5-5 5s-5-2-5-5v-76l-35 35c-2 2-5 2-7 0s-2-5 0-7l42-42c1-1 3-2 5-2z"
                        />
                      </svg>
            
            <p>Click to upload learning materials</p>
            <small>
              Accepted files: PDF Maximum size: 2 MB.
            </small>
            {/if}
          </label>
          {#if files}
            <p class="file-info">File Uploaded: {files[0].name}</p>
            <button type="submit" class="generate-quiz-btn" onclick={sendSlides}>Generate Quiz</button>
            {/if}    
          </form>
          {#if rateLimitMessage.length > 0}
            <p>{rateLimitMessage}</p>
          {/if}
          </div>
        </div>
        <div id="col3"></div>
        <div id="spacer2"></div>
  </div>