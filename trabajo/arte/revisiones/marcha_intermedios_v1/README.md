# T05 · Más posturas entre las fases de marcha

13 de octubre de 2026. El autor pide más posturas para un andar más natural. Se adelanta una exploración de intermedios T05.2 sobre el primer medio paso derecho; esta petición no supone aprobar el arte anterior ni dar por cerrado T05.1.

Se añaden **carga, despegue y extensión** entre contacto/apoyo/cruce/impulso: ahora hay **siete posturas de ese medio paso**, no siete más. Objetivo inicial del asistente: 16 dibujos por ciclo de dos pasos y por perfil; cifra ajustable al revisar el bucle, no número final aprobado por el autor. Falta la transición al contacto contrario y todo el otro medio paso, además del perfil izquierdo propio.

[PNG originales, intentos y siete prompts exactos de imagegen integrado](../../personajes/sota/caminar_v2/README.md). Cada intermedio parte del v7 aprobado y de las poses contiguas; las correcciones conservan su intento previo. No se deforman sprites ni se editan colores por código.

| Captura | Uso |
| --- | --- |
| [Serie ampliada 2×](comparacion_2x.png) | 1672 × 1200, leer de izquierda a derecha y luego la segunda fila. V7 original y siete posturas con escala/render comunes. |
| [Serie en Velvet](comparacion_velvet.png) | 1672 × 941, misma secuencia a escala del juego, pies y = 705 y planos actuales de barandillas. |

Godot Compatibility / Apple M4. Mismo CUTOUT y nearest en todas las figuras; escala **252/871** común, sin igualar altura por fotograma ni aplicar filtros de oscuridad. Encuadre horizontal por centro del contorno para comparación estática; pivote de locomoción todavía sin calibrar. Se usa siempre v7 original real, no el reposo reconstruido de las hojas generadas.

**Correcciones antes de entregar:** carga v1 pierde el contraluz; v2 lo recupera, pero excede el rango tonal de la prueba. Extensión v1 queda demasiado próxima al impulso; v2 cambia la articulación, pero también queda más clara. Carga/extensión v3 corrigen la paleta con imagegen; los siete intentos y prompts se conservan.

[Medidas](medidas.json): media ponderada sobre RGB sRGB codificado con alfa ≥ 0,95. Carga 0,164; despegue 0,160; extensión 0,162 frente a v7 0,152: aproximadamente +8,4 %, +5,8 % y +7,2 %. Son un aviso de continuidad, no prueba de igualdad de paleta, iluminación, anatomía o aprobación: ropa, piel, forma y contorno afectan el promedio. Las variantes corregidas pasan el margen de revisión automática existente (−20 %/+15 %); el promedio no sustituye la revisión del dibujo. Continúan pequeñas variaciones generativas de proporciones/contornos por revisar en movimiento.

**Comprobado:** dimensiones/alfa/márgenes/altura y rango tonal de las siete posturas; modo anterior de cuatro fases conservado; dos capturas GPU generadas y revisadas sin errores. No hay ciclo animado, sincronización de apoyos, exportación nueva ni prueba de navegador en esta entrega. El recorrido mantiene v7.

Desde la raíz del repositorio:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/poses_oscuras.gd -- --intermedios
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/poses_oscuras.gd -- --intermedios --capturas
```

Sin `--intermedios`, la prueba conserva las medidas y láminas de `marcha_poses_oscuras_v1`. Necesita archivos externos de `trabajo/`; está excluida de la exportación Web.

**Siguiente:** cerrar coherencia visual y completar el otro paso/transiciones antes de revisar el bucle. Después ajustar ritmo, pivote, oscilación del cuerpo y pie plantado durante el avance. Más dibujos no bastan para demostrar naturalidad. Nueva serie pendiente de valoración del autor.
