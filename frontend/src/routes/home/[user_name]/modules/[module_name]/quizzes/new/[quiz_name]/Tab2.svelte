    
<script>
    import Modal from './Modal.svelte';
    let showModal = false;
    let questions = [];
    let newQuestionName = "";

    function registerQuestion(){

    }
    
</script>    
<div id="col-modules">
    <div id="my-modules">
      <h2>Questions
        <button id="new-module-button" onclick={() => (showModal = true)}>
        <svg  xmlns="http://www.w3.org/2000/svg"  width="32"  height="32"  viewBox="0 0 20 20"  fill="none"  stroke="currentColor"  stroke-width="1"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-plus"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 5l0 14" /><path d="M5 12l14 0" /></svg>
        <span class="tooltiptext">Add a New Question</span>
        </button>
      </h2>
    {#if questions.length == 0}
        <p>No questions added yet.</p>
        <p>Add questions manually using the + button, or import a full quiz with AI on the right.</p>
    {/if}
    </div>
     <div id="modules-container">
        {#each questions as question}
        <div class="module-box">
            <p>{question.question_name}</p>
        </div>
        {/each}
    </div>
    {#if showModal}
      <Modal bind:showModal>
        <form onsubmit={registerQuestion}>
        <nav id="form-navbar">
          <h2>Add a New Question</h2>
          <button onclick={() => (showModal = false)}>
            <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-x"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M18 6l-12 12" /><path d="M6 6l12 12" /></svg>
          </button>
        </nav>
        <div id="form-fields">
          <input id="question-name" bind:value={newQuestionName} type="text" placeholder="Question Name">
        </div>
        <div id="form-button-section">
          <button type="submit">
            <p>Continue</p>
          </button>
        </div>
        </form>
      </Modal>
    {/if}
</div>