<script lang="ts">
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { getUserManager } from '$lib/auth/user-manager';
  import { signIn } from '$lib/auth/auth';

  onMount(async () => {
    const userManager = getUserManager();

    try {
      await userManager.signinRedirectCallback();
      await goto('/');
    } catch {
      await userManager.removeUser();

      signIn();
    }
  });
</script>
