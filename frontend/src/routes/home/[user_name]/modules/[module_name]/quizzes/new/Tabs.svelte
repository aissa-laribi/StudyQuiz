<script>
  export let items = [];
  export let activeTabValue = 1;

  const handleClick = tabValue => () => (activeTabValue = tabValue);
</script>

<ul>
{#each items as item}
	<li class={activeTabValue === item.value ? 'active' : ''}>
		<span on:click={handleClick(item.value)}>{item.label}</span>
	</li>
{/each}
</ul>
{#each items as item}
	{#if activeTabValue == item.value}
	<div class="box">
		<svelte:component this={item.component}/>
	</div>
	{/if}
{/each}
<style>
	.box {
		border: 1px solid #000000;
    border-radius: 0 0 .5rem .5rem;
    border-top: 0;
    background-color: white;
    height: 60vh
	}
  ul {
    display: flex;
    flex-wrap: wrap;
    padding-left: 0;
    margin-bottom: 0;
    list-style: none;
    border-bottom: 1px solid #dee2e6;
  }
	li {
		margin-bottom: -1px;
	}

  span {
    border: 1px solid #5d5e5f;
    border-top-left-radius: 0.25rem;
    border-top-right-radius: 0.25rem;
    display: block;
    padding: 0.5rem 1rem;
    cursor: pointer;
  }

  span:hover {
    background-color: #000000;
    color: white;
  }

  li.active > span {
    background-color: #fff;
    border-color: #5d5e5f #5d5e5f #fff;
  }
</style>