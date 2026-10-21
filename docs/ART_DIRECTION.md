# Dirección artística · 2D ilustrado

## Referencia maestra

`art/originals/sota.png` y `jefa.png`, originales del autor. Contorno oscuro firme, sombras amplias de bordes definidos, tonos de piel cálidos, pelo en masas legibles, materiales usados con detalle selectivo. Los PNG del juego son copias idénticas por SHA256. No se reflejan, regeneran, pixelan ni repintan.

La ciudad se construye por acumulación: instalaciones añadidas, reparaciones y diferencias de recursos visibles. La Fiebre admite rojos y ciruela; el hogar usa petróleo, ocres y luz práctica. La Penumbra no tiene sol directo. No añadir números gigantes de cota ni convertir el fondo en una ciudad futurista limpia.

## Candidatos de este hito

El autor suministró el logo rojo sobre fondo claro «EL ARRECIFE PRODUCTS» para la primera pantalla de apertura. Original intacto en `art/originals/branding/el_arrecife_products.png`; copia idéntica en `game/assets/branding/`. No se ha redibujado ni recoloreado. Esta indicación concreta del logo no supone la aprobación de los fondos candidatos ni del texto legal.

Cuatro fondos originales de exploración en `game/assets/backgrounds/candidates/`, generados con la herramienta integrada imagegen y el retrato de Sota como referencia de estilo. Prompts en `art/prompts/fondos_hito1.json`; no se ha usado CLI/API externa. El pasaje original `fiebre.png` sigue intacto. Se conservan dos variantes pobladas: `fiebre_multitud_v1.png` y `fiebre_multitud_v2.png`. La segunda se muestra en el juego para revisar la densidad de población; su proceso está en `art/prompts/fiebre_multitud_v2.md`. Un quinto fondo candidato muestra la ciudad desde una ventana ajena al dormitorio, para el menú; sus tres versiones y dirección de generación están en `art/iterations/menu_nudo_ventana/` y `art/prompts/menu_nudo_ventana.md`. Todos son PNG aplanados, **pendientes de aprobación final**, sin fuentes por capas.

Se conservan los PNG originales de generación. No se ha regenerado ningún personaje. **Observación del autor:** gusta el lenguaje visual de los entornos a primera vista, pero hay que revisar sus detalles; las calles de las cotas mostradas deben sentirse densamente pobladas. La variante del pasaje incorpora clientela de distinto poder adquisitivo y personas que trabajan allí, sin convertirlas automáticamente en contactos jugables. Se despejaron las entradas de Velvet y del local contiguo para conservar las interacciones. Aún falta cotejar cada figura, implante, sombra, reflejo y continuidad espacial a tamaño de juego; el local contiguo no atribuye propiedad a la Jefa ni la representa físicamente. El dormitorio necesita revisar la luz exterior: el tono ámbar debe leerse como bruma iluminada artificialmente, nunca como sol en La Fiebre. También falta verificar continuidad arquitectónica exacta entre las habitaciones.

## Población en las cotas mostradas

Las calles y pasos públicos deben tener vida en varias profundidades: gente circulando, esperando, trabajando y asomada a galerías. Mostrar la densidad sin tapar puertas, objetos clave, rutas ni puntos de interacción. La multitud es parte del entorno; sólo algunas personas tienen diálogo. La Fiebre mezcla visitantes con recursos, habitantes y personal de servicio, incluidos trabajadores del ocio y del sexo, representados como adultos con oficios y agencia, sin reducirlos a reclamos. Diferenciar recursos por confección, conservación de la ropa, transporte y mantenimiento de implantes. El Nudo deberá mostrar oficios de red y reparación; Los Puntales, tránsito de cuadrillas y mantenimiento estructural. Estas composiciones concretas son dirección de arte del juego, no nuevas afirmaciones de canon literario.

## Especificación común de producción

Maestro recomendado: 2560×1440, 16:9; exportación inicial 1920×1080 PNG sRGB. Cámara fija a la altura de Sota, sin manos/avatar ni cámara móvil. Mantener puntos interactivos dentro de márgenes y separarlos; colocar hotspots sobre el resultado real, no sobre posiciones del prompt. Conservar una fuente editable con capas, además del PNG. La escena llena la pantalla; planificar márgenes superiores/inferiores que admitan recorte en pantallas más anchas y bandas de interfaz superpuestas.

Capas: estructura/fondo, objetos interactivos cuando requieran cambio, luz emisiva, humo y primer plano. Animación contenida; versión estática accesible. Retratos ilustrados originales como referencia en cada encargo. Ni arte pixel ni render 3D. Las interfaces y los textos legibles los dibuja Godot.

## Plan de ilustraciones (12 vistas)

| Vista | Composición y objetos | Luz / capas / animación |
| --- | --- | --- |
| Dormitorio | Cama izquierda, ventana, deck sobre mesa, puerta derecha | Petróleo/ámbar práctico; ventana, pantalla del deck, polvo opcional |
| Salón/cocina | Terminal, recibo en mesa, contador, puertas diferenciadas | Ocre y verde apagado; pantalla, indicador del contador |
| Baño | Espejo sin duplicar avatar, tubería, estante, salida | Fluorescente frío y puerta cálida; goteo opcional ligado al agua |
| Fiebre: pasaje | Velvet lateral, accesos despejados, multitud de vecinos, clientela y personal; lugar de reunión separado | Rojo local, sombra azul verdosa; humo/neón por capas |
| Fiebre: umbral | Acceso y control, sin atribuir a Jefa propiedad del local | Contraste interior/exterior; luz de puerta |
| Fiebre: encuentro | Mesa, libro y lugar propio de la Jefa, sin recepción permanente | Luz de trabajo contenida; figura por diseñar desde retrato |
| Nudo: acceso | Conductos de red, control, circulación vertical y paso público concurrido | Verde/cian apagado, estado del lector |
| Nudo: taller | Reparación de equipos, componentes y manos/oficios en segundo plano | Trabajo neutro, pantallas aisladas |
| Nudo: terminal | Puerto físico y equipo de contraste, recibo comparado | Respuesta de pantalla; primer plano separable |
| Puntales: acceso | Uniones estructurales y paso denso de trabajadores, sin bloquear la ruta | Luz industrial cálida, profundidad gris |
| Puntales: taller | Herramientas, piezas de conducción, registros de trabajo | Luz útil y materiales gastados; objeto comprobable separable |
| Puntales: trabajo | Estructura que soporta otras cotas, intervención local concreta | Bruma y puntos de servicio; cierre visual pendiente de guion |

Las últimas ocho no tienen fondo aún. Los cuatro fondos activos, incluida la variante poblada, requieren aprobación y despiece antes de considerarse arte final. Faltan música, ambiente y efectos; los controles de audio actúan sobre buses preparados, actualmente sin pistas.

## Originales históricos

Guardia, figurante y acompañante del acceso se preservan en `art/originals/historico_*.png`. Son figuras pixel, no retratos de diálogo ilustrados. No se han encontrado otros retratos finales en el inventario del repositorio. Procedencia y prompts antiguos en `art/provenance/`; documentos históricos con enlaces relativos a su rama original. Su existencia no obliga a trasladar ese estilo al nuevo juego.
