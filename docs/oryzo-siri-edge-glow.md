# Mapeamento — Glow de borda "estilo Siri" do oryzo.ai

Engenharia reversa do efeito de **glow animado nas bordas da tela** de
`https://oryzo.ai/` (o frame que aparece após o scroll inicial).

> Veredito: **não é CSS.** É um **pass de pós-processamento em WebGL/Three.js**.
> No próprio código deles a classe se chama `AppleEfx` e o shader usa variáveis
> `appleColor` — eles modelaram explicitamente no visual da Siri/Apple
> Intelligence. O CSS `box-shadow` que existe no site (`.hero-video__glow`) é só
> o glow laranja do *thumbnail* de vídeo; o glow multicolor de tela inteira é
> outro mecanismo, em shader.

---

## 1. Como está montado

- Site em **Astro**; toda a cena (mão 3D + texto + glow) é renderizada num único
  `<canvas id="canvas">` com **Three.js** (97× `THREE.`, 139× `gl_FragColor`,
  pipeline de pós com `Bokeh`, blur, RGB shift, convolução).
- O glow de borda é um **PostEffect** (`class AppleEfx extends PostEffect`)
  aplicado sobre a textura da cena já renderizada (`u_texture`), num quad
  fullscreen.

Uniforms principais do pass:

| Uniform | Papel |
|---|---|
| `u_texture` | a cena já renderizada (entrada do post) |
| `u_resolution` | tamanho do canvas em px → **adapta à tela** (setado no resize) |
| `u_coverAspect` | aspect "cover" p/ a paleta não distorcer |
| `u_padding` | espessura da moldura de glow |
| `u_lmsTexture` | textura-paleta 6×1 com as cores do gradiente |
| `u_time` | tempo → **rotaciona** a paleta (o "se mexer") |
| `u_amount` | intensidade geral (dirigida pelo scroll) |
| `u_pulse` / `u_pulseCenter` | onda reativa (ripple) a partir de um ponto |

---

## 2. As três ideias do efeito

### a) Máscara de borda via SDF (distância até a borda)
Um **signed distance field de retângulo arredondado** do tamanho da tela mede a
distância de cada pixel até a borda; `linearstep` + `pow(d,3)` concentram o brilho
nas beiradas e o apagam no centro. Há **duas** caixas (uma fina/nítida `d`, uma
larga/suave `d2`) somadas → glow em camadas.

```glsl
float d  = sdBox(borderUv, u_resolution*0.5 - u_padding*2.) - u_padding;
d  = linearstep(0.0, u_padding*2.5, d);  d  = pow(d, 3.0);   // halo interno nítido
float d2 = sdBox(borderUv, u_resolution*0.5 - u_padding*3.) - u_padding*1.5;
d2 = linearstep(0.0, u_padding*5.5, d2); d2 = pow(d2, 5.0);  // halo externo suave
```
Como o SDF usa `u_resolution`, a moldura **acompanha qualquer tamanho de tela**.

### b) Cor que flui (a "alma" do efeito Siri)
4 cores são guardadas numa textura 6×1 (`u_lmsTexture`) e amostradas em 4 cantos
para um gradiente bilinear. A coordenada de amostragem é **rotacionada pelo tempo**
(`angle = u_time * -5.`), então as cores giram/escorrem pela borda.

```glsl
vec2 glowUv = (v_uv - 0.5) * u_coverAspect * 2.0;
float angle = u_time * -5.0;
mat2  rot   = mat2(cos(angle),-sin(angle), sin(angle),cos(angle));
glowUv = clamp(rot*glowUv*0.5 + 0.5, 0.0, 1.0);
vec3 cT = mix(c0, c1, glowUv.x);
vec3 cB = mix(c3, c2, glowUv.x);
vec3 glowColor = mix(cB, cT, glowUv.y);
glowColor *= glowColor*glowColor*2.0;   // realça saturação/contraste
```

Paleta real do oryzo (convertida p/ linear no JS):

| | hex | cor |
|---|---|---|
| c0 | `#ff9cff` | rosa/magenta |
| c1 | `#ff9638` | laranja |
| c2 | `#ffff22` | amarelo |
| c3 | `#54ffff` | ciano |

### c) Pulse/onda reativa
Um anel que viaja a partir de `u_pulseCenter` (duas `smoothstep` formam a faixa do
anel) distorce a borda e injeta brilho extra — é o "reagir" quando você interage
(ex.: o *TRY TO HOVER HAND*). `u_amount`/`u_pulse` são animados via GSAP/easing.

```glsl
vec2 wp = (v_uv - u_pulseCenter)*aspect;
float wt = u_pulse*wtl - wl + (wl - length(wp));
float wave = smoothstep(0.,wsl,wt) * smoothstep(wsl+wel,wsl,wt) * u_amount;
```

### Composição final
```glsl
vec3 color = pow(base.rgb, vec3(2.2));            // scene → linear
float glow = (0.001 + d + d2*0.5) * 5.0;
color += u_amount * glowColor * glow;             // soma o glow nas bordas
color += wave * (d*0.25 + d2*0.25 + glowColor*0.05);
gl_FragColor = vec4(pow(color, vec3(1.0/2.2)) + blueNoise*0.004, ...); // gamma + dither
```
O **blue-noise dithering** (`+ bnoise*0.004`) evita banding no degradê suave.

---

## 3. O gatilho por scroll (o "frame" que você mencionou)

A intensidade é função da posição de scroll da seção de AI:

```js
appleEfx.amount = math.fit(r, 5.5, 6, 0, 1) * math.fit(r, 7.5, 8, 1, 0);
```
ou seja: o glow **surge** quando o scroll chega em ~5.5–6 e **some** em ~7.5–8.
Por isso ele "aparece naquele frame" depois do scroll inicial.

E o ajuste à tela:
```js
material.uniforms.u_resolution.value.set(width, height);      // no resize
material.uniforms.u_coverAspect.value.set(width/height, ...); // cover
```

---

## 4. Receita para reproduzir

1. Renderize sua cena normalmente num render target (`u_texture`).
2. Desenhe um quad fullscreen com o fragment shader acima.
3. Uniforms mínimos: `u_texture`, `u_resolution` (atualizado no resize),
   `u_time` (incrementa no rAF), `u_padding`, paleta (4 cores) e `u_amount`.
4. SDF de retângulo arredondado → `pow()` para empurrar o brilho p/ a borda.
5. Rotacione a UV da paleta com `u_time` → cor que flui.
6. (Opcional) pulse radial em interações; dither com blue noise.

Sem WebGL não dá pra ter o "fluxo" idêntico, mas dá pra **aproximar em CSS** com
`conic-gradient` animado + `mask` mostrando só a borda:

```css
.siri-edge{position:fixed;inset:0;padding:3px;border-radius:24px;pointer-events:none;
  background:conic-gradient(from var(--a), #ff9cff,#ff9638,#ffff22,#54ffff,#ff9cff);
  -webkit-mask:linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0);
  -webkit-mask-composite:xor; mask-composite:exclude;
  filter:blur(8px) saturate(1.4); animation:spin 6s linear infinite}
@keyframes spin{to{--a:360deg}}
@property --a{syntax:'<angle>';inherits:false;initial-value:0deg}
```

> Um demo WebGL fiel acompanha este doc em `docs/demos/siri-edge-glow.html`.

---

## 5. Referências
- Site: https://oryzo.ai/ (Astro + Three.js; bundle `_astro/hoisted.*.js`)
- Classe/shader: `AppleEfx` / `appleColor` / `u_lmsTexture` (extraídos do bundle)

*Trechos de GLSL e cores são literais do bundle público `hoisted.CRsATKbF.js`.*
