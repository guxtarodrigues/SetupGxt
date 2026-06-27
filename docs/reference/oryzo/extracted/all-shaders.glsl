// Todos os blocos GLSL encontrados em raw/hoisted.js (118 no total).
// Indice por relevancia ja documentado em docs/oryzo-siri-edge-glow.md


// ===================== BLOCK 0 =====================
void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}

// ===================== BLOCK 1 =====================
void main() {
  gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}

// ===================== BLOCK 2 =====================
varying vec3 vWorldDirection;
vec3 transformDirection( in vec3 dir, in mat4 matrix ) {
  return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );
}
void main() {
  vWorldDirection = transformDirection( position, modelMatrix );
  #include <begin_vertex>
  #include <project_vertex>
}

// ===================== BLOCK 3 =====================
uniform sampler2D tEquirect;
varying vec3 vWorldDirection;
#include <common>
void main() {
  vec3 direction = normalize( vWorldDirection );
  vec2 sampleUV = equirectUv( direction );
  gl_FragColor = texture2D( tEquirect, sampleUV );
}

// ===================== BLOCK 4 =====================
gl_FragColor = linearToOutputTexel( gl_FragColor );

// ===================== BLOCK 5 =====================
+M,T=["#define varying in",t.glslVersion===GLSL3?"":"layout(location = 0) out highp vec4 pc_fragColor;
",t.glslVersion===GLSL3?"":"#define gl_FragColor pc_fragColor","#define gl_FragDepthEXT gl_FragDepth","#define texture2D texture","#define textureCube texture","#define texture2DProj textureProj","#define texture2DLodEXT textureLod","#define texture2DProjLodEXT textureProjLod","#define textureCubeLodEXT textureLod","#define texture2DGradEXT textureGrad","#define texture2DProjGradEXT textureProjGrad","#define textureCubeGradEXT textureGrad"].join(

// ===================== BLOCK 6 =====================
void main() {
  gl_Position = vec4( position, 1.0 );
}

// ===================== BLOCK 7 =====================
uniform sampler2D shadow_pass;
uniform vec2 resolution;
uniform float radius;
#include <packing>
void main() {
  const float samples = float( VSM_SAMPLES );
  float mean = 0.0;
  float squared_mean = 0.0;
  float uvStride = samples <= 1.0 ? 0.0 : 2.0 / ( samples - 1.0 );
  float uvStart = samples <= 1.0 ? 0.0 : - 1.0;
  for ( float i = 0.0;
  i < samples;
  i ++ ) {
    float uvOffset = uvStart + i * uvStride;
    #ifdef HORIZONTAL_PASS
    vec2 distribution = unpackRGBATo2Half( texture2D( shadow_pass, ( gl_FragCoord.xy + vec2( uvOffset, 0.0 ) * radius ) / resolution ) );
    mean += distribution.x;
    squared_mean += distribution.y * distribution.y + distribution.x * distribution.x;
    #else
    float depth = unpackRGBAToDepth( texture2D( shadow_pass, ( gl_FragCoord.xy + vec2( 0.0, uvOffset ) * radius ) / resolution ) );
    mean += depth;
    squared_mean += depth * depth;
    #endif
  }
mean = mean / samples;
squared_mean = squared_mean / samples;
float std_dev = sqrt( squared_mean - mean * mean );
gl_FragColor = pack2HalfToRGBA( vec2( mean, std_dev ) );
}

// ===================== BLOCK 8 =====================
void main() {
  gl_Position = vec4( position, 1.0 );
}

// ===================== BLOCK 9 =====================
uniform sampler2DArray depthColor;
uniform float depthWidth;
uniform float depthHeight;
void main() {
  vec2 coord = vec2( gl_FragCoord.x / depthWidth, gl_FragCoord.y / depthHeight );
  if ( coord.x >= 1.0 ) {
    gl_FragDepth = texture( depthColor, vec3( coord.x - 1.0, coord.y, 1 ) ).r;
  }
else {
  gl_FragDepth = texture( depthColor, vec3( coord.x, coord.y, 0 ) ).r;
}
}

// ===================== BLOCK 10 =====================
#define GLSLIFY 1
attribute vec2 position;
varying vec2 v_uv;
void main() {
  v_uv=position*.5+.5;
  gl_Position=vec4(position,0.,1.);
}

// ===================== BLOCK 11 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
varying vec2 v_uv;
void main() {
  gl_FragColor=texture2D(u_texture,v_uv);
}

// ===================== BLOCK 12 =====================
#define GLSLIFY 1
attribute vec2 position;
attribute vec2 uv;
varying vec2 v_uv;
void main() {
  v_uv=uv;
  gl_Position=vec4(position,0.0,1.0);
}

// ===================== BLOCK 13 =====================
#define GLSLIFY 1
uniform vec4 u_color;
varying vec2 v_uv;
void main() {
  gl_FragColor=u_color;
}

// ===================== BLOCK 14 =====================
#define GLSLIFY 1
attribute vec3 position;
attribute vec2 uv;
uniform vec4 u_transform;
varying vec2 v_uv;
void main() {
  v_uv=uv;
  gl_Position=vec4(position.xy*u_transform.zw+u_transform.xy,0.0,1.0);
}

// ===================== BLOCK 15 =====================
$ {
  this.precisionPrefix2}
#define varying in
layout(location = 0) out vec4 pc_fragColor;
#define gl_FragColor pc_fragColor
#define gl_FragDepthEXT gl_FragDepth
#define texture2D texture
#define textureCube texture
#define texture2DProj textureProj
#define texture2DLodEXT textureLod
#define texture2DProjLodEXT textureProjLod
#define textureCubeLodEXT textureLod
#define texture2DGradEXT textureGrad
#define texture2DProjGradEXT textureProjGrad
#define textureCubeGradEXT textureGrad

// ===================== BLOCK 16 =====================
#define GLSLIFY 1
attribute vec3 position;
attribute vec2 uv;
uniform vec4 u_rect;
uniform vec2 u_boxSize;
varying vec2 v_xy;
void main() {
  vec2 pos=position.xy*.5+.5;
  pos=mix(u_rect.xy,u_rect.xy+u_rect.zw,pos);
  gl_Position=vec4(pos,0.,1.);
  v_xy=vec2(uv.x,1.-uv.y)*u_boxSize;
}

// ===================== BLOCK 17 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec2 u_posA;
uniform vec2 u_dir;
uniform float u_length;
uniform vec2 u_texelSize;
uniform vec2 u_blurRadii;
uniform vec3 u_color;
uniform float u_colorAlphaA;
uniform float u_colorAlphaB;
uniform vec2 u_boxSize;
uniform float u_radius;
uniform float u_outline;
varying vec2 v_xy;
#include <linearstep>
#include <getBlueNoise>
#include <sampleBlur>
float sdRoundedBox(in vec2 p,in vec2 b,in float r) {
  vec2 q=abs(p)-b+r;
  return min(max(q.x,q.y),0.0)+length(max(q,0.0))-r;
}
void main() {
  vec3 bnoise=getBlueNoise(gl_FragCoord.xy);
  vec2 uv=gl_FragCoord.xy*u_texelSize;
  float ratio=clamp(dot(v_xy-u_posA.xy,u_dir)/u_length,0.,1.);
  float sdf=sdRoundedBox(v_xy-u_boxSize.xy*0.5,u_boxSize*.5,u_radius);
  float roundedBox=smoothstep(1.5,0.,sdf);
  float blurRadius=mix(u_blurRadii.x,u_blurRadii.y,ratio)*roundedBox;
  vec4 color=sampleBlur(u_texture,uv,u_texelSize,blurRadius,bnoise.z);
  float colorAlpha=mix(u_colorAlphaA,u_colorAlphaB,ratio)*roundedBox;
  color.rgb=mix(color.rgb,u_color,colorAlpha);
  float outline=smoothstep(-1.5,0.,sdf)*roundedBox;
  vec2 boxUv=v_xy/u_boxSize;
  color.rgb+=outline*linearstep(0.,2.,2.-boxUv.x-boxUv.y)*max(u_colorAlphaA,u_colorAlphaB)*u_outline;
  gl_FragColor=color;
}

// ===================== BLOCK 18 =====================
#define GLSLIFY 1
varying vec2 v_uv;
void main() {
  gl_Position=vec4(position.xy,0.0,1.0);
  v_uv=position.xy*0.5+0.5;
}

// ===================== BLOCK 19 =====================
#define GLSLIFY 1
uniform vec2 u_resolution;
uniform float u_opacity;
#include <getBlueNoise>
#include <getBgColor>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  gl_FragColor=vec4(pow(getBgColor(blueNoise.z),vec3(1.0/2.2))+blueNoise/255.0,u_opacity);
}

// ===================== BLOCK 20 =====================
#define GLSLIFY 1
varying vec2 v_uv;
void main() {
  v_uv=position.xy*.5+.5;
  gl_Position=vec4(position.xy,0.,1.);
}

// ===================== BLOCK 21 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
varying vec2 v_uv;
void main() {
  gl_FragColor=texture2D(u_texture,v_uv);
}

// ===================== BLOCK 22 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec2 u_texelSize;
uniform float u_blurRadius;
varying vec2 v_uv;
#include <getBlueNoise>
#include <sampleBlur>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  gl_FragColor=sampleBlur(u_texture,v_uv,u_texelSize,u_blurRadius,blueNoise.z);
}

// ===================== BLOCK 23 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec4 u_channelMixerR;
uniform vec4 u_channelMixerG;
uniform vec4 u_channelMixerB;
uniform vec4 u_channelMixerA;
uniform vec2 u_uvScale;
varying vec2 v_uv;
void main() {
  vec4 color=texture2D(u_texture,fract(v_uv*u_uvScale));
  gl_FragColor=vec4(dot(color,u_channelMixerR),dot(color,u_channelMixerG),dot(color,u_channelMixerB),dot(color,u_channelMixerA));
}

// ===================== BLOCK 24 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform float u_maxRange;
varying vec2 v_uv;
void main() {
  vec4 value=texture2D(u_texture,v_uv);
  gl_FragColor=vec4(value.xyz*value.w*u_maxRange,1.0);
}

// ===================== BLOCK 25 =====================
#define GLSLIFY 1
uniform vec2 u_uvScale;
uniform float u_uvHeightBias;
uniform mat4 u_goboProjectionMatrix;
uniform vec2 u_planeResolution;
uniform float u_height;
uniform sampler2D u_texture;
uniform mat4 u_goboMatrix;
uniform mat4 u_screenToWorld;
uniform mat4 u_cameraMVP;
uniform float u_zoom;
varying vec4 v_goboNdc;
varying vec2 v_uv;
#ifdef NEEDS_ANGULAR_RGB
uniform vec3 u_angleInfo;
varying vec2 v_uv2;
#endif
void main() {
  v_uv=uv*u_uvScale;
  vec2 uvHeight=uv;
  uvHeight.x+=u_uvHeightBias;
  uvHeight*=u_uvScale;
  float height=texture2D(u_texture,uvHeight).r;
  #ifdef NEEDS_ANGULAR_RGB
  v_uv.x+=u_angleInfo.x*u_uvScale.x;
  v_uv2=uv*u_uvScale;
  v_uv2.x+=u_angleInfo.y*u_uvScale.x;
  #endif
  gl_Position=projectionMatrix*viewMatrix*modelMatrix*vec4(position,1.0);
  vec4 tableNDC=u_cameraMVP*vec4(-0.0105761,0.7471+height*u_height,-0.0485146,1);
  tableNDC.xyz/=tableNDC.w;
  v_goboNdc=(u_goboMatrix*u_screenToWorld*vec4(gl_Position.xy/gl_Position.w/u_zoom,tableNDC.z,1.0));
}

// ===================== BLOCK 26 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
varying vec2 v_uv;
#ifdef IS_SHADOW
uniform float u_shadowOpacity;
#else
#include <linearstep>
uniform float u_activeRatio;
uniform vec2 u_resolution;
uniform vec2 u_2DlightPos;
uniform sampler2D u_goboTexture;
uniform mat4 u_goboProjectionMatrix;
uniform float u_goboOpacity;
uniform vec4 u_goboParams;
#include <getGoboBlurRatio>
varying vec4 v_goboNdc;
#include <getBlueNoise>
#include <getBgColor>
#include <sampleBlur>
#ifdef NEEDS_ANGULAR_RGB
uniform vec3 u_angleInfo;
varying vec2 v_uv2;
#endif
#endif
void main() {
  vec4 color=pow(texture2D(u_texture,v_uv),vec4(2.2));
  #ifdef IS_SHADOW
  gl_FragColor=vec4(color.a*u_shadowOpacity);
  #else
  #ifdef NEEDS_ANGULAR_RGB
  vec4 color2=pow(texture2D(u_texture,v_uv2),vec4(2.2));
  color=mix(color,color2,u_angleInfo.z);
  #endif
  vec2 texelSize=1.0/u_resolution;
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec2 lightPos=u_2DlightPos/u_resolution;
  float lightDist=length(lightPos-screenUv);
  float falloff=1.0/(1.0+0.3*lightDist*lightDist);
  float gobo=1.0;
  vec2 goboUv=v_goboNdc.xy/v_goboNdc.w*0.5+0.5;
  if(u_goboOpacity>0.&&goboUv.x>=0.0&&goboUv.x<=1.0&&goboUv.y>=0.0&&goboUv.y<=1.0) {
    gobo=sampleBlur(u_goboTexture,goboUv,vec2(1./512.),getGoboBlurRatio(v_goboNdc.z,u_goboParams)*2.,blueNoise.z).r;
    gobo=mix(1.0,gobo,u_goboOpacity);
  }
gl_FragColor=color;
gl_FragColor.rgb*=0.5+0.5*gobo;
gl_FragColor.rgb=mix(getBgColor(blueNoise.z),gl_FragColor.rgb,u_activeRatio);
gl_FragColor.rgb=pow(gl_FragColor.rgb,vec3(1.0/2.2));
#endif
}

// ===================== BLOCK 27 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform float u_time;
uniform float u_strength;
varying vec2 v_uv;
void main() {
  vec4 params=texture2D(u_texture,v_uv);
  float s=params.r;
  float amp1=params.g*u_strength;
  float phase1=(params.b-.5)*6.283185;
  float amp23=params.a*u_strength;
  vec3 waves=sin(u_time*vec3(1.,2.,3.)+phase1*vec3(1.,2.,.5));
  float motion=(amp1*waves.x)+(amp23*.5*waves.y)+(amp23*.3*waves.z);
  gl_FragColor=vec4(vec3(clamp(s+motion,0.,1.)),1.);
}

// ===================== BLOCK 28 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec2 u_delta;
varying vec2 v_uv[9];
void main() {
  vec2 uv=position.xy*0.5+0.5;
  v_uv[0]=uv;
  vec2 delta=u_delta;
  v_uv[1]=uv-delta;
  v_uv[2]=uv+delta;
  delta+=u_delta;
  v_uv[3]=uv-delta;
  v_uv[4]=uv+delta;
  delta+=u_delta;
  v_uv[5]=uv-delta;
  v_uv[6]=uv+delta;
  delta+=u_delta;
  v_uv[7]=uv-delta;
  v_uv[8]=uv+delta;
  gl_Position=vec4(position,1.0);
}

// ===================== BLOCK 29 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
varying vec2 v_uv[9];
void main() {
  vec4 color=texture2D(u_texture,v_uv[0])*0.1633;
  color+=texture2D(u_texture,v_uv[1])*0.1531;
  color+=texture2D(u_texture,v_uv[2])*0.1531;
  color+=texture2D(u_texture,v_uv[3])*0.12245;
  color+=texture2D(u_texture,v_uv[4])*0.12245;
  color+=texture2D(u_texture,v_uv[5])*0.0918;
  color+=texture2D(u_texture,v_uv[6])*0.0918;
  color+=texture2D(u_texture,v_uv[7])*0.051;
  color+=texture2D(u_texture,v_uv[8])*0.051;
  gl_FragColor=color;
}

// ===================== BLOCK 30 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec2 u_delta;
varying vec2 v_uv;
void main() {
  vec4 color=texture2D(u_texture,v_uv)*0.1633;
  vec2 delta=u_delta;
  color+=texture2D(u_texture,v_uv-delta)*0.1531;
  color+=texture2D(u_texture,v_uv+delta)*0.1531;
  delta+=u_delta;
  color+=texture2D(u_texture,v_uv-delta)*0.12245;
  color+=texture2D(u_texture,v_uv+delta)*0.12245;
  delta+=u_delta;
  color+=texture2D(u_texture,v_uv-delta)*0.0918;
  color+=texture2D(u_texture,v_uv+delta)*0.0918;
  delta+=u_delta;
  color+=texture2D(u_texture,v_uv-delta)*0.051;
  color+=texture2D(u_texture,v_uv+delta)*0.051;
  gl_FragColor=color;
}

// ===================== BLOCK 31 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec2 u_resolution;
uniform vec2 u_heroViewResolution;
uniform vec2 u_planeResolution;
uniform float u_zoom;
uniform float u_rotation;
uniform mat4 u_screenToWorld;
uniform float u_screenTableNDCDepth;
varying vec2 v_uv;
varying vec4 v_worldPos4;
mat2 transform(float zoom,float angle) {
  float s=sin(angle);
  float c=cos(angle);
  return mat2(c,-s,s,c)*zoom;
}
void main() {
  mat2 t=transform(1./u_zoom,-u_rotation);
  vec2 uv=position.xy*.5;
  uv.x*=u_resolution.x/u_resolution.y;
  uv=t*uv;
  uv*=u_heroViewResolution.y/u_planeResolution.xy;
  v_uv=uv+0.5;
  v_worldPos4=(u_screenToWorld*vec4(position.xy/u_zoom,u_screenTableNDCDepth,1.0));
  gl_Position=vec4(position.xy,0.0,1.0);
}

// ===================== BLOCK 32 =====================
#define GLSLIFY 1
#include <linearstep>
uniform sampler2D u_texture;
uniform sampler2D u_shadowMap;
uniform sampler2D u_shadowCacheMap;
uniform sampler2D u_deskPadTexture;
uniform sampler2D u_goboTexture;
uniform mat4 u_goboMatrix;
uniform float u_goboOpacity;
uniform vec4 u_goboParams;
#include <getGoboBlurRatio>
uniform vec2 u_resolution;
uniform vec2 u_viewResolution;
uniform vec2 u_planeResolution;
uniform vec2 u_2DlightPos;
uniform mat4 u_screenToWorld;
uniform float u_screenTableNDCDepth;
uniform float u_zoom;
uniform float u_activeRatio;
uniform vec3 u_coasterPos;
uniform vec2 u_textureCorrection;
uniform float u_blurRectRadius;
uniform vec4 u_blurRect;
uniform float u_blurRatio;
uniform vec3 u_blurColor;
uniform float u_useMobileLayout;
varying vec2 v_uv;
varying vec4 v_worldPos4;
#include <getBlueNoise>
#include <getBgColor>
#include <sampleBlur>
#include <rgb2hsb>
#include <hsb2rgb>
struct Ellipsoid {
  vec3 cen;
  vec3 rad;
};
float eliSoftShadow(in vec3 ro,in vec3 rd,in Ellipsoid sph,in float k) {
  vec3 oc=ro-sph.cen;
  vec3 ocn=oc/sph.rad;
  vec3 rdn=rd/sph.rad;
  float a=dot(rdn,rdn);
  float b=dot(ocn,rdn);
  float c=dot(ocn,ocn);
  float h=b*b-a*(c-1.0);
  float t=(-b-sqrt(max(h,0.0)))/a;
  return(h>0.0)? step(t,0.0): smoothstep(0.0,1.0,-k*h/max(t,0.0));
}
float sdBox(in vec2 p,in vec2 b) {
  vec2 d=abs(p)-b;
  return length(max(d,0.0))+min(max(d.x,d.y),0.0);
}
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec2 texelSize=1.0/u_resolution;
  vec2 aspect=vec2(u_resolution.x/u_resolution.y,1.0);
  vec2 planeAspect=vec2(u_planeResolution.x/u_planeResolution.y,1.0);
  float outDist=sdBox((v_uv-.5)*planeAspect,planeAspect*.5*u_textureCorrection);
  vec2 baseUv=v_uv+(blueNoise.xy-.5)*planeAspect*max(0.,outDist)*0.5;
  vec2 px=screenUv*u_viewResolution;
  float blurRatio=linearstep(-u_blurRectRadius,0.,-sdBox(px-u_blurRect.xy,u_blurRect.zw*.5-u_blurRectRadius))*u_blurRatio;
  vec3 color=sampleBlur(u_texture,(baseUv-.5)/u_textureCorrection+.5,texelSize,blurRatio*blurRatio*blurRatio*u_resolution.y/50.,blueNoise.z).rgb;
  color=mix(color,u_blurColor,blurRatio*0.8);
  vec2 lightPos=vec2(0.0,0.0);
  float lightDist=length(lightPos-screenUv);
  float falloff=1.0/(1.0+0.3*lightDist*lightDist);
  vec4 shadowInfos=texture2D(u_shadowMap,screenUv);
  float shadow=(1.0-shadowInfos.r*falloff);
  vec3 worldPos=v_worldPos4.xyz/v_worldPos4.w;
  Ellipsoid sph=Ellipsoid(u_coasterPos,vec3(0.045,0.01,0.045));
  vec3 lightDir=normalize(vec3(1.2,0.8,-1.2));
  float coasterShadow=eliSoftShadow(worldPos,lightDir,sph,0.00001);
  coasterShadow=mix(1.,coasterShadow,u_activeRatio*u_activeRatio)*0.8+0.2;
  float gobo=1.0;
  vec4 goboNdc=u_goboMatrix*vec4(worldPos,1.);
  goboNdc/=goboNdc.w;
  vec2 goboUv=goboNdc.xy*0.5+0.5;
  if(u_goboOpacity>0.&&goboUv.x>=0.0&&goboUv.x<=1.0&&goboUv.y>=0.0&&goboUv.y<=1.0) {
    gobo=sampleBlur(u_goboTexture,goboUv,vec2(1./512.),getGoboBlurRatio(goboNdc.z,u_goboParams)*2.,blueNoise.z).r;
    gobo=mix(1.0,gobo,u_goboOpacity);
  }
float shade=mix(1.,shadow*coasterShadow*(0.5+0.5*gobo),0.975);
vec3 hsb=rgb2hsb(color);
hsb.g=min(hsb.g+(1.-shade)*0.1,1.);
hsb.b*=shade;
color.rgb=hsb2rgb(hsb);
color=mix(color,vec3(0.0254,0.04299,0.01794),smoothstep(0.6,0.8,screenUv.y)*u_useMobileLayout);
color=mix(getBgColor(blueNoise.z),color,u_activeRatio);
gl_FragColor=vec4(pow(color,vec3(1.0/2.2)),0.);
}

// ===================== BLOCK 33 =====================
#define GLSLIFY 1
uniform sampler2D u_lowPaintTexture;
uniform sampler2D u_prevPaintTexture;
uniform vec2 u_paintTexelSize;
uniform vec4 u_drawFrom;
uniform vec4 u_drawTo;
uniform float u_pushStrength;
uniform vec3 u_dissipations;
uniform vec2 u_vel;
varying vec2 v_uv;
vec2 sdSegment(in vec2 p,in vec2 a,in vec2 b) {
  vec2 pa=p-a,ba=b-a;
  float h=clamp(dot(pa,ba)/dot(ba,ba),0.0,1.0);
  return vec2(length(pa-ba*h),h);
}
#ifdef USE_NOISE
uniform float u_curlScale;
uniform float u_curlStrength;
vec2 hash(vec2 p) {
  vec3 p3=fract(vec3(p.xyx)*vec3(.1031,.1030,.0973));
  p3+=dot(p3,p3.yzx+33.33);
  return fract((p3.xx+p3.yz)*p3.zy)*2.0-1.0;
}
vec3 noised(in vec2 p) {
  vec2 i=floor(p);
  vec2 f=fract(p);
  vec2 u=f*f*f*(f*(f*6.0-15.0)+10.0);
  vec2 du=30.0*f*f*(f*(f-2.0)+1.0);
  vec2 ga=hash(i+vec2(0.0,0.0));
  vec2 gb=hash(i+vec2(1.0,0.0));
  vec2 gc=hash(i+vec2(0.0,1.0));
  vec2 gd=hash(i+vec2(1.0,1.0));
  float va=dot(ga,f-vec2(0.0,0.0));
  float vb=dot(gb,f-vec2(1.0,0.0));
  float vc=dot(gc,f-vec2(0.0,1.0));
  float vd=dot(gd,f-vec2(1.0,1.0));
  return vec3(va+u.x*(vb-va)+u.y*(vc-va)+u.x*u.y*(va-vb-vc+vd),ga+u.x*(gb-ga)+u.y*(gc-ga)+u.x*u.y*(ga-gb-gc+gd)+du*(u.yx*(va-vb-vc+vd)+vec2(vb,vc)-va));
}
#endif
void main() {
  vec2 res=sdSegment(gl_FragCoord.xy,u_drawFrom.xy,u_drawTo.xy);
  vec2 radiusWeight=mix(u_drawFrom.zw,u_drawTo.zw,res.y);
  float d=1.0-smoothstep(-0.01,radiusWeight.x,res.x);
  vec4 lowData=texture2D(u_lowPaintTexture,v_uv);
  vec2 velInv=(0.5-lowData.xy)*u_pushStrength;
  #ifdef USE_NOISE
  vec3 noise3=noised(gl_FragCoord.xy*u_curlScale*(1.0-lowData.xy));
  vec2 noise=noised(gl_FragCoord.xy*u_curlScale*(2.0-lowData.xy*(0.5+noise3.x)+noise3.yz*0.1)).yz;
  velInv+=noise*(lowData.z+lowData.w)*u_curlStrength;
  #endif
  vec4 data=texture2D(u_prevPaintTexture,v_uv+velInv*u_paintTexelSize);
  data.xy-=0.5;
  vec4 delta=(u_dissipations.xxyz-1.0)*data;
  vec2 newVel=u_vel*d;
  delta+=vec4(newVel,radiusWeight.yy*d);
  delta.zw=sign(delta.zw)*max(vec2(0.004),abs(delta.zw));
  data+=delta;
  data.xy+=0.5;
  gl_FragColor=clamp(data,vec4(0.0),vec4(1.0));
}

// ===================== BLOCK 34 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec2 u_texelSize;
varying vec2 v_uv;
varying vec4 v_offsets[2];
void SMAANeighborhoodBlendingVS(vec2 texcoord) {
  v_offsets[0]=texcoord.xyxy+u_texelSize.xyxy*vec4(-1.0,0.0,0.0,1.0);
  v_offsets[1]=texcoord.xyxy+u_texelSize.xyxy*vec4(1.0,0.0,0.0,-1.0);
}
void main() {
  v_uv=position.xy*0.5+0.5;
  SMAANeighborhoodBlendingVS(v_uv);
  gl_Position=vec4(position,1.0);
}

// ===================== BLOCK 35 =====================
#define GLSLIFY 1
uniform sampler2D u_weightsTexture;
uniform sampler2D u_texture;
uniform vec2 u_texelSize;
varying vec2 v_uv;
varying vec4 v_offsets[2];
vec4 SMAANeighborhoodBlendingPS(vec2 texcoord,vec4 offset[2],sampler2D colorTex,sampler2D blendTex) {
  vec4 a;
  a.xz=texture2D(blendTex,texcoord).xz;
  a.y=texture2D(blendTex,offset[1].zw).g;
  a.w=texture2D(blendTex,offset[1].xy).a;
  if(dot(a,vec4(1.0,1.0,1.0,1.0))<1e-5) {
    return texture2D(colorTex,texcoord,0.0);
  }
else {
  vec2 offset;
  offset.x=a.a>a.b ? a.a :-a.b;
  offset.y=a.g>a.r ?-a.g : a.r;
  if(abs(offset.x)>abs(offset.y)) {
    offset.y=0.0;
  }
else {
  offset.x=0.0;
}
vec4 C=texture2D(colorTex,texcoord,0.0);
texcoord+=sign(offset)*u_texelSize;
vec4 Cop=texture2D(colorTex,texcoord,0.0);
float s=abs(offset.x)>abs(offset.y)? abs(offset.x): abs(offset.y);
C.xyz=pow(abs(C.xyz),vec3(2.2));
Cop.xyz=pow(abs(Cop.xyz),vec3(2.2));
vec4 mixed=mix(C,Cop,s);
mixed.xyz=pow(abs(mixed.xyz),vec3(1.0/2.2));
return mixed;
}
}
void main() {
  gl_FragColor=SMAANeighborhoodBlendingPS(v_uv,v_offsets,u_texture,u_weightsTexture);
}

// ===================== BLOCK 36 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec2 u_texelSize;
varying vec2 v_uv;
varying vec4 v_offsets[3];
void SMAAEdgeDetectionVS(vec2 texcoord) {
  v_offsets[0]=texcoord.xyxy+u_texelSize.xyxy*vec4(-1.0,0.0,0.0,1.0);
  v_offsets[1]=texcoord.xyxy+u_texelSize.xyxy*vec4(1.0,0.0,0.0,-1.0);
  v_offsets[2]=texcoord.xyxy+u_texelSize.xyxy*vec4(-2.0,0.0,0.0,2.0);
}
void main() {
  v_uv=position.xy*0.5+0.5;
  SMAAEdgeDetectionVS(v_uv);
  gl_Position=vec4(position,1.0);
}

// ===================== BLOCK 37 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec2 u_thresholds;
varying vec2 v_uv;
varying vec4 v_offsets[3];
vec4 SMAAColorEdgeDetectionPS(vec2 texcoord,vec4 offset[3],sampler2D colorTex) {
  vec4 delta;
  vec3 C=texture2D(colorTex,texcoord).rgb;
  vec3 Cleft=texture2D(colorTex,offset[0].xy).rgb;
  vec3 t=abs(C-Cleft);
  delta.x=max(max(t.r,t.g),t.b);
  vec3 Ctop=texture2D(colorTex,offset[0].zw).rgb;
  t=abs(C-Ctop);
  delta.y=max(max(t.r,t.g),t.b);
  vec2 edges=step(u_thresholds,delta.xy);
  if(dot(edges,vec2(1.0,1.0))==0.0)discard;
  vec3 Cright=texture2D(colorTex,offset[1].xy).rgb;
  t=abs(C-Cright);
  delta.z=max(max(t.r,t.g),t.b);
  vec3 Cbottom=texture2D(colorTex,offset[1].zw).rgb;
  t=abs(C-Cbottom);
  delta.w=max(max(t.r,t.g),t.b);
  float maxDelta=max(max(max(delta.x,delta.y),delta.z),delta.w);
  vec3 Cleftleft=texture2D(colorTex,offset[2].xy).rgb;
  t=abs(C-Cleftleft);
  delta.z=max(max(t.r,t.g),t.b);
  vec3 Ctoptop=texture2D(colorTex,offset[2].zw).rgb;
  t=abs(C-Ctoptop);
  delta.w=max(max(t.r,t.g),t.b);
  maxDelta=max(max(maxDelta,delta.z),delta.w);
  edges.xy*=step(0.5*maxDelta,delta.xy);
  return vec4(edges,0.0,0.0);
}
void main() {
  gl_FragColor=SMAAColorEdgeDetectionPS(v_uv,v_offsets,u_texture);
}

// ===================== BLOCK 38 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec2 u_texelSize;
varying vec2 v_uv;
varying vec4 v_offsets[3];
varying vec2 v_pixcoord;
void SMAABlendingWeightCalculationVS(vec2 texcoord) {
  v_pixcoord=texcoord/u_texelSize;
  v_offsets[0]=texcoord.xyxy+u_texelSize.xyxy*vec4(-0.25,0.125,1.25,0.125);
  v_offsets[1]=texcoord.xyxy+u_texelSize.xyxy*vec4(-0.125,0.25,-0.125,-1.25);
  v_offsets[2]=vec4(v_offsets[0].xz,v_offsets[1].yw)+vec4(-2.0,2.0,-2.0,2.0)*u_texelSize.xxyy*float(SMAA_MAX_SEARCH_STEPS);
}
void main() {
  v_uv=position.xy*0.5+0.5;
  SMAABlendingWeightCalculationVS(v_uv);
  gl_Position=vec4(position,1.0);
}

// ===================== BLOCK 39 =====================
#define GLSLIFY 1
#define SMAASampleLevelZeroOffset( tex, coord, offset ) texture2D( tex, coord + float( offset ) * u_texelSize, 0.0 )
uniform sampler2D u_edgesTexture;
uniform sampler2D u_areaTexture;
uniform sampler2D u_searchTexture;
uniform vec2 u_texelSize;
varying vec2 v_uv;
varying vec4 v_offsets[3];
varying vec2 v_pixcoord;
vec2 round(vec2 x) {
  return sign(x)*floor(abs(x)+0.5);
}
float SMAASearchLength(sampler2D searchTex,vec2 e,float bias,float scale) {
  e.r=bias+e.r*scale;
  return 255.0*texture2D(searchTex,e,0.0).r;
}
float SMAASearchXLeft(sampler2D edgesTex,sampler2D searchTex,vec2 texcoord,float end) {
  vec2 e=vec2(0.0,1.0);
  for(int i=0;
  i<SMAA_MAX_SEARCH_STEPS;
  i++) {
    e=texture2D(edgesTex,texcoord,0.0).rg;
    texcoord-=vec2(2.0,0.0)*u_texelSize;
    if(!(texcoord.x>end&&e.g>0.8281&&e.r==0.0))break;
  }
texcoord.x+=0.25*u_texelSize.x;
texcoord.x+=u_texelSize.x;
texcoord.x+=2.0*u_texelSize.x;
texcoord.x-=u_texelSize.x*SMAASearchLength(searchTex,e,0.0,0.5);
return texcoord.x;
}
float SMAASearchXRight(sampler2D edgesTex,sampler2D searchTex,vec2 texcoord,float end) {
  vec2 e=vec2(0.0,1.0);
  for(int i=0;
  i<SMAA_MAX_SEARCH_STEPS;
  i++) {
    e=texture2D(edgesTex,texcoord,0.0).rg;
    texcoord+=vec2(2.0,0.0)*u_texelSize;
    if(!(texcoord.x<end&&e.g>0.8281&&e.r==0.0))break;
  }
texcoord.x-=0.25*u_texelSize.x;
texcoord.x-=u_texelSize.x;
texcoord.x-=2.0*u_texelSize.x;
texcoord.x+=u_texelSize.x*SMAASearchLength(searchTex,e,0.5,0.5);
return texcoord.x;
}
float SMAASearchYUp(sampler2D edgesTex,sampler2D searchTex,vec2 texcoord,float end) {
  vec2 e=vec2(1.0,0.0);
  for(int i=0;
  i<SMAA_MAX_SEARCH_STEPS;
  i++) {
    e=texture2D(edgesTex,texcoord,0.0).rg;
    texcoord+=vec2(0.0,2.0)*u_texelSize;
    if(!(texcoord.y>end&&e.r>0.8281&&e.g==0.0))break;
  }
texcoord.y-=0.25*u_texelSize.y;
texcoord.y-=u_texelSize.y;
texcoord.y-=2.0*u_texelSize.y;
texcoord.y+=u_texelSize.y*SMAASearchLength(searchTex,e.gr,0.0,0.5);
return texcoord.y;
}
float SMAASearchYDown(sampler2D edgesTex,sampler2D searchTex,vec2 texcoord,float end) {
  vec2 e=vec2(1.0,0.0);
  for(int i=0;
  i<SMAA_MAX_SEARCH_STEPS;
  i++) {
    e=texture2D(edgesTex,texcoord,0.0).rg;
    texcoord-=vec2(0.0,2.0)*u_texelSize;
    if(!(texcoord.y<end&&e.r>0.8281&&e.g==0.0))break;
  }
texcoord.y+=0.25*u_texelSize.y;
texcoord.y+=u_texelSize.y;
texcoord.y+=2.0*u_texelSize.y;
texcoord.y-=u_texelSize.y*SMAASearchLength(searchTex,e.gr,0.5,0.5);
return texcoord.y;
}
vec2 SMAAArea(sampler2D areaTex,vec2 dist,float e1,float e2,float offset) {
  vec2 texcoord=float(SMAA_AREATEX_MAX_DISTANCE)*round(4.0*vec2(e1,e2))+dist;
  texcoord=SMAA_AREATEX_PIXEL_SIZE*texcoord+(0.5*SMAA_AREATEX_PIXEL_SIZE);
  texcoord.y+=SMAA_AREATEX_SUBTEX_SIZE*offset;
  return texture2D(areaTex,texcoord,0.0).rg;
}
vec4 SMAABlendingWeightCalculationPS(vec2 texcoord,vec2 pixcoord,vec4 offset[3],sampler2D edgesTex,sampler2D areaTex,sampler2D searchTex,ivec4 subsampleIndices) {
  vec4 weights=vec4(0.0,0.0,0.0,0.0);
  vec2 e=texture2D(edgesTex,texcoord).rg;
  if(e.g>0.0) {
    vec2 d;
    vec2 coords;
    coords.x=SMAASearchXLeft(edgesTex,searchTex,offset[0].xy,offset[2].x);
    coords.y=offset[1].y;
    d.x=coords.x;
    float e1=texture2D(edgesTex,coords,0.0).r;
    coords.x=SMAASearchXRight(edgesTex,searchTex,offset[0].zw,offset[2].y);
    d.y=coords.x;
    d=d/u_texelSize.x-pixcoord.x;
    vec2 sqrt_d=sqrt(abs(d));
    coords.y-=1.0*u_texelSize.y;
    float e2=SMAASampleLevelZeroOffset(edgesTex,coords,ivec2(1,0)).r;
    weights.rg=SMAAArea(areaTex,sqrt_d,e1,e2,float(subsampleIndices.y));
  }
if(e.r>0.0) {
  vec2 d;
  vec2 coords;
  coords.y=SMAASearchYUp(edgesTex,searchTex,offset[1].xy,offset[2].z);
  coords.x=offset[0].x;
  d.x=coords.y;
  float e1=texture2D(edgesTex,coords,0.0).g;
  coords.y=SMAASearchYDown(edgesTex,searchTex,offset[1].zw,offset[2].w);
  d.y=coords.y;
  d=d/u_texelSize.y-pixcoord.y;
  vec2 sqrt_d=sqrt(abs(d));
  coords.y-=1.0*u_texelSize.y;
  float e2=SMAASampleLevelZeroOffset(edgesTex,coords,ivec2(0,1)).g;
  weights.ba=SMAAArea(areaTex,sqrt_d,e1,e2,float(subsampleIndices.x));
}
return weights;
}
void main() {
  gl_FragColor=SMAABlendingWeightCalculationPS(v_uv,v_pixcoord,v_offsets,u_edgesTexture,u_areaTexture,u_searchTexture,ivec4(0.0));
}

// ===================== BLOCK 40 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform sampler2D u_depthTexture;
uniform vec2 u_texelSize;
uniform float u_focusDistance;
uniform float u_lensCoeff;
uniform float u_maxCoC;
uniform float u_rcpMaxCoC;
uniform float u_cameraNear;
uniform float u_cameraFar;
varying vec2 v_uv;
float max3(vec3 xyz) {
  return max(xyz.x,max(xyz.y,xyz.z));
}
#ifndef USE_FLOAT
uniform float u_hashNoise;
float hash13(vec3 p3) {
  p3=fract(p3*.1031);
  p3+=dot(p3,p3.yzx+33.33);
  return fract((p3.x+p3.y)*p3.z);
}
#endif
float getViewZ(vec2 uv) {
  float depth=texture2D(u_depthTexture,uv).r*2.0-1.0;
  return 2.0*u_cameraNear*u_cameraFar/(u_cameraFar+u_cameraNear-depth*(u_cameraFar-u_cameraNear));
}
void main() {
  vec3 duv=u_texelSize.xyx*vec3(0.5,0.5,-0.5);
  vec3 c0=texture2D(u_texture,v_uv-duv.xy).rgb;
  vec3 c1=texture2D(u_texture,v_uv-duv.zy).rgb;
  vec3 c2=texture2D(u_texture,v_uv+duv.zy).rgb;
  vec3 c3=texture2D(u_texture,v_uv+duv.xy).rgb;
  vec2 uvAlt=v_uv;
  float d0=getViewZ(uvAlt-duv.xy);
  float d1=getViewZ(uvAlt-duv.zy);
  float d2=getViewZ(uvAlt+duv.zy);
  float d3=getViewZ(uvAlt+duv.xy);
  vec4 depths=vec4(d0,d1,d2,d3);
  float focusDistance=u_focusDistance;
  vec4 cocs=(depths-focusDistance)*u_lensCoeff/depths;
  cocs=clamp(cocs,-u_maxCoC,u_maxCoC);
  vec4 weights=clamp(abs(cocs)*u_rcpMaxCoC,vec4(0.0),vec4(1.0));
  weights.x*=1.0/(max3(c0)+1.0);
  weights.y*=1.0/(max3(c1)+1.0);
  weights.z*=1.0/(max3(c2)+1.0);
  weights.w*=1.0/(max3(c3)+1.0);
  vec3 avg=c0*weights.x+c1*weights.y+c2*weights.z+c3*weights.w;
  avg/=dot(weights,vec4(1.0));
  float coc=dot(cocs,vec4(0.25));
  avg*=smoothstep(0.0,u_texelSize.y*2.0,abs(coc));
  gl_FragColor=vec4(avg,coc);
  #ifndef USE_FLOAT
  gl_FragColor=sign(gl_FragColor)*sqrt(abs(gl_FragColor));
  gl_FragColor=gl_FragColor*0.5+0.5+hash13(vec3(gl_FragCoord.xy,u_hashNoise))/255.0;
  #endif
}

// ===================== BLOCK 41 =====================
#define GLSLIFY 1
#if QUALITY == 0
const int kSampleCount=16;
vec2 kDiskKernel[kSampleCount];
void initKernel() {
  kDiskKernel[0]=vec2(0.0,0.0);
  kDiskKernel[1]=vec2(0.54545456,0.0);
  kDiskKernel[2]=vec2(0.16855472,0.5187581);
  kDiskKernel[3]=vec2(-0.44128203,0.3206101);
  kDiskKernel[4]=vec2(-0.44128197,-0.3206102);
  kDiskKernel[5]=vec2(0.1685548,-0.5187581);
  kDiskKernel[6]=vec2(1.0,0.0);
  kDiskKernel[7]=vec2(0.809017,0.58778524);
  kDiskKernel[8]=vec2(0.30901697,0.95105654);
  kDiskKernel[9]=vec2(-0.30901703,0.9510565);
  kDiskKernel[10]=vec2(-0.80901706,0.5877852);
  kDiskKernel[11]=vec2(-1.0,0.0);
  kDiskKernel[12]=vec2(-0.80901694,-0.58778536);
  kDiskKernel[13]=vec2(-0.30901664,-0.9510566);
  kDiskKernel[14]=vec2(0.30901712,-0.9510565);
  kDiskKernel[15]=vec2(0.80901694,-0.5877853);
}
#endif
#if QUALITY == 1
const int kSampleCount=22;
vec2 kDiskKernel[kSampleCount];
void initKernel() {
  kDiskKernel[0]=vec2(0.0,0.0);
  kDiskKernel[1]=vec2(0.53333336,0.0);
  kDiskKernel[2]=vec2(0.3325279,0.4169768);
  kDiskKernel[3]=vec2(-0.11867785,0.5199616);
  kDiskKernel[4]=vec2(-0.48051673,0.2314047);
  kDiskKernel[5]=vec2(-0.48051673,-0.23140468);
  kDiskKernel[6]=vec2(-0.11867763,-0.51996166);
  kDiskKernel[7]=vec2(0.33252785,-0.4169769);
  kDiskKernel[8]=vec2(1.0,0.0);
  kDiskKernel[9]=vec2(0.90096885,0.43388376);
  kDiskKernel[10]=vec2(0.6234898,0.7818315);
  kDiskKernel[11]=vec2(0.22252098,0.9749279);
  kDiskKernel[12]=vec2(-0.22252095,0.9749279);
  kDiskKernel[13]=vec2(-0.62349,0.7818314);
  kDiskKernel[14]=vec2(-0.90096885,0.43388382);
  kDiskKernel[15]=vec2(-1.0,0.0);
  kDiskKernel[16]=vec2(-0.90096885,-0.43388376);
  kDiskKernel[17]=vec2(-0.6234896,-0.7818316);
  kDiskKernel[18]=vec2(-0.22252055,-0.974928);
  kDiskKernel[19]=vec2(0.2225215,-0.9749278);
  kDiskKernel[20]=vec2(0.6234897,-0.7818316);
  kDiskKernel[21]=vec2(0.90096885,-0.43388376);
}
#endif
#if QUALITY == 2
const int kSampleCount=43;
vec2 kDiskKernel[kSampleCount];
void initKernel() {
  kDiskKernel[0]=vec2(0.0,0.0);
  kDiskKernel[1]=vec2(0.36363637,0.0);
  kDiskKernel[2]=vec2(0.22672357,0.28430238);
  kDiskKernel[3]=vec2(-0.08091671,0.35451925);
  kDiskKernel[4]=vec2(-0.32762504,0.15777594);
  kDiskKernel[5]=vec2(-0.32762504,-0.15777591);
  kDiskKernel[6]=vec2(-0.08091656,-0.35451928);
  kDiskKernel[7]=vec2(0.22672352,-0.2843024);
  kDiskKernel[8]=vec2(0.6818182,0.0);
  kDiskKernel[9]=vec2(0.614297,0.29582983);
  kDiskKernel[10]=vec2(0.42510667,0.5330669);
  kDiskKernel[11]=vec2(0.15171885,0.6647236);
  kDiskKernel[12]=vec2(-0.15171883,0.6647236);
  kDiskKernel[13]=vec2(-0.4251068,0.53306687);
  kDiskKernel[14]=vec2(-0.614297,0.29582986);
  kDiskKernel[15]=vec2(-0.6818182,0);
  kDiskKernel[16]=vec2(-0.614297,-0.29582983);
  kDiskKernel[17]=vec2(-0.42510656,-0.53306705);
  kDiskKernel[18]=vec2(-0.15171856,-0.66472363);
  kDiskKernel[19]=vec2(0.1517192,-0.6647235);
  kDiskKernel[20]=vec2(0.4251066,-0.53306705);
  kDiskKernel[21]=vec2(0.614297,-0.29582983);
  kDiskKernel[22]=vec2(1.0,0.0);
  kDiskKernel[23]=vec2(0.9555728,0.2947552);
  kDiskKernel[24]=vec2(0.82623875,0.5633201);
  kDiskKernel[25]=vec2(0.6234898,0.7818315);
  kDiskKernel[26]=vec2(0.36534098,0.93087375);
  kDiskKernel[27]=vec2(0.07473,0.9972038);
  kDiskKernel[28]=vec2(-0.22252095,0.9749279);
  kDiskKernel[29]=vec2(-0.50000006,0.8660254);
  kDiskKernel[30]=vec2(-0.73305196,0.6801727);
  kDiskKernel[31]=vec2(-0.90096885,0.43388382);
  kDiskKernel[32]=vec2(-0.98883086,0.14904208);
  kDiskKernel[33]=vec2(-0.9888308,-0.14904249);
  kDiskKernel[34]=vec2(-0.90096885,-0.43388376);
  kDiskKernel[35]=vec2(-0.73305184,-0.6801728);
  kDiskKernel[36]=vec2(-0.4999999,-0.86602545);
  kDiskKernel[37]=vec2(-0.222521,-0.9749279);
  kDiskKernel[38]=vec2(0.07473029,-0.99720377);
  kDiskKernel[39]=vec2(0.36534148,-0.9308736);
  kDiskKernel[40]=vec2(0.6234897,-0.7818316);
  kDiskKernel[41]=vec2(0.8262388,-0.56332);
  kDiskKernel[42]=vec2(0.9555729,-0.29475483);
}
#endif
#if QUALITY == 3
const int kSampleCount=71;
vec2 kDiskKernel[kSampleCount];
void initKernel() {
  kDiskKernel[0]=vec2(0,0);
  kDiskKernel[1]=vec2(0.2758621,0.0);
  kDiskKernel[2]=vec2(0.1719972,0.21567768);
  kDiskKernel[3]=vec2(-0.061385095,0.26894566);
  kDiskKernel[4]=vec2(-0.24854316,0.1196921);
  kDiskKernel[5]=vec2(-0.24854316,-0.11969208);
  kDiskKernel[6]=vec2(-0.061384983,-0.2689457);
  kDiskKernel[7]=vec2(0.17199717,-0.21567771);
  kDiskKernel[8]=vec2(0.51724136,0.0);
  kDiskKernel[9]=vec2(0.46601835,0.22442262);
  kDiskKernel[10]=vec2(0.32249472,0.40439558);
  kDiskKernel[11]=vec2(0.11509705,0.50427306);
  kDiskKernel[12]=vec2(-0.11509704,0.50427306);
  kDiskKernel[13]=vec2(-0.3224948,0.40439552);
  kDiskKernel[14]=vec2(-0.46601835,0.22442265);
  kDiskKernel[15]=vec2(-0.51724136,0.0);
  kDiskKernel[16]=vec2(-0.46601835,-0.22442262);
  kDiskKernel[17]=vec2(-0.32249463,-0.40439564);
  kDiskKernel[18]=vec2(-0.11509683,-0.5042731);
  kDiskKernel[19]=vec2(0.11509732,-0.504273);
  kDiskKernel[20]=vec2(0.32249466,-0.40439564);
  kDiskKernel[21]=vec2(0.46601835,-0.22442262);
  kDiskKernel[22]=vec2(0.7586207,0.0);
  kDiskKernel[23]=vec2(0.7249173,0.22360738);
  kDiskKernel[24]=vec2(0.6268018,0.4273463);
  kDiskKernel[25]=vec2(0.47299224,0.59311354);
  kDiskKernel[26]=vec2(0.27715522,0.7061801);
  kDiskKernel[27]=vec2(0.056691725,0.75649947);
  kDiskKernel[28]=vec2(-0.168809,0.7396005);
  kDiskKernel[29]=vec2(-0.3793104,0.65698475);
  kDiskKernel[30]=vec2(-0.55610836,0.51599306);
  kDiskKernel[31]=vec2(-0.6834936,0.32915324);
  kDiskKernel[32]=vec2(-0.7501475,0.113066405);
  kDiskKernel[33]=vec2(-0.7501475,-0.11306671);
  kDiskKernel[34]=vec2(-0.6834936,-0.32915318);
  kDiskKernel[35]=vec2(-0.5561083,-0.5159932);
  kDiskKernel[36]=vec2(-0.37931028,-0.6569848);
  kDiskKernel[37]=vec2(-0.16880904,-0.7396005);
  kDiskKernel[38]=vec2(0.056691945,-0.7564994);
  kDiskKernel[39]=vec2(0.2771556,-0.7061799);
  kDiskKernel[40]=vec2(0.47299215,-0.59311366);
  kDiskKernel[41]=vec2(0.62680185,-0.4273462);
  kDiskKernel[42]=vec2(0.72491735,-0.22360711);
  kDiskKernel[43]=vec2(1.0,0.0);
  kDiskKernel[44]=vec2(0.9749279,0.22252093);
  kDiskKernel[45]=vec2(0.90096885,0.43388376);
  kDiskKernel[46]=vec2(0.7818315,0.6234898);
  kDiskKernel[47]=vec2(0.6234898,0.7818315);
  kDiskKernel[48]=vec2(0.43388364,0.9009689);
  kDiskKernel[49]=vec2(0.22252098,0.9749279);
  kDiskKernel[50]=vec2(0.0,1.0);
  kDiskKernel[51]=vec2(-0.22252095,0.9749279);
  kDiskKernel[52]=vec2(-0.43388385,0.90096885);
  kDiskKernel[53]=vec2(-0.62349,0.7818314);
  kDiskKernel[54]=vec2(-0.7818317,0.62348956);
  kDiskKernel[55]=vec2(-0.90096885,0.43388382);
  kDiskKernel[56]=vec2(-0.9749279,0.22252093);
  kDiskKernel[57]=vec2(-1.0,0.0);
  kDiskKernel[58]=vec2(-0.9749279,-0.22252087);
  kDiskKernel[59]=vec2(-0.90096885,-0.43388376);
  kDiskKernel[60]=vec2(-0.7818314,-0.6234899);
  kDiskKernel[61]=vec2(-0.6234896,-0.7818316);
  kDiskKernel[62]=vec2(-0.43388346,-0.900969);
  kDiskKernel[63]=vec2(-0.22252055,-0.974928);
  kDiskKernel[64]=vec2(0.0,-1.0);
  kDiskKernel[65]=vec2(0.2225215,-0.9749278);
  kDiskKernel[66]=vec2(0.4338835,-0.90096897);
  kDiskKernel[67]=vec2(0.6234897,-0.7818316);
  kDiskKernel[68]=vec2(0.78183144,-0.62348986);
  kDiskKernel[69]=vec2(0.90096885,-0.43388376);
  kDiskKernel[70]=vec2(0.9749279,-0.22252086);
}
#endif
uniform sampler2D u_cocTexture;
uniform vec2 u_cocTexelSize;
uniform float u_rcpAspect;
uniform float u_maxCoC;
varying vec2 v_uv;
void main() {
  initKernel();
  vec4 samp0=texture2D(u_cocTexture,v_uv);
  #ifndef USE_FLOAT
  samp0=samp0*2.0-1.0;
  samp0=sign(samp0)*samp0*samp0;
  #endif
  vec4 bgAcc=vec4(0.0);
  vec4 fgAcc=vec4(0.0);
  for(int si=0;
  si<kSampleCount;
  si++) {
    vec2 disp=kDiskKernel[si]*u_maxCoC;
    float dist=length(disp);
    vec2 duv=vec2(disp.x*u_rcpAspect,disp.y);
    vec4 samp=texture2D(u_cocTexture,v_uv+duv);
    #ifndef USE_FLOAT
    samp=samp*2.0-1.0;
    samp=sign(samp)*samp*samp;
    #endif
    float bgCoC=max(min(samp0.a,samp.a),0.0);
    float margin=u_cocTexelSize.y*2.0;
    float bgWeight=clamp((bgCoC-dist+margin)/margin,0.0,1.0);
    float fgWeight=clamp((-samp.a-dist+margin)/margin,0.0,1.0);
    fgWeight*=step(u_cocTexelSize.y,-samp.a);
    bgAcc+=vec4(samp.rgb,1.0)*bgWeight;
    fgAcc+=vec4(samp.rgb,1.0)*fgWeight;
  }
bgAcc.rgb/=bgAcc.a+step(bgAcc.a,0.0);
fgAcc.rgb/=fgAcc.a+step(fgAcc.a,0.0);
bgAcc.a=smoothstep(u_cocTexelSize.y,u_cocTexelSize.y*2.0,samp0.a);
fgAcc.a*=3.14159265359/float(kSampleCount);
vec3 rgb=vec3(0.0);
rgb=mix(rgb,bgAcc.rgb,clamp(bgAcc.a,0.0,1.0));
rgb=mix(rgb,fgAcc.rgb,clamp(fgAcc.a,0.0,1.0));
float alpha=(1.0-clamp(bgAcc.a,0.0,1.0))*(1.0-clamp(fgAcc.a,0.0,1.0));
gl_FragColor=vec4(rgb,alpha);
}

// ===================== BLOCK 42 =====================
#define GLSLIFY 1
uniform sampler2D u_bokehTexture;
uniform vec2 u_bokehTexelSize;
varying vec2 v_uv;
void main() {
  vec4 duv=u_bokehTexelSize.xyxy*vec4(1.0,1.0,-1.0,0.0);
  vec4 acc;
  acc=texture2D(u_bokehTexture,v_uv-duv.xy);
  acc+=texture2D(u_bokehTexture,v_uv-duv.wy)*2.0;
  acc+=texture2D(u_bokehTexture,v_uv-duv.zy);
  acc+=texture2D(u_bokehTexture,v_uv+duv.zw)*2.0;
  acc+=texture2D(u_bokehTexture,v_uv)*4.0;
  acc+=texture2D(u_bokehTexture,v_uv+duv.xw)*2.0;
  acc+=texture2D(u_bokehTexture,v_uv+duv.zy);
  acc+=texture2D(u_bokehTexture,v_uv+duv.wy)*2.0;
  acc+=texture2D(u_bokehTexture,v_uv+duv.xy);
  gl_FragColor=acc*0.0625;
}

// ===================== BLOCK 43 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_texture;
uniform sampler2D u_blurTexture;
uniform float u_amount;
void main() {
  vec4 cs=texture2D(u_texture,v_uv);
  vec4 cb=texture2D(u_blurTexture,v_uv);
  vec3 rgb=cs.rgb*cb.a+cb.rgb;
  gl_FragColor=mix(cs,vec4(rgb,cs.a),u_amount);
}

// ===================== BLOCK 44 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_texture;
uniform sampler2D u_blurTexture0;
#if ITERATION > 1
uniform sampler2D u_blurTexture1;
#endif
#if ITERATION > 2
uniform sampler2D u_blurTexture2;
#endif
#if ITERATION > 3
uniform sampler2D u_blurTexture3;
#endif
#if ITERATION > 4
uniform sampler2D u_blurTexture4;
#endif
uniform float u_bloomWeights[ITERATION];
uniform float u_saturation;
#include <common>
vec3 dithering(vec3 color) {
  float grid_position=rand(gl_FragCoord.xy);
  vec3 dither_shift_RGB=vec3(0.25/255.0,-0.25/255.0,0.25/255.0);
  dither_shift_RGB=mix(2.0*dither_shift_RGB,-2.0*dither_shift_RGB,grid_position);
  return color+dither_shift_RGB;
}
void main() {
  vec4 color=texture2D(u_texture,v_uv);
  vec3 bloomColor=(u_bloomWeights[0]*texture2D(u_blurTexture0,v_uv)
  #if ITERATION > 1
  +u_bloomWeights[1]*texture2D(u_blurTexture1,v_uv)
  #endif
  #if ITERATION > 2
  +u_bloomWeights[2]*texture2D(u_blurTexture2,v_uv)
  #endif
  #if ITERATION > 3
  +u_bloomWeights[3]*texture2D(u_blurTexture3,v_uv)
  #endif
  #if ITERATION > 4
  +u_bloomWeights[4]*texture2D(u_blurTexture4,v_uv)
  #endif
  ).rgb;
  float luma=dot(bloomColor,vec3(0.299,0.587,0.114));
  color.rgb+=mix(vec3(luma),bloomColor,u_saturation);
  color.rgb=dithering(color.rgb);
  gl_FragColor=color;
}

// ===================== BLOCK 45 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform float u_luminosityThreshold;
uniform float u_smoothWidth;
uniform float u_lumaStrength;
uniform float u_selectiveStrength;
#ifdef USE_HALO
uniform vec2 u_texelSize;
uniform vec2 u_aspect;
uniform float u_haloWidth;
uniform float u_haloRGBShift;
uniform vec3 u_haloLeftColor;
uniform vec3 u_haloMidColor;
uniform vec3 u_haloRightColor;
uniform float u_haloStrength;
uniform float u_haloMaskInner;
uniform float u_haloMaskOuter;
#ifdef USE_LENS_DIRT
uniform sampler2D u_dirtTexture;
uniform vec2 u_dirtAspect;
#endif
#endif
#ifdef USE_CONVOLUTION
uniform float u_convolutionBuffer;
#endif
varying vec2 v_uv;
void main() {
  vec2 uv=v_uv;
  #ifdef USE_CONVOLUTION
  uv=(uv-0.5)*(1.0+u_convolutionBuffer)+0.5;
  #endif
  vec4 texel=texture2D(u_texture,uv);
  float luma=dot(texel.xyz,vec3(0.299,0.587,0.114));
  float alpha=smoothstep(u_luminosityThreshold,u_luminosityThreshold+u_smoothWidth,luma);
  vec3 color=texel.rgb*(alpha*u_lumaStrength+texel.a*u_selectiveStrength);
  gl_FragColor=vec4(color,1.0);
  #ifdef USE_HALO
  vec2 toCenter=(uv-0.5)*u_aspect;
  vec2 ghostUv=1.0-(toCenter+0.5);
  vec2 ghostVec=(vec2(0.5)-ghostUv);
  vec2 direction=normalize(ghostVec);
  vec2 haloVec=direction*u_haloWidth;
  float weight=length(vec2(0.5)-fract(ghostUv+haloVec));
  weight=pow(1.0-weight,3.0);
  vec3 distortion=vec3(-u_texelSize.x,0.0,u_texelSize.x)*u_haloRGBShift;
  float zoomBlurRatio=fract(atan(toCenter.y,toCenter.x)*40.0)*0.05+0.95;
  ghostUv*=zoomBlurRatio;
  vec2 haloUv=ghostUv+haloVec;
  vec3 halo=(texture2D(u_texture,haloUv+direction*distortion.r).rgb*u_haloLeftColor+texture2D(u_texture,haloUv+direction*distortion.g).rgb*u_haloMidColor+texture2D(u_texture,haloUv+direction*distortion.b).rgb*u_haloRightColor)*u_haloStrength*smoothstep(u_haloMaskInner,u_haloMaskOuter,length(toCenter));
  #ifdef USE_LENS_DIRT
  vec2 dirtUv=(uv-0.5)*u_dirtAspect+0.5;
  vec3 dirt=texture2D(u_dirtTexture,dirtUv).rgb;
  gl_FragColor.rgb+=(halo+alpha+0.05*dirt)*dirt;
  #else
  gl_FragColor.rgb+=halo;
  #endif
  #endif
  #ifdef USE_CONVOLUTION
  gl_FragColor.rgb*=max(abs(uv.x-0.5),abs(uv.y-0.5))>0.5 ? 0. : 1.;
  #endif
}

// ===================== BLOCK 46 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_texture;
uniform vec2 u_resolution;
uniform vec2 u_direction;
float gaussianPdf(in float x,in float sigma) {
  return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}
void main() {
  vec2 invSize=1.0/u_resolution;
  float fSigma=float(SIGMA);
  float weightSum=gaussianPdf(0.0,fSigma);
  vec3 diffuseSum=texture2D(u_texture,v_uv).rgb*weightSum;
  for(int i=1;
  i<KERNEL_RADIUS;
  i++) {
    float x=float(i);
    float w=gaussianPdf(x,fSigma);
    vec2 uvOffset=u_direction*invSize*x;
    vec3 sample1=texture2D(u_texture,v_uv+uvOffset).rgb;
    vec3 sample2=texture2D(u_texture,v_uv-uvOffset).rgb;
    diffuseSum+=(sample1+sample2)*w;
    weightSum+=2.0*w;
  }
gl_FragColor=vec4(diffuseSum/weightSum,1.0);
}

// ===================== BLOCK 47 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec2 u_texelSize;
uniform float u_subtransformSize,u_normalization;
uniform bool u_isHorizontal,u_isForward;
const float TWOPI=6.283185307179586;
void main() {
  float index=(u_isHorizontal ? gl_FragCoord.x : gl_FragCoord.y)-0.5;
  float evenIndex=floor(index/u_subtransformSize)*(u_subtransformSize*0.5)+mod(index,u_subtransformSize*0.5)+0.5;
  vec2 evenPos=(u_isHorizontal ? vec2(evenIndex,gl_FragCoord.y): vec2(gl_FragCoord.x,evenIndex))*u_texelSize;
  vec2 oddPos=evenPos+vec2(u_isHorizontal,!u_isHorizontal)*.5;
  vec4 even=texture2D(u_texture,evenPos);
  vec4 odd=texture2D(u_texture,oddPos);
  float twiddleArgument=(u_isForward ? TWOPI :-TWOPI)*(index/u_subtransformSize);
  vec2 twiddle=vec2(cos(twiddleArgument),sin(twiddleArgument));
  gl_FragColor=(even.rgba+vec4(twiddle.x*odd.xz-twiddle.y*odd.yw,twiddle.y*odd.xz+twiddle.x*odd.yw).xzyw)*u_normalization;
}

// ===================== BLOCK 48 =====================
#define GLSLIFY 1
uniform vec2 u_aspect;
varying vec2 v_uv;
void main() {
  vec2 toCenter=(fract(v_uv+0.5)-0.5)*0.35*u_aspect;
  vec2 rotToCenter=mat2(0.7071067811865476,-0.7071067811865476,0.7071067811865476,0.7071067811865476)*toCenter;
  float res=exp(-length(toCenter)*2.0)*0.02+exp(-length(toCenter)*15.0)*0.5+exp(-length(toCenter)*50.0)*3.+exp(-length(rotToCenter*vec2(1.0,8.0))*75.0)*8.+exp(-length(rotToCenter*vec2(8.0,1.0))*75.0)*8.+exp(-length(rotToCenter*vec2(1.0,20.0))*150.0)*40.+exp(-length(rotToCenter*vec2(20.0,1.0))*150.0)*40.+exp(-length(toCenter*vec2(1.0,10.0))*60.0)*8.+exp(-length(toCenter*vec2(10.0,1.0))*60.0)*8.+exp(-length(toCenter*vec2(1.0,20.0))*120.0)*75.+exp(-length(toCenter*vec2(20.0,1.0))*120.0)*75.;
  gl_FragColor=vec4(res,0.0,res,0.0);
}

// ===================== BLOCK 49 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_texture;
uniform sampler2D u_kernelTexture;
void main() {
  vec4 a=texture2D(u_texture,v_uv);
  vec4 b=texture2D(u_kernelTexture,v_uv);
  gl_FragColor=vec4(a.xz*b.xz-a.yw*b.yw,a.xz*b.yw+a.yw*b.xz).xzyw;
}

// ===================== BLOCK 50 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform float u_amount;
varying vec2 v_uv;
void main() {
  gl_FragColor=texture2D(u_texture,v_uv)*u_amount;
}

// ===================== BLOCK 51 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_texture;
uniform sampler2D u_bloomTexture;
uniform float u_convolutionBuffer;
uniform float u_saturation;
#include <common>
vec3 dithering(vec3 color) {
  float grid_position=rand(gl_FragCoord.xy);
  vec3 dither_shift_RGB=vec3(0.25/255.0,-0.25/255.0,0.25/255.0);
  dither_shift_RGB=mix(2.0*dither_shift_RGB,-2.0*dither_shift_RGB,grid_position);
  return color+dither_shift_RGB;
}
void main() {
  vec4 color=texture2D(u_texture,v_uv);
  vec2 bloomUv=(v_uv-0.5)*(1.0-u_convolutionBuffer)+0.5;
  vec3 bloomColor=texture2D(u_bloomTexture,bloomUv).rgb;
  float luma=dot(bloomColor,vec3(0.299,0.587,0.114));
  color.rgb+=mix(vec3(luma),bloomColor,u_saturation);
  color.rgb=dithering(color.rgb);
  gl_FragColor=color;
}

// ===================== BLOCK 52 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform sampler2D u_screenPaintTexture;
uniform vec2 u_screenPaintTexelSize;
uniform float u_amount;
uniform float u_rgbShift;
uniform float u_multiplier;
uniform float u_colorMultiplier;
uniform float u_shade;
varying vec2 v_uv;
#include <getBlueNoise>
void main() {
  vec3 bnoise=getBlueNoise(gl_FragCoord.xy+vec2(17.,29.));
  vec4 data=texture2D(u_screenPaintTexture,v_uv);
  float weight=(data.z+data.w)*0.5;
  vec2 vel=(0.5-data.xy-0.001)*2.*weight;
  vec4 color=vec4(0.0);
  vec2 velocity=vel*u_amount/4.0*u_screenPaintTexelSize*u_multiplier;
  vec2 uv=v_uv+bnoise.xy*velocity;
  for(int i=0;
  i<9;
  i++) {
    color+=texture2D(u_texture,uv);
    uv+=velocity;
  }
color/=9.;
color.rgb+=sin(vec3(vel.x+vel.y)*40.0+vec3(0.0,2.0,4.0)*u_rgbShift)*smoothstep(0.4,-0.9,weight)*u_shade*max(abs(vel.x),abs(vel.y))*u_colorMultiplier;
gl_FragColor=color;
}

// ===================== BLOCK 53 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_texture;
uniform vec3 u_bgColor;
uniform float u_opacity;
uniform float u_vignetteFrom;
uniform float u_vignetteTo;
uniform vec2 u_vignetteAspect;
uniform vec3 u_vignetteColor;
uniform float u_saturation;
uniform float u_contrast;
uniform float u_brightness;
uniform vec3 u_tintColor;
uniform float u_tintOpacity;
uniform float u_ditherSeed;
uniform float u_debugAlpha;
float hash13(vec3 p3) {
  p3=fract(p3*.1031);
  p3+=dot(p3,p3.yzx+33.33);
  return fract((p3.x+p3.y)*p3.z);
}
vec3 screen(vec3 cb,vec3 cs) {
  return cb+cs-(cb*cs);
}
vec3 colorDodge(vec3 cb,vec3 cs) {
  return mix(min(vec3(1.0),cb/(1.0-cs)),vec3(1.0),step(vec3(1.0),cs));
}
void main() {
  vec2 uv=v_uv;
  vec4 texel=pow(texture2D(u_texture,uv),vec4(2.2));
  vec3 color=texel.rgb;
  float luma=dot(color,vec3(0.299,0.587,0.114));
  color=mix(vec3(luma),color,1.0+u_saturation);
  color=clamp(0.5+(1.0+u_contrast)*(color-0.5),0.,1.);
  color+=u_brightness;
  color=mix(color,screen(colorDodge(color,u_tintColor),u_tintColor),u_tintOpacity);
  float d=length((uv-0.5)*u_vignetteAspect)*2.0;
  color=mix(color,u_vignetteColor,smoothstep(u_vignetteFrom,u_vignetteTo,d));
  gl_FragColor=vec4(mix(u_bgColor,color,u_opacity),1.0);
  gl_FragColor.rgb=mix(gl_FragColor.rgb,texel.aaa,u_debugAlpha);
  gl_FragColor.rgb=min(vec3(1.),pow(gl_FragColor.rgb,vec3(1.0/2.2))+hash13(vec3(gl_FragCoord.xy,u_ditherSeed))/255.0);
}

// ===================== BLOCK 54 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_texture;
uniform float u_hideRatio;
uniform float u_maskRatio;
uniform vec2 u_resolution;
uniform vec2 u_viewportResolution;
#include <getBlueNoise>
#include <sampleBlurSRGB>
void main() {
  vec3 bnoise=getBlueNoise(gl_FragCoord.xy);
  float a=u_resolution.x/u_resolution.y*0.2;
  float l=1.+a;
  float s=0.6;
  float x=v_uv.y+v_uv.x*a;
  float mask=smoothstep(0.,s,u_maskRatio*(l+s)-x)*smoothstep(s,0.,(u_maskRatio-1.)*(l+s)-x);
  float blurRadius=pow((1.-x/l),2.)*50.*u_viewportResolution.y/1080.*(1.-u_hideRatio);
  vec3 sceneColor=sampleBlurSRGB(u_texture,v_uv,1./u_resolution,blurRadius,bnoise.z).rgb;
  vec3 color=mix(vec3(0.0676,0.1063,0.0429),sceneColor,mask);
  gl_FragColor=vec4(pow(color,vec3(1.0/2.2)),1.);
}

// ===================== BLOCK 55 =====================
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

// ===================== BLOCK 56 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform sampler2D u_historyTexture;
uniform highp sampler2D u_velocityTexture;
uniform vec2 u_resolution;
uniform float u_historyWeight;
varying vec2 v_uv;
vec2 unpackRGBATo2Half(const in vec4 v) {
  return vec2(v.x+(v.y/255.0),v.z+(v.w/255.0));
}
vec4 AdjustHDRColor(vec4 color) {
  float luminance=dot(color.rgb,vec3(0.299,0.587,0.114));
  float luminanceWeight=1.0/(1.0+luminance);
  return vec4(color.rgb*luminanceWeight,color.a);
}
vec4 SampleHistoryCatmullRom(sampler2D tex,vec2 uv,vec2 texelSize) {
  vec2 position=uv*u_resolution;
  vec2 centerPosition=floor(position-0.5)+0.5;
  vec2 f=position-centerPosition;
  vec2 f2=f*f;
  vec2 f3=f2*f;
  vec2 w0=f2-0.5*(f3+f);
  vec2 w1=1.5*f3-2.5*f2+1.0;
  vec2 w3=0.5*(f3-f2);
  vec2 w2=1.0-w0-w1-w3;
  vec2 s0=w0+w1;
  vec2 s1=w2+w3;
  vec2 f0=w1/s0;
  vec2 f1=w3/s1;
  vec2 t0=(centerPosition-1.0+f0)*texelSize;
  vec2 t1=(centerPosition+1.0+f1)*texelSize;
  return(texture2D(tex,vec2(t0.x,t0.y))*s0.x+texture2D(tex,vec2(t1.x,t0.y))*s1.x)*s0.y+(texture2D(tex,vec2(t0.x,t1.y))*s0.x+texture2D(tex,vec2(t1.x,t1.y))*s1.x)*s1.y;
}
void main() {
  vec2 texelSize=1.0/u_resolution;
  vec4 velocityRaw=texture2D(u_velocityTexture,v_uv);
  vec2 velocity=unpackRGBATo2Half(velocityRaw)-0.5;
  vec2 previousPixelPos=v_uv-velocity;
  vec4 currentColor=texture2D(u_texture,v_uv);
  vec4 historyColorWeighted=SampleHistoryCatmullRom(u_historyTexture,previousPixelPos,texelSize);
  if(any(lessThan(previousPixelPos,vec2(0.0)))||any(greaterThan(previousPixelPos,vec2(1.0)))) {
    historyColorWeighted=currentColor;
  }
vec4 minColor=vec4(9999.0);
vec4 maxColor=vec4(-9999.0);
for(int x=-1;
x<=1;
++x) {
  for(int y=-1;
  y<=1;
  ++y) {
    vec4 neighbor=texture2D(u_texture,v_uv+vec2(x,y)*texelSize);
    minColor=min(minColor,neighbor);
    maxColor=max(maxColor,neighbor);
  }
}
historyColorWeighted=clamp(historyColorWeighted,minColor,maxColor);
vec4 blendedColor=(currentColor*(1.0-u_historyWeight)+historyColorWeighted*u_historyWeight);
gl_FragColor=blendedColor;
}

// ===================== BLOCK 57 =====================
#define GLSLIFY 1
#define FXAA_QUALITY_P0 1.0
#define FXAA_QUALITY_P1 1.5
#define FXAA_QUALITY_P2 2.0
#define FXAA_QUALITY_P3 4.0
#define FXAA_QUALITY_P4 12.0
#define FxaaBool bool
#define FxaaFloat float
#define FxaaFloat2 vec2
#define FxaaFloat3 vec3
#define FxaaFloat4 vec4
#define FxaaHalf float
#define FxaaHalf2 vec2
#define FxaaHalf3 vec3
#define FxaaHalf4 vec4
#define FxaaInt2 vec2
#define FxaaTex sampler2D
#define FxaaSat(x) clamp(x, 0.0, 1.0)
#define FxaaTexTop(t, p) texture2D(t, p)
#define FxaaTexOff(t, p, o, r) texture2D(t, p + (o * r))
FxaaFloat FxaaLuma(FxaaFloat4 rgba) {
  return rgba.y;
}
FxaaFloat4 FxaaPixelShader(FxaaFloat2 pos,FxaaTex tex,FxaaFloat2 fxaaQualityRcpFrame,FxaaFloat fxaaQualitySubpix,FxaaFloat fxaaQualityEdgeThreshold,FxaaFloat fxaaQualityEdgeThresholdMin) {
  FxaaFloat2 posM;
  posM.x=pos.x;
  posM.y=pos.y;
  FxaaFloat4 rgbyM=FxaaTexTop(tex,posM);
  #define lumaM rgbyM.y
  FxaaFloat lumaS=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(0,1),fxaaQualityRcpFrame.xy));
  FxaaFloat lumaE=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(1,0),fxaaQualityRcpFrame.xy));
  FxaaFloat lumaN=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(0,-1),fxaaQualityRcpFrame.xy));
  FxaaFloat lumaW=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(-1,0),fxaaQualityRcpFrame.xy));
  FxaaFloat maxSM=max(lumaS,lumaM);
  FxaaFloat minSM=min(lumaS,lumaM);
  FxaaFloat maxESM=max(lumaE,maxSM);
  FxaaFloat minESM=min(lumaE,minSM);
  FxaaFloat maxWN=max(lumaN,lumaW);
  FxaaFloat minWN=min(lumaN,lumaW);
  FxaaFloat rangeMax=max(maxWN,maxESM);
  FxaaFloat rangeMin=min(minWN,minESM);
  FxaaFloat rangeMaxScaled=rangeMax*fxaaQualityEdgeThreshold;
  FxaaFloat range=rangeMax-rangeMin;
  FxaaFloat rangeMaxClamped=max(fxaaQualityEdgeThresholdMin,rangeMaxScaled);
  FxaaBool earlyExit=range<rangeMaxClamped;
  if(earlyExit)return rgbyM;
  FxaaFloat lumaNW=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(-1,-1),fxaaQualityRcpFrame.xy));
  FxaaFloat lumaSE=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(1,1),fxaaQualityRcpFrame.xy));
  FxaaFloat lumaNE=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(1,-1),fxaaQualityRcpFrame.xy));
  FxaaFloat lumaSW=FxaaLuma(FxaaTexOff(tex,posM,FxaaInt2(-1,1),fxaaQualityRcpFrame.xy));
  FxaaFloat lumaNS=lumaN+lumaS;
  FxaaFloat lumaWE=lumaW+lumaE;
  FxaaFloat subpixRcpRange=1.0/range;
  FxaaFloat subpixNSWE=lumaNS+lumaWE;
  FxaaFloat edgeHorz1=(-2.0*lumaM)+lumaNS;
  FxaaFloat edgeVert1=(-2.0*lumaM)+lumaWE;
  FxaaFloat lumaNESE=lumaNE+lumaSE;
  FxaaFloat lumaNWNE=lumaNW+lumaNE;
  FxaaFloat edgeHorz2=(-2.0*lumaE)+lumaNESE;
  FxaaFloat edgeVert2=(-2.0*lumaN)+lumaNWNE;
  FxaaFloat lumaNWSW=lumaNW+lumaSW;
  FxaaFloat lumaSWSE=lumaSW+lumaSE;
  FxaaFloat edgeHorz4=(abs(edgeHorz1)*2.0)+abs(edgeHorz2);
  FxaaFloat edgeVert4=(abs(edgeVert1)*2.0)+abs(edgeVert2);
  FxaaFloat edgeHorz3=(-2.0*lumaW)+lumaNWSW;
  FxaaFloat edgeVert3=(-2.0*lumaS)+lumaSWSE;
  FxaaFloat edgeHorz=abs(edgeHorz3)+edgeHorz4;
  FxaaFloat edgeVert=abs(edgeVert3)+edgeVert4;
  FxaaFloat subpixNWSWNESE=lumaNWSW+lumaNESE;
  FxaaFloat lengthSign=fxaaQualityRcpFrame.x;
  FxaaBool horzSpan=edgeHorz>=edgeVert;
  FxaaFloat subpixA=subpixNSWE*2.0+subpixNWSWNESE;
  if(!horzSpan)lumaN=lumaW;
  if(!horzSpan)lumaS=lumaE;
  if(horzSpan)lengthSign=fxaaQualityRcpFrame.y;
  FxaaFloat subpixB=(subpixA*(1.0/12.0))-lumaM;
  FxaaFloat gradientN=lumaN-lumaM;
  FxaaFloat gradientS=lumaS-lumaM;
  FxaaFloat lumaNN=lumaN+lumaM;
  FxaaFloat lumaSS=lumaS+lumaM;
  FxaaBool pairN=abs(gradientN)>=abs(gradientS);
  FxaaFloat gradient=max(abs(gradientN),abs(gradientS));
  if(pairN)lengthSign=-lengthSign;
  FxaaFloat subpixC=FxaaSat(abs(subpixB)*subpixRcpRange);
  FxaaFloat2 posB;
  posB.x=posM.x;
  posB.y=posM.y;
  FxaaFloat2 offNP;
  offNP.x=(!horzSpan)? 0.0 : fxaaQualityRcpFrame.x;
  offNP.y=(horzSpan)? 0.0 : fxaaQualityRcpFrame.y;
  if(!horzSpan)posB.x+=lengthSign*0.5;
  if(horzSpan)posB.y+=lengthSign*0.5;
  FxaaFloat2 posN;
  posN.x=posB.x-offNP.x*FXAA_QUALITY_P0;
  posN.y=posB.y-offNP.y*FXAA_QUALITY_P0;
  FxaaFloat2 posP;
  posP.x=posB.x+offNP.x*FXAA_QUALITY_P0;
  posP.y=posB.y+offNP.y*FXAA_QUALITY_P0;
  FxaaFloat subpixD=((-2.0)*subpixC)+3.0;
  FxaaFloat lumaEndN=FxaaLuma(FxaaTexTop(tex,posN));
  FxaaFloat subpixE=subpixC*subpixC;
  FxaaFloat lumaEndP=FxaaLuma(FxaaTexTop(tex,posP));
  if(!pairN)lumaNN=lumaSS;
  FxaaFloat gradientScaled=gradient*1.0/4.0;
  FxaaFloat lumaMM=lumaM-lumaNN*0.5;
  FxaaFloat subpixF=subpixD*subpixE;
  FxaaBool lumaMLTZero=lumaMM<0.0;
  lumaEndN-=lumaNN*0.5;
  lumaEndP-=lumaNN*0.5;
  FxaaBool doneN=abs(lumaEndN)>=gradientScaled;
  FxaaBool doneP=abs(lumaEndP)>=gradientScaled;
  if(!doneN)posN.x-=offNP.x*FXAA_QUALITY_P1;
  if(!doneN)posN.y-=offNP.y*FXAA_QUALITY_P1;
  FxaaBool doneNP=(!doneN)||(!doneP);
  if(!doneP)posP.x+=offNP.x*FXAA_QUALITY_P1;
  if(!doneP)posP.y+=offNP.y*FXAA_QUALITY_P1;
  if(doneNP) {
    if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));
    if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));
    if(!doneN)lumaEndN=lumaEndN-lumaNN*0.5;
    if(!doneP)lumaEndP=lumaEndP-lumaNN*0.5;
    doneN=abs(lumaEndN)>=gradientScaled;
    doneP=abs(lumaEndP)>=gradientScaled;
    if(!doneN)posN.x-=offNP.x*FXAA_QUALITY_P2;
    if(!doneN)posN.y-=offNP.y*FXAA_QUALITY_P2;
    doneNP=(!doneN)||(!doneP);
    if(!doneP)posP.x+=offNP.x*FXAA_QUALITY_P2;
    if(!doneP)posP.y+=offNP.y*FXAA_QUALITY_P2;
    if(doneNP) {
      if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));
      if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));
      if(!doneN)lumaEndN=lumaEndN-lumaNN*0.5;
      if(!doneP)lumaEndP=lumaEndP-lumaNN*0.5;
      doneN=abs(lumaEndN)>=gradientScaled;
      doneP=abs(lumaEndP)>=gradientScaled;
      if(!doneN)posN.x-=offNP.x*FXAA_QUALITY_P3;
      if(!doneN)posN.y-=offNP.y*FXAA_QUALITY_P3;
      doneNP=(!doneN)||(!doneP);
      if(!doneP)posP.x+=offNP.x*FXAA_QUALITY_P3;
      if(!doneP)posP.y+=offNP.y*FXAA_QUALITY_P3;
      if(doneNP) {
        if(!doneN)lumaEndN=FxaaLuma(FxaaTexTop(tex,posN.xy));
        if(!doneP)lumaEndP=FxaaLuma(FxaaTexTop(tex,posP.xy));
        if(!doneN)lumaEndN=lumaEndN-lumaNN*0.5;
        if(!doneP)lumaEndP=lumaEndP-lumaNN*0.5;
        doneN=abs(lumaEndN)>=gradientScaled;
        doneP=abs(lumaEndP)>=gradientScaled;
        if(!doneN)posN.x-=offNP.x*FXAA_QUALITY_P4;
        if(!doneN)posN.y-=offNP.y*FXAA_QUALITY_P4;
        doneNP=(!doneN)||(!doneP);
        if(!doneP)posP.x+=offNP.x*FXAA_QUALITY_P4;
        if(!doneP)posP.y+=offNP.y*FXAA_QUALITY_P4;
      }
  }
}
FxaaFloat dstN=posM.x-posN.x;
FxaaFloat dstP=posP.x-posM.x;
if(!horzSpan)dstN=posM.y-posN.y;
if(!horzSpan)dstP=posP.y-posM.y;
FxaaBool goodSpanN=(lumaEndN<0.0)!=lumaMLTZero;
FxaaFloat spanLength=(dstP+dstN);
FxaaBool goodSpanP=(lumaEndP<0.0)!=lumaMLTZero;
FxaaFloat spanLengthRcp=1.0/spanLength;
FxaaBool directionN=dstN<dstP;
FxaaFloat dst=min(dstN,dstP);
FxaaBool goodSpan=directionN ? goodSpanN : goodSpanP;
FxaaFloat subpixG=subpixF*subpixF;
FxaaFloat pixelOffset=(dst*(-spanLengthRcp))+0.5;
FxaaFloat subpixH=subpixG*fxaaQualitySubpix;
FxaaFloat pixelOffsetGood=goodSpan ? pixelOffset : 0.0;
FxaaFloat pixelOffsetSubpix=max(pixelOffsetGood,subpixH);
if(!horzSpan)posM.x+=pixelOffsetSubpix*lengthSign;
if(horzSpan)posM.y+=pixelOffsetSubpix*lengthSign;
return FxaaFloat4(FxaaTexTop(tex,posM).xyz,lumaM);
}
varying vec2 v_uv;
uniform sampler2D u_texture;
uniform vec2 u_texelSize;
const float fxaaQualitySubpix=0.5;
const float fxaaQualityEdgeThreshold=0.125;
const float fxaaQualityEdgeThresholdMin=0.0833;
void main() {
  vec2 fxaaQualityRcpFrame=u_texelSize;
  vec4 color=FxaaPixelShader(v_uv,u_texture,fxaaQualityRcpFrame,fxaaQualitySubpix,fxaaQualityEdgeThreshold,fxaaQualityEdgeThresholdMin);
  #ifdef SKIP_ALPHA
  float alpha=texture2D(u_texture,v_uv).a;
  gl_FragColor=vec4(color.rgb,alpha);
  #else
  gl_FragColor=color;
  #endif
}

// ===================== BLOCK 58 =====================
#define GLSLIFY 1
#ifdef IS_COVER
attribute float Cd;
varying float v_ao;
#else
varying vec2 v_uv;
#ifdef IS_LABEL
varying vec2 v_labelUv;
#endif
#endif
varying vec3 v_viewNormal;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
#include <taaJitteringVert>
void main() {
  vec3 pos=position;
  vec4 viewPosition=modelViewMatrix*vec4(pos,1.0);
  getTAAPositions(pos,gl_Position,v_currentFramePosition,v_previousFramePosition);
  v_viewNormal=normalMatrix*normal;
  v_modelPosition=position;
  v_worldPosition=(modelMatrix*vec4(pos,1.0)).xyz;
  v_viewPosition=-viewPosition.xyz;
  #ifdef IS_COVER
  v_ao=Cd;
  #else
  v_uv=uv*vec2(.5,1.);
  #ifdef IS_LABEL
  v_uv.x+=.5;
  v_labelUv=uv*vec2(2.,1.);
  #endif
  #endif
}

// ===================== BLOCK 59 =====================
#define GLSLIFY 1
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
uniform vec3 u_lightPosition;
uniform sampler2D u_specTexture;
uniform sampler2D u_brdfLut;
uniform vec3 u_smokePosition;
uniform vec2 u_bboxY;
uniform float u_alphaMultiplier;
uniform vec2 u_resolution;
varying float v_ao;
#include <taaJitteringFragPars>
#include <linearstep>
#include <thermodynamicPars>
#include <cart2Polar>
void main() {
  float smoke=distance(v_modelPosition,u_smokePosition);
  smoke=1.0/(1000.0*smoke*smoke+1.0);
  float unitHeight=(v_modelPosition.y-u_bboxY.x)/(u_bboxY.y-u_bboxY.x);
  vec3 viewNormal=normalize(v_viewNormal);
  vec3 N=normalize((vec4(viewNormal,0.)*viewMatrix).xyz);
  vec3 V=normalize(cameraPosition-v_worldPosition);
  vec3 reflection=normalize(reflect(-V,N));
  vec3 L=normalize(vec3(0.5,0.48,1.));
  float NdL=max(0.,dot(N,L));
  float NdV=clamp(abs(dot(N,V)),0.001,1.0);
  vec3 albedo=vec3(0.2);
  vec3 f0=vec3(0.04);
  float roughness=0.;
  float metallic=0.28;
  vec3 specularColor=mix(f0,albedo,metallic);
  vec3 brdf=texture2D(u_brdfLut,vec2(NdV,roughness)).rgb;
  reflection.xz=mat2(0.,-1.,1.,0.)*reflection.xz;
  vec4 specularMap=texture2D(u_specTexture,cart2Polar(reflection)+vec2(0.25,0.0));
  vec3 specularLight=specularMap.rgb*specularMap.a*4.*specularColor;
  vec3 color=specularLight*(specularColor*brdf.x+brdf.y);
  color+=vec3(pow(linearstep(0.9,1.0,NdL),8.))*vec3(1.,0.9,0.7)*0.5;
  color*v_ao;
  vec3 thermalGradient=0.1+pow(texture2D(u_thermalTexture,vec2(0.3+0.1*smoke+0.5*unitHeight*unitHeight,0.5)).rgb,vec3(2.2));
  gl_FragColor=vec4(pow(color,vec3(1./2.2)),(thermalGradient.g*0.5+smoothstep(0.5,1.,thermalGradient.r)*0.5)*u_alphaMultiplier);
  gl_FragColor.rgb=mix(gl_FragColor.rgb,thermalGradient,getThermalFadeStep(u_resolution));
  #include <taaJitteringFrag>
}

// ===================== BLOCK 60 =====================
#define GLSLIFY 1
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
uniform sampler2D u_baseTexture;
uniform sampler2D u_harmonics0Texture;
uniform float u_strength;
uniform vec2 u_freq;
uniform float u_time;
uniform float u_shadow;
uniform vec3 u_lightPosition;
uniform vec3 u_position;
uniform float u_alphaMultiplier;
uniform vec2 u_resolution;
uniform mat4 u_coasterInvMatrix;
uniform mat4 modelMatrix;
#include <taaJitteringFragPars>
#include <hsb2rgb>
#include <rgb2hsb>
#include <sampleHarmonics>
#include <getBlueNoise>
#include <linearstep>
#include <thermodynamicPars>
#ifdef IS_LABEL
uniform sampler2D u_texture;
varying vec2 v_labelUv;
#endif
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec3 rgb=texture2D(u_baseTexture,v_uv).rgb;
  vec3 hsb=rgb2hsb(rgb);
  hsb.b+=sampleHarmonics(u_harmonics0Texture,v_uv,u_freq,u_time,u_strength);
  vec3 color=hsb2rgb(hsb);
  color=clamp(color,vec3(0.0),vec3(1.0));
  color=pow(color,vec3(1.3));
  #ifdef IS_CUP
  float bottomRatio=linearstep(.04,-.01,v_worldPosition.y-u_position.y);
  bottomRatio*=bottomRatio;
  color*=mix(vec3(1.),mix(vec3(0.,0.3,0.2),vec3(1.,0.3,0.),linearstep(0.,0.0075,u_position.y)),bottomRatio);
  #endif
  float luma=dot(color,vec3(0.2126,0.7152,0.0722));
  float thermalLevel=0.65+0.35*smoothstep(0.1,0.3,v_uv.x);
  vec3 thermalGradient=texture2D(u_thermalTexture,vec2(thermalLevel*(0.85+0.15*luma),0.5)).rgb;
  #ifdef IS_LABEL
  vec3 labelColor=pow(texture2D(u_texture,v_labelUv).rrr,vec3(2.2))*vec3(1.,0.9,0.85);
  thermalGradient=texture2D(u_thermalTexture,vec2(thermalLevel*0.72*(1.0-0.15*labelColor.r),0.5)).rgb;
  color*=mix(labelColor,vec3(1.),color.r*color.r*0.07);
  #endif
  thermalGradient=pow(0.1+thermalGradient,vec3(2.2));
  color=mix(color,thermalGradient,getThermalFadeStep(u_resolution));
  gl_FragColor=vec4(pow(color,vec3(1./2.2)),(thermalGradient.g*0.5+smoothstep(0.5,1.,thermalGradient.r)*0.5)*u_alphaMultiplier);
  #include <taaJitteringFrag>
}

// ===================== BLOCK 61 =====================
#define GLSLIFY 1
varying vec2 v_uv;
void main() {
  gl_Position=vec4(position.xy,0.0,1.0);
  v_uv=position.xy*0.5+0.5;
}

// ===================== BLOCK 62 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_sceneCacheTexture;
uniform vec2 u_resolution;
#include <thermodynamicPars>
void main() {
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  float thermalFadeStep=getThermalFadeStep(u_resolution);
  vec3 sceneCacheColor=texture2D(u_sceneCacheTexture,screenUv).rgb;
  float luma=dot(sceneCacheColor,vec3(0.299,0.587,0.114));
  luma=0.8*smoothstep(0.0,1.5,luma);
  vec3 thermalColor=0.1+pow(texture2D(u_thermalTexture,vec2(luma,0.5)).rgb,vec3(2.2));
  gl_FragColor.rgb=mix(sceneCacheColor,thermalColor,thermalFadeStep);
  gl_FragColor.a=0.;
}

// ===================== BLOCK 63 =====================
#define GLSLIFY 1
uniform sampler2D u_baseTexture;
uniform sampler2D u_harmonics0Texture;
uniform sampler2D u_harmonics1Texture;
uniform float u_strength;
uniform float u_time;
varying vec2 v_uv;
#include <sampleHarmonics>
void main() {
  vec3 color=texture2D(u_baseTexture,v_uv).rgb;
  float c=color.r+calcHarmonic(color.g,color.b,1.,u_time)*u_strength+sampleHarmonics(u_harmonics0Texture,v_uv,vec2(2.,3.),u_time,u_strength)+sampleHarmonics(u_harmonics1Texture,v_uv,vec2(4.,5.),u_time,u_strength);
  gl_FragColor=vec4(pow(vec3(c),vec3(1./2.2)),1.);
}

// ===================== BLOCK 64 =====================
#define GLSLIFY 1
varying vec2 v_uv;
void main() {
  vec3 pos=normalMatrix*position;
  vec4 mvPosition=modelViewMatrix*vec4(pos,1.0);
  gl_Position=projectionMatrix*mvPosition;
  v_uv=uv;
}

// ===================== BLOCK 65 =====================
#define GLSLIFY 1
varying vec2 v_uv;
uniform sampler2D u_smokeTexture;
uniform float u_alphaMultiplier;
uniform vec2 u_resolution;
#include <thermodynamicPars>
void main() {
  float s=texture2D(u_smokeTexture,v_uv).r;
  gl_FragColor=vec4(vec3(s*0.3+0.7),s*0.15);
  vec3 thermalGradient=texture2D(u_thermalTexture,vec2(s,0.5)).rgb;
  thermalGradient=pow(thermalGradient*0.6+0.4,vec3(2.2));
  gl_FragColor=mix(gl_FragColor,vec4(thermalGradient,s),getThermalFadeStep(u_resolution));
}

// ===================== BLOCK 66 =====================
, {
  onLoad:i=> {
    this._geometryLoad(e,i,t)
  }
}
)
}
_geometryLoad(e,t,i) {
  let r;
  switch(e) {
    case"LABEL":case"CUP":r=cupFrag;
    break;
    case"COVER":r=coverFrag,t.computeBoundingBox();
    break
  }
let o=Object.assign( {
  u_resolution:properties.sharedUniforms.u_resolution
}
,this.sharedUniforms,thermodynamicOverlay.sharedUniforms,blueNoise.sharedUniforms,e==="COVER"? {
  u_smokePosition: {
    value:this.smokePosition
  }
,u_bboxY: {
  value:new Vector2(t.boundingBox.min.y,t.boundingBox.max.y)
}
}
: {
}
),a=new ShaderMaterial( {
  vertexShader:vert$c,fragmentShader:r,uniforms:o
}
),l=new TAAMesh(t,a);
switch(e) {
  case"CUP":a.defines.IS_CUP=!0,this.cupMesh=l;
  break;
  case"COVER":a.uniforms.u_brdfLut=properties.sharedUniforms.u_brdfLut,a.uniforms.u_specTexture= {
    value:i
  }
,a.defines.IS_COVER=!0,this.coverMesh=l;
let u=this.dummyMesh=new Mesh(t,new ShaderMaterial( {
  uniforms: {
  }
,vertexShader:"void main()  {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.);
}
",fragmentShader:"void main()  {
  gl_FragColor = vec4(1.);
}
"
}
));
cameraControls.initClippingMesh(u);
break;
case"LABEL":a.uniforms.u_texture= {
  value:i
}
,a.defines.IS_LABEL=!0,this.labelMesh=l
}
this.container.add(l),cameraControls.initClippingMesh(l)
}
init() {
  let e=properties.loader.load(settings.TEXTURE_PATH+"coffee/cover-specular.webp", {
    type:"texture",colorSpace:SRGBColorSpace,wrap:RepeatWrapping
  }
).content,t=properties.loader.load(settings.TEXTURE_PATH+"coffee/LABEL.webp", {
  type:"texture",channel:1,autoMobile:!0
}
).content;
this.sharedUniforms.u_baseTexture.value=properties.loader.load(settings.TEXTURE_PATH+"coffee/BASE_COLOR.webp", {
  type:"texture",colorSpace:SRGBColorSpace,mipFilter:LinearFilter,magFilter:LinearFilter,autoMobile:!0
}
).content,this.sharedUniforms.u_harmonics0Texture.value=properties.loader.load(settings.TEXTURE_PATH+"coffee/BASE_HARMONICS_0_MOBILE.png", {
  type:"texture",mipFilter:NearestFilter,magFilter:NearestFilter
}
).content,this._loadGeoemtry("COVER",e),this._loadGeoemtry("CUP",null),this._loadGeoemtry("LABEL",t),_smokeBaseTexture=properties.loader.load(settings.TEXTURE_PATH+"coffee/smoke/base.webp", {
  type:"texture",mipFilter:NearestFilter,magFilter:NearestFilter
}
).content,_smokeHarmonics0Texture=properties.loader.load(settings.TEXTURE_PATH+"coffee/smoke/harmonics_0.webp", {
  type:"texture",mipFilter:NearestFilter,magFilter:NearestFilter
}
).content,_smokeHarmonics1Texture=properties.loader.load(settings.TEXTURE_PATH+"coffee/smoke/harmonics_1.webp", {
  type:"texture",mipFilter:NearestFilter,magFilter:NearestFilter
}
).content,_smokeRT=fboHelper.createRenderTarget(83,184),_smokeCacheMaterial=fboHelper.createRawShaderMaterial( {
  fragmentShader:smokeCacheFrag,uniforms:Object.assign( {
    u_baseTexture: {
      value:_smokeBaseTexture
    }
  ,u_harmonics0Texture: {
    value:_smokeHarmonics0Texture
  }
,u_harmonics1Texture: {
  value:_smokeHarmonics1Texture
}
,u_strength: {
  value:.322202
}
,u_time: {
  value:0
}
,u_resolution:properties.sharedUniforms.u_resolution
}
,thermodynamicOverlay.sharedUniforms)
}
);
let i=.15,r=new PlaneGeometry(84/184*i,i);
r.translate(0,.5*i,0);
let o=this.smokeMesh=new Mesh(r,new ShaderMaterial( {
  uniforms:Object.assign( {
    u_smokeTexture: {
      value:_smokeRT.texture
    }
  ,u_resolution:properties.sharedUniforms.u_resolution
}
,thermodynamicOverlay.sharedUniforms),vertexShader:smokeVert,fragmentShader:smokeFrag,blending:CustomBlending,blendEquation:AddEquation,blendSrc:SrcAlphaFactor,blendDst:OneMinusSrcAlphaFactor,blendEquationAlpha:AddEquation,blendDstAlpha:OneFactor,blendSrcAlpha:OneFactor,depthWrite:!1
}
));
o.position.copy(this.smokePosition),o.material.onBeforeRender=()=> {
  o.normalMatrix.invert()
}
,o.renderOrder=1,cameraControls.initClippingMesh(o),this.container.add(o)
}
resize(e,t) {
}
preUpdate(e) {
}
setClip;
update(e) {
  !this.cupMesh||!this.coverMesh||(this.container.visible=this.isActive,this.lightPosition.copy(coaster.lightPosition),this.sharedUniforms.u_time.value=this.cupTime*Math.PI*2,this.isActive&&(_smokeCacheMaterial.uniforms.u_time.value=properties.time*2,fboHelper.render(_smokeCacheMaterial,_smokeRT),this.dummyMesh&&(this.dummyMesh.position.copy(this.container.position),this.dummyMesh.quaternion.copy(this.container.quaternion)),this.sharedUniforms.u_position.value.copy(this.container.position),this.sharedUniforms.u_alphaMultiplier.value=this.alphaMultiplier))
}
postUpdate(e) {
}
}
const tableCoffee=new TableCoffee,coasterVert=

// ===================== BLOCK 67 =====================
#define GLSLIFY 1
#include <linearstep>
#include <textureBicubic>
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
varying float v_ao;
uniform sampler2D u_texture;
uniform sampler2D u_envTexture;
uniform sampler2D u_brdfLut;
uniform vec3 u_localLightPosition;
uniform vec2 u_textureSize;
uniform sampler2D u_goboTexture;
uniform mat4 u_goboMatrix;
uniform float u_goboOpacity;
uniform vec4 u_goboParams;
#include <getGoboBlurRatio>
uniform vec2 u_2DlightPos;
uniform vec2 u_resolution;
uniform sampler2D u_imgBasedTexture;
uniform float u_imgBasedOpacity;
uniform mat4 u_imgBasedMVP;
uniform float u_highlightRatio;
uniform float u_condomSceneRatio;
uniform float u_wearableBlendingRatio;
uniform float u_extraBumpScale;
uniform sampler2D u_lmsTexture;
uniform float u_time;
uniform float u_heroRatio;
float dot2(vec2 v) {
  return dot(v,v);
}
float sdCappedCone(vec2 q,float h,float r1,float r2) {
  vec2 k1=vec2(r2,h);
  vec2 k2=vec2(r2-r1,2.0*h);
  vec2 ca=vec2(q.x-min(q.x,(q.y<0.0)?r1:r2),abs(q.y)-h);
  vec2 cb=q-k1+k2*clamp(dot(k1-q,k2)/dot2(k2),0.0,1.0);
  float s=(cb.x<0.0&&ca.y<0.0)?-1.0 : 1.0;
  return s*sqrt(min(dot2(ca),dot2(cb)));
}
float opUnion(float d1,float d2) {
  return min(d1,d2);
}
float opSubtraction(float d1,float d2) {
  return max(-d1,d2);
}
float map(in vec3 pos) {
  vec2 q=vec2(length(pos.xz),pos.y);
  float c1=sdCappedCone(q+vec2(0.,-.0102),.007,.0412,.0446);
  float c2=sdCappedCone(q+vec2(0.,-.0016),.0015,.0385,.039);
  float c3=sdCappedCone(q+vec2(0.,-.0155),.008,.038,.0395);
  return opSubtraction(c3,opUnion(c1,c2));
}
float calcSoftshadow(in vec3 ro,in vec3 rd,float mint,float maxt,float w) {
  float res=1.0;
  float t=mint;
  for(int i=0;
  i<16&&t<maxt;
  i++) {
    float h=map(ro+t*rd);
    res=min(res,h/(w*t));
    t+=clamp(h,0.0001,0.1);
    if(res<-1.||t>maxt)break;
  }
res=max(res,-1.);
res=0.25*(1.+res)*(1.+res)*(2.0-res);
res=res*res*(3.0-2.0*res);
return res;
}
#include <getBlueNoise>
#include <sampleBlur>
#include <taaJitteringFragPars>
#include <perturbNormalArb>
#include <cart2Polar>
vec3 RRTAndODTFit(vec3 v) {
  vec3 a=v*(v+0.0245786)-0.000090537;
  vec3 b=v*(0.983729*v+0.4329510)+0.238081;
  return a/b;
}
#include <aces>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec4 map=textureBicubic(u_texture,v_uv,u_textureSize);
  vec3 albedo=pow(map.rgb,vec3(mix(2.0,1.85,u_heroRatio)));
  vec3 viewNormal=normalize(v_viewNormal);
  float bumpScale=1.0+0.5*max(u_highlightRatio,u_condomSceneRatio)+u_extraBumpScale;
  vec2 dSTdx=dFdx(v_uv);
  vec2 dSTdy=dFdy(v_uv);
  vec2 dHdxy=(vec2(textureBicubic(u_texture,v_uv+dSTdx,u_textureSize).w,textureBicubic(u_texture,v_uv+dSTdy,u_textureSize).w)-map.w)*bumpScale;
  viewNormal=perturbNormalArb(-v_viewPosition,viewNormal,dHdxy,1.0);
  vec3 N=normalize((vec4(viewNormal,0.)*viewMatrix).xyz);
  vec3 V=normalize(cameraPosition-v_worldPosition);
  vec3 reflection=normalize(reflect(-V,N));
  float NdV=clamp(abs(dot(N,V)),0.001,1.0);
  vec3 f0=vec3(0.04);
  float roughness=1.0;
  float metallic=0.0;
  vec3 diffuseColor=albedo*(vec3(1.0)-f0)*(1.0-metallic);
  vec3 specularColor=mix(f0,albedo,metallic);
  vec3 brdf=texture2D(u_brdfLut,vec2(NdV,roughness)).rgb;
  vec3 diffuseLight=texture2D(u_envTexture,cart2Polar(N)).rgb;
  vec3 specularLight=texture2D(u_envTexture,cart2Polar(reflection)).rgb;
  float shadow=calcSoftshadow(v_modelPosition,normalize(u_localLightPosition),0.00001,0.08,mix(1.0,0.5,max(u_highlightRatio,u_condomSceneRatio)));
  vec3 appleColor=texture2D(u_lmsTexture,4.0*v_modelPosition.xy+blueNoise.xy*0.5-u_time).rgb;
  appleColor=mix(vec3(1.0),0.5+appleColor*0.5,u_highlightRatio);
  vec3 appleColor0=texture2D(u_lmsTexture,2.0*v_modelPosition.zy+blueNoise.xy*0.5-u_time).rgb;
  vec3 appleColor1=texture2D(u_lmsTexture,2.0*v_modelPosition.zy+blueNoise.xy*0.5+u_time).rgb;
  vec3 color=appleColor*(diffuseColor*diffuseLight+specularLight*(specularColor*brdf.x+brdf.y));
  float highlightIntensity=100.0;
  vec3 highlightPos=highlightIntensity*vec3(0.8,-0.9,-0.05);
  vec3 highlightL=normalize(highlightPos-v_worldPosition);
  float highlightNdL=max(0.0,dot(N,highlightL));
  color+=appleColor0*4.0*u_highlightRatio*albedo*highlightNdL;
  highlightPos=highlightIntensity*vec3(-0.7,-0.5,-0.2);
  highlightL=normalize(highlightPos-v_worldPosition);
  highlightNdL=max(0.0,dot(N,highlightL));
  color+=appleColor1*4.0*u_highlightRatio*albedo*highlightNdL;
  float gobo=1.0;
  vec4 goboNdc=u_goboMatrix*vec4(v_worldPosition,1.);
  goboNdc/=goboNdc.w;
  vec2 goboUv=goboNdc.xy*0.5+0.5;
  if(u_goboOpacity>0.&&goboUv.x>=0.0&&goboUv.x<=1.0&&goboUv.y>=0.0&&goboUv.y<=1.0) {
    gobo=sampleBlur(u_goboTexture,goboUv,vec2(1./512.),getGoboBlurRatio(goboNdc.z,u_goboParams)*2.,blueNoise.z).r;
    gobo=mix(1.0,gobo,u_goboOpacity);
  }
shadow=mix(shadow,0.6+0.4*shadow,u_heroRatio);
color*=shadow*shadow*(0.5+0.3*gobo+0.2*v_ao);
color*=mix(1.0,0.75,u_heroRatio);
color+=mix(0.05,0.1,u_heroRatio)*albedo;
color+=albedo*0.4*u_condomSceneRatio;
vec3 wearableColor=4.0*pow(map.rgb,vec3(3.0-0.5*v_ao))*(0.05+0.95*smoothstep(0.0,0.3,shadow*shadow));
color=mix(color,wearableColor,u_wearableBlendingRatio);
gl_FragColor.rgb=color;
gl_FragColor.rgb=aces(gl_FragColor.rgb);
gl_FragColor.rgb=pow(gl_FragColor.rgb,vec3(1./2.2));
vec4 imgBasedPos4=u_imgBasedMVP*vec4(v_modelPosition,1.0);
vec3 imgBased=texture2D(u_imgBasedTexture,imgBasedPos4.xy/imgBasedPos4.w*0.5+0.5).rgb;
gl_FragColor.a=0.;
#include <taaJitteringFrag>
}

// ===================== BLOCK 68 =====================
#define GLSLIFY 1
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
varying float v_ao;
uniform sampler2D u_texture;
uniform sampler2D u_envTexture;
uniform sampler2D u_brdfLut;
uniform vec3 u_giColor;
uniform float u_zoomRatio;
uniform vec3 u_lightPosition;
uniform float u_coffeeShadowStrength;
uniform mat2 u_randomFlipRot;
uniform mat4 modelMatrix;
uniform mat4 u_coffeeInvMatrix;
uniform sampler2D u_textMap;
uniform vec2 u_textSize;
uniform float u_textOpacity;
uniform vec2 u_resolution;
uniform vec2 u_textureSize;
float dot2(vec2 v) {
  return dot(v,v);
}
float opUnion(float d1,float d2) {
  return min(d1,d2);
}
float opSubtraction(float d1,float d2) {
  return max(-d1,d2);
}
#include <sdCappedCone>
float map(in vec3 worldPos) {
  mat4 invModelMatrix=inverse(modelMatrix);
  vec3 objSpacePos=(invModelMatrix*vec4(worldPos,1.0)).xyz;
  float cTop=sdCappedCone(objSpacePos,vec3(0.,0.003,0.),vec3(0.,0.0175,0.),0.0415,0.045);
  float cBottom=sdCappedCone(objSpacePos,vec3(0.,0.0,0.),vec3(0.,0.003,0.),0.03912,0.0397);
  float cInnerTop=sdCappedCone(objSpacePos,vec3(0.,0.008,0.),vec3(0.,0.01,0.),0.0325,0.0355);
  float cInnerBottom=sdCappedCone(objSpacePos,vec3(0.,0.01,0.),vec3(0.,0.0175,0.),0.0355,0.039);
  float coasterSDF=opSubtraction(opUnion(cInnerTop,cInnerBottom),opUnion(cTop,cBottom));
  vec3 coffeeObjSpacePos=(u_coffeeInvMatrix*vec4(worldPos,1.0)).xyz;
  float coffeeRadiusBottom=0.029881315305829048;
  float coffeeRadiusTop=0.04465631768107414;
  float coffeeHeight=0.10891598463058472;
  float coffeeSDF=sdCappedCone(coffeeObjSpacePos,vec3(0.,0.,0.),vec3(0.,coffeeHeight,0.),coffeeRadiusBottom,coffeeRadiusTop);
  return opUnion(coffeeSDF,coasterSDF);
}
float calcSoftshadow(in vec3 ro,in vec3 rd,float mint,float maxt,float w) {
  float res=1.0;
  float t=mint;
  for(int i=0;
  i<32&&t<maxt;
  i++) {
    float h=map(ro+t*rd);
    res=min(res,h/(w*t));
    t+=clamp(h,0.0005,0.1);
    if(res<-1.||t>maxt)break;
  }
res=max(res,-1.);
res=0.25*(1.+res)*(1.+res)*(2.0-res);
res=res*res*(3.0-2.0*res);
return res;
}
#include <getBlueNoise>
#include <taaJitteringFragPars>
#include <textureBicubic>
#include <tonemapping_pars_fragment>
#include <thermodynamicPars>
#include <perturbNormalArb>
#include <cart2Polar>
vec3 getTextBumpAlpha() {
  vec3 pos=v_modelPosition;
  pos.xz=u_randomFlipRot*pos.xz;
  vec2 bottomUv=(pos.xz+0.03912)/(2.0*0.03912);
  vec2 textAspectRatio=vec2(u_textSize.x/u_textSize.y,1.0);
  bottomUv=(bottomUv-0.5)*1.2*textAspectRatio+0.5;
  bottomUv=bottomUv.yx;
  bottomUv.x=1.0-bottomUv.x;
  float bottomMask=1.0-step(0.0,pos.y);
  vec3 textBumpAlpha=bottomMask*texture2D(u_textMap,bottomUv).rgb;
  return textBumpAlpha;
}
float blendColorBurn(float base,float blend) {
  return(blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
}
vec3 blendColorBurn(vec3 base,vec3 blend) {
  return vec3(blendColorBurn(base.r,blend.r),blendColorBurn(base.g,blend.g),blendColorBurn(base.b,blend.b));
}
vec3 blendColorBurn(vec3 base,vec3 blend,float opacity) {
  return(blendColorBurn(base,blend)*opacity+base*(1.0-opacity));
}
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec2 uv=v_uv;
  vec3 textBumpAlpha=u_textOpacity*getTextBumpAlpha();
  vec2 textBump=textBumpAlpha.xy;
  float textAlpha=textBumpAlpha.z;
  vec4 map=textureBicubic(u_texture,uv,u_textureSize);
  vec3 albedo=pow(map.rgb,vec3(mix(1.8,1.7,u_zoomRatio)));
  albedo=mix(albedo,0.25*blendColorBurn(albedo,vec3(0.25),textAlpha),0.85*textAlpha);
  vec3 giColor=pow(u_giColor,vec3(2.2));
  vec3 viewNormal=normalize(v_viewNormal);
  float bumpScale=mix(3.0,5.0,smoothstep(0.0,0.5,u_zoomRatio));
  vec2 dSTdx=dFdx(uv);
  vec2 dSTdy=dFdy(uv);
  vec2 dHdxy=(vec2(textureBicubic(u_texture,uv+dSTdx,u_textureSize).w,textureBicubic(u_texture,uv+dSTdy,u_textureSize).w)-map.w)*bumpScale;
  dHdxy-=4.0*textBump*textAlpha;
  viewNormal=perturbNormalArb(-v_viewPosition,viewNormal,dHdxy,1.0);
  vec3 N=normalize((vec4(viewNormal,0.)*viewMatrix).xyz);
  vec3 V=normalize(cameraPosition-v_worldPosition);
  vec3 reflection=normalize(reflect(-V,N));
  vec3 L=u_lightPosition-v_worldPosition;
  float lightDistance=length(L);
  L/=lightDistance;
  float NdV=clamp(abs(dot(N,V)),0.001,1.0);
  float NdL=max(0.,dot(N,L));
  vec3 f0=vec3(0.04);
  float roughness=1.0*(1.0-0.25*textAlpha);
  float metallic=0.0;
  vec3 diffuseColor=albedo*(vec3(1.0)-f0)*(1.0-metallic);
  vec3 specularColor=mix(f0,albedo,metallic);
  vec3 brdf=texture2D(u_brdfLut,vec2(NdV,roughness)).rgb;
  vec3 diffuseLight=texture2D(u_envTexture,cart2Polar(N)).rgb;
  vec3 specularLight=texture2D(u_envTexture,cart2Polar(reflection)).rgb;
  vec3 indirectLight=diffuseColor*diffuseLight+specularLight*(specularColor*brdf.x+brdf.y);
  float shadow=calcSoftshadow(v_worldPosition+N*0.,L,0.0015,0.08,mix(0.5,0.5,u_zoomRatio));
  shadow=mix(shadow,1.0,u_thermalRatio);
  vec3 encryptionColor=albedo*3.5*(0.1+0.9*NdL);
  encryptionColor*=0.8+0.2*v_ao;
  encryptionColor+=giColor*albedo*4.0*step(0.04,length(v_modelPosition.xz))*(0.1+smoothstep(0.014,-0.004,v_worldPosition.y));
  encryptionColor*=0.3+0.7*shadow*shadow;
  vec3 featureColor=albedo*NdL;
  featureColor+=0.5*indirectLight;
  featureColor*=(0.5+0.5*shadow*shadow);
  featureColor*=0.75+0.25*v_ao;
  featureColor*=0.75;
  featureColor+=0.1*albedo;
  vec3 color=mix(featureColor,encryptionColor,u_zoomRatio);
  float luma=dot(albedo,vec3(0.2126,0.7152,0.0722));
  vec3 thermalGradient=pow(0.1+texture2D(u_thermalTexture,vec2(0.5*luma+0.9*(1.0-v_ao)*(0.1+0.9*smoothstep(0.005,0.008,v_modelPosition.y)),0.5)).rgb,vec3(2.2));
  color=mix(color,thermalGradient,getThermalFadeStep(u_resolution));
  gl_FragColor.rgb=color;
  gl_FragColor.rgb=ACESFilmicToneMapping(gl_FragColor.rgb);
  gl_FragColor=vec4(pow(gl_FragColor.rgb,vec3(1./2.2)),0.);
  #include <taaJitteringFrag>
}

// ===================== BLOCK 69 =====================
#define GLSLIFY 1
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
uniform float u_blendRatio;
varying vec2 v_uv;
void main() {
  gl_FragColor=mix(texture2D(u_texture1,v_uv),texture2D(u_texture2,v_uv),u_blendRatio);
}

// ===================== BLOCK 70 =====================
#define GLSLIFY 1
#include <linearstep>
#include <textureBicubic>
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
varying float v_ao;
varying vec3 v_modelNormal;
uniform vec2 u_resolution;
uniform float u_opacity;
uniform vec2 u_textureSize;
uniform vec3 u_lightPosition;
uniform vec3 u_localLightPosition;
uniform vec3 u_extraLightPosition1;
uniform vec3 u_extraLightPosition2;
uniform sampler2D u_texture;
uniform sampler2D u_imgBasedTexture;
uniform float u_imgBasedOpacity;
uniform mat4 u_imgBasedMVP;
uniform float u_neighboorTopAo;
uniform float u_neighboorBottomAo;
uniform mat4 modelMatrix;
uniform float u_blendEnvToLights;
uniform float u_blendEnvRatio;
uniform float u_haloIntensity;
float dot2(vec2 v) {
  return dot(v,v);
}
float opUnion(float d1,float d2) {
  return min(d1,d2);
}
float opSubtraction(float d1,float d2) {
  return max(-d1,d2);
}
float sdCappedCone(vec2 q,float h,float r1,float r2) {
  vec2 k1=vec2(r2,h);
  vec2 k2=vec2(r2-r1,2.0*h);
  vec2 ca=vec2(q.x-min(q.x,(q.y<0.0)?r1:r2),abs(q.y)-h);
  vec2 cb=q-k1+k2*clamp(dot(k1-q,k2)/dot2(k2),0.0,1.0);
  float s=(cb.x<0.0&&ca.y<0.0)?-1.0 : 1.0;
  return s*sqrt(min(dot2(ca),dot2(cb)));
}
float map(in vec3 pos) {
  vec2 q=vec2(length(pos.xz),pos.y);
  float c1=sdCappedCone(q+vec2(0.,-.0102),.007,.0412,.0446);
  float c2=sdCappedCone(q+vec2(0.,-.0016),.0015,.0385,.039);
  float c3=sdCappedCone(q+vec2(0.,-.0155),.008,.038,.0395);
  return opSubtraction(c3,opUnion(c1,c2));
}
float calcSoftshadow(in vec3 ro,in vec3 rd,float mint,float maxt,float w) {
  float res=1.0;
  float t=mint;
  for(int i=0;
  i<16&&t<maxt;
  i++) {
    float h=map(ro+t*rd);
    res=min(res,h/(w*t));
    t+=clamp(h,0.0001,0.1);
    if(res<-1.||t>maxt)break;
  }
res=max(res,-1.);
res=0.25*(1.+res)*(1.+res)*(2.0-res);
res=res*res*(3.0-2.0*res);
return res;
}
#include <getBlueNoise>
#include <taaJitteringFragPars>
#include <getBgColor>
#include <perturbNormalArb>
#include <cart2Polar>
vec3 RRTAndODTFit(vec3 v) {
  vec3 a=v*(v+0.0245786)-0.000090537;
  vec3 b=v*(0.983729*v+0.4329510)+0.238081;
  return a/b;
}
#include <aces>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec4 map=textureBicubic(u_texture,v_uv,u_textureSize);
  vec3 albedo=pow(map.rgb,vec3(mix(2.2,1.8,u_blendEnvToLights)));
  vec3 viewNormal=normalize(v_viewNormal);
  float bumpScale=1.5;
  vec2 dSTdx=dFdx(v_uv);
  vec2 dSTdy=dFdy(v_uv);
  vec2 dHdxy=(vec2(textureBicubic(u_texture,v_uv+dSTdx,u_textureSize).w,textureBicubic(u_texture,v_uv+dSTdy,u_textureSize).w)-map.w)*bumpScale;
  viewNormal=perturbNormalArb(-v_viewPosition,viewNormal,dHdxy,1.0);
  vec3 N=normalize((vec4(viewNormal,0.)*viewMatrix).xyz);
  vec3 V=normalize(cameraPosition-v_worldPosition);
  vec3 reflection=normalize(reflect(-V,N));
  vec3 L0=normalize(u_lightPosition-v_worldPosition);
  vec3 L1=normalize(u_extraLightPosition1-v_worldPosition);
  vec3 L2=normalize(u_extraLightPosition2-v_worldPosition);
  float NdV=clamp(abs(dot(N,V)),0.001,1.0);
  float NdL0=max(0.,dot(N,L0));
  float NdL1=max(0.,dot(N,L1));
  float NdL2=max(0.,dot(N,L2));
  float shadow=calcSoftshadow(v_modelPosition,normalize(u_localLightPosition),0.00001,0.08,0.5+u_blendEnvToLights*0.5);
  vec3 lightColor=0.8*albedo+8.0*(0.06+albedo)*NdL0*NdL0+step(0.039,length(v_modelPosition.xz))*mix(50.0,100.0,u_blendEnvRatio)*(mix(0.05,0.1,u_blendEnvRatio)+albedo)*NdL1*NdL1;
  lightColor+=1.25*(0.05+albedo)*NdL2;
  lightColor+=0.3*albedo*albedo*NdL2;
  lightColor+=(1.0-step(0.039,length(v_modelPosition.xz)))*1.5*albedo*albedo*(1.0-shadow*shadow);
  lightColor*=0.2+0.8*shadow*shadow;
  lightColor*=mix(0.45+0.55*shadow*shadow,1.0,smoothstep(0.032,0.034,length(v_modelPosition.xz)));
  lightColor*=0.7+0.3*v_ao;
  vec3 color=0.8*lightColor*(1.0-0.75*u_haloIntensity);
  gl_FragColor.rgb=color;
  gl_FragColor.rgb=aces(gl_FragColor.rgb);
  vec4 imgBasedPos4=u_imgBasedMVP*vec4(v_modelPosition,1.0);
  vec3 imgBased=texture2D(u_imgBasedTexture,imgBasedPos4.xy/imgBasedPos4.w).rgb;
  gl_FragColor.rgb=mix(gl_FragColor.rgb,imgBased,u_imgBasedOpacity);
  gl_FragColor.rgb*=mix(1.0,pow(smoothstep(0.02,0.016,v_modelPosition.y),2.0),u_neighboorTopAo);
  gl_FragColor.rgb*=mix(1.0,pow(smoothstep(0.0,0.006,v_modelPosition.y),2.0),u_neighboorBottomAo);
  gl_FragColor.rgb=mix(getBgColor(blueNoise.z),gl_FragColor.rgb,u_opacity);
  gl_FragColor.rgb=pow(gl_FragColor.rgb,vec3(1./2.2));
  gl_FragColor.a=0.;
  #include <taaJitteringFrag>
}

// ===================== BLOCK 71 =====================
#define GLSLIFY 1
attribute vec2 layoutUv;
attribute float lineIndex;
attribute float lineLettersTotal;
attribute float lineLetterIndex;
attribute float lineWordsTotal;
attribute float lineWordIndex;
attribute float wordIndex;
attribute float letterIndex;
varying vec2 vUv;
void main() {
  gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.0);
  vUv=uv;
}

// ===================== BLOCK 72 =====================
#define GLSLIFY 1
varying vec2 vUv;
uniform float uOpacity;
uniform float uAlphaTest;
uniform vec3 uColor;
uniform sampler2D uMap;
uniform vec2 u_resolution;
float median(float r,float g,float b) {
  return max(min(r,g),min(max(r,g),b));
}
float getAlpha(vec2 uv) {
  vec3 s=texture2D(uMap,uv).rgb;
  float sigDist=median(s.r,s.g,s.b)-0.4;
  return clamp(sigDist/fwidth(4.0*sigDist)+0.5,0.0,1.0);
}
void main() {
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec2 texel=1.0/u_resolution;
  vec2 uv=vUv;
  vec2 uvDx=vUv+vec2(texel.x,0.0);
  vec2 uvDy=vUv+vec2(0.0,texel.y);
  float alpha=getAlpha(uv);
  float alphaDx=getAlpha(uvDx);
  float alphaDy=getAlpha(uvDy);
  vec2 bump=(vec2(alphaDx,alphaDy)-alpha);
  if(alpha<uAlphaTest)discard;
  if(screenUv.x<texel.x)discard;
  if(screenUv.x>1.0-texel.x)discard;
  vec4 filledFragColor=vec4(bump,uOpacity*alpha,1.0);
  gl_FragColor=filledFragColor;
}

// ===================== BLOCK 73 =====================
precision highp float;
#define GLSLIFY 1
uint pack8888(vec4 v) {
  uvec4 t=uvec4(v*255.0+.5)<<uvec4(24u,16u,8u,0u);
  return t.x|t.y|t.z|t.w;
}
vec4 unpack8888(uint v) {
  return vec4((uvec4(v)>>uvec4(24u,16u,8u,0u))&0xffu)/255.0;
}
vec3 unpack101010(uint v) {
  return vec3((uvec3(v)>>uvec3(20u,10u,0u))&0x3ffu)/1023.0;
}
vec3 unpack111110(uint v) {
  return vec3((uvec3(v)>>uvec3(21u,10u,0u))&uvec3(0x7ffu,0x7ffu,0x3ffu))/vec3(2047.0,2047.0,1023.0);
}
uniform highp usampler2D splatIndexTexture;
uniform highp usampler2D splatTexture;
uniform ivec2 splatTextureSize;
uniform sampler2D sh0Texture;
uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform vec2 cameraParams;
uniform vec2 viewport;
uniform vec2 focal;
uniform vec3 means_mins;
uniform vec3 means_maxs;
uniform float scales_mins;
uniform float scales_maxs;
uniform float sh0_mins;
uniform float sh0_maxs;
uniform float opacity;
uniform float colorMultiplier;
varying vec4 vColor;
varying vec2 vConic;
varying float vConicW;
varying vec2 vCenter;
mat3 quatToMat3(vec4 q) {
  float x=q.x;
  float y=q.y;
  float z=q.z;
  float w=q.w;
  float x2=x+x;
  float y2=y+y;
  float z2=z+z;
  float xx=x*x2;
  float xy=x*y2;
  float xz=x*z2;
  float yy=y*y2;
  float yz=y*z2;
  float zz=z*z2;
  float wx=w*x2;
  float wy=w*y2;
  float wz=w*z2;
  return mat3(1.0-(yy+zz),xy+wz,xz-wy,xy-wz,1.0-(xx+zz),yz+wx,xz+wy,yz-wx,1.0-(xx+yy));
}
mediump vec4 discardVec=vec4(0.0,0.0,2.0,1.0);
vec3 unpackCenter(uvec4 packedData) {
  vec3 l=unpack8888(packedData.x).xyz;
  vec3 u=unpack8888(packedData.y).xyz;
  vec3 n=(l+u*256.0)/257.0;
  vec3 v=mix(means_mins,means_maxs,n);
  return sign(v)*(exp(abs(v))-1.0);
}
vec4 unpackQuat(uvec4 packedData) {
  vec3 qdata=unpack8888(packedData.z).xyz;
  uint qmode=packedData.w&0x3u;
  vec3 abc=(qdata-0.5)*sqrt(2.0);
  float d=sqrt(max(0.0,1.0-dot(abc,abc)));
  return((qmode==0u)? vec4(d,abc):((qmode==1u)? vec4(abc.x,d,abc.yz):((qmode==2u)? vec4(abc.xy,d,abc.z): vec4(abc,d)))).yzwx;
}
vec3 unpackScale(uvec4 packedData) {
  vec3 sdata=unpack101010(packedData.w>>2u);
  return exp(mix(vec3(scales_mins),vec3(scales_maxs),sdata));
}
#ifdef SH_COEFFS
uniform sampler2D shNTexture;
uniform float shN_mins;
uniform float shN_maxs;
vec3[SH_COEFFS]unpackShN(uvec4 packedData) {
  ivec2 tmp=ivec2(packedData.xy&255u);
  int idx=tmp.x+tmp.y*256;
  int x=(idx % 64)*SH_COEFFS;
  int y=idx/64;
  vec3 sh[SH_COEFFS];
  for(int i=0;
  i<SH_COEFFS;
  i++) {
    sh[i]=mix(vec3(shN_mins),vec3(shN_maxs),unpack111110(pack8888(texelFetch(shNTexture,ivec2(x+i,y),0))));
  }
return sh;
}
#endif
const float SH_C0=0.28209479177387814;
#ifdef SH_COEFFS
const float SH_C1=0.4886025119029199f;
#if SH_COEFFS > 3
const float SH_C2_0=1.0925484305920792f;
const float SH_C2_1=-1.0925484305920792f;
const float SH_C2_2=0.31539156525252005f;
const float SH_C2_3=-1.0925484305920792f;
const float SH_C2_4=0.5462742152960396f;
#endif
#if SH_COEFFS > 8
const float SH_C3_0=-0.5900435899266435f;
const float SH_C3_1=2.890611442640554f;
const float SH_C3_2=-0.4570457994644658f;
const float SH_C3_3=0.3731763325901154f;
const float SH_C3_4=-0.4570457994644658f;
const float SH_C3_5=1.445305721320277f;
const float SH_C3_6=-0.5900435899266435f;
#endif
vec3 evalSH(in vec3 sh[SH_COEFFS],in vec3 dir) {
  float x=dir.x;
  float y=dir.y;
  float z=dir.z;
  vec3 result=SH_C1*(-sh[0]*y+sh[1]*z-sh[2]*x);
  #if SH_COEFFS > 3
  float xx=x*x;
  float yy=y*y;
  float zz=z*z;
  float xy=x*y;
  float yz=y*z;
  float xz=x*z;
  result+=sh[3]*(SH_C2_0*xy)+sh[4]*(SH_C2_1*yz)+sh[5]*(SH_C2_2*(2.0*zz-xx-yy))+sh[6]*(SH_C2_3*xz)+sh[7]*(SH_C2_4*(xx-yy));
  #endif
  #if SH_COEFFS > 8
  result+=sh[8]*(SH_C3_0*y*(3.0*xx-yy))+sh[9]*(SH_C3_1*xy*z)+sh[10]*(SH_C3_2*y*(4.0*zz-xx-yy))+sh[11]*(SH_C3_3*z*(2.0*zz-3.0*xx-3.0*yy))+sh[12]*(SH_C3_4*x*(4.0*zz-xx-yy))+sh[13]*(SH_C3_5*z*(xx-yy))+sh[14]*(SH_C3_6*x*(xx-3.0*yy));
  #endif
  return result;
}
#endif
void main() {
  int splatID=gl_VertexID/4;
  int splatIndex=int(texelFetch(splatIndexTexture,ivec2(splatID % splatTextureSize.x,splatID/splatTextureSize.x),0).r);
  ivec2 splatXY=ivec2(splatIndex % splatTextureSize.x,splatIndex/splatTextureSize.x);
  int cornerID=gl_VertexID % 4;
  vec2 position=vec2(cornerID % 2,cornerID/2)*2.-1.;
  uvec4 packedData=texelFetch(splatTexture,splatXY,0);
  vec4 sh0Data=texelFetch(sh0Texture,splatXY,0);
  vec3 center=unpackCenter(packedData);
  vec4 quat=unpackQuat(packedData);
  vec3 scale=unpackScale(packedData);
  vec3 sh0=vec3(0.5)+mix(vec3(sh0_mins),vec3(sh0_maxs),unpack111110(pack8888(sh0Data)))*SH_C0;
  float alpha=float(packedData.z&0xffu)/255.0;
  vec4 viewCenter=modelViewMatrix*vec4(center,1.);
  vec4 clipCenter=projectionMatrix*viewCenter;
  if(viewCenter.z>0.) {
    gl_Position=discardVec;
    return;
  }
float s=1.0/(viewCenter.z*viewCenter.z);
mat3 J=mat3(focal.x/viewCenter.z,0.,-(focal.x*viewCenter.x)*s,0.,focal.y/viewCenter.z,-(focal.y*viewCenter.y)*s,0.0,0.0,0.0);
mat3 rot=quatToMat3(quat);
mat3 M=transpose(mat3(scale.x*rot[0],scale.y*rot[1],scale.z*rot[2]));
vec3 covA=vec3(dot(M[0],M[0]),dot(M[0],M[1]),dot(M[0],M[2]));
vec3 covB=vec3(dot(M[1],M[1]),dot(M[1],M[2]),dot(M[2],M[2]));
mat3 Vrk=mat3(covA.x,covA.y,covA.z,covA.y,covB.x,covB.y,covA.z,covB.y,covB.z);
mat3 W=transpose(mat3(modelViewMatrix));
mat3 T=W*J;
mat3 cov=transpose(T)*Vrk*T;
vec3 cov2D=vec3(cov[0][0],cov[0][1],cov[1][1]);
cov2D.x+=0.3;
cov2D.z+=0.3;
float det=cov2D.x*cov2D.z-cov2D.y*cov2D.y;
float detInv=1.0/det;
vec3 conic=vec3(cov2D.z,-cov2D.y,cov2D.x)*detInv;
vConic=conic.xy;
float traceOver2=0.5*(cov2D.x+cov2D.z);
float radius=length(vec2((cov2D.x-cov2D.z)/2.0,cov2D.y));
float eigenValue1=traceOver2+radius;
float eigenValue2=max(traceOver2-radius,0.1);
float vmin=min(1024.0,min(viewport.x,viewport.y));
vec2 radius_vec=(2.0*min(sqrt(vec2(eigenValue1,eigenValue2)*2.),vmin));
vec2 c=clipCenter.ww/viewport;
if(any(greaterThan(abs(clipCenter.xy)-vec2(max(radius_vec.x,radius_vec.y))*c,clipCenter.ww))) {
  gl_Position=discardVec;
  return;
}
vec2 eigenVector1=vec2(cov2D.y,eigenValue1-cov2D.x);
eigenVector1=normalize(eigenVector1);
vec2 eigenVector2=vec2(eigenVector1.y,-eigenVector1.x);
vec2 basisVec1=eigenVector1*radius_vec.x;
vec2 basisVec2=eigenVector2*radius_vec.y;
vec2 offsetPixels=position.x*basisVec1+position.y*basisVec2;
vec2 offsetNDC=(offsetPixels/viewport);
clipCenter.xy+=offsetNDC*clipCenter.w*2.;
gl_Position=clipCenter;
vec3 color=sh0;
#ifdef SH_COEFFS
vec3 dir=normalize((viewCenter.xyz/viewCenter.w)*mat3(modelViewMatrix));
vec3 sh[SH_COEFFS]=unpackShN(packedData);
color+=evalSH(sh,dir);
#endif
vColor=vec4(color*colorMultiplier*mix(alpha,1.,.5+colorMultiplier*.5),alpha*opacity);
vConic=conic.xy;
vConicW=conic.z;
vCenter=position.xy*radius_vec;
vCenter=offsetPixels;
}

// ===================== BLOCK 74 =====================
precision highp float;
#define GLSLIFY 1
varying vec4 vColor;
varying vec2 vConic;
varying float vConicW;
varying vec2 vCenter;
varying vec3 vTest;
#ifndef NO_TAA
#include <taaJitteringFragPars>
#endif
void main() {
  float power=-0.5*(vCenter.x*(vCenter.x*vConic.x+vCenter.y*vConic.y)+vCenter.y*(vCenter.x*vConic.y+vCenter.y*vConicW));
  if(power>0.0)discard;
  float alpha=min(0.99,vColor.a*exp(power));
  if(alpha<1.0/255.0)discard;
  gl_FragColor=vec4(vColor.rgb,alpha);
  #ifndef NO_TAA
  #include <taaJitteringFrag>
  #endif
}

// ===================== BLOCK 75 =====================
#define GLSLIFY 1
attribute vec2 position;
uniform float u_aspect;
uniform float u_zoom;
uniform vec2 u_texelSize;
varying vec2 v_uv;
void main() {
  v_uv=position*vec2(u_aspect*.5,.5)*vec2(u_texelSize.x/u_texelSize.y,1.)+.5;
  vec2 pos=position;
  pos*=u_zoom;
  gl_Position=vec4(pos,0.,1.);
}

// ===================== BLOCK 76 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform float u_opacity;
uniform vec2 u_texelSize;
uniform float u_blurRadius;
uniform float u_brightness;
varying vec2 v_uv;
#include <getBlueNoise>
#include <sampleBlurSRGB>
void main() {
  vec3 bnoise=getBlueNoise(gl_FragCoord.xy);
  float blurRadius=(smoothstep(0.3,0.05,v_uv.y)+smoothstep(0.35,0.8,v_uv.y)+smoothstep(0.5,0.6,abs(v_uv.x-.5))*2.)*u_blurRadius;
  vec3 color=sampleBlurSRGB(u_texture,v_uv,u_texelSize,blurRadius,bnoise.z).rrr;
  color*=u_brightness;
  gl_FragColor=vec4(pow(color,vec3(1./2.2)),u_opacity);
}

// ===================== BLOCK 77 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec4 u_rect;
uniform vec2 u_viewportResolution;
uniform float u_offsetX;
uniform float u_delayedOffsetX;
uniform vec2 u_textureSize;
uniform vec2 u_mouseOffset;
uniform float u_uvBoxAspect;
uniform float u_zoom;
varying vec2 v_uv;
varying vec2 v_screenUv;
varying vec2 v_uvFrom;
varying vec2 v_uvTo;
void main() {
  vec2 pos=position.xy*.5+.5;
  v_uv=pos;
  pos=mix(u_rect.xy,u_rect.xy+u_rect.zw,pos)/u_viewportResolution;
  v_screenUv=pos.xy;
  pos=pos*2.-1.;
  gl_Position=vec4(pos,0.,1.0);
  vec2 baseUv=position.xy*.5*u_textureSize;
  baseUv.x*=u_textureSize.y/u_textureSize.x*u_uvBoxAspect;
  v_uvFrom=baseUv;
  v_uvFrom.x+=u_delayedOffsetX*5.*(u_textureSize.x-u_textureSize.y*u_uvBoxAspect)/2.;
  v_uvFrom/=u_textureSize;
  v_uvFrom+=u_mouseOffset*.5;
  v_uvFrom.y+=0.08;
  v_uvFrom/=u_zoom;
  v_uvFrom.y-=0.08;
  v_uvFrom+=.5;
  v_uvTo=baseUv;
  v_uvTo.x+=u_offsetX*5.*(u_textureSize.x-u_textureSize.y*u_uvBoxAspect)/2.;
  v_uvTo/=u_textureSize;
  v_uvTo+=u_mouseOffset*.5;
  v_uvTo.y+=0.08;
  v_uvTo/=u_zoom;
  v_uvTo.y-=0.08;
  v_uvTo+=.5;
}

// ===================== BLOCK 78 =====================
#define GLSLIFY 1
layout(location=1)out vec4 pc_fragVelocity;
#define gl_FragVelocity pc_fragVelocity
vec4 pack2HalfToRGBA(const in vec2 v) {
  vec4 r=vec4(v.x,fract(v.x*255.0),v.y,fract(v.y*255.0));
  return vec4(r.x-r.y/255.0,r.y,r.z-r.w/255.0,r.w);
}
uniform sampler2D u_texture;
uniform sampler2D u_sceneCacheTexture;
uniform vec2 u_textureSize;
uniform vec2 u_viewportResolution;
uniform vec2 u_resolution;
uniform float u_opacity;
uniform float u_brightness;
uniform vec4 u_rect;
uniform vec2 u_mouseOffset;
varying vec2 v_uv;
varying vec2 v_uvFrom;
varying vec2 v_uvTo;
varying vec2 v_screenUv;
#include <linearstep>
#include <getBlueNoise>
#include <sampleBlur>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  float uvSBit=1./float(BLUR_SAMPLE);
  float t=uvSBit*blueNoise.z;
  vec3 color=vec3(0.);
  for(int i=0;
  i<BLUR_SAMPLE;
  i++) {
    t+=uvSBit;
    vec2 uv=mix(v_uvFrom,v_uvTo,t);
    color+=texture2D(u_texture,uv).rgb;
  }
color/=float(BLUR_SAMPLE);
vec2 midUv=(v_uvFrom+v_uvTo)*.5;
float edgeStrength=max(0.,abs(midUv.y-.5)-.5);
vec3 edgeColor=sampleBlur(u_texture,midUv,1./u_textureSize,edgeStrength*u_textureSize.y*5.,blueNoise.x).rgb;
color=mix(color,edgeColor,min(1.,edgeStrength*10.));
color=vec3(mix(mix(color.r,color.g,linearstep(-0.5,0.,u_mouseOffset.x)),color.b,linearstep(0.,0.5,u_mouseOffset.x)));
color*=u_brightness;
vec3 sceneColor=pow(texture2D(u_sceneCacheTexture,v_screenUv).rgb,vec3(2.2));
float alpha=min(u_opacity,1.-min(1.,edgeStrength*1.));
color=mix(sceneColor,color,alpha);
color=pow(color,vec3(1./2.2));
gl_FragColor.rgb=color;
gl_FragColor.a=u_opacity;
gl_FragVelocity=pack2HalfToRGBA(vec2(0.5));
}

// ===================== BLOCK 79 =====================
#define GLSLIFY 1
attribute vec4 boneIndices;
attribute vec4 boneWeights;
attribute float Cd;
attribute float thickness;
uniform mat4 u_projectionMatrix;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying float v_ao;
varying float v_thickness;
uniform sampler2D u_boneDataTexture;
mat4 getBoneMatrix(float index) {
  float uvT=(index+.5)/float(MAX_BONES);
  return mat4(texture2D(u_boneDataTexture,vec2(.125,uvT)),texture2D(u_boneDataTexture,vec2(.375,uvT)),texture2D(u_boneDataTexture,vec2(.625,uvT)),texture2D(u_boneDataTexture,vec2(.875,uvT)));
}
void main() {
  vec4 position4=vec4(position,1.0);
  vec4 skinnedPosition=vec4(0.0);
  mat4 boneMatrix0=getBoneMatrix(boneIndices.x);
  mat4 boneMatrix1=getBoneMatrix(boneIndices.y);
  mat4 boneMatrix2=getBoneMatrix(boneIndices.z);
  mat4 boneMatrix3=getBoneMatrix(boneIndices.w);
  skinnedPosition+=(boneMatrix0*position4)*boneWeights.x;
  skinnedPosition+=(boneMatrix1*position4)*boneWeights.y;
  skinnedPosition+=(boneMatrix2*position4)*boneWeights.z;
  skinnedPosition+=(boneMatrix3*position4)*boneWeights.w;
  vec3 pos=skinnedPosition.xyz;
  skinnedPosition=vec4(0.0);
  position4=vec4(position+normal*0.01,1.0);
  skinnedPosition+=(boneMatrix0*position4)*boneWeights.x;
  skinnedPosition+=(boneMatrix1*position4)*boneWeights.y;
  skinnedPosition+=(boneMatrix2*position4)*boneWeights.z;
  skinnedPosition+=(boneMatrix3*position4)*boneWeights.w;
  vec3 nor=normalize(skinnedPosition.xyz-pos);
  vec4 mvPosition=modelViewMatrix*vec4(pos,1.0);
  v_viewPosition=-mvPosition.xyz;
  v_modelPosition=pos;
  v_viewNormal=normalMatrix*nor;
  v_worldPosition=(modelMatrix*vec4(pos,1.0)).xyz;
  v_ao=Cd;
  v_thickness=thickness;
  v_uv=uv;
  gl_Position=u_projectionMatrix*mvPosition;
}

// ===================== BLOCK 80 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying float v_ao;
varying float v_thickness;
#include <perturbNormalArb>
void main() {
  if(v_worldPosition.z<-0.1&&v_worldPosition.y<-0.22) {
    discard;
  }
vec4 map=texture2D(u_texture,v_uv);
vec3 N=normalize(v_viewNormal);
float bumpScale=3.;
vec2 dSTdx=dFdx(v_uv);
vec2 dSTdy=dFdy(v_uv);
vec2 dHdxy=(vec2(texture2D(u_texture,v_uv+dSTdx).r,texture2D(u_texture,v_uv+dSTdy).r)-map.r)*bumpScale;
N=perturbNormalArb(-v_viewPosition,N,dHdxy,1.0);
vec3 V=normalize(-v_viewPosition);
vec3 R=reflect(V,N);
float NdV=clamp(abs(dot(N,V)),0.001,1.0);
float fresnel=pow(1.0-NdV,3.0);
float smallPart=pow(1.-v_thickness,8.)*pow(1.-v_ao,5.);
vec3 color=vec3(v_ao*0.025+smallPart*smoothstep(-0.5,1.,R.z)*0.975);
color+=(1.-color)*fresnel*(.25+v_ao*.75);
gl_FragColor=vec4(pow(color,vec3(1./2.2)),smoothstep(-0.1,0.2,v_worldPosition.z));
gl_FragColor.rgb=1.-gl_FragColor.ggg;
}

// ===================== BLOCK 81 =====================
#define GLSLIFY 1
attribute vec2 a_instancePosition;
attribute float a_instanceRotation;
attribute vec2 a_instanceDirection;
attribute vec2 a_uvOffsetX;
attribute float a_spriteAspect;
attribute float a_spriteScale;
attribute vec3 a_collision;
uniform float u_scale;
uniform vec2 u_resolution;
varying vec2 v_uv;
varying vec2 v_uvOffsetX;
varying vec3 v_test;
float fit(float v,float a,float b,float c,float d) {
  return c+(d-c)*((v-a)/(b-a));
}
#define PI 3.14159265358979323846
void main() {
  vec2 impulse=a_collision.xy;
  float impulseRatio=a_collision.z;
  vec2 impulseDirection=normalize(impulse);
  vec2 centerUv=2.0*(uv-0.5);
  float prod=dot(centerUv,impulseDirection);
  float rotation=a_instanceRotation;
  vec2 aspect=vec2(u_resolution.x/u_resolution.y,1.0);
  vec2 pos=position.xy+0.025*sin(PI*impulseRatio)*(0.5+0.5*sin(4.0*PI*prod+32.0*impulseRatio))*impulseDirection;
  pos*=a_spriteScale*u_scale*vec2(a_spriteAspect,1.0);
  float wobble=pow(cos(0.5*PI*impulseRatio)*sin(8.0*PI*impulseRatio),2.0);
  pos*=1.0+0.12*vec2(wobble,-wobble);
  float c=cos(rotation);
  float s=sin(rotation);
  pos=vec2(pos.x*c-pos.y*s,pos.x*s+pos.y*c);
  pos/=aspect;
  pos+=a_instancePosition;
  gl_Position=vec4(pos,0.,1.);
  v_uv=uv;
  v_uvOffsetX=a_uvOffsetX;
  v_test=a_collision;
}

// ===================== BLOCK 82 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform float u_opacity;
varying vec2 v_uv;
varying vec2 v_uvOffsetX;
varying vec3 v_test;
float fit(float v,float a,float b,float c,float d) {
  return c+(d-c)*((v-a)/(b-a));
}
#define PI 3.14159265358979323846
void main() {
  float uvX=v_uvOffsetX.x+v_uv.x*(v_uvOffsetX.y-v_uvOffsetX.x);
  vec2 texCoord=vec2(uvX,v_uv.y);
  vec4 sprite=texture2D(u_texture,texCoord);
  float color=sprite.r;
  float mask=sprite.g;
  gl_FragColor.rgb=vec3(color)*mask;
  gl_FragColor.a=u_opacity*mask;
}

// ===================== BLOCK 83 =====================
#define GLSLIFY 1
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_worldNormal;
varying vec3 v_viewPosition;
#ifdef IS_PINBOARD
attribute float instanceId;
#endif
#ifdef IS_DESK
attribute float type;
varying float v_shadow;
varying float v_type;
#endif
#include <taaJitteringVert>
void main() {
  vec3 pos=position;
  vec2 outUv=uv;
  #ifdef IS_PINBOARD
  pos.x+=instanceId*0.767429;
  outUv.y+=instanceId*.5;
  #endif
  vec4 viewPosition=modelViewMatrix*vec4(pos,1.0);
  getTAAPositions(pos,gl_Position,v_currentFramePosition,v_previousFramePosition);
  vec3 viewNormal=normalMatrix*normal;
  v_worldNormal=normalize((vec4(viewNormal,0.)*viewMatrix).xyz);
  v_uv=outUv;
  v_modelPosition=position;
  v_worldPosition=(modelMatrix*vec4(pos,1.0)).xyz;
  v_viewPosition=-viewPosition.xyz;
  #ifdef IS_DESK
  v_shadow=min(1.,abs(mod(floor(type+.5),2.)-1.))*.95+.05;
  v_shadow*=mix(max(0.,dot(v_worldNormal.xz,normalize(vec2(1.,0.2))))*.9+.1,1.,min(1.,abs(type-3.)));
  v_type=type;
  #endif
}

// ===================== BLOCK 84 =====================
#define GLSLIFY 1
#include <linearstep>
varying vec3 v_viewNormal;
varying vec2 v_uv;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_worldNormal;
varying vec3 v_viewPosition;
uniform sampler2D u_texture;
uniform vec2 u_textureSize;
uniform sampler2D u_goboTexture;
uniform mat4 u_goboMatrix;
uniform float u_goboOpacity;
uniform vec4 u_goboParams;
uniform vec3 u_lightPosition;
uniform float u_thermalRatio;
#include <getGoboBlurRatio>
#ifdef IS_DESK
uniform vec3 u_localLightPosition;
uniform vec3 u_coffeePosition;
uniform vec4 u_coffeeQuaternion;
uniform vec3 u_coasterPosition;
uniform vec4 u_coasterQuaternion;
uniform mat4 modelMatrix;
uniform mat4 u_coffeeInvMatrix;
uniform mat4 u_coasterInvMatrix;
uniform sampler2D u_hdTexture;
uniform float u_hdTextureShift;
uniform sampler2D u_reflectionTexture;
uniform vec2 u_resolution;
varying float v_shadow;
varying float v_type;
float dot2(vec2 v) {
  return dot(v,v);
}
float opUnion(float d1,float d2) {
  return min(d1,d2);
}
float opSubtraction(float d1,float d2) {
  return max(-d1,d2);
}
#include <sdCappedCone>
float map(in vec3 worldPos) {
  vec3 coasterObjSpacePos=(u_coasterInvMatrix*vec4(worldPos,1.0)).xyz;
  float yBias=-0.000025;
  float cTop=sdCappedCone(coasterObjSpacePos,vec3(0.,0.003+yBias,0.),vec3(0.,0.0175+yBias,0.),0.0415,0.045);
  float cBottom=sdCappedCone(coasterObjSpacePos,vec3(0.,0.0+yBias,0.),vec3(0.,0.003+yBias,0.),0.03912,0.0397);
  float coasterSDF=opUnion(cTop,cBottom);
  vec3 coffeeObjSpacePos=(u_coffeeInvMatrix*vec4(worldPos,1.0)).xyz;
  float coffeeRadiusBottom=0.029881315305829048;
  float coffeeRadiusTop=0.04465631768107414;
  float coffeeHeight=0.10891598463058472;
  float coffeeSDF=sdCappedCone(coffeeObjSpacePos,vec3(0.,0.,0.),vec3(0.,coffeeHeight,0.),coffeeRadiusBottom,coffeeRadiusTop);
  return opUnion(coffeeSDF,coasterSDF);
}
float calcSoftshadow(in vec3 ro,in vec3 rd,float mint,float maxt,float w) {
  float res=1.0;
  float t=mint;
  for(int i=0;
  i<32&&t<maxt;
  i++) {
    float h=map(ro+t*rd);
    res=min(res,h/(w*t));
    t+=clamp(h,0.0005,0.1);
    if(res<-1.||t>maxt)break;
  }
res=max(res,-1.);
res=0.25*(1.+res)*(1.+res)*(2.0-res);
return res;
}
#endif
#include <taaJitteringFragPars>
#include <textureBicubic>
#include <getBlueNoise>
#include <sampleBlur>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec2 uv=v_uv;
  #ifdef IS_DESK
  uv.x=pow(linearstep(0.,.25,uv.x),2.)*.1+linearstep(.25,.75,uv.x)*.8+pow(linearstep(.75,1.,uv.x),.5)*.1;
  #endif
  vec3 color=textureBicubic(u_texture,uv,u_textureSize).rgb;
  #ifdef IS_DESK
  vec2 hdUv=v_modelPosition.xz/vec2(.45,-.225)+vec2(.5,.5-.005*u_hdTextureShift);
  hdUv.y=pow(max(0.,hdUv.y),1./1.35);
  float hdD=length(hdUv-.5)*2.;
  float hdBlend=smoothstep(1.,0.95,hdD);
  color=mix(color,textureBicubic(u_hdTexture,hdUv,u_textureSize).rgb,hdBlend);
  color*=v_shadow;
  float shadow=calcSoftshadow(v_worldPosition+vec3(0.,-0.003,0.),normalize(u_lightPosition-v_worldPosition),0.005,1.0,0.03);
  shadow=clamp(shadow+u_thermalRatio*0.5,0.0,1.0);
  color*=0.05+0.95*shadow*shadow;
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec3 reflection=pow(texture2D(u_reflectionTexture,screenUv).rgb,vec3(2.2));
  color+=reflection*(v_type>1.5 ? 0.65 : 1.)*(shadow*.8+.2);
  #endif
  float gobo=1.0;
  vec4 goboNdc=u_goboMatrix*vec4(v_worldPosition,1.);
  goboNdc/=goboNdc.w;
  vec2 goboUv=goboNdc.xy*0.5+0.5;
  if(u_goboOpacity>0.&&goboUv.x>=0.0&&goboUv.x<=1.0&&goboUv.y>=0.0&&goboUv.y<=1.0) {
    gobo=sampleBlur(u_goboTexture,goboUv,vec2(1./512.),getGoboBlurRatio(goboNdc.z,u_goboParams)*2.,blueNoise.z).r;
    gobo=mix(1.0,gobo,u_goboOpacity);
    gobo=clamp(gobo+u_thermalRatio*0.5,0.0,1.0);
  }
color*=0.35+0.65*mix(vec3(0.1,0.05,0.),vec3(1.),gobo);
color=pow(color,vec3(1./2.2));
gl_FragColor=vec4(color,0.);
#include <taaJitteringFrag>
}

// ===================== BLOCK 85 =====================
#define GLSLIFY 1
varying vec3 v_worldPosition;
varying vec3 v_modelNormal;
#include <taaJitteringVert>
void main() {
  getTAAPositions(position,gl_Position,v_currentFramePosition,v_previousFramePosition);
  v_worldPosition=(modelMatrix*vec4(position,1.0)).xyz;
  v_modelNormal=normal;
}

// ===================== BLOCK 86 =====================
#define GLSLIFY 1
#include <linearstep>
varying vec3 v_worldPosition;
varying vec3 v_modelNormal;
uniform sampler2D u_goboTexture;
uniform mat4 u_goboMatrix;
uniform float u_goboOpacity;
uniform vec4 u_goboParams;
uniform float u_thermalRatio;
#include <getGoboBlurRatio>
#include <taaJitteringFragPars>
#include <getBlueNoise>
#include <sampleBlur>
void main() {
  vec3 modelNormal=normalize(v_modelNormal);
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  float gobo=1.0;
  vec4 goboNdc=u_goboMatrix*vec4(v_worldPosition,1.);
  goboNdc/=goboNdc.w;
  vec2 goboUv=goboNdc.xy*0.5+0.5;
  if(u_goboOpacity>0.&&goboUv.x>=0.0&&goboUv.x<=1.0&&goboUv.y>=0.0&&goboUv.y<=1.0) {
    gobo=sampleBlur(u_goboTexture,goboUv,vec2(1./512.),getGoboBlurRatio(goboNdc.z,u_goboParams)*2.,blueNoise.z).r;
    gobo=mix(1.0,gobo,u_goboOpacity);
    gobo=clamp(gobo,0.0,1.0);
  }
vec3 color=vec3(0.9,0.85,0.7);
color*=mix(vec3(0.3,0.25,0.2),vec3(1.),gobo);
color=pow(color,vec3(1./2.2));
gl_FragColor=vec4(color,modelNormal.z*modelNormal.z*modelNormal.z*(1.-gobo)*0.5);
#include <taaJitteringFrag>
}

// ===================== BLOCK 87 =====================
#define GLSLIFY 1
attribute vec3 position;
attribute float id;
uniform vec4 u_rect;
uniform vec2 u_viewportResolution;
uniform vec2 u_textureSize;
uniform vec2 u_scaleFix;
uniform float u_pixelRange;
uniform float u_rotation;
uniform float u_scale;
uniform float u_depth;
uniform float u_hideRatio;
varying vec2 v_uv;
varying float v_idRatio;
void main() {
  vec2 pos=position.xy*.5+.5;
  v_uv=(pos-.5)*u_scaleFix+.5;
  pos=mix(u_rect.xy,u_rect.xy+u_rect.zw,pos);
  v_idRatio=id/3.;
  float hideRatio=smoothstep(v_idRatio*0.2,v_idRatio*0.2+0.8,u_hideRatio);
  hideRatio*=hideRatio*hideRatio;
  pos.y+=hideRatio*u_rect.w*1.3;
  pos-=vec2(u_rect.x+u_rect.z*.5,u_viewportResolution.y*.5);
  pos=mat2(cos(u_rotation),-sin(u_rotation),sin(u_rotation),cos(u_rotation))*pos*u_scale;
  pos+=vec2(u_rect.x+u_rect.z*.5,u_viewportResolution.y*.5);
  pos=pos/u_viewportResolution*2.-1.;
  gl_Position=vec4(pos,u_depth,1.);
}

// ===================== BLOCK 88 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec3 u_color;
uniform vec2 u_textureSize;
uniform vec2 u_scaleFix;
uniform float u_pixelRange;
uniform vec2 u_resolution;
uniform float u_pulseRatio;
uniform sampler2D u_cupCoverTexture;
uniform sampler2D u_baseTexture;
uniform sampler2D u_screenPaintTexture;
varying vec2 v_uv;
varying float v_idRatio;
float median(float r,float g,float b) {
  return max(min(r,g),min(max(r,g),b));
}
void main() {
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec4 screenPaint=texture2D(u_screenPaintTexture,screenUv);
  vec3 msdf=texture2D(u_texture,v_uv).rgb;
  float sd=median(msdf.r,msdf.g,msdf.b);
  float screenPxDistance=(sd-.4)*u_pixelRange/length(vec2(dFdx(v_uv.x),dFdy(v_uv.y))*u_textureSize/u_scaleFix);
  float opacity=clamp(screenPxDistance*2.,0.,1.);
  vec4 baseColor=texture2D(u_baseTexture,screenUv);
  float cupCoverMask=1.-texture2D(u_cupCoverTexture,screenUv).r;
  opacity*=cupCoverMask;
  float l=0.5+u_pulseRatio*2.;
  float d=(1.-u_pulseRatio)*(1.+l)-(1.-v_uv.y*0.8+v_uv.x*0.2)-l;
  float pulseAlpha=smoothstep(-l,-0.0001,d)*smoothstep(0.,-0.0001,d)*smoothstep(0.,0.2,u_pulseRatio);
  float alpha=opacity*max(pulseAlpha,0.2+0.8*screenPaint.z);
  gl_FragColor=mix(baseColor,vec4(u_color,baseColor.a+alpha),opacity);
}

// ===================== BLOCK 89 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec4 u_rect;
uniform vec2 u_viewportResolution;
varying vec2 v_uv;
void main() {
  vec2 pos=position.xy*.5+.5;
  v_uv=pos;
  pos=mix(u_rect.xy,u_rect.xy+u_rect.zw,pos)/u_viewportResolution*2.-1.;
  gl_Position=vec4(pos,0.,1.);
}

// ===================== BLOCK 90 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec4 u_rect;
uniform vec2 u_resolution;
uniform vec2 u_viewportResolution;
uniform float u_activeRatio;
varying vec2 v_uv;
#include <getBlueNoise>
vec4 sampleBlur(sampler2D tex,vec2 uv,vec2 texelSize,float blurAmount,float n,vec4 clampRect) {
  const float G=2.39996323;
  float gc=cos(G);
  float gs=sin(G);
  mat2 rot=mat2(gc,gs,-gs,gc);
  float initialAngle=n*6.28318530718;
  vec2 d=vec2(cos(initialAngle),sin(initialAngle));
  float sn=1.0/sqrt(float(BLUR_SAMPLE));
  vec2 s=texelSize*blurAmount*sn;
  vec4 c=vec4(0.);
  for(int i=0;
  i<BLUR_SAMPLE;
  i++) {
    float r=sqrt(float(i+1));
    vec4 tex=texture2D(tex,clamp(uv+d*r*s,clampRect.xy,clampRect.zw));
    c+=vec4(pow(tex.rgb,vec3(2.2)),tex.a);
    d=rot*d;
  }
return c/float(BLUR_SAMPLE);
}
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec2 uv=(v_uv*2.-1.)*vec2(u_rect.z/u_rect.w,1.);
  float vignette=smoothstep(0.6,1.,length(uv));
  vec4 clampRect=vec4(u_rect.xy+1.,u_rect.xy+u_rect.zw-1.)/u_viewportResolution.xyxy;
  vec4 map=sampleBlur(u_texture,screenUv,1./u_resolution,vignette*u_rect.w*0.005*u_activeRatio,blueNoise.z,clampRect);
  vec3 color=map.rgb;
  color*=mix(vec3(1.),mix(vec3(0.85,0.78,0.7),vec3(0.45,0.4,0.35),length(uv)),u_activeRatio);
  gl_FragColor=vec4(pow(color,vec3(1./2.2)),map.a);
}

// ===================== BLOCK 91 =====================
#define GLSLIFY 1
attribute vec3 position;
varying vec2 v_uv;
uniform vec2 u_scaleFix;
uniform float u_shrinkRatio;
uniform vec4 u_rectFrom;
uniform vec4 u_rectTo;
uniform vec3 u_center;
uniform vec2 u_viewportResolution;
varying vec2 v_rectSize;
void main() {
  vec2 pos=position.xy*.5+.5;
  v_uv=(pos-.5)*u_scaleFix+.5;
  vec4 rect=mix(u_rectFrom,u_rectTo,u_shrinkRatio);
  pos=mix(rect.xy,rect.xy+rect.zw,pos)/u_viewportResolution;
  pos=pos*2.-1.;
  gl_Position=vec4(pos,0.,1.);
  v_rectSize=rect.zw;
}

// ===================== BLOCK 92 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform vec3 u_color;
uniform vec2 u_textureSize;
uniform vec2 u_scaleFix;
uniform float u_pixelRange;
uniform vec2 u_resolution;
uniform float u_pulseRatio;
uniform float u_glowRatio;
uniform float u_opacity;
varying vec2 v_uv;
varying vec2 v_rectSize;
#include <linearstep>
#include <getBlueNoise>
#include <getBgColor>
float median(float r,float g,float b) {
  return max(min(r,g),min(max(r,g),b));
}
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec3 msdf=texture2D(u_texture,v_uv).rgb;
  float sd=median(msdf.r,msdf.g,msdf.b);
  float screenPxDistance=(sd-.5)*u_pixelRange/length(vec2(dFdx(v_uv.x),dFdy(v_uv.y))*u_textureSize/u_scaleFix);
  float opacity=clamp(screenPxDistance*2.+.5,0.,1.)*u_opacity;
  vec3 bgColor=pow(getBgColor(blueNoise.z),vec3(1./2.2));
  vec3 color=mix(bgColor,u_color,opacity);
  float d=-length((v_uv-.5)*vec2(1.,v_rectSize.y/v_rectSize.x))+u_pulseRatio*2.;
  float alpha=clamp(d,0.,1.)*opacity;
  gl_FragColor=vec4(color,alpha*u_glowRatio);
}

// ===================== BLOCK 93 =====================
#define GLSLIFY 1
attribute float side;
attribute vec4 boneIndices;
attribute vec4 boneWeights;
uniform sampler2D u_animTexture;
uniform vec2 u_animTexelSize;
uniform vec3 u_animBlendParams;
uniform float u_isBack;
uniform float u_offset;
uniform vec3 u_pMin;
uniform vec3 u_pMax;
uniform vec4 u_orientMin;
uniform vec4 u_orientMax;
uniform float u_boneCount;
uniform float u_frameCount;
uniform vec4 u_uvMap;
varying vec3 v_viewPosition;
varying vec3 v_viewNormal;
varying vec3 v_worldPosition;
varying vec2 v_uv;
#include <taaJitteringVert>
vec2 unpackFactors=vec2(1./256.,255./256.);
vec3 qrotate(vec4 q,vec3 v) {
  return v+2.*cross(q.xyz,cross(q.xyz,v)+q.w*v);
}
void computeSkin(inout vec3 p,inout vec3 n,vec2 xy,float w) {
  vec3 p0=texture2D(u_animTexture,xy*u_animTexelSize).xyz;
  vec3 p1=texture2D(u_animTexture,(xy+vec2(1.,0.))*u_animTexelSize).xyz;
  vec4 o0=texture2D(u_animTexture,(xy+vec2(0.,1.))*u_animTexelSize);
  vec4 o1=texture2D(u_animTexture,(xy+1.)*u_animTexelSize);
  vec3 bp=mix(u_pMin,u_pMax,p0*unpackFactors.x+p1*unpackFactors.y);
  vec4 bo=mix(u_orientMin,u_orientMax,o0*unpackFactors.x+o1*unpackFactors.y);
  p+=(qrotate(bo,position)+bp)*w;
  n+=qrotate(bo,normal)*w;
}
void main() {
  vec3 posFrom=vec3(0.);
  vec3 posTo=vec3(0.);
  vec3 norFrom=vec3(0.);
  vec3 norTo=vec3(0.);
  vec2 xyFrom=vec2(.5,u_animBlendParams.x+.5);
  vec2 xyTo=vec2(.5,u_animBlendParams.y+.5);
  computeSkin(posFrom,norFrom,xyFrom+vec2(boneIndices.x*2.,0.),boneWeights.x);
  computeSkin(posFrom,norFrom,xyFrom+vec2(boneIndices.y*2.,0.),boneWeights.y);
  computeSkin(posFrom,norFrom,xyFrom+vec2(boneIndices.z*2.,0.),boneWeights.z);
  computeSkin(posFrom,norFrom,xyFrom+vec2(boneIndices.w*2.,0.),boneWeights.w);
  norFrom=normalize(norFrom);
  computeSkin(posTo,norTo,xyTo+vec2(boneIndices.x*2.,0.),boneWeights.x);
  computeSkin(posTo,norTo,xyTo+vec2(boneIndices.y*2.,0.),boneWeights.y);
  computeSkin(posTo,norTo,xyTo+vec2(boneIndices.z*2.,0.),boneWeights.z);
  computeSkin(posTo,norTo,xyTo+vec2(boneIndices.w*2.,0.),boneWeights.w);
  norTo=normalize(norTo);
  vec3 pos=mix(posFrom,posTo,u_animBlendParams.z);
  pos.x+=side*u_offset*0.5;
  pos.z+=u_offset*2.;
  vec3 nor=normalize(mix(norFrom,norTo,u_animBlendParams.z));
  vec4 viewPosition=modelViewMatrix*vec4(pos,1.0);
  v_viewPosition=-viewPosition.xyz;
  v_viewNormal=normalMatrix*nor;
  getTAAPositions(pos,gl_Position,v_currentFramePosition,v_previousFramePosition);
  gl_Position.z+=(u_isBack-.5)*0.2*gl_Position.w;
  v_uv=(position.xy-u_uvMap.xy)/u_uvMap.zw;
  v_worldPosition=(modelMatrix*vec4(pos,1.0)).xyz;
  v_viewPosition=-viewPosition.xyz;
}

// ===================== BLOCK 94 =====================
#define GLSLIFY 1
uniform float u_isBack;
uniform float u_opacity;
uniform float u_harmonicsTime;
uniform sampler2D u_baseTexture;
uniform sampler2D u_harmonics0Texture;
uniform sampler2D u_harmonics1Texture;
uniform float u_harmonicsStrength;
uniform float u_harmonicsFreq[5];
uniform sampler2D u_normalTexture;
uniform sampler2D u_envTexture;
uniform sampler2D u_patternTexture;
uniform sampler2D u_specEnvTexture;
uniform vec3 u_lightPosition;
uniform vec3 u_color;
#ifdef IS_BACK
#else
uniform sampler2D u_sceneCacheTexture;
uniform vec2 u_resolution;
#endif
varying vec2 v_uv;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
#include <hsb2rgb>
#include <sampleHarmonics>
#include <taaJitteringFragPars>
#include <cart2Polar>
varying vec3 v_viewNormal;
mat3 getTangentFrame(vec3 eye_pos,vec3 surf_norm,vec2 uv) {
  vec3 q0=dFdx(eye_pos.xyz);
  vec3 q1=dFdy(eye_pos.xyz);
  vec2 st0=dFdx(uv.st);
  vec2 st1=dFdy(uv.st);
  vec3 N=surf_norm;
  vec3 q1perp=cross(q1,N);
  vec3 q0perp=cross(N,q0);
  vec3 T=q1perp*st0.x+q0perp*st1.x;
  vec3 B=q1perp*st0.y+q0perp*st1.y;
  float det=max(dot(T,T),dot(B,B));
  float scale=(det==0.0)? 0.0 : inversesqrt(det);
  return mat3(T*scale,B*scale,N);
}
vec3 RRTAndODTFit(vec3 v) {
  vec3 a=v*(v+0.0245786)-0.000090537;
  vec3 b=v*(0.983729*v+0.4329510)+0.238081;
  return a/b;
}
#include <aces>
float getAO(vec2 uv) {
  return sampleHarmonics(u_baseTexture,u_harmonics0Texture,uv,vec3(u_harmonicsFreq[0],u_harmonicsFreq[1],u_harmonicsFreq[2]),u_harmonicsTime,u_harmonicsStrength)+sampleHarmonics(u_harmonics1Texture,uv,vec2(u_harmonicsFreq[3],u_harmonicsFreq[4]),u_harmonicsTime,u_harmonicsStrength);
}
vec3 blendOverlay(vec3 base,vec3 blend) {
  return mix(1.0-2.0*(1.0-base)*(1.0-blend),2.0*base*blend,step(base,vec3(0.5)));
}
#include <perturbNormalArb>
#include <sampleBlur>
#include <getBlueNoise>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  float faceDirection=gl_FrontFacing ? 1.0 :-1.0;
  float normalMask=max(smoothstep(.792,0.793,2.0*abs(v_uv.x-0.5)),smoothstep(.792,0.793,2.0*abs(v_uv.y-0.5)));
  vec3 viewNormal=normalize(v_viewNormal)*faceDirection;
  vec2 normalUv=90.0*v_uv;
  mat3 tbn=getTangentFrame(-v_viewPosition,viewNormal,normalUv);
  vec3 normalTexture=texture2D(u_normalTexture,normalUv).xyz*2.0-1.0;
  normalTexture.xy*=-0.25*normalMask;
  normalTexture=normalize(normalTexture);
  vec3 perturbedNormal=normalize(tbn*normalTexture);
  float ao=getAO(v_uv);
  float bumpScale=1.;
  vec2 dSTdx=dFdx(v_uv)*2.;
  vec2 dSTdy=dFdy(v_uv)*2.;
  vec2 dHdxy=(vec2(getAO(v_uv+dSTdx),getAO(v_uv+dSTdy))-ao)*bumpScale;
  perturbedNormal=perturbNormalArb(-v_viewPosition,perturbedNormal,dHdxy,1.0);
  vec3 N=normalize((vec4(perturbedNormal,0.)*viewMatrix).xyz);
  vec3 V=normalize(cameraPosition-v_worldPosition);
  vec3 reflection=normalize(reflect(-V,N));
  float NdV=clamp(abs(dot(N,V)),0.001,1.0);
  float fresnel=pow(1.0-NdV,5.0);
  #ifdef IS_BACK
  vec3 albedo=u_color;
  float roughness=0.8;
  float metallic=1.0;
  #else
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  float reverseAo=pow(1.-ao,3.);
  float blurAmount=(1.-abs(perturbedNormal.z));
  vec3 sceneColor=sampleBlur(u_sceneCacheTexture,screenUv,1./u_resolution,blurAmount*u_resolution.y/300.,blueNoise.z).rgb;
  sceneColor=pow(sceneColor,vec3(2.2));
  vec3 albedo=u_color*sceneColor;
  float roughness=blurAmount;
  float metallic=0.0;
  #endif
  vec3 f0=vec3(0.04);
  vec3 diffuseColor=albedo*(vec3(1.0)-f0)*(1.0-metallic);
  vec3 specularColor=mix(f0,albedo,metallic);
  vec3 diffuseLight=texture2D(u_envTexture,cart2Polar(N)).rgb;
  #ifdef IS_BACK
  vec2 patternUv=mat2(1.,-2.,1.,2.)*sqrt(2.)*v_uv*0.86;
  float pattern=texture2D(u_patternTexture,patternUv).r;
  albedo=mix(albedo,vec3(1.),pattern);
  vec3 color=0.5*albedo;
  color+=diffuseColor*diffuseLight*(1.+pattern*0.5);
  color*=ao;
  #else
  vec3 specularLight=texture2D(u_specEnvTexture,cart2Polar(reflection)).rgb*20.;
  vec3 indirect=diffuseColor*diffuseLight+specularLight*specularColor;
  vec3 color=sceneColor;
  float d=clamp(dot(viewNormal,vec3(0.5773)),0.0,1.0);
  color+=reverseAo*d*(0.1+u_color);
  color+=indirect;
  color*=mix(1.0,0.6,blurAmount);
  color+=0.5*indirect*u_opacity*smoothstep(.75,0.8,d);
  color=mix(sceneColor,color,u_opacity);
  #endif
  color=clamp(color,0.,1.);
  float alpha=u_opacity;
  #ifdef IS_BACK
  color=aces(color);
  #else
  alpha=specularLight.r;
  #endif
  gl_FragColor=vec4(color,alpha);
  gl_FragColor.rgb=pow(gl_FragColor.rgb,vec3(1./2.2));
  #include <taaJitteringFrag>
}

// ===================== BLOCK 95 =====================
#define GLSLIFY 1
varying vec3 v_viewNormal;
varying vec3 v_worldPosition;
varying vec2 v_uv1;
varying vec2 v_uv2;
varying vec3 v_viewPosition;
varying vec3 v_modelPosition;
attribute vec4 boneIndices;
attribute vec4 boneWeights;
attribute vec4 fingerWeights;
uniform sampler2D u_skinPositionTexture;
uniform sampler2D u_skinOrientTexture;
uniform vec2 u_skinTextureSize;
uniform vec2 u_uvOffset1;
uniform vec2 u_uvOffset2;
varying float v_f;
varying vec4 v_fingerWeights;
vec3 qrotate(vec4 q,vec3 v) {
  return v+2.*cross(q.xyz,cross(q.xyz,v)+q.w*v);
}
void applySkin(inout vec3 pos,inout vec3 nor,float boneIndex,float boneWeight) {
  vec2 skinUv=vec2(boneIndex+.5,.5)/u_skinTextureSize;
  vec4 quat=texture2D(u_skinOrientTexture,skinUv);
  pos+=(qrotate(quat,position)+texture2D(u_skinPositionTexture,skinUv).xyz)*boneWeight;
  nor+=qrotate(quat,normal)*boneWeight;
}
#include <taaJitteringVert>
void main() {
  vec3 pos=vec3(0.);
  vec3 nor=vec3(0.);
  applySkin(pos,nor,boneIndices.x,boneWeights.x);
  applySkin(pos,nor,boneIndices.y,boneWeights.y);
  applySkin(pos,nor,boneIndices.z,boneWeights.z);
  applySkin(pos,nor,boneIndices.w,boneWeights.w);
  vec4 viewPos=modelViewMatrix*vec4(pos,1.0);
  getTAAPositions(pos,gl_Position,v_currentFramePosition,v_previousFramePosition);
  v_uv1=uv*0.5+u_uvOffset1;
  v_uv2=uv*0.5+u_uvOffset2;
  v_viewPosition=-viewPos.xyz;
  v_viewNormal=normalMatrix*nor;
  v_worldPosition=(modelMatrix*vec4(pos,1.0)).xyz;
  v_f=dot(normal,normalize(vec3(.6,.5,0.)+position*8.));
  v_modelPosition=position;
  v_fingerWeights=fingerWeights;
}

// ===================== BLOCK 96 =====================
#define GLSLIFY 1
varying vec3 v_viewNormal;
varying vec2 v_uv1;
varying vec2 v_uv2;
varying vec3 v_modelPosition;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
varying float v_f;
uniform sampler2D u_handTexture;
uniform float u_animationRatio;
uniform vec3 u_rimColor;
uniform float u_uvBlend;
uniform vec2 u_resolution;
uniform float u_haloLightStrength;
uniform float u_opacity;
uniform float u_highlightRatio;
uniform sampler2D u_lmsTexture;
uniform float u_time;
varying vec4 v_fingerWeights;
uniform vec4 u_fingerWeights;
#include <linearstep>
#include <getBlueNoise>
#include <getBgColor>
#include <taaJitteringFragPars>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec3 viewNormal=normalize(v_viewNormal);
  vec3 N=normalize((vec4(viewNormal,0.)*viewMatrix).xyz);
  vec3 V=normalize(cameraPosition-v_worldPosition);
  vec3 rimColor=pow(u_rimColor,vec3(2.2));
  vec3 albedo=mix(texture2D(u_handTexture,v_uv1).rgb,texture2D(u_handTexture,v_uv2).rgb,max(min(1.,dot(u_fingerWeights,v_fingerWeights)),u_uvBlend));
  float lumaPerceptual=dot(albedo,vec3(0.2126,0.7152,0.0722));
  float lumaLinear=dot(albedo,vec3(0.2126,0.7152,0.0722));
  float luma=mix(lumaPerceptual,lumaLinear,0.9);
  float lightIntensity=300.0*u_highlightRatio;
  float specularPower=50.0;
  float scatterIntensity=100.0*u_highlightRatio;
  float scatterPower=4.0;
  float scatterDistortion=0.5;
  vec3 appleColor0=texture2D(u_lmsTexture,4.0*v_modelPosition.yz+blueNoise.xy*0.5-u_time).rgb;
  vec3 appleColor1=texture2D(u_lmsTexture,4.0*v_modelPosition.yz+blueNoise.xy*0.5+u_time).rgb;
  vec3 color=albedo+u_highlightRatio*albedo*mix(appleColor0,appleColor1,0.5);
  vec3 lightPos=100.0*vec3(0.8,-0.9,-0.05);
  vec3 L=normalize(lightPos-v_worldPosition);
  vec3 H=normalize(V+L);
  float NdH=max(0.0,dot(N,H));
  float NdL=max(0.0,dot(N,L));
  float spec=pow(NdH,specularPower);
  float totalSpec=spec;
  color+=appleColor0*0.4*lightIntensity*luma*NdL*spec;
  float backNdL=max(0.0,dot(-N,L));
  vec3 scatterDir=normalize(L+N*scatterDistortion);
  float scatter=pow(max(0.0,dot(V,-scatterDir)),scatterPower);
  color+=2.0*scatterIntensity*luma*rimColor*scatter*backNdL;
  lightPos=100.0*vec3(-0.7,-0.5,-0.2);
  L=normalize(lightPos-v_worldPosition);
  H=normalize(V+L);
  NdH=max(0.0,dot(N,H));
  NdL=max(0.0,dot(N,L));
  spec=pow(NdH,specularPower);
  totalSpec+=spec;
  color+=appleColor1*lightIntensity*luma*NdL*spec;
  backNdL=max(0.0,dot(-N,L));
  scatterDir=normalize(L+N*scatterDistortion);
  scatter=pow(max(0.0,dot(V,-scatterDir)),scatterPower);
  color+=3.0*scatterIntensity*luma*rimColor*scatter*backNdL;
  gl_FragColor=vec4(color,min(1.,totalSpec*2.));
  float screenY=gl_FragCoord.y/u_resolution.y;
  float opacity=smoothstep(0.,1.,u_opacity*2.-(.5-min(.5,screenY)*2.));
  gl_FragColor.rgb=mix(getBgColor(blueNoise.z),gl_FragColor.rgb,opacity);
  gl_FragColor.rgb=pow(gl_FragColor.rgb,vec3(1.0/2.2));
  #include <taaJitteringFrag>
}

// ===================== BLOCK 97 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec4 u_rect;
uniform vec2 u_viewportResolution;
uniform vec2 u_textureSize;
uniform float u_zoom;
uniform vec2 u_zoomCenter;
uniform float u_rotation;
uniform float u_scale;
varying vec2 v_uv;
varying vec2 v_toZoomCenter;
void main() {
  vec2 pos=position.xy*.5+.5;
  v_uv=(pos-.5)*u_rect.zw;
  float c=cos(u_rotation);
  float s=sin(u_rotation);
  v_uv=v_uv*mat2(c,-s,s,c);
  v_uv=v_uv/u_scale;
  v_uv=v_uv/u_rect.zw+.5;
  pos=mix(u_rect.xy,u_rect.xy+u_rect.zw,pos)/u_viewportResolution;
  pos=pos*2.-1.;
  pos-=u_zoomCenter;
  v_toZoomCenter=pos*u_viewportResolution;
  pos=pos*u_zoom+u_zoomCenter*u_zoom;
  gl_Position=vec4(pos,0.,1.0);
}

// ===================== BLOCK 98 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform sampler2D u_clipTexture;
uniform sampler2D u_sceneCacheTexture;
uniform vec2 u_resolution;
uniform vec2 u_textureSize;
uniform float u_showRatio;
uniform float u_opacity;
uniform vec2 u_viewportResolution;
uniform sampler2D u_pinTexture;
uniform vec2 u_pinTextureSize;
uniform vec2 u_pinScaleFix;
uniform float u_pinPixelRange;
uniform vec3 u_pinColor;
uniform float u_pinShowRatio;
uniform float u_time;
uniform vec2 u_easedMouse;
varying vec2 v_uv;
varying vec2 v_toZoomCenter;
#include <getBlueNoise>
#include <sampleBlur>
#include <sampleBlurSRGB>
#include <linearstep>
float median(float r,float g,float b) {
  return max(min(r,g),min(max(r,g),b));
}
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec2 texelSize=1.0/u_textureSize;
  float blurRatio=linearstep(0.15,0.2+u_showRatio*0.6,length(v_toZoomCenter)/u_viewportResolution.y);
  blurRatio=blurRatio*blurRatio*(1.-u_showRatio);
  vec4 color=sampleBlur(u_texture,v_uv,texelSize,blurRatio*200.*256./u_viewportResolution.y,blueNoise.z);
  float clipRatio=linearstep(.5,.7,u_showRatio);
  vec2 clipUv=(v_uv*vec2(850.,1100.)-vec2(282.,612.))/vec2(256.,256.);
  vec4 clipColor=sampleBlur(u_clipTexture,clipUv,vec2(1./256.),blurRatio*200.,blueNoise.z);
  clipColor.rgb*=mix(1.,smoothstep(0.2,0.325,length(clipUv-vec2(.45,.45))),linearstep(.2,.5,u_showRatio));
  color=mix(color,clipColor,linearstep(0.5,0.4,length(clipUv-.5))*(1.-linearstep(.5,.7,u_showRatio)));
  vec4 sceneColor=sampleBlurSRGB(u_sceneCacheTexture,screenUv,1./u_resolution,blurRatio*200.*256./u_viewportResolution.y*u_opacity,blueNoise.z);
  float blendRatio=smoothstep(blurRatio*0.25,1.+blurRatio*0.25,u_opacity*1.25);
  gl_FragColor=mix(sceneColor,color,blendRatio);
  vec2 pinUv=(v_uv-.5)*mix(1.8,1.5,u_pinShowRatio)+.5;
  pinUv=(pinUv*u_textureSize-vec2(240.,330.+(1.-u_pinShowRatio)*40.)+gl_FragColor.rg*20.)/u_pinTextureSize;
  pinUv+=(1.+pow((1.-pinUv.y),2.))*u_easedMouse*-0.025;
  vec3 pinMsdf=texture2D(u_pinTexture,pinUv).rgb;
  float pinSd=median(pinMsdf.r,pinMsdf.g,pinMsdf.b);
  pinSd=(pinSd-.5)*u_pinPixelRange/length(vec2(dFdx(pinUv.x),dFdy(pinUv.y))*u_pinTextureSize/u_pinScaleFix);
  float pinOpacity=clamp(pinSd*2.+.5,0.,1.)*smoothstep(-0.05,0.05,gl_FragColor.r)*smoothstep(0.95,0.8,pinUv.y)*smoothstep(0.4,1.,pinUv.y+u_pinShowRatio);
  pinOpacity*=u_pinShowRatio;
  float d=length(pinUv-vec2(0.68,0.08));
  pinOpacity*=pinOpacity*max(linearstep(0.25,0.125,d)*1.5,0.5+(sin(u_time*-6.+d*8.)*.5+.5)*1.);
  gl_FragColor.rgb+=u_pinColor*pinOpacity;
  gl_FragColor.rgb=pow(min(gl_FragColor.rgb,vec3(1.)),vec3(1./2.2));
  gl_FragColor.a=max(sceneColor.g*(1.-blendRatio),pinOpacity);
}

// ===================== BLOCK 99 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform mat4 u_mvp;
varying vec2 v_uv;
void main() {
  v_uv=position.xy*.5+.5;
  gl_Position=u_mvp*vec4(position,1.0);
}

// ===================== BLOCK 100 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform sampler2D u_screenPaintTexture;
uniform vec2 u_resolution;
uniform vec3 u_mixer;
uniform float u_opacity;
uniform float u_activeRatio;
uniform vec3 u_color;
uniform float u_blur;
varying vec2 v_uv;
vec3 sampleBlur(sampler2D tex,vec2 uv,vec2 texelSize,float blurAmount,float n) {
  const float G=2.39996323;
  float gc=cos(G);
  float gs=sin(G);
  mat2 rot=mat2(gc,gs,-gs,gc);
  float initialAngle=n*6.28318530718;
  vec2 uvOffset=vec2(5./512.,0.);
  vec2 d=vec2(cos(initialAngle),sin(initialAngle));
  float sn=1.0/sqrt(float(BLUR_SAMPLE));
  vec2 s=texelSize*blurAmount*sn;
  vec3 c=vec3(0.);
  for(int i=0;
  i<BLUR_SAMPLE;
  i++) {
    float r=sqrt(float(i+1));
    vec2 o=d*r*s;
    vec3 masks=c+=vec3(dot(u_mixer,texture2D(u_texture,uv+o-uvOffset).rgb),dot(u_mixer,texture2D(u_texture,uv+o).rgb),dot(u_mixer,texture2D(u_texture,uv+o+uvOffset).rgb));
    d=rot*d;
  }
return c/float(BLUR_SAMPLE);
}
#include <getBlueNoise>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec4 screenPaint=texture2D(u_screenPaintTexture,screenUv);
  float paint=smoothstep(0.1,0.3,0.5*(screenPaint.z+screenPaint.w));
  vec3 masks=sampleBlur(u_texture,v_uv,vec2(1./512.),15.*min((1.-paint),u_blur),blueNoise.z)*2.;
  float alpha=max(u_opacity,paint*(0.5+u_opacity*0.5)*2.)*masks.g*u_activeRatio;
  vec3 color=mix(u_color,(u_color*masks*0.75+masks*0.25),paint);
  gl_FragColor=vec4(min(vec3(1.),color*(1.+paint)),alpha);
}

// ===================== BLOCK 101 =====================
#define GLSLIFY 1
uniform vec3 u_color;
uniform vec2 u_resolution;
uniform float u_transitionRatio;
uniform float u_pealRatio;
uniform sampler2D u_goboTexture;
uniform mat4 u_goboMatrix;
uniform float u_goboOpacity;
uniform vec4 u_goboParams;
uniform float u_screenOffsetY;
varying vec2 v_uv;
#include <linearstep>
#include <getBlueNoise>
#include <sampleBlur>
#include <getGoboBlurRatio>
void main() {
  vec3 blueNoise=getBlueNoise(gl_FragCoord.xy);
  vec3 worldPos=vec3((v_uv-.5)*vec2(u_resolution.x/u_resolution.y,1.),0.);
  worldPos.y+=u_screenOffsetY;
  float gobo=1.0;
  vec4 goboNdc=u_goboMatrix*vec4(worldPos,1.);
  goboNdc/=goboNdc.w;
  vec2 goboUv=goboNdc.xy*0.5+0.5;
  if(u_goboOpacity>0.&&goboUv.x>=0.0&&goboUv.x<=1.0&&goboUv.y>=0.0&&goboUv.y<=1.0) {
    float blurRatio=linearstep(-0.3,0.5,dot(worldPos.xy,normalize(vec2(-1.,-1.))));
    gobo=sampleBlur(u_goboTexture,goboUv,vec2(1./512.),blurRatio*blurRatio*3.,blueNoise.z).r;
    gobo=mix(1.0,gobo,u_goboOpacity);
    float f=mix(0.3,0.005,blurRatio);
    gobo=mix(1.-f,1.,gobo);
  }
gl_FragColor=vec4(u_color*gobo,0.);
gl_FragColor.rgb=pow(gl_FragColor.rgb,vec3(1./2.2));
gl_FragColor.rgb*=clamp(u_pealRatio*1.5-0.5+v_uv.x*0.5,0.,1.);
}

// ===================== BLOCK 102 =====================
#define GLSLIFY 1
attribute float side;
attribute float Cd;
uniform float u_pealRatio;
varying vec3 v_viewNormal;
varying vec3 v_viewPosition;
varying vec2 v_diffUv;
varying vec2 v_shadowUv;
varying float v_ratio;
varying float v_ao;
varying float v_side;
varying vec3 v_localPos;
#define PI 3.141592653589
vec4 quaternion(float angle,vec3 axis) {
  angle*=.5;
  return vec4(axis*sin(angle),cos(angle));
}
vec3 qrotate(vec4 q,vec3 v) {
  return v+2.0*cross(q.xyz,cross(q.xyz,v)+q.w*v);
}
void bendRollShape(inout vec3 pos,inout vec3 nor,float bend,float originZ,float caplen) {
  float side=pos.z>0. ? 1. :-1.;
  pos.z=abs(pos.z);
  vec3 origin=vec3(0,0,originZ);
  vec3 dir=normalize(vec3(0.,0.1,1.));
  vec3 axis1=vec3(-1.,0.,0.);
  vec3 axis2=cross(axis1,dir);
  mat3 rot_matrix=transpose(mat3(axis1.x,axis1.y,axis1.z,axis2.x,axis2.y,axis2.z,dir.x,dir.y,dir.z));
  mat3 inverse=transpose(rot_matrix);
  vec3 original=(pos-origin)*inverse;
  float bend_threshold=0.0001;
  if(abs(bend)>bend_threshold&&(original.z>=0.)) {
    vec3 center=vec3(0,caplen/bend,0);
    vec4 q=quaternion(bend*original.z/caplen,vec3(-1.,0.,0.));
    original.z=0.;
    original=qrotate(q,original);
    original+=center-qrotate(q,center);
    nor.z*=side;
    nor=qrotate(q,nor*inverse)*rot_matrix;
    nor.z*=side;
  }
pos=original*rot_matrix+origin;
pos.z*=side;
}
#include <taaJitteringVert>
void main() {
  vec3 pos=position;
  vec3 nor=normal;
  vec3 posA=vec3(-0.16,0.,-0.11*side);
  vec3 posB=vec3(0.12,0.,0.);
  float abLength=length(posA-posB);
  pos-=posA;
  float angle=atan(posB.x-posA.x,posB.z-posA.z)+PI*.5;
  vec4 q=quaternion(angle,vec3(0.,1.,0.));
  pos=qrotate(q,pos);
  nor=qrotate(q,nor);
  float bend=u_pealRatio;
  bendRollShape(pos,nor,bend*PI*2.,abLength*(1.-bend)*0.8,0.15);
  q.x*=-1.;
  q.y*=-1.;
  q.z*=-1.;
  pos=qrotate(q,pos);
  nor=qrotate(q,nor);
  pos+=posA;
  v_viewNormal=normalMatrix*nor;
  vec4 mvPosition=modelViewMatrix*vec4(pos,1.0);
  v_viewPosition=-mvPosition.xyz;
  getTAAPositions(pos,gl_Position,v_currentFramePosition,v_previousFramePosition);
  v_diffUv=vec2(uv.x,uv.y*2./3.);
  v_shadowUv=vec2(uv.x,(uv.y+2.)/3.);
  v_ratio=clamp(dot(position-posA,(posB-posA)/abLength),0.,1.);
  v_ao=Cd;
  v_side=side;
  v_localPos=position;
}

// ===================== BLOCK 103 =====================
#define GLSLIFY 1
uniform sampler2D u_texture;
uniform float u_showRatio;
uniform float u_pealRatio;
uniform vec2 u_easedMouse;
varying vec3 v_viewNormal;
varying vec3 v_viewPosition;
varying vec2 v_diffUv;
varying vec2 v_shadowUv;
varying float v_ratio;
varying float v_ao;
varying float v_side;
varying vec3 v_localPos;
#include <linearstep>
#include <taaJitteringFragPars>
#include <perturbNormalArb>
void main() {
  vec3 viewNormal=normalize(v_viewNormal);
  vec3 diff=texture2D(u_texture,v_diffUv).rgb;
  vec3 shadowmask=texture2D(u_texture,v_shadowUv).rgb;
  vec2 dSTdx=dFdx(v_diffUv);
  vec2 dSTdy=dFdy(v_diffUv);
  vec2 dHdxy=(vec2(texture2D(u_texture,v_diffUv+dSTdx).g,texture2D(u_texture,v_diffUv+dSTdy).g)-diff.g)*3.0;
  viewNormal=perturbNormalArb(-v_viewPosition,viewNormal,dHdxy,1.0);
  float t=min(1.,u_pealRatio*u_pealRatio*(1.+v_ratio))*2.;
  float shadow=mix(mix(shadowmask.r,shadowmask.g,linearstep(0.2,1.,t+u_easedMouse.x*0.025)),shadowmask.b,linearstep(1.,1.6,t));
  shadow=pow(shadow,2.+(1.-v_ao*v_ao)*5.*t/2.+u_easedMouse.y*0.1);
  vec3 color=diff*shadow*1.5;
  float luma=dot(color,vec3(0.299,0.587,0.114));
  color=mix(vec3(luma),color,1.2);
  color=color*1.35;
  vec3 reflection=reflect(-normalize(v_viewPosition),viewNormal);
  float spec=smoothstep(0.9,1.,dot(reflection,normalize(vec3(0.,v_side*-0.6,0.85)+vec3(u_easedMouse.xy,0.)*0.2)))*diff.g*diff.g*v_ao*v_ao*shadow*10.;
  color+=spec;
  color=clamp(color*u_showRatio*u_showRatio,0.,1.);
  color*=smoothstep(0.135,0.12,abs(v_localPos.x));
  gl_FragColor=vec4(pow(color,vec3(1./2.2)),min(spec*0.35,1.));
  #include <taaJitteringFrag>
}

// ===================== BLOCK 104 =====================
#define GLSLIFY 1
attribute vec3 position;
uniform vec4 u_rect;
uniform vec2 u_viewportResolution;
uniform vec2 u_size;
varying float v_x;
varying float v_dist;
void main() {
  vec2 pos=position.xy/u_size+.5;
  pos=mix(u_rect.xy,u_rect.xy+u_rect.zw,pos)/u_viewportResolution;
  v_x=pos.x;
  v_dist=position.z;
  pos=pos*2.-1.;
  gl_Position=vec4(pos,0.,1.0);
}

// ===================== BLOCK 105 =====================
#define GLSLIFY 1
uniform vec3 u_bgColor;
uniform vec3 u_color;
uniform float u_pealRatio;
uniform float u_pulseRatio;
uniform float u_transitionRatio;
varying float v_x;
varying float v_dist;
#include <linearstep>
void main() {
  vec3 color=u_color;
  color*=clamp(u_pealRatio*2.-1.+v_x,0.,1.);
  float aaAlpha=linearstep(0.01+fwidth(v_dist),0.,v_dist);
  color=mix(u_bgColor,color,aaAlpha);
  float l=0.5+u_pulseRatio*2.;
  float d=(1.-u_pulseRatio)*(1.+l)-v_x-l;
  float alpha=smoothstep(-l,-0.0001,d)*smoothstep(0.,-0.0001,d);
  alpha*=0.2;
  alpha+=smoothstep(0.,0.4,u_pulseRatio)*smoothstep(1.,.4,u_pulseRatio)*0.2;
  alpha*=smoothstep(0.3,0.1,u_transitionRatio);
  gl_FragColor=vec4(color,alpha*aaAlpha);
}

// ===================== BLOCK 106 =====================
#define GLSLIFY 1
attribute vec3 position;
attribute vec3 OP;
attribute float radius;
attribute float id;
uniform vec4 u_rect;
uniform float u_thickness;
uniform float u_showRatio;
uniform vec2 u_viewportResolution;
uniform vec2 u_size;
varying float v_x;
varying float v_curveu;
varying float v_perimeter;
varying float v_radius;
varying vec2 v_pos2;
varying float v_showRatio;
vec4 hash42(vec2 p) {
  vec4 p4=fract(vec4(p.xyxy)*vec4(.1031,.1030,.0973,.1099));
  p4+=dot(p4,p4.wzxy+33.33);
  return fract((p4.xxyz+p4.yzzw)*p4.zywx);
}
#include <linearstep>
void main() {
  float curveu=position.z;
  float perimeter=OP.z;
  vec2 pos=mix(OP.xy,position.xy,u_thickness)/u_size+.5;
  pos=mix(u_rect.xy,u_rect.xy+u_rect.zw,pos)/u_viewportResolution;
  v_x=pos.x;
  pos=pos*2.-1.;
  gl_Position=vec4(pos,0.,1.0);
  v_curveu=curveu;
  v_perimeter=perimeter;
  v_radius=radius;
  v_pos2=pos.xy;
  vec4 rands=hash42(vec2(id*5.,9.));
  v_showRatio=linearstep(0.,0.7,u_showRatio-rands.x*0.3);
}

// ===================== BLOCK 107 =====================
#define GLSLIFY 1
uniform float u_time;
uniform float u_showRatio;
uniform float u_hideRatio;
uniform float u_endRatio2;
uniform sampler2D u_screenPaintTexture;
uniform vec2 u_resolution;
uniform vec3 u_color;
uniform float u_pealRatio;
uniform float u_pulseRatio;
varying float v_x;
varying float v_curveu;
varying float v_perimeter;
varying float v_radius;
varying vec2 v_pos2;
varying float v_showRatio;
float exponentialOut(float t) {
  return t==1.0 ? t : 1.0-pow(2.0,-3.0*t);
}
void main() {
  vec2 screenUv=gl_FragCoord.xy/u_resolution;
  vec4 screenPaint=texture2D(u_screenPaintTexture,screenUv);
  float radiusAlpha=1.-v_radius;
  float easedShowRatio=exponentialOut(v_showRatio);
  float t=-fract(v_curveu-v_showRatio*0.2+0.15)+easedShowRatio;
  float alpha=max(v_showRatio,step(0.,t));
  t=u_time/v_perimeter*0.2-v_curveu;
  t=mod(t,1.);
  float curveAlpha=smoothstep(0.,0.05,t)*smoothstep(0.8,0.5,t);
  float l=0.5+u_pulseRatio*2.;
  float d=(1.-u_pulseRatio)*(1.+l)-v_x-l;
  float pulseAlpha=smoothstep(-l,-0.0001,d)*smoothstep(0.,-0.0001,d)*smoothstep(0.,0.2,u_pulseRatio);
  alpha=max(pulseAlpha,smoothstep(0.2,0.5,(screenPaint.z+screenPaint.w)*0.5))*curveAlpha*u_hideRatio*(1.-u_endRatio2);
  alpha*=radiusAlpha;
  alpha=alpha*u_showRatio*(1.-u_endRatio2);
  vec3 color=u_color;
  color*=clamp(u_pealRatio*2.-1.+v_x,0.,1.);
  gl_FragColor=vec4(color,alpha);
}

// ===================== BLOCK 108 =====================
attribute vec2 vertex;
attribute vec2 uv;
uniform vec4 mat;
uniform vec2 translate;
varying vec2 st;
void main() {
  st = uv;
  gl_Position = vec4(mat2(mat) * vertex + translate, 0, 1);
}

// ===================== BLOCK 109 =====================
precision highp float;
uniform sampler2D image;
varying vec2 st;
void main() {
  gl_FragColor = texture2D(image, st);
}

// ===================== BLOCK 110 =====================
#define GLSLIFY 1
attribute vec2 instanceUv;
attribute float Cd;
uniform sampler2D u_positionTexture;
uniform sampler2D u_rotationTexture;
uniform float u_scale;
varying vec2 v_uv;
varying vec3 v_worldPosition;
varying vec3 v_worldNormal;
varying vec3 v_viewNormal;
varying vec3 v_viewPosition;
varying float v_ao;
varying float v_brightness;
float linearStep(float edge0,float edge1,float x) {
  return clamp((x-edge0)/(edge1-edge0),0.0,1.0);
}
vec3 qrotate(vec4 q,vec3 v) {
  return v+2.0*cross(q.xyz,cross(q.xyz,v)+q.w*v);
}
void main() {
  vec4 posData=texture2D(u_positionTexture,instanceUv);
  vec4 rotData=texture2D(u_rotationTexture,instanceUv);
  vec3 instancePosition=posData.xyz;
  vec4 instanceQuat=rotData;
  vec3 localPos=position;
  vec3 norm=normal;
  localPos*=u_scale;
  localPos=qrotate(instanceQuat,localPos);
  vec3 rotatedNormal=qrotate(instanceQuat,norm);
  vec3 worldPos=localPos+instancePosition;
  vec4 mvPosition=modelViewMatrix*vec4(worldPos,1.0);
  v_viewNormal=normalMatrix*rotatedNormal;
  v_viewPosition=-mvPosition.xyz;
  v_worldPosition=(modelMatrix*vec4(worldPos,1.0)).xyz;
  v_uv=uv;
  v_ao=Cd;
  v_brightness=posData.w;
  gl_Position=projectionMatrix*mvPosition;
}

// ===================== BLOCK 111 =====================
#define GLSLIFY 1
uniform vec3 u_lightPosition;
uniform sampler2D u_coffeeBeansTexture;
uniform sampler2D u_lightFieldSlicedTexture;
uniform vec2 u_resolution;
uniform vec3 u_lightColor;
#include <lightFieldSlice>
varying vec2 v_uv;
varying vec3 v_worldPosition;
varying vec3 v_viewPosition;
varying vec3 v_viewNormal;
varying float v_ao;
varying float v_brightness;
#define PI 3.141592653589793
#define PI2 6.283185307179586
#define PI_HALF 1.5707963267948966
#define ENV_LODS 6.0
#define LN2 0.6931472
#include <packing>
#include <getBlueNoise>
#include <getBgColor>
#include <perturbNormalArb>
void main() {
  vec4 map=texture2D(u_coffeeBeansTexture,v_uv);
  vec3 albedo=pow(map.rgb,vec3(2.2+0.8*(v_brightness-0.5)));
  vec3 VN=normalize(v_viewNormal);
  float bumpScale=1.25;
  vec2 dSTdx=dFdx(v_uv);
  vec2 dSTdy=dFdy(v_uv);
  vec2 dHdxy=(vec2(texture2D(u_coffeeBeansTexture,v_uv+dSTdx).w,texture2D(u_coffeeBeansTexture,v_uv+dSTdy).w)-map.w)*bumpScale;
  VN=perturbNormalArb(-v_viewPosition,VN,dHdxy,1.0);
  vec3 N=normalize((vec4(VN,0.)*viewMatrix).xyz);
  vec3 V=normalize(cameraPosition-v_worldPosition);
  vec3 L=u_lightPosition-v_worldPosition;
  float lightDistance=length(L);
  L/=lightDistance;
  vec3 H=normalize(L+V);
  float NdL=dot(N,L);
  float NdH=clamp(dot(N,H),0.0,1.0);
  float NdV=clamp(dot(N,V),0.001,1.0);
  float specular=pow(NdH,80.0-40.0*v_brightness);
  float attenuation=1.0/(30.0*lightDistance*lightDistance+0.01);
  float diff=max(0.,NdL);
  float backLight=max(0.,-NdL);
  vec3 rayGridPos=lightFieldPosToGrid(v_worldPosition);
  float ao=1.0-sampleLightField(u_lightFieldSlicedTexture,rayGridPos+N).r;
  ao*=ao*ao*v_ao;
  float shadow=1.-max(sampleLightField(u_lightFieldSlicedTexture,rayGridPos+L).r,sampleLightField(u_lightFieldSlicedTexture,rayGridPos+L*2.).r);
  shadow*=shadow;
  vec3 color=vec3(0.);
  color+=albedo*diff*attenuation*shadow*ao;
  color+=albedo*backLight*attenuation*(1.-shadow)*0.015;
  color+=(albedo*0.8+0.2)*specular*attenuation*shadow*ao;
  gl_FragColor.rgb=pow(color,vec3(1.0/2.2));
  gl_FragColor.a=min(1.,shadow*ao*attenuation);
}

// ===================== BLOCK 112 =====================
#define GLSLIFY 1
attribute vec3 position;
attribute vec2 instanceUv;
uniform sampler2D u_positionTexture;
uniform vec3 u_lightPosition;
uniform vec3 u_color;
#include <lightFieldSlice>
varying vec4 v_color;
void main() {
  vec4 posData=texture2D(u_positionTexture,instanceUv);
  vec3 instancePosition=posData.xyz;
  vec3 L=u_lightPosition-instancePosition;
  float lightDistance=length(L);
  L/=lightDistance;
  vec3 lightFieldGrid=clampedLightFieldPosToGrid(instancePosition);
  vec2 lightFieldUv=lightFieldGridToUv(lightFieldGrid);
  gl_Position=vec4(lightFieldUv*2.0-1.0,0.0,1.0);
  gl_PointSize=1.;
  v_color=vec4(1.);
}

// ===================== BLOCK 113 =====================
#define GLSLIFY 1
varying vec4 v_color;
void main() {
  gl_FragColor=v_color;
}

// ===================== BLOCK 114 =====================
#define GLSLIFY 1
uniform sampler2D u_prevSliceTexture;
uniform sampler2D u_drawnSliceTexture;
varying vec2 v_uv;
#include <lightFieldSlice>
float sampleSlice4(vec3 gridPos) {
  vec3 sliceOffset=vec3(-.5,.5,0.);
  return(texture2D(u_drawnSliceTexture,lightFieldGridToUv(clampLightFieldGrid(gridPos+sliceOffset.xxz))).r+texture2D(u_drawnSliceTexture,lightFieldGridToUv(clampLightFieldGrid(gridPos+sliceOffset.xyz))).r+texture2D(u_drawnSliceTexture,lightFieldGridToUv(clampLightFieldGrid(gridPos+sliceOffset.yxz))).r+texture2D(u_drawnSliceTexture,lightFieldGridToUv(clampLightFieldGrid(gridPos+sliceOffset.yyz))).r)/4.;
}
void main() {
  vec3 gridPos=vec3(mod(gl_FragCoord.xy,u_lightFieldGridCount.xy),dot(floor(gl_FragCoord.xy/u_lightFieldGridCount.xy),vec2(1.,u_lightFieldSliceColRowCount.x))+.5);
  float prev=texture2D(u_prevSliceTexture,v_uv).r;
  float curr=(sampleSlice4(gridPos+vec3(0.,0.,-1.))+sampleSlice4(gridPos)*2.+sampleSlice4(gridPos+vec3(0.,0.,1.)))*.25;
  float delta=(curr-prev)*mix(0.15,0.05,step(prev,curr));
  prev+=delta;
  gl_FragColor=vec4(prev);
}

// ===================== BLOCK 115 =====================
#define GLSLIFY 1
uint pack8888(vec4 v) {
  uvec4 t=uvec4(v*255.0+.5)<<uvec4(24u,16u,8u,0u);
  return t.x|t.y|t.z|t.w;
}
uint pack101010(vec3 v) {
  uvec3 t=uvec3(v*1023.0)<<uvec3(20u,10u,0u);
  return t.x|t.y|t.z;
}
uint pack111110(vec3 v) {
  uvec3 t=uvec3(v*vec3(2047.0,2047.0,1023.0))<<uvec3(21u,10u,0u);
  return t.x|t.y|t.z;
}
vec4 unpack8888(uint v) {
  return vec4((uvec4(v)>>uvec4(24u,16u,8u,0u))&0xffu)/255.0;
}
vec3 codebookNormalize(vec3 s,vec4 codebook[64]) {
  uvec3 idx=uvec3(s*255.0);
  vec3 v=vec3(codebook[idx.x>>2u][idx.x&3u],codebook[idx.y>>2u][idx.y&3u],codebook[idx.z>>2u][idx.z&3u]);
  return(v-codebook[0].x)/(codebook[63].w-codebook[0].x);
}
uniform sampler2D u_meansLTexture;
uniform sampler2D u_meansUTexture;
uniform sampler2D u_quatsTexture;
uniform sampler2D u_scalesTexture;
uniform sampler2D u_sh0Texture;
uniform sampler2D u_shNLabelsTexture;
uniform vec4 u_scalesCodebook[64];
uniform vec4 u_sh0Codebook[64];
uniform uint u_splatCount;
layout(location=0)out uvec4 packedFragColor0;
layout(location=1)out vec4 packedFragColor1;
void main() {
  int w=int(textureSize(u_meansUTexture,0).x);
  ivec2 xy=ivec2(gl_FragCoord.xy);
  vec3 meansLData=texelFetch(u_meansLTexture,xy,0).xyz;
  vec3 meansUData=texelFetch(u_meansUTexture,xy,0).xyz;
  vec4 quatsData=texelFetch(u_quatsTexture,xy,0);
  vec3 scalesData=texelFetch(u_scalesTexture,xy,0).xyz;
  vec4 sh0Data=texelFetch(u_sh0Texture,xy,0);
  vec2 shNLabelData=texelFetch(u_shNLabelsTexture,xy,0).xy;
  uint scale=pack101010(codebookNormalize(scalesData,u_scalesCodebook));
  uint sh0=pack111110(codebookNormalize(sh0Data.xyz,u_sh0Codebook));
  float alpha=sh0Data.w;
  uint qmode=uint(quatsData.w*255.0)-252u;
  packedFragColor0=uvec4(pack8888(vec4(meansLData,shNLabelData.x)),pack8888(vec4(meansUData,shNLabelData.y)),pack8888(vec4(quatsData.xyz,alpha)),(scale<<2u)|qmode);
  packedFragColor1=unpack8888(sh0);
}

// ===================== BLOCK 116 =====================
#define GLSLIFY 1
uint pack111110(vec3 v) {
  uvec3 t=uvec3(v*vec3(2047.0,2047.0,1023.0))<<uvec3(21u,10u,0u);
  return t.x|t.y|t.z;
}
vec4 unpack8888(uint v) {
  return vec4((uvec4(v)>>uvec4(24u,16u,8u,0u))&0xffu)/255.0;
}
vec3 codebookNormalize(vec3 s,vec4 codebook[64]) {
  uvec3 idx=uvec3(s*255.0);
  vec3 v=vec3(codebook[idx.x>>2u][idx.x&3u],codebook[idx.y>>2u][idx.y&3u],codebook[idx.z>>2u][idx.z&3u]);
  return(v-codebook[0].x)/(codebook[63].w-codebook[0].x);
}
uniform sampler2D u_shNCentroidsTexture;
uniform vec4 u_shNCodebook[64];
out vec4 packedFragColor;
void main() {
  ivec2 xy=ivec2(gl_FragCoord.xy);
  vec3 shNData=texelFetch(u_shNCentroidsTexture,xy,0).xyz;
  packedFragColor=unpack8888(pack111110(codebookNormalize(shNData,u_shNCodebook)));
}

// ===================== BLOCK 117 =====================
$ {
  fboHelper.precisionPrefix}
attribute vec2 position;
varying vec2 v_uv;
void main() {
  v_uv = position * 0.5 + 0.5;
  v_uv.y = 1.0 - v_uv.y;
  gl_Position = vec4(position, 0.0, 1.0);
}
