import * as THREE from "three";
import fragmentShader from "./shaders/fragment.glsl";
import vertexShader from "./shaders/vertex.glsl";

export function start(canvas: HTMLCanvasElement) {
  const width = window.innerWidth,
    height = window.innerHeight;

  // init

  const camera = new THREE.PerspectiveCamera(45, width / height, 1, 3000);
  camera.position.z = 100;

  const scene = new THREE.Scene();

  // #region addMesh

  const material = new THREE.ShaderMaterial({
    fragmentShader,
    vertexShader,
    uniforms: {
      progress: { value: 0 },
    },
    side: THREE.DoubleSide,
  });

  const geometry = new THREE.BufferGeometry();
  // create a simple square shape. We duplicate the top left and bottom right
  // vertices because each vertex needs to appear once per triangle.
  // prettier-ignore
  const vertices = new Float32Array( [
    -1.0, -1.0,  1.0, // v0
     1.0, -1.0,  1.0, // v1
     1.0,  1.0,  1.0, // v2
  
     1.0,  1.0,  1.0, // v3
    -1.0,  1.0,  1.0, // v4
    -1.0, -1.0,  1.0  // v5
  ] );

  let number = 512 ** 2;
  const positions = new Float32Array(number * 3);

  let index = 0;
  for (let i = 0; i < 512; i++) {
    for (let j = 0; j < 512; j++) {
      positions.set([i, j, 0], index);
      index++;
    }
  }

  // itemSize = 3 because there are 3 values (components) per vertex
  geometry.setAttribute("position", new THREE.BufferAttribute(positions, 3));

  // let material = new THREE.MeshNormalMaterial();

  const mesh = new THREE.Mesh(geometry, material);
  scene.add(mesh);
  // #endregion

  const renderer = new THREE.WebGLRenderer({ antialias: true, canvas });
  renderer.setSize(width, height);
  renderer.setAnimationLoop(animation);

  // animation

  function animation(time) {
    mesh.rotation.x += 0.01;
    mesh.rotation.y += 0.02;

    renderer.render(scene, camera);
  }
}
