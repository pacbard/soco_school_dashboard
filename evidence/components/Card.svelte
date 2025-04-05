<script context="module">
	export const evidenceInclude = true;
</script>

<script>
	export let title = 'Details';
	export let size = 'w-full';
	export let padding = 'p-1';
	export let style = 'bg-white border border-gray-200 rounded-lg shadow-sm';
</script>

<div class="{size} {padding} {style}" >
	<div class="px-6 py-4">
		<div class="font-bold text-xl mb-2">{title}</div>
		<slot />
	</div>
</div>
