attribute vec3 atDepth;

attribute float size;
attribute float time;
varying vec3 vColor;
uniform float progress;
uniform float speed;
uniform float shakeStrength;
float timeWindow = 0.1;

  // Simplex 2D noise
  //
vec3 permute(vec3 x) {
  return mod(((x * 34.0) + 1.0) * x, 289.0);
}

float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
  vec2 i = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0));
  vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
  m = m * m;
  m = m * m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float random(float seed) {
  return fract(sin(seed) * 100000.0);
}

float nearTime(float eventTime, float progress) {
  float distance = abs(eventTime - (progress - floor(progress)));
  if(distance <= timeWindow) {
    return cos((1.0 - (distance / timeWindow)) * 3.1415);
  }
  return 0.0;
}

void main() {
  vColor = color;
  float nearTime = nearTime(time, progress);
  gl_PointSize = max(size, size * nearTime);
  float noise = snoise(vec2(size, progress));

  float xShake = snoise(vec2(progress * 0.1 / speed, atDepth.x));
  float yShake = snoise(vec2(progress * 0.1 / speed, atDepth.y));
  float zShake = snoise(vec2(progress * 0.1 / speed, atDepth.z));
  vec3 shake = vec3(xShake, yShake, zShake);
  vec3 newPosition = atDepth + shake * shakeStrength * nearTime;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);
}
