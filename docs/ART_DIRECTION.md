# Dirección artística · 2D ilustrado

## Referencia maestra

`art/originals/sota.png` y `jefa.png`, originales del autor. Contorno oscuro firme, sombras amplias de bordes definidos, tonos de piel cálidos, pelo en masas legibles, materiales usados con detalle selectivo. Los PNG del juego son copias idénticas por SHA256. No se reflejan, regeneran, pixelan ni repintan.

**Decisión del autor, 25 oct 2026:** los fondos deben tener el mismo lenguaje ilustrado que los retratos. En cada fondo nuevo se comparan juntos a tamaño de juego: grosor y seguridad del contorno, masas de color, sombras angulares de borde definido, pocos brillos y detalle selectivo. Una paleta compatible por sí sola no basta; evitar microtextura, rayado fino y acabado de render arquitectónico o fotográfico.

La ciudad se construye por acumulación: instalaciones añadidas, reparaciones y diferencias de recursos visibles. La Fiebre admite rojos y ciruela; el hogar usa petróleo, ocres y luz práctica. La Penumbra no tiene sol directo. No añadir números gigantes de cota ni convertir el fondo en una ciudad futurista limpia.

## Candidatos de este hito

El autor suministró el logo rojo sobre fondo claro «EL ARRECIFE PRODUCTS» para la primera pantalla de apertura. Original intacto en `art/originals/branding/el_arrecife_products.png`; copia idéntica en `game/assets/branding/`. No se ha redibujado ni recoloreado. Esta indicación concreta del logo no supone la aprobación de los fondos candidatos ni del texto legal.

Cuatro fondos originales de exploración en `game/assets/backgrounds/candidates/`, generados con la herramienta integrada imagegen y el retrato de Sota como referencia de estilo. Prompts en `art/prompts/fondos_hito1.json`; no se ha usado CLI/API externa. El pasaje original `fiebre.png` sigue intacto. Se conservan dos variantes pobladas: `fiebre_multitud_v1.png` y `fiebre_multitud_v2.png`. La segunda se muestra en el juego para revisar la densidad de población; su proceso está en `art/prompts/fiebre_multitud_v2.md`. Un quinto fondo candidato muestra la ciudad desde una ventana ajena al dormitorio, para el menú; sus tres versiones y dirección de generación están en `art/iterations/menu_nudo_ventana/` y `art/prompts/menu_nudo_ventana.md`. Todos son PNG aplanados, **pendientes de aprobación final**, sin fuentes por capas.

Se conservan los PNG originales de generación. No se ha regenerado ningún personaje. **Observación del autor:** gusta el lenguaje visual de los entornos a primera vista, pero hay que revisar sus detalles; las calles de las cotas mostradas deben sentirse densamente pobladas. La variante del pasaje incorpora clientela de distinto poder adquisitivo y personas que trabajan allí, sin convertirlas automáticamente en contactos jugables. Se despejaron las entradas de Velvet y del local contiguo para conservar las interacciones. Aún falta cotejar cada figura, implante, sombra, reflejo y continuidad espacial a tamaño de juego; el local contiguo no atribuye propiedad a la Jefa ni la representa físicamente. El dormitorio necesita revisar la luz exterior: el tono ámbar debe leerse como bruma iluminada artificialmente, nunca como sol en La Fiebre. También falta verificar continuidad arquitectónica exacta entre las habitaciones.

## Piloto de movimiento ambiental · 24 oct 2026

El autor aprobó el [diseño del piloto](superpowers/specs/2026-10-23-ambiente-dinamico-design.md). `fiebre_multitud_v2.png` sigue intacto y aplanado. La capa transparente editable se dibuja en `game/scripts/ui/ambient_fiebre.gd`: brillo rojo de las luces de Velvet y sus reflejos en el suelo, vapor junto a la ventilación de la pared derecha y bruma dentro del arco lejano. Sus coordenadas están normalizadas respecto al PNG completo, no a la ventana recortada. Las figuras permanecen inmóviles. No se han generado nuevas versiones de los retratos ni del fondo.

El piloto está implementado y comprobado en escritorio, Web y horizontal pequeño. Después de que el autor no percibiera movimiento en una pestaña con el paquete antiguo, se aumentó el recorrido y la opacidad de vapor, bruma y pulso luminoso; su aspecto final aún espera valoración visual. [Animación actual de seis segundos](evidence/ambient_fiebre_visible_844x390.gif) · [con movimiento](evidence/ambient_fiebre_visible_844x390.png) · [con movimiento reducido](evidence/ambient_fiebre_visible_reducido_844x390.png). La solución vectorial evita un despiece completo del fondo, pero no sustituye máscaras artísticas si una vista futura requiere humo detrás de elementos del primer plano. El menú y las otras veinte vistas quedan para una tanda posterior.

## Velvet visto desde dentro · corrección 24 oct 2026

El autor observó que el antiguo `fiebre_entrada.png` repetía el exterior del pasaje. Se conservó esa variante en `art/iterations/zonas_fiebre/velvet_umbral_exterior/` y se generó un nuevo candidato con el [prompt y las referencias](../art/prompts/velvet_interior_2026-10-24.md). La vista ahora mira la barra, mesas y reservados desde dentro; a la derecha queda la salida a la calle, sin gente delante. [Render 1280×720](evidence/velvet_interior_1280x720.png) · [render 844×390](evidence/velvet_interior_844x390.png). Los retratos, originales y canon no se modificaron. El fondo nuevo está integrado para prueba técnica; **su aprobación artística final sigue pendiente**.

## Muestra de Los Puntales · 25 oct 2026

Tras el canon visual D225, se produjo una [muestra candidata de `puntales_acceso`](../art/iterations/zonas_puntales/puntales_acceso_canon_v1.png) fuera del juego: refuerzos estructurales entre viviendas y comercios, paleta gris/óxido/azul, cielo proyectado y tres rutas despejadas. La primera generación tenía sombras de sol demasiado duras; se conserva junto al [prompt y la corrección de luz](../art/prompts/puntales_acceso_canon_v1.md). [Recorte de prueba a 844×390](evidence/puntales_acceso_canon_v1_844x390.png). Ambos PNG son aplanados. La revisión independiente observó que aún se repiten varias lámparas ámbar y quedan reflejos extensos en el pavimento: valorar si deben reducirse para distanciar la muestra de los fondos actuales. **Pendiente:** valoración artística del autor; no sustituir aún el fondo activo ni extender automáticamente la muestra a las otras vistas.

**Corrección del autor, 25 oct:** la v1 parecía demasiado iluminada para Los Puntales. Se generó una [v2 más sombría](../art/iterations/zonas_puntales/puntales_acceso_canon_v2.png) con cielo proyectado azul grisáceo, sombras bajo la estructura y luz práctica localizada. La [vista a 844×390](evidence/puntales_acceso_canon_v2_844x390.png) conserva las tres rutas. [Prompt de la v2](../art/prompts/puntales_acceso_canon_v2.md). La v1 no se sobrescribió. La v2 también queda pendiente de valoración artística y fuera del juego.

**Ajuste de estilo solicitado por el autor, 25 oct:** conserva la luz de la v2 y presenta una [v3 con formas y sombras más próximas a los retratos](../art/iterations/zonas_puntales/puntales_acceso_canon_v3.png). [Vista 844×390](evidence/puntales_acceso_canon_v3_844x390.png) · [prompt](../art/prompts/puntales_acceso_canon_v3.md). Se mantienen todas las versiones. **El autor aprobó este enfoque como dirección para Los Puntales** y pidió continuar.

**Cota completa, 25 oct:** el juego usa la v3 del acceso y cinco [fondos candidatos propios](../art/prompts/zonas_puntales_canon_2026-10-25.md) para taller, frente de trabajo, soportes, presión y verificación. Se conservaron los PNG anteriores y el primer borrador del taller. La luz de Penumbra procede de cielo artificial entre estructuras y de luminarias locales; cada escena tiene función espacial distinta. La galería de soportes usa una v2: la marca blanca cruza una unión metálica con corrosión, como exige el documento jugable. Se alinearon sobre el arte final la marca, el manómetro y el registro. [Validación y capturas por vista](VALIDACION.md). **La v3 del acceso fija la dirección aprobada; las otras cinco ilustraciones y su continuidad dentro del juego siguen pendientes de aprobación artística del autor.**

## Población en las cotas mostradas

Las calles y pasos públicos deben tener vida en varias profundidades: gente circulando, esperando, trabajando y asomada a galerías. Mostrar la densidad sin tapar puertas, objetos clave, rutas ni puntos de interacción. La multitud es parte del entorno; sólo algunas personas tienen diálogo. La Fiebre mezcla visitantes con recursos, habitantes y personal de servicio, incluidos trabajadores del ocio y del sexo, representados como adultos con oficios y agencia, sin reducirlos a reclamos. Diferenciar recursos por confección, conservación de la ropa, transporte y mantenimiento de implantes. El Nudo deberá mostrar oficios de red y reparación; Los Puntales, tránsito de cuadrillas y mantenimiento estructural. Estas composiciones concretas son dirección de arte del juego, no nuevas afirmaciones de canon literario.

## Especificación común de producción

Maestro recomendado: 2560×1440, 16:9; exportación inicial 1920×1080 PNG sRGB. Cámara fija a la altura de Sota, sin manos/avatar ni cámara móvil. Mantener puntos interactivos dentro de márgenes y separarlos; colocar hotspots sobre el resultado real, no sobre posiciones del prompt. Conservar una fuente editable con capas, además del PNG. La escena llena la pantalla; planificar márgenes superiores/inferiores que admitan recorte en pantallas más anchas y bandas de interfaz superpuestas.

Capas: estructura/fondo, objetos interactivos cuando requieran cambio, luz emisiva, humo y primer plano. Animación contenida; versión estática accesible. Retratos ilustrados originales como referencia en cada encargo. Ni arte pixel ni render 3D. Las interfaces y los textos legibles los dibuja Godot.

## Ilustraciones del mapa de 21 vistas

El autor aprobó tres vistas del apartamento y seis de cada cota, incluidos los nombres y conexiones del [diseño espacial](superpowers/specs/2026-10-21-21-vistas-zonas-design.md). Las 21 vistas ya están implementadas con un fondo candidato propio y recorridos de ida y vuelta. Los 17 fondos añadidos para las cotas conservan sus prompts en `art/prompts/zonas_{fiebre,nudo,puntales}.md`; la primera variante de soportes se conserva en `art/iterations/zonas_puntales/`. La revisión artística del autor sigue pendiente para cada fondo.

| Vista | Composición y objetos | Luz / capas / animación |
| --- | --- | --- |
| Dormitorio | Cama izquierda, ventana, deck sobre mesa, puerta derecha | Petróleo/ámbar práctico; ventana, pantalla del deck, polvo opcional |
| Salón/cocina | Terminal, recibo en mesa, contador, puertas diferenciadas | Ocre y verde apagado; pantalla, indicador del contador |
| Baño | Espejo sin duplicar avatar, tubería, estante, salida | Fluorescente frío y puerta cálida; goteo opcional ligado al agua |
| Fiebre: pasaje | Velvet lateral, accesos despejados, multitud de vecinos, clientela y personal; lugar de reunión separado | Rojo local, sombra azul verdosa; humo/neón por capas |
| Fiebre: interior de Velvet | Salón, barra y salida lateral al pasaje, sin atribuir a la Jefa propiedad del local | Rojo/ciruela y ámbar de interior; luz fría en la puerta |
| Fiebre: encuentro | Mesa, libro y lugar propio de la Jefa, sin recepción permanente | Luz de trabajo contenida; figura por diseñar desde retrato |
| Nudo: acceso | Conductos de red, control, circulación vertical y paso público concurrido | Verde/cian apagado, estado del lector |
| Nudo: taller | Reparación de equipos, componentes y manos/oficios en segundo plano | Trabajo neutro, pantallas aisladas |
| Nudo: terminal | Puerto físico y equipo de contraste, recibo comparado | Respuesta de pantalla; primer plano separable |
| Puntales: acceso | Uniones estructurales y paso denso de trabajadores, sin bloquear la ruta | Sombra bajo estructura, cielo artificial gris azulado y luz de trabajo local |
| Puntales: taller | Herramientas, piezas de conducción, registros de trabajo | Luz útil y materiales gastados; objeto comprobable separable |
| Puntales: trabajo | Estructura que soporta otras cotas, intervención local concreta | Bruma y puntos de servicio; cierre visual pendiente de guion |

La tabla recoge la dirección inicial de doce vistas; el inventario completo y sus conexiones están en el diseño espacial aprobado. Los 21 fondos activos son candidatos aplanados, pendientes de aprobación y despiece antes de considerarse arte final. Los seis fondos antiguos de Los Puntales tenían un render más detallado y brillante; las nuevas versiones acercan contorno, sombras y luz a la muestra aprobada, y su coherencia con los retratos y entre escenas aún debe valorar el autor. La versión 0.2.0 incluye ambiente mecánico y un toque de interfaz; no tiene partitura musical.

## Originales históricos

Guardia, figurante y acompañante del acceso se preservan en `art/originals/historico_*.png`. Son figuras pixel, no retratos de diálogo ilustrados. No se han encontrado otros retratos finales en el inventario del repositorio. Procedencia y prompts antiguos en `art/provenance/`; documentos históricos con enlaces relativos a su rama original. Su existencia no obliga a trasladar ese estilo al nuevo juego.
