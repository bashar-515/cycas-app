<script lang="ts">
  import { signOut } from '$lib/auth/auth';
  import '$lib/script';
</script>

<div>
  Hello, World!
</div>

<button on:click={signOut}>
  sign out
</button>
