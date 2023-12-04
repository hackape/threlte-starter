<script>
import { onMount } from "svelte";
import { start } from "./sketch";
/** @type {HTMLCanvasElement} */
let canvas;
onMount(() => {
  start(canvas);
});
</script>

<canvas class="w-full h-full" bind:this={canvas} />
