<script lang="ts">
  import '$lib/script';
  import { signOut } from '$lib/auth/auth';
</script>

<div>
  Hello, World!
</div>

<button on:click={signOut}>
  sign out
</button>
