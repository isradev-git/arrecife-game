# Sota · Poses clave de caminar · T05.1

13 de octubre de 2026. Producción con **imagegen integrado**, sin API/CLI de generación. Ocho poses propias por perfil: contacto, apoyo, cruce e impulso, con cada pierna, formando dos pasos. Propuesta del asistente, **pendiente de valoración del autor** y de intermedios/calibración; no cierra T05. La autorización de continuar no se registra como aprobación del resultado nuevo.

Referencias observadas: [Sota v7 aprobada](../../../../../godot/assets/personajes/sota/perfiles_pixel_v7.png) y [personajes del autor](../../../referencias/pixel_art_v1/personajes_estilo.png). Solo perfiles, pelo/mecha, chaqueta, correa/deck y ojos mínimos. Sin correr ni cambios de historia. PNG originales y prompts anteriores intactos.

## Intentos y selección

| Hoja | Prompt | Revisión del asistente |
| --- | --- | --- |
| [Derecha v1](derecha_intento_v1.png) | [Prompt](prompt_derecha_v1.txt) | Segunda mitad repetía la pierna de apoyo. No usada. |
| [Derecha v2](derecha_intento_v2.png) | [Prompt](prompt_derecha_v2.txt) | Mejora parcial; contacto/cruce B todavía incoherentes. No usada. |
| [Derecha v3](derecha_intento_v3.png) | [Prompt](prompt_derecha_v3.txt) | Corrige contacto B; cruce B aún con bolsillo en pierna incorrecta. No usada. |
| [Derecha v4](derecha_v4.png) | [Prompt](prompt_derecha_v4.txt) | Ocho poses seleccionadas para prueba. |
| [Izquierda v1](izquierda_intento_v1.png) | [Prompt](prompt_izquierda_v1.txt) | Repite apoyos/poses de contacto; deck demasiado expuesto. No usada. |
| [Izquierda v2](izquierda_intento_v2.png) | [Prompt](prompt_izquierda_v2.txt) | Corrige parte del cruce; poses/equipo aún variables. Conservada, no usada en selección final. |
| [Izquierda v3](izquierda_v3.png) | [Prompt](prompt_izquierda_v3.txt) | Seleccionadas poses 0–5 y 7; deck menos expuesto. Cruce B vuelve a cambiar de pierna. |
| [Izquierda v4](izquierda_v4.png) | [Prompt](prompt_izquierda_v4.txt) | Seleccionada solo pose 6, cruce B; otras variaciones de la edición no sustituyen v3. |

Son ediciones generativas: no se afirma conservación píxel a píxel entre intentos. No se redibujan ni se limpian PNG por código. Las hojas son 1536 × 1024 con alfa real; el RGB oculto fuera de alfa puede conservar colores, sin fondo opaco. Copias de los tres PNG seleccionados en `godot/assets/personajes/sota/`, idénticas a sus fuentes.

## Montaje

[Metadatos](../../../../../godot/assets/personajes/sota/caminar_v1.json): región completa medida al umbral alfa 0,1, cadera horizontal calibrada y planta. Algunas botas cruzan las celdas teóricas 4 × 2: se mide cada figura completa y se usa AtlasTexture con márgenes, evitando amputar pies o incluir otra pose. Todos los marcos lógicos son **512 × 544**, con pivote común **(256, 510)**. Los PNG no se modifican. Una única escala **252/470** para las dieciséis poses; no se igualan las alturas por fotograma. Alturas dibujadas variables aproximadamente 246–255: revisar la oscilación y las proporciones durante T05.2.

Secuencia por distancia real desplazada, ciclo provisional de **192 px**, no por tiempo transcurrido al estar quieta. En el recorrido la casilla **Pasos en prueba** permite probar las poses; desactivada al arrancar. Reposo/restauración mantienen v7 aprobada. Contraluz calculado por el shader alfa existente: rosa/rojo y ámbar manuales de Velvet, ancho 3 de origen, sin pintar neón fijo nuevo. Fuentes espaciales pendientes.

[Láminas y prueba Godot/Web](../../../revisiones/marcha_poses_v1/README.md). Primer bloque de poses clave revisable; falta afinar contacto/deslizamiento, encuadre de zancada en extremos, manos/anatomía/ropa/equipo, duración de fases, intermedios y cierre del bucle. T06 conserva arranque/parada, giro y reposo. No se promete naturalidad final a partir de estas ocho poses solamente.
