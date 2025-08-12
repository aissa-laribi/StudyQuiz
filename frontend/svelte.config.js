import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: vitePreprocess(),
  kit: {
    // Generates a /build directory for static hosting
    adapter: adapter({
      // Let SvelteKit serve index.html for any unknown route (client-side routing)
      fallback: 'index.html'
    })
    // (no other changes needed)
  }
};

export default config;
