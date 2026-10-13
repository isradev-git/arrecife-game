# T05.1 · Primer medio paso desde la Sota oscura

13 de octubre de 2026. El autor autoriza continuar después de la corrección de contacto; no se registra como aprobación artística de esa pose. Se añaden apoyo, cruce e impulso de perfil derecho, editados con **imagegen integrado** desde v7 y el contacto corregido. [PNG originales y prompts exactos](../../personajes/sota/caminar_v2/README.md). Versiones anteriores intactas.

| Captura | Contenido |
| --- | --- |
| [Comparación ampliada 2×](comparacion_2x.png) | V7 original real, contacto, apoyo, cruce e impulso; misma escala y shader, fondo neutro para revisar sombras y dibujo. |
| [Comparación en Velvet](comparacion_velvet.png) | Las cinco figuras a escala del juego, pies y = 705, barandilla trasera detrás y delantera delante. |

Capturas nativas GPU Godot Compatibility / Apple M4, 1672 × 941. Se usa CUTOUT original y nearest en todas las figuras, sin filtros de brillo ni retoque de PNG por código. Solo se muestra la mitad derecha de cada hoja nueva; el reposo reconstruido de su mitad izquierda nunca sustituye al original aprobado.

Una escala común **252/871**, también en las poses nuevas. [Medidas reproducibles](medidas.json):

| Figura | Altura fuente | Altura resultante | Media de RGB ponderado |
| --- | --- | --- | --- |
| Reposo v7 | 871 | 252 | 0,152 |
| Contacto | 854 | 247,1 | 0,144 |
| Apoyo | 841 | 243,3 | 0,146 |
| Cruce | 865 | 250,3 | 0,155 |
| Impulso | 878 | 254,0 | 0,157 |

La media pondera RGB sRGB codificado sobre alfa ≥ 0,95; no es una medición fotométrica. Todas las poses quedan aproximadamente entre −5 % y +4 % respecto al original. Diferencias de forma, cantidad de piel y ropa afectan este promedio: no demuestra igualdad de paleta, anatomía ni aprobación. No se reescala cada pose para igualar alturas; el apoyo baja y el impulso sube.

**Comprobado:** dimensiones/alfa/márgenes de las cuatro hojas, altura fuente y rango tonal, generación de ambas capturas sin errores; revisión visual del asistente frente al v7 real. La propuesta conserva mejor la oscuridad y presenta fases distintas. Aún hay variaciones generativas de dibujo y proporciones que deben revisarse al montar el ciclo.

Reproducción desde la raíz del repositorio:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/poses_oscuras.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/poses_oscuras.gd -- --capturas
```

La prueba reutiliza la medición y captura de `tests/identidad_marcha.gd`; requiere los archivos externos de `trabajo/`. Está excluida de la exportación Web. El encuadre horizontal usa el centro del contorno para esta lámina estática; **no es el pivote definitivo de locomoción** ni prueba de pie plantado durante un desplazamiento.

**Pendiente:** valorar esta serie, cerrar identidad/proporciones, dibujar el paso de la pierna contraria y el perfil izquierdo propio; fijar celdas/pivotes, sincronizar apoyos y probar el bucle. Después, intermedios T05.2. No se integra esta serie en el recorrido ni se ha probado animada o en navegador; el juego conserva v7. T05 sigue en curso.
