# Validación del hito 1

20 de octubre de 2026. Godot 4.7.2 oficial, Mac mini M4, Compatibility. Estas pruebas certifican el alcance descrito; no aprueban el arte ni la ficción.

## Automatización

| Comprobación | Resultado |
| --- | --- |
| Importación del proyecto y arranque | Sin errores de script/importación registrados |
| `tests/run.gd`, headless | **137 comprobaciones, 0 fallos** |
| Mismo recorrido nativo con GPU Apple M4 | **156 comprobaciones, 0 fallos**; incluye 19 capturas |
| `tests/preservation.py` | Canon, cinco originales, dos copias de diálogo idénticos; un proyecto activo; ninguna dependencia 3D |
| Exportación Web, sin hilos | Generada correctamente con las plantillas 4.7.2 |

Los conteos difieren porque la ejecución GPU incluye comprobaciones de escritura de capturas. La última versión excluye del cotejo de límites los indicadores ocultos en vertical; en ese formato se usa una lista desplazable. No sumar las cifras como si fuesen casos independientes.

Las pruebas cubren: IDs/destinos y condiciones, cuatro zonas/doce vistas registradas, partida nueva, bloqueo previo al contrato, menú/opciones/créditos/continuar, intro saltable, deck, mensaje, aceptación, cocina/baño, documentos y paginación, terminal y registro, conversación/elección/flags, ruta a La Fiebre, persistencia de cada campo y rechazo de formatos inválidos, recuperación de `.bak`, rechazo de zona futura y limpieza de nueva partida. Se prueban READY_TO_COMPLETE y COMPLETED con efectos sintéticos de futuros hitos, sin atribuir esos contenidos al juego actual.

Entrada: eventos `InputEventMouseButton` y `InputEventScreenTouch` entregados al viewport. Se pulsa también la opción de diálogo mediante su botón. No son pruebas con un dedo físico.

Resoluciones nativas capturadas: 1280×720, 844×390, 1024×768 y 390×844. Ilustración completa, controles dentro del encuadre; diálogo desplazable. Horizontal es la composición recomendada. Vertical usa retratos menores y una lista de acciones para mantener legibilidad y acceso.

[Log headless](evidence/pruebas_headless.log) · [Log GPU](evidence/pruebas_nativas.log) · [Integridad](evidence/preservacion.log).

## Navegador

Helium/Chromium, WebGL 2, servidor HTTP local. Comprobados visualmente menú, introducción, dormitorio, deck/mensaje, contrato disponible/aceptado y cambio a cocina. Recargar la página habilita Continuar y restaura la cocina con el contrato activo.

Se ajusta el viewport a 844×390. Un `TouchEvent` de inicio/fin enviado al canvas sobre Deck abre su interfaz. Es una comprobación del recorrido táctil del navegador de escritorio, no una certificación de Safari ni de un teléfono real.

Consola sin errores de ejecución registrados. Se corrigieron símbolos ausentes de la fuente Web usando indicadores con caracteres disponibles. Los cambios finales de etiquetas acortan la salida de la cocina para evitar el solape con «Baño».

[Consola](evidence/web_consola.log) · [Errores](evidence/web_errores.log) · [Antes de recargar](evidence/web_cocina_antes_recarga.png) · [Después](evidence/web_cocina_tras_recarga.png) · [Toque sobre Deck](evidence/web_toque_deck.png).

La persistencia observada es entre recargas del mismo origen y perfil. Borrar almacenamiento, modo privado, restricciones del navegador o cambiar de host/puerto pueden impedir recuperar la partida. No se ha probado persistencia prolongada, cuotas agotadas ni cierres abruptos del dispositivo.

## Evidencia visual real

- [Menú](evidence/01_menu.png), [introducción](evidence/02_introduccion.png), [dormitorio](evidence/03_dormitorio.png).
- [Contrato](evidence/04_contrato.png), [cocina](evidence/05_cocina.png), [documento](evidence/06_documento.png), [terminal](evidence/07_terminal.png).
- [Baño](evidence/08_bano.png), [Sota sola](evidence/09_monologo.png), [La Fiebre](evidence/10_fiebre.png), [diálogo](evidence/11_dialogo.png).
- [Horizontal móvil](evidence/dialogo_844x390.png), [vertical](evidence/viewport_390x844.png).

Son capturas del juego ejecutándose, no maquetas. Los PNG fuente de fondos no se utilizan como prueba de interfaz. Se revisaron composición, retratos, etiquetas, desplazamiento y transiciones. Se corrigieron botones superpuestos, referencias a pantallas liberadas al redimensionar y opciones de diálogo recortadas en vertical.

## Límites pendientes

No se han probado Windows/Linux, Safari/iOS, Android ni teléfonos físicos. No hay aventura de 30 minutos completa, desenlace, sonido final, capas ambientales animadas ni arte aprobado para estos escenarios. Los fondos son candidatos aplanados. La ventana y la continuidad de las habitaciones requieren revisión artística. La Jefa aparece en el retrato de conversación; falta su figura ambiental. No se declara ninguna aprobación del autor sobre esta entrega.
