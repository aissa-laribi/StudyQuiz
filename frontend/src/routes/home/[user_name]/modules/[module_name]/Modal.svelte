<script>
	let { showModal = $bindable(), header, children } = $props();

	let dialog = $state(); // HTMLDialogElement

	$effect(() => {
		if (showModal) dialog.showModal();
	});
</script>

<!-- svelte-ignore a11y_click_events_have_key_events, a11y_no_noninteractive_element_interactions -->
<dialog
	bind:this={dialog}
	onclose={() => (showModal = false)}
	onclick={(e) => { if (e.target === dialog) dialog.close(); }}
>
	<div class="modal-box">
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

  dialog::backdrop {
    //background: rgba(223, 18, 18, 0.4);
  }

  .modal-box {
    padding: 2vh;
    border-radius:1rem;
    border: 1px black solid;
    background-color: white;
  }


  
</style>
