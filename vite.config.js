import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";
import dsv from "@rollup/plugin-dsv";
import glsl from 'vite-plugin-glsl';
export default defineConfig({
  plugins: [sveltekit(), dsv(), glsl()],
  ssr: {
    noExternal: ["three"],
  },
});
