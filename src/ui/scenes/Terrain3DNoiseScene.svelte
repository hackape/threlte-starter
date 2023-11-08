<script lang="ts">
// https://threlte.xyz/docs/examples/geometry/terrain-with-3d-noise
import { PlaneGeometry } from "three";
import { DEG2RAD } from "three/src/math/MathUtils";
import { createNoise2D } from "simplex-noise";
import { T } from "@threlte/core";
import { OrbitControls } from "@threlte/extras";
import { AutoColliders, Debug } from "@threlte/rapier";
import { World } from "@threlte/rapier";
import { Pane } from "tweakpane";

import { writable } from "svelte/store";
import { onMount } from "svelte";

const showCollider = writable(false);
const autoRotate = writable(true);

const geometry = new PlaneGeometry(10, 10, 100, 100);
const noise = createNoise2D();
const vertices = geometry.getAttribute("position").array;
for (let i = 0; i < vertices.length; i += 3) {
  const x = vertices[i];
  const y = vertices[i + 1];
  // @ts-ignore
  vertices[i + 2] = noise(x / 4, y / 4);
}
// needed for lighting
geometry.computeVertexNormals();

onMount(() => {
  const pane = new Pane();
  pane
    .addButton({
      title: "toggle",
      label: "Show Collider",
    })
    .on("click", () => {
      showCollider.update((v) => !v);
    });

  pane
    .addButton({
      title: "toggle",
      label: "AutoRotate",
    })
    .on("click", () => {
      autoRotate.update((v) => !v);
    });

  return () => {
    pane.dispose();
  };
});
</script>

<World>
  <Debug visible={$showCollider} />
  <T.PerspectiveCamera makeDefault position.y={5} position.z={10} lookAt.y={2}>
    <OrbitControls autoRotate={$autoRotate} enableZoom={false} maxPolarAngle={DEG2RAD * 80} />
  </T.PerspectiveCamera>
  <T.DirectionalLight position={[3, 10, 10]} />
  <T.HemisphereLight intensity={0.2} />
  <AutoColliders shape="trimesh">
    <T.Mesh {geometry} rotation.x={DEG2RAD * -90}>
      <T.MeshStandardMaterial />
    </T.Mesh>
  </AutoColliders>
</World>
