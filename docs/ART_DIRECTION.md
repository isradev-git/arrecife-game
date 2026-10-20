# Dirección artística · 2D ilustrado

## Referencia maestra

`art/originals/sota.png` y `jefa.png`, originales del autor. Contorno oscuro firme, sombras amplias de bordes definidos, tonos de piel cálidos, pelo en masas legibles, materiales usados con detalle selectivo. Los PNG del juego son copias idénticas por SHA256. No se reflejan, regeneran, pixelan ni repintan.

La ciudad se construye por acumulación: instalaciones añadidas, reparaciones y diferencias de recursos visibles. La Fiebre admite rojos y ciruela; el hogar usa petróleo, ocres y luz práctica. La Penumbra no tiene sol directo. No añadir números gigantes de cota ni convertir el fondo en una ciudad futurista limpia.

## Candidatos de este hito

El autor suministró el logo rojo sobre fondo claro «EL ARRECIFE PRODUCTS» para la primera pantalla de apertura. Original intacto en `art/originals/branding/el_arrecife_products.png`; copia idéntica en `game/assets/branding/`. No se ha redibujado ni recoloreado. Esta indicación concreta del logo no supone la aprobación de los fondos candidatos ni del texto legal.

Cuatro PNG en `game/assets/backgrounds/candidates/`, generados con la herramienta integrada imagegen y el retrato de Sota como referencia de estilo. Prompts completos en `art/prompts/fondos_hito1.json`; no se ha usado CLI/API externa. Son imágenes aplanadas, **pendientes de aprobación**, no fuentes finales por capas. El menú y las escenas lo indican.

Se conservan los PNG originales de generación. No se ha regenerado ningún personaje. La calle representa la mesa del encuentro mediante un indicador; falta una figura ambiental de la Jefa fiel al retrato. El dormitorio necesita revisar la luz exterior: el tono ámbar debe leerse como bruma iluminada artificialmente, nunca como sol en La Fiebre. También falta verificar continuidad arquitectónica exacta entre las habitaciones.

## Especificación común de producción

Maestro recomendado: 2560×1440, 16:9; exportación inicial 1920×1080 PNG sRGB. Cámara fija a la altura de Sota, sin manos/avatar ni cámara móvil. Mantener puntos interactivos dentro de márgenes y separarlos; colocar hotspots sobre el resultado real, no sobre posiciones del prompt. Conservar una fuente editable con capas, además del PNG. Contener toda la ilustración en pantallas de otra proporción.

Capas: estructura/fondo, objetos interactivos cuando requieran cambio, luz emisiva, humo y primer plano. Animación contenida; versión estática accesible. Retratos ilustrados originales como referencia en cada encargo. Ni arte pixel ni render 3D. Las interfaces y los textos legibles los dibuja Godot.

## Plan de ilustraciones (12 vistas)

| Vista | Composición y objetos | Luz / capas / animación |
| --- | --- | --- |
| Dormitorio | Cama izquierda, ventana, deck sobre mesa, puerta derecha | Petróleo/ámbar práctico; ventana, pantalla del deck, polvo opcional |
| Salón/cocina | Terminal, recibo en mesa, contador, puertas diferenciadas | Ocre y verde apagado; pantalla, indicador del contador |
| Baño | Espejo sin duplicar avatar, tubería, estante, salida | Fluorescente frío y puerta cálida; goteo opcional ligado al agua |
| Fiebre: pasaje | Velvet lateral, tránsito peatonal, mesa de reunión separada | Rojo local, sombra azul verdosa; humo/neón por capas |
| Fiebre: umbral | Acceso y control, sin atribuir a Jefa propiedad del local | Contraste interior/exterior; luz de puerta |
| Fiebre: encuentro | Mesa, libro y lugar propio de la Jefa, sin recepción permanente | Luz de trabajo contenida; figura por diseñar desde retrato |
| Nudo: acceso | Conductos de red, control, circulación vertical contextual | Verde/cian apagado, estado del lector |
| Nudo: taller | Reparación de equipos, componentes y manos/oficios en segundo plano | Trabajo neutro, pantallas aisladas |
| Nudo: terminal | Puerto físico y equipo de contraste, recibo comparado | Respuesta de pantalla; primer plano separable |
| Puntales: acceso | Uniones estructurales y paso de trabajadores | Luz industrial cálida, profundidad gris |
| Puntales: taller | Herramientas, piezas de conducción, registros de trabajo | Luz útil y materiales gastados; objeto comprobable separable |
| Puntales: trabajo | Estructura que soporta otras cotas, intervención local concreta | Bruma y puntos de servicio; cierre visual pendiente de guion |

Las últimas ocho no tienen fondo aún. Las cuatro actuales requieren aprobación y despiece antes de considerarlas arte final. Faltan música, ambiente y efectos; los controles de audio actúan sobre buses preparados, actualmente sin pistas.

## Originales históricos

Guardia, figurante y acompañante del acceso se preservan en `art/originals/historico_*.png`. Son figuras pixel, no retratos de diálogo ilustrados. No se han encontrado otros retratos finales en el inventario del repositorio. Procedencia y prompts antiguos en `art/provenance/`; documentos históricos con enlaces relativos a su rama original. Su existencia no obliga a trasladar ese estilo al nuevo juego.
