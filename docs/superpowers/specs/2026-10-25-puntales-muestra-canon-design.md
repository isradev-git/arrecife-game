# Muestra visual de Los Puntales · diseño

## Intención

El autor eligió producir una muestra de Los Puntales y avanzar después cota por cota. La primera muestra será la vista `puntales_acceso`, el punto de llegada desde El Nudo. Debe permitir reconocer la cota 2 en segundos y comprobar si su lenguaje ilustrado convive con los retratos originales de Sota y la Jefa. Las diferencias actuales están documentadas en [la auditoría visual](../../AUDITORIA_VISUAL_COTAS_2026-10-25.md).

## Enfoques considerados

- Retocar color y añadir detalles sobre el PNG actual: conserva composición, pero mantiene el vestíbulo industrial genérico y la repetición visual con El Nudo.
- Rehacer los 18 fondos en un lote: puede dar continuidad global, pero obliga a revisar demasiado arte antes de fijar una dirección.
- **Elegido por el autor:** rehacer una vista pública de Los Puntales, revisarla y continuar por las demás vistas de esa cota; después El Nudo y La Fiebre. El candidato será una versión nueva, sin sustituir todavía el fondo activo.

## La muestra

Imagen 2D horizontal, cámara fija en primera persona a la altura de Sota, sin avatar ni manos. Se llega a una zona de paso **habitada** bajo obras de estructura: vigas, cartelas, tirantes y refuerzos añadidos entre moles, con viviendas y comercios pequeños visibles detrás de la intervención. Hay cuadrillas adultas trabajando y gente que circula o espera, en varias profundidades. Las marcas de inspección, números de cuadrilla y cierres de obra sitúan el oficio sin convertir la escena en un cartel informativo. No se añade un personaje conversable ni una prueba del contrato.

La composición conserva tres destinos reconocibles y despejados para los hotspots actuales: **retorno a El Nudo a la izquierda**, **taller en una apertura central** y **camino al puesto de verificación a la derecha**. Un elemento de inspección legible en el centro permite «Observar el lugar». El candidato puede cambiar el encuadre y la arquitectura; no necesita imitar el PNG anterior. La conexión exacta entre imágenes se afinará al continuar con `nudo_paso_inferior` y las otras cinco vistas de Puntales.

Material y luz de D225: hormigón gris claro con polvo de corte, acero oscuro, imprimación rojo óxido, lonas y cabinas azul industrial, señales blancas de medición. El naranja de soldadura es local, no una retícula repetida de lámparas ámbar. El cielo **artificial** se entrevé entre estructura y edificios; no hay sol directo en la Penumbra. Humedad y reparación son posibles, pero se evita el suelo uniformemente brillante de los fondos actuales. Contorno oscuro firme, sombras amplias y detalle selectivo para dialogar con los retratos; no acabado fotográfico, pixel ni 3D.

**Precisión posterior del autor, 25 oct:** la luz más sombría de la v2 marca el enfoque. La coincidencia artística con los retratos es requisito principal: contorno firme, masas planas, sombras angulares y detalle selectivo también en entornos. La v3 explora esta corrección sin sustituir ni aprobar automáticamente las anteriores.

## Entregable y límites

Crear un PNG candidato versionado en `art/iterations/zonas_puntales/` y registrar el prompt y las referencias en `art/prompts/`. Conservar `puntales_acceso.png`, los retratos, las variantes previas y todos sus prompts. Mostrar el candidato junto al fondo actual y al retrato de Sota para valoración del autor. **La muestra no cambia todavía `world.json`, el mapa de 21 vistas, misiones, texto, partidas ni el canon.** La cota visual resultante no se extiende automáticamente a otras vistas sin esa valoración.

## Comprobación de la muestra

Inspeccionar el archivo final a tamaño original y en encuadres equivalentes a 1280×720 y 844×390; comprobar que los tres destinos siguen claros y que la población no tapa los pasos. Verificar archivo, dimensiones, prompt guardado y ausencia de cambios en el PNG activo y los originales. La integración posterior requerirá recolocar hotspots sobre el arte elegido, probar render y navegación en Godot y ejecutar las pruebas del README.

**Aprobación:** el autor aprobó este diseño el 25 oct 2026 y autorizó generar la muestra. La aprobación artística del PNG resultante sigue pendiente antes de integrarlo.
