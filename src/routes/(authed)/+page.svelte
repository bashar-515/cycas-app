<script lang="ts">
	import { onMount } from 'svelte';
	import { signOut } from '$lib/auth/auth';
	import { getApi } from '$lib/api/api';

	onMount(async () => {
		const api = getApi();
		const res = await api.ping();

        console.log(res);
	});
</script>

<div>Hello, World!</div>

<button on:click={signOut}> sign out </button>
