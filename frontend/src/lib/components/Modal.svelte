<script>
  let { showModal = $bindable(), header, children, variant = "default" } = $props();

  let dialog = $state();

  $effect(() => {
    if (showModal && dialog && !dialog.open) dialog.showModal();
  });
</script>

<!-- svelte-ignore a11y_click_events_have_key_events, a11y_no_noninteractive_element_interactions -->
<dialog
  bind:this={dialog}
  onclose={() => (showModal = false)}
  onclick={(event) => { if (event.target === dialog) dialog.close(); }}
>
  <div
    class:compact={variant === "compact"}
    class:positioned={variant === "positioned"}
    class="modal-box"
  >
    {@render header?.()}
    {@render children?.()}
  </div>
</dialog>

<style>
  dialog {
    border: none;
    padding: 0;
    background: transparent;
  }

  .modal-box {
    padding: 2vh;
    border-radius: 1rem;
    border: 1px solid black;
    background-color: white;
  }

  .modal-box.compact {
    padding: 1vh;
    border-radius: 1em;
    top: 7rem;
    left: 21rem;
    display: flex;
    position: fixed;
    height: 15vh;
  }

  .modal-box.positioned {
    padding: 1vh;
    border-radius: 1em;
    top: 7rem;
    left: 21rem;
    position: fixed;
    height: auto;
  }

  @media (max-width: 500px) {
    .modal-box.compact {
      top: 20vh;
      left: 5vh;
      margin: auto;
    }

    .modal-box.positioned {
      top: 20vh;
      left: 5vh;
      margin: auto;
    }
  }
</style>
