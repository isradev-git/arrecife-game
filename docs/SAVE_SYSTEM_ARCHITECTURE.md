# Protección del progreso · base técnica 0.2.1

Estado de trabajo del 23 de octubre de 2026. Sólo el guardado **local** funciona en el juego. `save_sync.gd` es un modelo probado con un repositorio simulado; no hay cuentas, servidor ni copia remota real. Este documento describe lo implementado y las condiciones de integración.

## Formato local y compatibilidad

`State.data` sigue en `VERSION = 1`. Es JSON en `user://partida.json`, hasta 1 MiB. Sus campos son:

| Campo | Contenido |
| --- | --- |
| `version` | Versión del esquema; actualmente 1. |
| `screen`, `zone` | Vista y zona actuales; deben existir y corresponderse. |
| `missions` | ID estable de contrato → `LOCKED`, `AVAILABLE`, `ACTIVE`, `READY_TO_COMPLETE` o `COMPLETED`. |
| `flags` | Hechos booleanos de la historia. |
| `discoveries`, `documents`, `messages`, `unlocked` | IDs estables ya descubiertos, leídos o accesibles. |
| `choices` | Clave estable de diálogo o mensaje → respuesta seleccionada. |

El contenido actual se identifica por los JSON de `game/data/`. La versión de contenido no está serializada: añadir una misión al catálogo no cambia por sí solo el esquema. `migrate_save()` copia la partida v1 y añade contratos nuevos como `LOCKED`, sin reiniciar contratos anteriores, ubicación, documentos, mensajes o elecciones. Una segunda aplicación no cambia el resultado. Los ID existentes de contenido deben mantenerse; retirar o renombrar uno exige una migración explícita **antes** de cargar. Un valor de esquema futuro o una referencia desconocida se rechaza y el archivo permanece intacto. La próxima versión de esquema sólo debe añadirse cuando cambie la estructura: una función `v1 → v2`, fixture previo/posterior y prueba de idempotencia o carga repetible. Un cliente antiguo no puede escribir sobre un archivo primario o backup incompatible.

## Operación local

Cada acción lógica de juego se escribe una vez. `State.apply()` agrupa efectos, elección y lectura de documento; aceptar contrato y navegar también restauran la memoria si falla el guardado. `new_game()` conserva una copia `.previa-*` de la partida válida antes de reemplazarla. `import_save()` valida el JSON, crea copia de la partida anterior y sólo confirma tras una escritura válida. `export_save()` entrega el JSON de un archivo local verificado, no una mutación de memoria todavía sin guardar. Estos dos métodos están probados como API; **todavía no tienen botones de descarga/subida para el jugador**.

`save_game()` escribe `.tmp`, comprueba escritura y lectura, mueve el primario a `.bak` y promueve el temporal. `load_game()` intenta primario, backup y temporal válido, en ese orden. Si `.tmp` es la **única copia válida**, se copia a `.bak` antes de abrirlo para la siguiente escritura; reiniciar o importar también la archiva. Un temporal ilegible no bloquea un primario válido, pero uno de versión futura sí queda protegido. La copia anterior no se limpia automáticamente. La UI sólo anuncia éxito al confirmar la operación; ante fallo presenta el error. El menú indica que una partida invitada está sólo en este dispositivo. Una caída de alimentación, un fallo de disco o una cuota de navegador pueden exceder las garantías de esta estrategia; falta la matriz real de Web y dispositivos.

## Límite local/nube

1. **GameState:** `State.data`, reglas de misiones, efectos, IDs y validación.
2. **LocalSaveRepository:** hoy son los métodos de `State` para `user://`; extraerlos cuando exista un segundo consumidor real, sin cambiar el formato v1.
3. **SaveMigrationService:** hoy `State.migrate_save()`; la cadena de versiones futuras se separará cuando haya una v2 real.
4. **CloudSaveRepository:** pendiente. Su contrato mínimo es `read(user_id, slot)` y `write(user_id, slot, snapshot, expected_revision)` con respuesta autoritativa. **El servidor** debe asociar `user_id` a la sesión autenticada, comprobar permisos y hacer el cambio de revisión de forma atómica. El identificador enviado por el cliente no prueba propiedad.
5. **AuthenticationService:** pendiente. Debe devolver una identidad confirmada, administrar sesión y renovación, y no registrar tokens. No se ha añadido un login ficticio.
6. **SaveSyncService:** `save_sync.gd` modela estados `local`, `pending`, `cloud`, `failed`, `conflict`. Mantiene la partida pendiente al quedarse offline o detectar conflicto. Sólo marca `cloud` después de comprobar la respuesta del repositorio y rechaza cambiar de identidad en la misma instancia; el futuro flujo de cierre de sesión tendrá que aislar la partida local de cada cuenta. **Aún no se conecta al juego ni persiste su cola/revisión entre sesiones**.

El flujo previsto es guardar localmente, encolar un snapshot validado y sincronizar cuando exista sesión. Una cuenta sin snapshot puede recibir la partida invitada. Si la cuenta ya tiene otra historia, se detiene y se conservan ambas; no se fusiona ni se elige automáticamente. Al recuperar en otro equipo, validar y migrar el snapshot remoto, respaldar la partida local y sólo entonces reemplazarla. Las revisiones deben impedir que dos pestañas o equipos sobrescriban en silencio. El historial remoto debe conservar al menos la revisión anterior recuperable; aún no existe.

## Candidato remoto, sin compromiso de producción

La opción más pequeña para la prueba vertical es **Supabase Auth + Postgres con RLS**, sirviendo Godot como archivos estáticos. [Godot `HTTPRequest`](https://docs.godotengine.org/en/stable/classes/class_httprequest.html) permite hablar por HTTPS con REST desde GDScript. Un puente [JavaScriptBridge](https://docs.godotengine.org/en/stable/tutorials/platform/web/javascript_bridge.html) pequeño puede ocuparse sólo de sesión/callback si el flujo de correo lo requiere; la lógica de juego no debe depender del SDK. Los enlaces o códigos por correo y [PKCE](https://supabase.com/docs/guides/auth/sessions/pkce-flow) son candidatos. El callback debe estar en una [URL permitida](https://supabase.com/docs/guides/auth/redirect-urls) de la subruta definitiva. Un código PKCE se intercambia en el navegador/dispositivo que inició el flujo; no debe suponerse que abrirlo en otro lo completará.

El cliente Web estaría sujeto a CORS de la API remota. La clave publicable puede distribuirse; una clave administrativa o `service_role`, nunca. [RLS](https://supabase.com/docs/guides/database/postgres/row-level-security) y los permisos SQL deben limitar `SELECT`, `INSERT`, `UPDATE` y, si existe, `DELETE` al usuario autenticado. Una actualización condicionada por revisión debe ejecutarse de forma atómica en el servidor; comprobar y luego escribir desde Godot no basta. Se necesitan pruebas reales con dos identidades, token expirado, concurrencia, historial y restauración. También hay que decidir región, retención, correo transaccional, costes y privacidad antes de contratar/configurar. No hay credenciales ni SQL de producción en este repositorio.

## Web y alojamiento

Destino editorial confirmado: `https://universo.israelzamora.es/`. El juego irá bajo una subruta **aún sin slug aprobado**. Se confirmó localmente que Godot 4.7.2 exporta `index.html`, `.js`, `.pck`, `.wasm`, `.png` y dos worklets JS con referencias relativas; el preset excluye `build/` y `tests/` del paquete. Un ensayo en `/ensayo/` sirvió los cinco archivos principales por HTTP con códigos 200 y tipos HTML, JavaScript, `application/octet-stream`, `application/wasm` e imagen PNG. Eso no prueba ejecución en navegador ni configuración de Ginernet.

El despliegue previsto es exportar localmente a una carpeta limpia y subir **su contenido** por FTP al subdirectorio aprobado. En producción exigir HTTPS, rutas y MIME correctos (`.wasm`: `application/wasm`; `.js`: JavaScript; `.pck`: binario), y una política de caché que evite mezclar `index.html`, JS, WASM y PCK de distintas versiones. Hay que comprobar en cPanel qué cabeceras puede configurarse y probar carga completa, audio, toque y recarga con la ruta final. `user://` Web pertenece al origen del navegador: cambiar dominio, subdominio o protocolo puede dejar el progreso local en otro almacenamiento. La subruta por sí sola no garantiza persistencia si cambia el origen o se borran datos. Los callbacks de autenticación y CORS requieren el dominio real, todavía no configurado. La exportación final de esta tanda se comprobó por HTTP local en `/ensayo-021/`, sin ejecutar el juego en navegador.
