<script>
    import { goto } from "$app/navigation";
    import { onMount } from "svelte";
    import { page } from '$app/stores';
    import { get } from 'svelte/store';
    

    const { module_name, quiz_name } = get(page).params;
    let files = $state();
    let quiz = $state([])
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
<div id="col-quizzes">
        <div id="followups-container">
        <div id="upcoming-quizzes">
        <h2>Upload Your Slides</h2>
        <form>
          <input bind:files id="file-uploaded" type="file" name="file" accept=".pdf"/> 
          <button type="submit" class="generate-quiz-btn" onclick={sendSlides}>Generate Quiz</button>
          <br>
          <small>
            Accepted files: PDF Maximum size: 2 MB.
          </small>
        </form>
        {#if rateLimitMessage.length > 0}
          <p>{rateLimitMessage}</p>
        {/if}
      </div>
    </div>
  </div>