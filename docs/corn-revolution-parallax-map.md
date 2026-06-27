# Mapeamento — Corn Revolution (Resn / Pioneer)

Engenharia reversa da estrutura de `cornrevolution.resn.global` para servir de
referência na construção de uma experiência com "parallax" semelhante.

> Premissa-chave: o que parece "parallax 2D" é, na verdade, **profundidade 3D
> real em WebGL** — uma câmera animada (baixada de software 3D) percorrendo uma
> cena com várias camadas de geometria, partículas e blur de profundidade,
> dirigida pelo scroll. Não são camadas de imagem deslizando em velocidades
> diferentes.

---

## 1. Stack confirmada (extraída dos bundles)

| Camada | Tecnologia | Evidência |
|---|---|---|
| Render 3D | **Three.js** (WebGL) | `vendors~main.js`, dezenas de `ShaderMaterial`/`RawShaderMaterial` |
| Animação | **GSAP / TweenMax v2** | 155× `.to(`, `TweenMax`, `fromTo` em `main.js` |
| Geometria | **glTF + Draco** (compressão de malha) | `KERNAL.gltf`, `stalk_rigged3.gltf`, `cobb_test.gltf`, `hair.gltf`, `DRACO` no vendor |
| Texturas | **KTX comprimido por GPU** (astc / s3tc / pvrtc) + Basis | caminhos `compressed/[format]/...`, `s3tc/pvrtc/astc` |
| Texto | **MSDF** (Multi-channel Signed Distance Field) | `gilroy-msdf.png`+`gilroy.json`, `manifold-msdf.png`+`manifold.json` |
| Profiling | stats.js (REVISION 16) | `addPanel` no vendor |
| UI não-WebGL | só logo, menu, signup, contato, legal | resto é tudo desenhado em WebGL |

Bundles servidos via CloudFront (`d1hl9u9k5hiqxp.cloudfront.net`):
`loader`, `vendors~main`, `main`, `test0` (mesma hash de build).

---

## 2. Bootstrap (o HTML é mínimo)

```html
<body>
  <div data-ui="scrollProxy"></div>   <!-- div alto: cria a barra de rolagem nativa -->
  <div data-ui="root" class="root"></div>  <!-- canvas WebGL monta aqui -->
  <div id="unsupported"> ... </div>   <!-- fallback "use Chrome/Firefox/..." -->
</body>
```

Fluxo de inicialização (`<script>` inline no `index.html`):
1. `detectGL()` testa suporte a WebGL; se falhar (ou IE ≤ 11) mostra `#unsupported`.
2. Caso ok, injeta dinamicamente `loader.<hash>.js`.
3. O `loader` faz **preload** de todos os assets (modelos, KTX, MSDF, áudio) e
   só então carrega `vendors~main` + `main` e inicia a experiência.

> Técnica central do scroll: o `scrollProxy` é um `<div>` cuja **altura** é
> setada por JS (`scrollProxy.style.height = totalHeight + "px"`). Ele dá ao
> navegador uma barra de rolagem nativa do tamanho da timeline; o canvas fica
> `position: fixed` e a app lê a posição de scroll para dirigir a animação.

---

## 3. Mecânica de scroll (o coração do efeito)

Não é scroll nativo direto. É **virtual scroll com inércia/damping**:

- Captura `wheel` (`deltaY`) e a posição do `scrollProxy`:
  `scrollY = deltaY * wheelMultiplier / 900`.
- Mantém `target` (destino) e `current` (valor suavizado), aproximados a cada
  frame por **lerp/damping** (`dampingFactor`, `lerp`) → movimento "manteigado".
- `snapPositions[]` por seção/sub-seção → o scroll "imanta" em pontos-chave
  (cada cena tem um ponto de descanso).
- Cada cena tem dois segmentos na timeline:
  - **`<cena>-in`** → transição de entrada (tocada conforme você rola).
  - **`<cena>-loop`** → estado idle/ambiente quando você para naquela cena.

Pseudo-loop por frame:

```text
target  += wheelDelta            // entrada do usuário
current += (target - current) * damping   // suavização
scrollNormalized = current / totalHeight
=> dirige: posição da câmera baixada, sceneAmounts[], partículas, shaders
```

---

## 4. As "camadas de parallax" = profundidade 3D real

A sensação de parallax vem de materiais/objetos em **profundidades distintas**
que se movem em ritmos diferentes quando a câmera faz dolly. Materiais achados:

- `foregroundPlantMaterial` — plantas em primeiro plano (movem muito)
- `bgPlantMaterial` — plantas de fundo
- `farPlantsMaterial` — plantas distantes (movem pouco)
- `floorMaterial` / `groundMaterial` — solo
- `particlesMaterial` + `outerParticlesMaterial` — partículas à frente e atrás
- `glowMaterial`, `threadMaterial`, `leafMaterial`, `cornMaterial`

Dois ingredientes adicionais que vendem o parallax:

1. **Câmera baixada do 3D** (`Camera-Object`, `Kernel-Camera-Object`,
   `Field-Camera-Object`): a câmera foi animada no software 3D (Blender/C4D),
   exportada no glTF e tem sua animação "scrubada" pelo scroll.
2. **Parallax de ponteiro**: `pointerEased` desloca `camera.position`; há um rig
   com `Tilt`/`TiltTg`/`TiltVel`/`cameraOffsetY`/`cameraTarget` — a câmera
   inclina suavemente seguindo o mouse, somando micro-profundidade ao dolly.

---

## 5. Transições entre cenas (post-processing)

- Cada cena renderiza para um **render target** próprio; um shader de
  pós-processamento mistura dois targets para a transição (cross-fade/wipe).
- `blurPass` / `doBlurPass` (64+ referências) → **blur de profundidade (DOF)**
  e blur de transição. Cenas marcam `doBlurPasses: true`.
- `FXAAShader` → anti-aliasing. `postProcessingMaterial`, `postMaterial`,
  `SciencePostProcessingMaterial` → passes customizados por cena.
- Cada cena tem props de **iluminação** interpoladas por `sceneAmounts[]`:
  `sunHeight`, `sunAngle`, `sunColor` sofrem `lerp` entre cena atual e próxima
  → a luz/atmosfera muda continuamente conforme você rola.

---

## 6. Estrutura narrativa (ordem das cenas)

Sequência reconstruída a partir de ids/nomes e dos modelos:

1. **Landing / herói** — espiga de milho (`cobb_test.gltf`) + cabelo/barba do
   milho (`hair.gltf`), partículas, lens-flare. Copy: *"From lab to field, it's
   corn seed development that will change farming."*
2. **DNA / Science** (`dna`, `science`) — melhoramento genético.
   *"Our breeders dial it in further."*
3. **Kernel / semente** (`KERNAL.gltf`, `Kernel-Camera-Object`) —
   *"Less than 0.01% of seeds make it."*
4. **Field density** (`field-density-in` / `-loop`) — densidade de plantio.
5. **Desafios / testes de estresse** (cada um com `-in` + `-loop`, hotspots
   interativos `Hotspot-Indicator` / `Hotspot-Content`):
   - `disease` (doença)
   - `drought` (seca)
   - `wind` (vento)
   - `soil` (solo — variações `clay`/`loam`/`sand`)
   - `storm` (tempestade)
   - `density` (densidade)
6. **Result** (`result`) — desfecho.
7. **Seções DOM** (fora do WebGL): signup, contato, legal, "Visit Corn
   Revolution Podcast".

Cenas extras de pós/UI: `default`, `normal`, `registered`, `image`, `icons-0/1/2`.

---

## 7. Estratégia de assets / performance

- **KTX por GPU**: o caminho `compressed/[format]/...` resolve `[format]` em
  runtime para o formato suportado pelo device (`astc`, `s3tc`/`dxt`, `pvrtc`).
  Carrega só o que a GPU entende → upload de textura barato.
- **Draco** nos `.gltf` → malhas pequenas no fio.
- **Mipmaps** pré-gerados (`...@mipmaps.ktx`).
- **MSDF** para texto: nítido em qualquer escala/zoom, layout e kerning vêm do
  `.json` que acompanha o atlas — todo o texto vive dentro do WebGL.
- Preload total antes de iniciar (tela de loading), evitando "pop-in".

---

## 8. Como reproduzir algo semelhante (receita)

Stack moderna sugerida (equivalente em 2025/2026):

1. **Three.js** (ou React-Three-Fiber + drei) para a cena.
2. **GSAP** + **ScrollTrigger** (`scrub: true`) ou **Lenis** para o
   smooth-scroll com inércia. ScrollTrigger substitui o `scrollProxy` manual.
3. Modele a cena em **Blender**: várias camadas de profundidade
   (foreground / mid / far) + **anime a câmera** e exporte em **glTF + Draco**.
   No web, "scrube" a animação da câmera com o progresso do ScrollTrigger.
4. Adicione **parallax de ponteiro**: desloque/incline a câmera com o mouse,
   suavizado por lerp (`pointerEased`).
5. **Texturas**: gere KTX2/Basis (`gltf-transform`/`toktx`) com mipmaps.
6. **Texto**: MSDF via `troika-three-text` (resolve MSDF + layout direto no R3F).
7. **Transições**: `EffectComposer` (postprocessing) com render targets por cena
   e um shader de blend; some DOF/blur (`postprocessing` lib) e FXAA/SMAA.
8. **Snap** entre seções (`ScrollTrigger.snap`) + segmentos `in`/`loop` por cena.
9. **Loading screen** com preload de todos os assets antes do `start`.

Esqueleto mínimo do loop scroll→câmera (R3F + Lenis + GSAP):

```js
// 1 fonte de verdade: progress 0..1 do scroll suavizado
const lenis = new Lenis({ smoothWheel: true, lerp: 0.1 });
function raf(t){ lenis.raf(t); requestAnimationFrame(raf); }
requestAnimationFrame(raf);

// dentro do useFrame: scruba a animação da câmera baixada do Blender
mixer.setTime(scrollProgress * clipDuration);           // câmera + cena
camera.position.x += (pointer.x * tiltAmount - camera.position.x) * 0.05; // parallax mouse
camera.position.y += (pointer.y * tiltAmount + baseY - camera.position.y) * 0.05;

// blend de luz/atmosfera por cena (lerp entre props da cena atual e a próxima)
sunColor.lerpColors(sceneA.sunColor, sceneB.sunColor, sceneBlend);
```

---

## 9. Referências

- Site: https://cornrevolution.resn.global/ (a versão Pioneer pública virou
  estática; a original Resn ainda roda).
- Case / SOTD Awwwards (jul/2020):
  https://www.awwwards.com/sites/pioneer-corn-revolutionized
- Fórum GSAP (workflow): tópico 21665 em gsap.com/forums
- Fórum Three.js (discussão técnica): discourse.threejs.org tópico 28777

*Mapa gerado por engenharia reversa dos bundles públicos (`loader`/`main`/
`vendors~main`) — nomes de cena, materiais e assets citados são literais dos
arquivos.*
