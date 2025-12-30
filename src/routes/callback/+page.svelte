<script lang="ts">
  import { onMount } from 'svelte';
  import { getUserManager } from '$lib/auth/user-manager';

  let err = '';

  onMount(async () => {
    try {
      await getUserManager().signinRedirectCallback();
      window.location.href = '/';
    } catch (e) {
      err = e instanceof Error ? e.message : String(e);
      console.error(e);
    }
  });
</script>

{#if err}
  <pre>{err}</pre>
{:else}
  Signing in...
{/if}
