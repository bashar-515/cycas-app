<script lang="ts">
	import { onMount } from 'svelte';
	import { isSignedIn, signIn } from '$lib/auth/auth';

	let ready = false;

	onMount(async () => {
		if (!(await isSignedIn())) {
			await signIn();

			return;
		}

		ready = true;
	});
</script>

{#if ready}
	<slot />
{/if}
