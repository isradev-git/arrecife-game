# Validación del hito 1

20 de octubre de 2026. Godot 4.7.2 oficial, Mac mini M4, Compatibility. Estas pruebas certifican el alcance descrito; no aprueban el arte ni la ficción.

## Automatización

| Comprobación | Resultado |
| --- | --- |
| Importación del proyecto y arranque | Sin errores de script/importación registrados |
| `tests/run.gd`, headless | **193 comprobaciones, 0 fallos** |
| Mismo recorrido nativo con GPU Apple M4 | **216 comprobaciones, 0 fallos**; incluye 23 capturas |
| `tests/preservation.py` | Canon, cinco originales, dos copias de diálogo y logo original idénticos; un proyecto activo; ninguna dependencia 3D |
| Exportación Web, sin hilos | Generada correctamente con las plantillas 4.7.2 |

Los conteos difieren porque la ejecución GPU incluye comprobaciones de escritura de capturas. Se comprueba logo → autoría → aviso → menú, espera en móvil vertical, cobertura del menú hasta volver a horizontal y configuración nativa por sensor para que el aviso pueda verse con el teléfono erguido. En las cuatro proporciones se comprueba que cada área táctil sea de 56×56 unidades, permanezca sobre la ilustración y no tenga rótulos superpuestos. Un clic cercano a la puerta, fuera del área acotada, no navega; el clic central sí. La prueba vertical de interacción de la escena se ejecuta en modo ordenador dentro de Godot para conservar la regresión de layout; en un móvil la escena queda cubierta. No sumar las cifras como si fuesen casos independientes.

Las pruebas cubren: IDs/destinos y condiciones, cuatro zonas/doce vistas registradas, partida nueva, bloqueo previo al contrato, menú/opciones/créditos/continuar, intro saltable, deck, mensaje, aceptación, cocina/baño, documentos y paginación, terminal y registro, conversación/elección/flags, ruta a La Fiebre, persistencia de cada campo y rechazo de formatos inválidos, recuperación de `.bak`, rechazo de zona futura y limpieza de nueva partida. Se prueban READY_TO_COMPLETE y COMPLETED con efectos sintéticos de futuros hitos, sin atribuir esos contenidos al juego actual.

Entrada: eventos `InputEventMouseButton` y `InputEventScreenTouch` entregados al viewport. Se pulsa también la opción de diálogo mediante su botón. No son pruebas con un dedo físico.

Resoluciones nativas capturadas: 1280×720, 844×390, 1024×768 y 390×844. Ilustración completa, controles dentro del encuadre; diálogo desplazable. En móvil, horizontal es obligatorio. La prueba de layout vertical corresponde al modo ordenador. La lista de acciones sólo aparece al abrir «Pistas».

[Log headless](evidence/pruebas_headless.log) · [Log GPU](evidence/pruebas_nativas.log) · [Integridad](evidence/preservacion.log).

## Navegador

Helium/Chromium, WebGL 2, servidor HTTP local. Comprobados visualmente menú, introducción, dormitorio, deck/mensaje, contrato disponible/aceptado y cambio a cocina. Recargar la página habilita Continuar y restaura la cocina con el contrato activo.

Se ajusta el viewport a 844×390. Un `TouchEvent` de inicio/fin enviado al canvas sobre Deck abre su interfaz. Es una comprobación del recorrido táctil del navegador de escritorio, no una certificación de Safari ni de un teléfono real.

Consola sin errores de ejecución registrados en la revisión del hito 1. En la corrección móvil posterior, se reemplazaron los indicadores con letras y rótulos por puntos de luz y áreas táctiles transparentes. A 844×390 se comprobó visualmente el dormitorio, un `TouchEvent` sobre la puerta que lleva a la cocina, una observación sobre el suministro y la apertura del terminal desde «Pistas». Tras acotar las áreas, se repitió en la nueva exportación Web: toque próximo al punto sin navegar; toque central con navegación correcta.

Antes de la nueva decisión horizontal se probó la exploración Web a 390×844: escena y observación juntas, texto legible y toques dentro/fuera del punto. Esa captura es evidencia histórica del diseño anterior. Con la nueva exportación se emuló iPhone 12 en Helium: en 390×844 aparece «Gira el móvil» y no el menú; al pasar a 844×390 aparece el menú; de vuelta a vertical reaparece el aviso encima del menú. El icono de giro se vio en movimiento. Emulación de navegador, no hardware iOS/Safari.

Con el logo original integrado se repitió la exportación Web. En una sesión de pestaña vacía apareció el logo; se recargó durante la apertura y apareció directamente el menú. Se cerró esa pestaña y se abrió otra en la misma dirección: el logo volvió a aparecer. Una recarga adicional con iPhone emulado en vertical mostró únicamente el aviso de giro, sin repetir logo ni crédito. Se inspeccionó el valor de sesión `el_arrecife_apertura_v1`. Si el navegador impide usar `sessionStorage`, la apertura se muestra de nuevo como degradación segura; aún no se ha probado ese caso en hardware.

La exportación final usa `boot_splash/show_image=false`: se inspeccionó el HTML generado y su clase `show-image--false` oculta la imagen azul de Godot durante la descarga. Queda el fondo neutro `#0c171d`, seguido del logo original sólo en la primera apertura de la pestaña.

[Consola](evidence/web_consola.log) · [Errores](evidence/web_errores.log) · [Antes de recargar](evidence/web_cocina_antes_recarga.png) · [Después](evidence/web_cocina_tras_recarga.png) · [Toque sobre Deck](evidence/web_toque_deck.png).

La persistencia observada es entre recargas del mismo origen y perfil. Borrar almacenamiento, modo privado, restricciones del navegador o cambiar de host/puerto pueden impedir recuperar la partida. No se ha probado persistencia prolongada, cuotas agotadas ni cierres abruptos del dispositivo.

## Evidencia visual real

- [Logo](evidence/00_logo.png), [autoría](evidence/00_autoria.png), [aviso PC](evidence/00_aviso_pc.png), [aviso móvil](evidence/00_girar_movil.png).
- [Web primera visita con el logo original](evidence/web_apertura_primera_visita.png), [recarga directa al menú](evidence/web_apertura_recarga.png), [pestaña nueva con logo](evidence/web_apertura_pestana_nueva.png), [recarga móvil vertical con aviso](evidence/web_apertura_recarga_movil_vertical.png).
- [Web iPhone emulado vertical inicial](evidence/web_iphone_vertical.png), [horizontal con menú](evidence/web_iphone_horizontal.png), [vertical tras menú](evidence/web_iphone_giro_en_menu.png).
- [Menú](evidence/01_menu.png), [introducción](evidence/02_introduccion.png), [dormitorio](evidence/03_dormitorio.png).
- [Contrato](evidence/04_contrato.png), [cocina](evidence/05_cocina.png), [documento](evidence/06_documento.png), [terminal](evidence/07_terminal.png).
- [Baño](evidence/08_bano.png), [Sota sola](evidence/09_monologo.png), [La Fiebre](evidence/10_fiebre.png), [diálogo](evidence/11_dialogo.png).
- [Horizontal móvil](evidence/dialogo_844x390.png), [vertical](evidence/viewport_390x844.png).
- [Dormitorio Web con puntos discretos](evidence/web_movil_sutil_dormitorio.png), [cocina tras toque directo](evidence/web_movil_sutil_toque.png), [acciones a petición](evidence/web_movil_sutil_pistas.png).
- [Escena vertical Web histórica, anterior al bloqueo](evidence/web_movil_vertical_escena.png), [cocina tras toque vertical histórico](evidence/web_movil_vertical_toque.png).

Son capturas del juego ejecutándose, no maquetas. Los PNG fuente de fondos no se utilizan como prueba de interfaz. Se revisaron composición, retratos, etiquetas, desplazamiento y transiciones. Se corrigieron botones superpuestos, referencias a pantallas liberadas al redimensionar y opciones de diálogo recortadas en vertical.

## Límites pendientes

No se han probado Windows/Linux, Safari/iOS, Android real ni teléfonos físicos. La detección móvil Web usa los indicadores `web_android`/`web_ios` de Godot, comprobada con iPhone emulado; queda por validar en Safari y Android físicos. El logo original fue suministrado por el autor para esta pantalla; el texto de derechos requiere revisión editorial. No hay aventura de 30 minutos completa, desenlace, sonido final, capas ambientales animadas ni arte aprobado para estos escenarios. Los fondos son candidatos aplanados. La ventana y la continuidad de las habitaciones requieren revisión artística. La Jefa aparece en el retrato de conversación; falta su figura ambiental. No se declara ninguna aprobación del autor sobre el resto de esta entrega.
