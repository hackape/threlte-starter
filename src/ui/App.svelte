<script lang="ts">
import { Pane } from "tweakpane";
import { Canvas } from "@threlte/core";

const exmaples = import.meta.glob("./scenes/*.svelte");

let Scene: any;
let ref: HTMLDivElement;
$: {
  if (ref) {
    const pane = new Pane({ title: "Examples", container: ref });
    const buttons = Object.keys(exmaples)
      .map((path) => {
        const name = path.split("/").pop()!.split(".")[0];
        if (name.startsWith("_")) return null;
        const button = pane.addButton({ title: name }).on("click", () => {
          exmaples[path]().then((m) => {
            Scene = m.default;
          });
        });
        return button;
      })
      .filter((x) => x);

    // default to first example
    const btn1 = buttons[0]!;
    btn1.controller.buttonController.emitter.emit("click", {
      sender: btn1.controller.buttonController,
    });
  }
}
</script>

<div class="App absolute inset-0">
  <div class="Menu absolute left-0 w-80" bind:this={ref} />
  {#if Scene}
    <Canvas>
      <svelte:component this={Scene} />
    </Canvas>
  {/if}
</div>
