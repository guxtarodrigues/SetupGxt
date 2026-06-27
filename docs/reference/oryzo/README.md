# Referência — código-fonte do oryzo.ai

Código real do site `https://oryzo.ai/`, salvo para **comparar e refinar** a nossa
reprodução do glow de borda (estilo Siri). Baixado em 2026-06-27.

> ⚠️ Material de **terceiros**, guardado apenas como referência técnica/estudo.
> Não redistribuir como nosso. Os créditos são da Oryzo/estúdio que construiu o
> site. Use para entender a técnica, não para copiar 1:1 em produção.

## Estrutura

```
raw/                      # arquivos crus, exatamente como servidos pelo site
  index.html              # bootstrap Astro (canvas #canvas, fallback, etc.)
  index.css               # /_astro/index.TL6TuoJb.css
  hoisted.js              # /_astro/hoisted.CRsATKbF.js  (bundle Three.js, ~1MB minif.)

extracted/                # trechos relevantes, isolados e formatados
  complete-effect.html         # *** EFEITO COMPLETO *** glow + bloom + vignette (pipeline real)
  preview-original-border.html # so o glow (shader AppleEfx isolado)
  appleEfx.border.frag.glsl    # MOLDURA de glow (o efeito Siri) — shader verbatim
  appleEfx.class.js            # classe JS AppleEfx (paleta, init, render/uniforms)
  screenPaint.sim.frag.glsl    # simulacao de fluido c/ curl noise (a "fumaca")
  screenPaint.distortion.frag.glsl  # distorcao/smear + rgb shift na tela
  screenPaint.class.js         # classe JS ScreenPaint (constantes, buffers)
  all-shaders.glsl             # TODOS os 118 blocos GLSL do bundle, rotulados
```

## Pipeline de pós-processamento do site (o que define a "qualidade")

Ordem real dos passes no bundle (`addQueue`):

```
TAA → FXAA → SMAA → Bokeh(DOF) → AppleEfx(glow) → PostLayer → Bloom(+lens dirt)
   → BlurBox → ScreenPaintDistortion(fumaça) → Final(saturação/contraste/vignette/dither)
```

> Por isso o glow isolado nunca bate com o site: no site ele é seguido de **Bloom**
> (halo suave) e do **Final** (vignette + grade de cor + dither). O
> `complete-effect.html` reproduz essa cadeia (glow → bloom → final), que é a parte
> que falta pra chegar no nível. Tudo isso é técnica/shader — extraído dos blocks
> 55 (glow), 51 (bloom composite) e 53 (final). Parâmetros default do bundle:
> `bloomSaturation=1`, `vignetteFrom≈0.6`, `vignetteTo≈1.6`, `toneMappingExposure=1`.

## Como VER o efeito da borda original (clicar e rodar)

Os arquivos `.glsl`/`.js` são **só código** — o navegador não roda um `.glsl`
sozinho. Para ver o efeito rodando:

- **Abra `extracted/preview-original-border.html`** no navegador (duplo-clique).
  Essa página embute o `appleEfx.border.frag.glsl` **verbatim** e fornece os
  uniforms como no site (paleta `lmsTexture`, blue-noise, cena escura, e o driver
  do `render()`). É o shader original deles rodando.
- Ou abra o site real: `https://oryzo.ai/` (rolar até a seção).
- O `raw/index.html` **não** roda standalone (depende de assets/modelos/chunks
  que não baixamos).

> Nota técnica: a `lmsTexture` é 6×1 (NPOT). Em WebGL1, `REPEAT` numa textura NPOT
> a invalida (amostra preto) — por isso o preview usa `CLAMP_TO_EDGE` (o shader só
> amostra a paleta em x=0..0.5, então não precisa de repeat). No site, que roda em
> WebGL2, o `RepeatWrapping` original funciona normalmente.

## O que importa para o nosso glow

1. **`extracted/appleEfx.border.frag.glsl`** — é o coração do efeito que queremos.
   Paleta de 4 cores (`#ff9cff #ff9638 #ffff22 #54ffff`) amostrada por UV
   rotacionada (`u_time*-5`) e elevada ao cubo (hotspot que avança pro centro),
   SDF de retângulo arredondado para a moldura, e onda `u_pulse`.
2. **`extracted/appleEfx.class.js`** — como os uniforms são dirigidos:
   `pulse += dt*0.5`, `pulseCenter` na borda direita, `amount = sineIn`, `padding`
   capado em 50, fórmula do `coverAspect`.
3. **ScreenPaint** (a fumaça) — documentado mas **fora** do nosso demo a pedido.

## Como foi extraído

`hoisted.js` é minificado num arquivo só. Os shaders são template strings; foram
isolados por busca de `gl_FragColor`/`void main()` e reformatados (indentação por
chaves). A lógica GLSL é **verbatim**; só o whitespace foi adicionado. As classes
JS estão minificadas (nomes como `_v0$a` são do próprio bundle).

## Nossa reprodução

Vive em `docs/demos/siri-edge-glow.html` e a análise técnica em
`docs/oryzo-siri-edge-glow.md`. O demo já usa o shader `AppleEfx` verbatim; estes
arquivos servem para conferir qualquer detalhe (cores, constantes, ordem dos
passes) conforme a gente refina.
