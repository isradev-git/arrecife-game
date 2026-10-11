# Velvet · Guardia y cabina por capas T07.9

12 de octubre de 2026. El autor pide continuar los personajes y establece dos funciones para esta cabina: **hablar con el guardia y viajar a otra cota**. Se entrega su preparación visual; conversaciones y viajes todavía sin implementar. Arte nuevo pendiente de valoración.

Generado con la herramienta integrada **imagegen**, en tres ediciones desde el entorno horizontal vigente. Para el guardia se aporta también la referencia aprobada de personajes. PNG originales copiados sin modificación; recortes y escalas mediante AtlasTexture en Godot. Se conservan todos los recursos anteriores.

| Recurso | Original y región utilizada | Prompt completo |
| --- | --- | --- |
| [guardia_cabina_v1.png](../../../../../godot/assets/entornos/velvet/guardia_cabina_v1.png) | 1024 × 1536, RGBA transparente; región x = 300, y = 107, ancho 540, alto 1383 | [Guardia](prompt_guardia.txt) |
| [frontal_cabina_v1.png](../../../../../godot/assets/entornos/velvet/frontal_cabina_v1.png) | 837 × 1880, RGBA transparente; región x = 80, y = 122, ancho 673, alto 1637 | [Frontal](prompt_frontal.txt) |
| [fondo_cabina_reparado_v1.png](../../../../../godot/assets/entornos/velvet/fondo_cabina_reparado_v1.png) | 1672 × 941, opaco; solo se usa x = 149–278, y = 389–675 | [Interior vacío](prompt_fondo.txt) |

Guardia adulto de perfil derecho: gorra, uniforme oscuro, parche naranja discreto, botas y deck azul sujeto con ambas manos. Píxel grueso, rostro en sombras y ojo apenas visible; sin arma ni identidad narrativa nueva. Altura 260, x = 166, y = 415, escala uniforme 260 / 1383 y apoyo y = 675. Material propio con contraluz manual ámbar desde izquierda y rojo desde derecha, separado de su base; fuentes espaciales pendientes.

Frontal en x = 151, y = 396, tamaño 126 × 279, base horizontal y = 675. Ventanilla realmente transparente; marco y panel inferior opacos mediante el shader de metal existente. Se ajustan ancho/alto del recurso al hueco arquitectónico. La generación cambia detalles y deja una ventanilla mayor que la original; no es una extracción idéntica. El interior reconstruido elimina al guardia y al frontal pintados; fuera del parche el montaje conserva exactamente el fondo anterior.

Orden: interior z = −19, guardia z = −8, frontal z = −7, Sota z = 0, barandilla delantera z = +5. El guardia queda dentro de la cabina y Sota pasa por delante, en el centro y = 705. Recepción, personas del acceso y ambas barandillas conservadas.

Controles de revisión **Guardia / Cabina** independientes y **Frente al guardia** (Sota x = 300). El panel se mueve a x = 480 al revisar x ≤ 340 para no tapar la ventanilla; vuelve a x = 24 en el resto del recorrido. No son acciones de juego.

**Función futura autorizada:** dos acciones diferenciadas, «Hablar con el guardia» y «Cambiar de cota». Diálogo en T11 y recorrido en T19, con destinos descubiertos y permisos coherentes con canon/guion. Bajar es fácil; subir exige autorización. La acreditación del encargo ya cubre a Sota y su regreso: no inventar un bloqueo o un trámite extra. Revisar la señalización y la puesta en escena del acceso al integrar el viaje: se conserva por ahora PERSONAL / SALIDA AUTORIZADA de la referencia. Esta función es una decisión del juego; canon literario intacto.

[Catorce capturas y comprobaciones Godot/Web](../../../revisiones/cabina_v1/README.md). Figuras estáticas, contraluz manual, retícula definitiva y resto de personas/arquitectura/atmósfera pendientes.
