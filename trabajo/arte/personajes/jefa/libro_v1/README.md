# Libro de la Nómina · Objeto independiente T08.2

12 de octubre de 2026. El autor aprueba el sprite pixel art de la Jefa y autoriza continuar. Se prepara su libro propio, establecido en canon/guion; el aspecto del objeto es propuesta del asistente, pendiente de valoración. No es el registro de habitaciones ni añade pruebas o cifras del caso.

[libro_nomina_v1.png](../../../../../godot/assets/personajes/jefa/libro_nomina_v1.png): 2172 × 724, RGBA transparente. Generado con **imagegen integrado**, usando como referencias la Jefa aprobada y la escena vigente. [Prompt completo](prompt.txt). PNG original copiado sin modificación; Jefa, retratos y recursos anteriores intactos.

Libro abierto, tapas burdeos oscuras, lomo reforzado, esquinas de latón mate, páginas claras y marcador de tela. Píxel grueso y marcas abstractas de cuentas; sin palabras, nombres, cantidades o información legible. Materiales y vista superficial compatibles con el mostrador; no emite luz ni contiene neón pintado.

AtlasTexture x = 123, y = 142, ancho 1926, alto 456. Montaje de 56 × 18 en x = 1318, y ≈ 521.895; escala separada por eje para que las páginas sean legibles bajo las manos. Apoyo de tapa medido en y local = 408, alineado con superficie y = 538; el marcador cuelga unos dos píxeles por debajo. Nearest y shader de objeto opaco existentes. Z = −5, detrás de las manos de Jefa z = −4, mostrador z = −3 y equipo z = −2; Sota z = 0. La profundidad del resto se conserva.

El primer montaje, más plano y a la derecha, dejaba pocas páginas visibles; se ajustan tamaño y posición en Godot sin editar la imagen ni el personaje aprobado. Control **Libro** independiente de Jefa/Equipo. Ocultar objetos sirve para revisar planos; no define cómo se comportarán en la partida.

[Catorce capturas y pruebas Godot/Web](../../../revisiones/libro_v1/README.md). Pendientes respiración y acción de consulta/anotación de la Jefa, retirada del libro al marcharse e interfaz de diálogo. Este recurso no produce nuevas conversaciones ni altera el canon/guion.
