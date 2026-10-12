# Sota · Base sin neón fijo

**Preferencia posterior · 12 de octubre:** el autor compara en navegador y prefiere v7 (Referencia aprobada), ahora predeterminada. Esta variante se conserva para comparación; no adquiere la aprobación de v7. [Registro](../../../revisiones/preferencia_sota_v1/README.md).

11 de octubre de 2026. T03 adelantada: el autor autoriza continuar tras aprobar el estilo de Sota v7 y que el contraluz coincida con la luz del entorno. Se prepara una variante de ambos perfiles sin el neón rosa/naranja pintado, conservando la referencia aprobada.

**Entrega del asistente, pendiente de valoración del autor.** Edición con imagegen integrado; no se retoca el PNG por código.

- [Base transparente](../../../../../godot/assets/personajes/sota/perfiles_base_v1.png), 1536 × 1024.
- [Prompt completo](../prompt_base_v1.txt), con v7 como único objetivo de edición.
- [Regiones y apoyos](../../../../../godot/assets/personajes/sota/perfiles_base_v1.json): dos perfiles propios, alturas 871/866 y bases locales y = 946 al umbral alfa 0,1.
- [Comparación en Velvet e iluminación separada](../../../revisiones/luz_v2/README.md).

El asistente observa pelo, chaqueta, parche derecho, pantalón, botas, correa y lado físico del deck conservados; ojos como pequeñas marcas oscuras, sin iris ni blancos. No hay frontal ni tres cuartos. La generación introduce pequeñas variaciones de silueta y color; la nueva imagen no es idéntica píxel a píxel a v7 ni hereda automáticamente su aprobación estética.

El neón de escenario se añade ahora mediante una máscara del contorno calculada con el alfa en Godot. No depende de seleccionar colores rosas/naranjas de la imagen. Color, intensidad y dirección son parámetros separados; intensidad cero devuelve exactamente esta base. No se entrega una máscara artística interior ni un sistema de sombras/oclusiones de escena.

Importación y transparencia correctas; regiones, altura, apoyo y filtros comprobados. Render nativo de la máscara: alfa invariante, muestras interiores conservadas, cambios de dirección en ambos perfiles y retorno exacto a la base. Exportación Web correcta. Retícula de producción, valoración del autor, luces vinculadas al escenario, visual Web y animaciones pendientes.

Original generado: `/Users/glitchbane/.codex/generated_images/01a12073-55ef-7ed1-8a16-ad74d5324000/exec-989ad807-df6c-4e0a-86d8-b1cad9e72b82.png`. Copia sin edición en el proyecto. [V7 y prompts anteriores](../pixel_v3/README.md) conservados.
