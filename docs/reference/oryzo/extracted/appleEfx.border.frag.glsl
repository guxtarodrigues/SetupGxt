// ============================================================================
// AppleEfx — fragment shader da MOLDURA de glow (oryzo.ai)
// Extraído verbatim de raw/hoisted.js (template string -> "fragmentShader$3").
// Pass de pos-processamento fullscreen: recebe a cena em u_texture e soma o
// glow arco-iris nas bordas (SDF) com paleta rotacionada + onda (pulse).
// ============================================================================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform float u_padding;
uniform vec2 u_resolution;
uniform vec2 u_coverAspect;
uniform float u_time;
uniform float u_amount;
uniform float u_pulse;
uniform vec2 u_pulseCenter;
uniform sampler2D u_lmsTexture;
varying vec2 v_uv;
#include <getBlueNoise>
float sdBox(in vec2 p,in vec2 b) {
  vec2 d=abs(p)-b;
  return length(max(d,0.0))+min(max(d.x,d.y),0.0);
}
float sdCircle(vec2 p,float r) {
  return length(p)-r;
}
float opSmoothUnion(float a,float b,float k) {
  k*=4.0;
  float h=max(k-abs(a-b),0.0);
  return min(a,b)-h*h*0.25/k;
}
const float PI=3.14159265359;
#include <linearstep>
void main() {
  vec3 bnoise=getBlueNoise(gl_FragCoord.xy);
  vec2 aspect=vec2(u_resolution.x/u_resolution.y,1.);
  vec2 glowUv=(v_uv-0.5)*u_coverAspect*2.;
  float angle=u_time*-5.;
  mat2 rot=mat2(cos(angle),-sin(angle),sin(angle),cos(angle));
  glowUv=rot*glowUv;
  glowUv=glowUv*.5+.5;
  glowUv=clamp(glowUv,vec2(0.),vec2(1.));
  vec3 c0=texture2D(u_lmsTexture,vec2(0.,.5)).rgb;
  vec3 c1=texture2D(u_lmsTexture,vec2(1./6.,.5)).rgb;
  vec3 c2=texture2D(u_lmsTexture,vec2(2./6.,.5)).rgb;
  vec3 c3=texture2D(u_lmsTexture,vec2(3./6.,.5)).rgb;
  vec3 colorT=mix(c0,c1,glowUv.x);
  vec3 colorB=mix(c3,c2,glowUv.x);
  vec3 glowColor=mix(colorB,colorT,glowUv.y);
  glowColor*=glowColor*glowColor*2.;
  vec2 wp=(v_uv-u_pulseCenter)*aspect;
  float wl=length(aspect);
  float wpl=wl-length(wp);
  float wsl=0.5*wl;
  float wel=0.5*wl;
  float wtl=wl+wsl+wel;
  float wt=u_pulse*wtl-wl+wpl;
  float w0=smoothstep(0.,wsl,wt);
  float w1=smoothstep(wsl+wel,wsl,wt);
  float wd=abs(wt-wsl);
  float wave=w0*w1*u_amount;
  vec2 waveDir=normalize(wp);
  vec2 borderUv=(v_uv-0.5)*u_resolution+waveDir*wave*0.01*u_resolution.x;
  float d=sdBox(borderUv,u_resolution*0.5-u_padding*2.)-u_padding;
  d=linearstep(0.0,u_padding*2.5,d);
  float test=d;
  d=pow(d,3.0);
  float d2=sdBox(borderUv,u_resolution*0.5-u_padding*3.)-u_padding*1.5;
  d2=linearstep(0.0,u_padding*5.5,d2);
  test+=d2;
  d2=pow(d2,5.);
  vec4 base=texture2D(u_texture,v_uv+waveDir*smoothstep(0.,0.4,abs(wd))*wave*-0.005);
  vec3 color=pow(base.rgb,vec3(2.2));
  float glow=(0.001+d+d2*0.5)*5.;
  color+=u_amount*glowColor*glow;
  color+=wave*(d*0.25+d2*0.25+glowColor*0.05);
  color=min(color,1.);
  glow=dot(glowColor,vec3(0.2126,0.7152,0.0722))*glow;
  gl_FragColor=vec4(pow(color,vec3(1.0/2.2))+bnoise*0.004,min(1.,base.a+glow+wave*(d+d2*0.5+0.05)));
}
