# Los Puntales · acceso · muestra canónica v1

**Estado:** candidato de revisión, no integrado ni aprobado como arte final. Diseño: `docs/superpowers/specs/2026-10-25-puntales-muestra-canon-design.md`. Herramienta: `image_gen` integrada, categoría `illustration-story`, fondo opaco.

## Referencias y papel de cada una

1. `game/assets/backgrounds/candidates/puntales_acceso.png`: **sólo** orientación de tres salidas (izquierda, centro, derecha) y cámara a altura humana. No copiar sus lámparas ámbar repetidas, brillo uniforme ni arquitectura de vestíbulo.
2. `art/originals/sota.png`: **sólo** lenguaje ilustrado del autor: contorno firme, sombras de borde definido y detalle selectivo.
3. `art/originals/jefa.png`: **sólo** lenguaje ilustrado del autor, no introducir a este personaje en la escena.

## Prompt final

> Use case: illustration-story. Asset type: fondo candidato para aventura 2D ilustrada en primera persona, panorámico horizontal 16:9, sin interfaz. Rehacer desde cero la llegada pública a Los Puntales, cota 2 del Arrecife. La cámara está quieta a la altura de una persona. La escena es una calle de paso habitada bajo una intervención estructural enorme: vigas, cartelas y tirantes sujetan moles construidas en épocas distintas; refuerzos añadidos y remiendos visibles; detrás se distinguen viviendas ocupadas y comercios modestos. Cuadrillas adultas trabajan en segundo plano y residentes circulan o esperan, sin bloquear accesos. La arquitectura cuenta el oficio de sostener la ciudad, no parece un vestíbulo de fábrica. Composición de juego con tres rutas inequívocas y despejadas: escalera de retorno hacia El Nudo en el lado izquierdo, apertura de taller de conducciones en la zona central, camino al puesto de verificación en el lado derecho. Un soporte o marca de inspección visible en el centro permite observar el lugar. La base visual sigue D225: hormigón gris claro con polvo de corte, acero oscuro, imprimación rojo óxido, lonas y cabinas azul industrial, pintura blanca de medición. El naranja de una soldadura es un acento local, no una sucesión de lámparas. Entre vigas y edificios se entrevé un cielo **artificial proyectado**, nunca sol directo. Ilustración digital 2D dibujada: contorno oscuro firme, siluetas claras, sombras amplias de bordes definidos, materiales usados con detalle selectivo, coherente con los retratos originales de Sota y la Jefa. Usar la imagen actual únicamente como referencia de la posición relativa de las tres rutas; usar los retratos únicamente como referencia de estilo. Sin Sota ni Jefa en la escena, sin avatar, manos, texto legible, números gigantes, logos, HUD, pistas de misión, violencia explícita, estética fotográfica, render 3D ni pixel art. Evitar el suelo uniformemente mojado y brillante y la repetición de pasarelas con tubos luminosos ámbar.

La primera generación se conserva como `art/iterations/zonas_puntales/puntales_acceso_canon_v1_borrador.png`. Su cielo azul y sombras largas se leían como sol directo. Se aplicó **una corrección localizada** con ese borrador como único objetivo de edición; el resultado elegido está en `art/iterations/zonas_puntales/puntales_acceso_canon_v1.png`.

## Prompt de corrección de luz

> Use case: lighting-weather. Edit target: the supplied image of Los Puntales. Change only the exterior illumination and sky interpretation. Preserve the illustrated linework, all architecture, the three unobstructed routes (left staircase, central workshop, right verification corridor), people, camera and material colors. Replace the apparent hard direct sunlight with broad, diffuse light from an artificial projected sky beneath an immense ceiling. Make faint panel joins or projection structure discernible only in upper blue openings. Remove the sharp sunbeam pattern and long crisp sun shadows on the floor; use soft cool ambient light with localized warm workshop lamps and a small welding accent. Keep the scene readable and dramatic, but unmistakably inside the Penumbra with no real sun. Do not add text, logos, characters, objects or UI. Keep widescreen horizontal 16:9.

**Límite de esta muestra:** ambos archivos son PNG aplanados. El despiece por capas queda para la producción de arte final tras la valoración del autor.

El PNG activo, los retratos y sus prompts previos se conservan sin alteraciones. La aprobación de esta muestra no se presupone para las otras cinco vistas ni para otras cotas.
