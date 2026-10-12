# PASE PENDIENTE · Revisión y paso a Godot

9 de octubre de 2026. El autor decide desarrollar el juego completo con Godot y distribuir una versión jugable en navegador. Considera que movimiento y entorno de v0.2 todavía están muy verdes. Este documento propone el orden de producción; no registra aprobación de un acabado nuevo.

Actualización: el orden y estado de ejecución se mantienen en [task.md](../task.md), una tarea cada vez. El autor ha descartado el título «Pase pendiente» para la versión final; este documento conserva el nombre histórico del prototipo.

**Decisión del 10 de octubre:** el autor aprueba cómo queda Sota en Velvet y establece presentación exclusivamente de perfil, en ambos sentidos. Reposo, respiración, conversación y cambios de dirección mantienen esa orientación; no producir frontal ni tres cuartos para ejecución.

**GitHub · 10 de octubre:** el autor autoriza subir el proyecto completo, canon y documentos internos incluidos, a `isradev-git/arrecife-game` pese a que el repositorio es público; indica que lo hará privado después. Esta autorización sustituye la exclusión del canon para esta subida de desarrollo. Sigue vigente separar fuentes internas de los paquetes distribuidos a jugadores.

**Cambio de acabado · 10 de octubre:** renovar sprites, modelos, personajes, objetos, animaciones y todas las capas de entorno hacia un pixel art más cercano a REPLACED. Los recursos actuales son una iteración previa. [Dirección artística vigente](../trabajo/direccion_artistica.md); la sustitución y revisión se incorporan a las tareas existentes. Se conserva el proyecto 2D y la identidad del universo; el 11 de octubre el autor rechaza el primer pase por cara definida y píxel fino, y exige caras sin detalle y píxel más intenso para todas las personas. Precisa después que los ojos deben verse muy poco, sin dejar la cara vacía. Se entrega una [propuesta corregida y comparación en Velvet](../trabajo/arte/revisiones/escala_v5/README.md), pendiente de valoración del autor. El resto de recursos, capas y animaciones siguen pendientes.

## Diagnóstico

El prototipo tiene el recorrido narrativo completo y reglas comprobables. Todavía no tiene el acabado visual, la animación ni la validación de distribución de una entrega pública.

| Parte | Estado real y consecuencia |
| --- | --- |
| Universo y alcance | Canon, Sota, tres localizaciones y cuatro pantallas definidos. Investigación sin combate. La duración de 25–35 minutos es un objetivo sin medir. |
| Historia | Encargo, siete pruebas, dos deducciones, informe y cierre implementados. Iria decide, el consentimiento es obligatorio y la devolución es parcial. No hace falta inventar otra historia para cambiar de motor. |
| Reglas | `juego/src/engine.js` concentra acciones, condiciones, destinos y validación del guardado. Sus seis pruebas del caso sirven de especificación para la migración. |
| Interfaz | `app.js`, HTML y CSS contienen diálogos, libreta, mapa, ayudas y controles accesibles. No se importan como escenas Godot: hay que reconstruirlos. |
| Movimiento | Desplazamiento horizontal limitado a una franja; aceleración, frenada y animación por distancia. No hay geometría de colisión ni profundidad transitable. El acercamiento usa un desplazamiento fijo respecto del punto de interacción, sin puntos de llegada propios para cada objeto. |
| Sota | Hojas distintas de caminar, correr y reposo; recortes, bases y escalas corregidos por fotograma. Persisten variaciones de anatomía y ropa; reflejar la imagen cambia de lado el deck. La transición entre poses de giro es discreta. |
| Ciudad | Fondos de 1672 × 941 con secundarios y mobiliario integrados en la pintura. Vapor, lluvia y luces se superponen por código. No hay capas separadas para parallax u oclusión. |
| Datos de texto | Guion de mesa, tarjetas Markdown y copias en JavaScript. No hay sincronización automática: una migración debe cotejar contenido y elegir una fuente de ejecución única. |
| Persistencia | Guardado en `localStorage`, con validación; conversación registrada al finalizar. Godot necesitará su propio guardado versionado. Las partidas antiguas no se trasladarán automáticamente. |
| Distribución | No hay publicación pública ni repositorio Git en esta carpeta. El prototipo arranca por HTTP local. Falta probar el juego completo en los navegadores de destino. |

Revisados continuidad, canon, dirección artística, guion v2, deducciones, protocolo, documentos en ejecución, todos los módulos JavaScript y sus pruebas, HTML/CSS y recursos activos. Se observaron v8, los cuatro escenarios y las hojas activas de Sota. Se comprobó que las tres hojas activas contienen transparencia real con `Image.detect_alpha()` de Godot; tener formato RGBA por sí solo no lo demuestra.

Las trece pruebas JavaScript pasan. Se abrió la v0.2 por HTTP en Safari y se observó el arranque y el desplazamiento hasta una interacción. No se repitió una partida completa cronometrada. No existe carpeta `sources/` en esta copia; no se presupone que esté sincronizada. El canon local sí está disponible.

## Base de trabajo

- Godot **4.7.2 estable**, edición estándar, instalado en `/Applications/Godot.app`. Mantener editor y plantillas en la misma versión.
- **GDScript + 2D + Compatibility**. Profundidad mediante composición de capas, escala, luz y oclusión; no hace falta construir una ciudad 3D para la experiencia aprobada.
- Editor de escritorio para desarrollar; exportación Web para jugar. El usuario final no instala Godot. La documentación oficial exige WebAssembly y WebGL 2.0, indica Compatibility y no admite actualmente exportación web de proyectos Godot 4 escritos en C#. [Exportación Web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html).
- Exportación inicial **sin hilos ni extensiones** para simplificar alojamiento y compatibilidad. Probar Safari desde el principio, además de un navegador Chromium y Firefox antes de publicar. El soporte teórico no sustituye la prueba en cada navegador. [Requisitos y limitaciones](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html).
- `juego/` conserva la referencia funcional v0.2. `godot/` contiene el proyecto nuevo. Ninguna dependencia de ejecución del JavaScript anterior.
- La escena `verificacion.tscn` solo verifica instalación, importación y exportación. No es una migración del caso ni la nueva versión artística.

## Hitos, en orden

### 0. Entorno reproducible

Instalar editor, verificar procedencia, preparar las plantillas, importar un recurso real, arrancar una escena y exportarla. Comprobar renderizado y entrada en navegador, no solo que aparece un archivo HTML. Comandos de repetición y resultados en [godot/README.md](../godot/README.md).

Antes de iniciar producción, añadir control de versiones local y una copia de respaldo. Publicar un repositorio no es necesario para publicar el juego. No incluir el canon inédito ni documentos de solución en un futuro repositorio público o paquete para jugadores.

### 1. Una escena que se sienta bien: Velvet

Este es el siguiente trabajo recomendado. Primera entrega pequeña: Sota recorre la galería, se detiene ante la jefa, inicia el encargo y puede abrir el primer documento. Se ejecuta ya en navegador.

Orden interno:

1. Revisar primero el nuevo acabado pixel art de Sota en Velvet: v8 conserva identidad y composición; REPLACED orienta el tratamiento visual vigente. Fijar escala, plano de suelo, resolución, retícula y filtrado con recursos nuevos a tamaño real antes de extender la producción. Los 1280 × 720 de la prueba de instalación no son una retícula artística aprobada.
2. Construir movimiento con límites/colisiones y puntos de llegada por interacción. Conservar teclado y clic; impedir movimiento mientras se lee o conversa. No añadir salto, combate ni plataformas.
3. Calibrar el ciclo de caminar: apoyos, transferencia de peso, distancia de zancada y pivote común. Corregir la consistencia de los fotogramas antes de aumentar su número. Revisar después carrera, frenada, cambio entre perfiles y reposo con respiración sutil; preparar izquierda propia para conservar el deck.
4. Comprobar qué debe quedar delante y detrás de Sota. Separar los elementos necesarios del fondo y reconstruir lo oculto por ellos. Guardar nuevas versiones y prompts. Godot no separa automáticamente los personajes de una ilustración.
5. Añadir profundidad y actividad discreta: capas con parallax donde haya movimiento de cámara, vapor, reflejos, luces y algún secundario independiente. La cámara debe servir a la composición; un fondo fijo no gana profundidad solo por usar un nodo de parallax.
6. Encargo y primer documento con controles de Godot, foco de teclado, texto cómodo y movimiento reducido. Evaluar el conjunto con el autor.

**Diálogos · decisión del autor, 12 de octubre:** escena oscurecida, retrato de Sota a la izquierda, interlocutor a la derecha y texto entre ambos. [Retratos de Sota/Jefa guardados](../trabajo/arte/personajes/retratos_v1/README.md). Implementar con el primer encargo en T10/T11; composición decidida, tamaños/opciones/foco y transiciones pendientes. La escena lateral conserva sprites de perfil y rostro pixelado; los retratos ilustrados son recursos de interfaz.

**Cierre del hito:** caminar y correr en ambos sentidos, parar, invertir dirección, llegar y hablar sin saltos de escala, atravesar objetos ni perder el foco; texto legible; escena ejecutable en navegador. Registrar por separado errores comprobados y valoración estética del autor. Si Sota sigue pareciendo deslizarse o cambiar de cuerpo, el hito sigue abierto.

### 2. Pasar el caso completo

Reutilizar el patrón aprobado para casillero, oficina y taller. Migrar reglas y contenidos manteniendo identificadores E0/P1–P7, D1/D2 y las condiciones de cierre. El estado del caso debe quedar separado del movimiento y de los controles de pantalla.

Estructura suficiente: escenas de localización, escena de Sota, controles de diálogo/libreta y un estado de partida compartido. Usar nodos, señales y recursos estándar; no construir un motor de aventuras genérico ni instalar un sistema de diálogos antes de necesitarlo.

Los textos de ejecución se consolidarán en datos Godot o JSON, cotejados con la mesa v2. Las tarjetas HTML requerirán adaptar párrafos y tablas, sin perder fechas, importes ni distinciones. El HTML antiguo queda como referencia, no como interfaz incrustada en el juego nuevo.

Guardado en `user://` con versión y validación. En web su persistencia depende del almacenamiento del navegador; hay que comprobar recarga y reapertura en el alojamiento real y avisar dentro del juego si no se puede conservar la partida. No sobrescribir ni borrar la partida del prototipo. [Persistencia web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html#using-cookies-for-data-persistence).

En la prueba Web, Safari expone principalmente un canvas en su árbol de accesibilidad. La accesibilidad de la interfaz HTML no se transfiere por usar botones Godot: verificar foco, teclado, tamaños y lectura asistida durante la migración, antes de dar la libreta por terminada.

**Cierre del hito:** equivalentes de las seis pruebas del caso en GDScript y recorrido manual completo: deducción tardía, respuesta incorrecta sin pérdida, documentos al salir de Sanz, lectura y consentimiento obligatorios, cantidades y cierre correctos, recarga y recuperación de guardados inválidos.

### 3. Terminar la experiencia

Revisar transiciones, sonido ambiente, pasos, retroalimentación de interacciones, lectura de documentos y mezcla. Las voces selectivas vienen después de probar el texto; verificar acceso a ElevenLabs antes de producirlas.

Hacer una partida del autor con lectura natural, medir duración y registrar dudas. Revisar especialmente el silencio voluntario de Iria, la diferencia entre presentación y autorización y cuánto revela el propio objetivo de pantalla. No alargar el juego con paseos o texto para cumplir una cifra.

Comprobar el recorrido completo en Safari, Chromium y Firefox; resolución habitual de portátil, pantalla completa, cambio de foco, teclado, opciones y guardado. Medir tiempos de carga y rendimiento de las escenas más cargadas. Móvil queda como destino posterior hasta diseñar y probar sus controles y lectura.

### 4. Compartirlo y presentarlo como proyecto

Propuesta: primera publicación en **itch.io**, con juego Web, portada, capturas, controles, duración medida y créditos. Se sube el ZIP de la exportación con `index.html` y sus recursos; no el directorio de trabajo. itch.io permite jugar directamente e incrustar el juego en su página. [Formato de publicación](https://itch.io/docs/creators/html5).

Preparar una ficha de portfolio que muestre qué hace el juego, el papel del autor, dirección visual, decisiones técnicas, proceso y enlace para jugar. Una descarga de escritorio puede añadirse desde el mismo proyecto cuando esté comprobada; no es requisito para el primer lanzamiento Web.

Antes de hacer público el enlace, comprobar el paquete alojado, la recarga y el guardado desde esa URL. Conservar versión y paquete publicado para poder restaurarlos. El enlace a CARGA ADMISIBLE solo se incorpora cuando exista y se verifique.

## Qué no resuelve cambiar de motor

Godot aporta edición de escenas, animación, colisiones, audio e importación/exportación. No corrige por sí mismo fotogramas incoherentes, personajes incrustados en fondos o ritmo narrativo. La parte que más condicionará el acabado será producir y revisar recursos consistentes dentro de una escena ya jugable.

No se propone ampliar localizaciones, añadir servicios en línea ni rehacer el universo. El trabajo inmediato es demostrar el acabado de Velvet y usarlo como patrón para terminar el caso pequeño.
