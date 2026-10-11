# Sota · Color de luz adaptable

11 de octubre de 2026. El autor valora positivamente el estilo vigente y advierte que el rosa del personaje podría desentonar al cambiar de escenario. **El estilo está aprobado; esta prueba de control de color está entregada por el asistente y pendiente de valoración.**

El rosa y el naranja están pintados en el atlas. Se conserva el PNG v7 y se controla su neón al dibujarlo con el [shader de Godot](../../../../godot/assets/personajes/sota/silueta.gdshader). No se regenera a Sota, no se modifica el archivo ni se añaden prompts. El modo inicial «Velvet original» mantiene exactamente el aspecto aprobado.

## Comparación nativa

Mismo Velvet aplanado, altura 252, suelo y = 710, nearest y dos perfiles propios. Los otros colores son una prueba de independencia del contorno; el fondo y sus personajes siguen teniendo la iluminación original de Velvet. Capturas del viewport de Godot Compatibility en Apple M4, 1672 × 941:

| Modo | Perfil derecho | Perfil izquierdo |
| --- | --- | --- |
| Velvet original | [velvet_0.png](velvet_0.png) | [velvet_1.png](velvet_1.png) |
| Sin neón | [sin_neon_0.png](sin_neon_0.png) | [sin_neon_1.png](sin_neon_1.png) |
| Azul | [azul_0.png](azul_0.png) | [azul_1.png](azul_1.png) |
| Ámbar | [ambar_0.png](ambar_0.png) | [ambar_1.png](ambar_1.png) |

La revisión mantiene los controles anteriores de versiones, perfiles, altura, ubicación y filtro. Los parámetros `pink_rim` y `warm_rim` permiten colores independientes; estos botones aplican el mismo color a ambos para comparar. «Sin neón» neutraliza los acentos intensos mediante un tono oscuro, sin quitar las sombras internas del dibujo. Se conserva la forma escalonada de los píxeles.

## Comprobaciones

- `tests/escala.gd`: perfiles, alturas, apoyos, transparencia, filtros y parámetros de los cuatro modos correctos.
- [tests/iluminacion.gd](../../../../godot/tests/iluminacion.gd), **sin `--headless`**: render real del atlas en un SubViewport transparente. Cada alternativa cambia 13 994 píxeles; menos del 10 % de la silueta opaca. Alfa idéntico en toda la imagen, muestras de cara/ojos/ropa/equipo sin cambios, cero píxeles del rosa intenso seleccionado. Desactivar el control devuelve un render idéntico byte a byte al original.
- Importación, escena técnica y exportación Web release correctas. Ocho capturas nativas conservadas; el asistente observa la neutralización y el azul en escena.

La prueba de muestras no acredita que ningún otro detalle pueda coincidir con la selección de neón. El selector usa colores propios de este atlas; hay que revisarlo si cambia su paleta.

## Límite y producción posterior

Esto es **recoloración del contorno ya dibujado**, no iluminación física. Puede cambiar color o neutralizar el neón; no calcula dirección, sombras, distancia a una lámpara ni oclusiones. No se debe aplicar sin revisión a personajes que tengan prendas rosas o naranjas intensas.

Antes de producir las animaciones, preparar una base sin neón de escenario y una máscara explícita de luz, conservando el estilo aprobado. Así el escenario podrá controlar color, intensidad y dirección sin seleccionar colores de ropa o piel. Esta preparación pertenece a T02/T03, antes de extender la producción; no se entrega aquí una base nueva ni un sistema espacial terminado.

Pendientes valoración de estos modos, máscara/base de producción, retícula, luz espacial, animación y comprobación visual Web. El bloqueo de control de Safari anterior no se reintenta; una exportación correcta no equivale a validación en navegador.

Implementación consultada en la documentación oficial de [CanvasItem shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html) y [uniforms del lenguaje de shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html). [Atlas y prompts anteriores](../../personajes/sota/pixel_v3/README.md) · [Dirección](../../../direccion_artistica.md) · [Tareas](../../../../task.md).
