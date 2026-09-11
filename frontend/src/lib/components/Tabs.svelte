<script>
  let { items = [], activeTabValue = $bindable(1), variant = "default" } = $props();

  /** @param {number} tabValue */
  const handleClick = (tabValue) => () => {
    activeTabValue = tabValue;
  };
</script>

<ul class:compact={variant === "compact"}>
  {#each items as item}
    <li class:active={activeTabValue === item.value}>
      <button type="button" onclick={handleClick(item.value)}>{item.label}</button>
    </li>
  {/each}
</ul>

{#each items as item}
  {#if activeTabValue === item.value}
    {@const Component = item.component}
    <div class:compact={variant === "compact"} class="box">
      <Component />
    </div>
  {/if}
{/each}

<style>
  .box {
    border: 1px solid #dee2e6;
    border-radius: 0 0 0.5rem 0.5rem;
    border-top: 0;
    background-color: white;
    margin-bottom: 10px;
    padding: 40px;
  }

  .box.compact {
    border-color: #000000;
    height: 60vh;
    padding: 0;
  }

  ul.compact button {
    border-color: #5d5e5f;
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

  button {
    border: 1px solid transparent;
    border-top-left-radius: 0.25rem;
    border-top-right-radius: 0.25rem;
    display: block;
    padding: 0.5rem 1rem;
    cursor: pointer;
    background: transparent;
    font: inherit;
  }

  button:hover {
    border-color: #e9ecef #e9ecef #dee2e6;
  }

  li.active > button {
    color: #495057;
    background-color: #fff;
    border-color: #dee2e6 #dee2e6 #fff;
  }

  li.active > button {
    background-color: #fff;
  }

  @media (max-width: 500px) {
    .box.compact {
      min-height: 100vh;
      height: auto;
    }
  }
</style>
