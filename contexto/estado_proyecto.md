# Estado del proyecto - Café Andino

## Resumen del proyecto
Implementación del entorno, objetos base, carga de datos de tiendas físicas y tienda online, y consultas analíticas en Snowflake con apoyo del equipo de agentes.

## Checklist de tareas

### Fase 1: Equipo de agentes y contexto
- [x] Estructura de directorios creada (contexto/, agentes/, datos/, scripts/, resultados/, docs/).
- [x] Reglas generales y límites definidos en AGENTS.md.
- [x] Contexto de negocio documentado en contexto/negocio.md.
- [x] Glosario técnico documentado en contexto/glosario.md.
- [x] Archivos de entrada creados en datos/ con formato y datos exactos del PDF.
- [x] Permisos de solo lectura aplicados a datos/ y prueba local documentada en resultados/prueba_solo_lectura.md.
- [x] Prueba de límites de instrucciones documentada en docs/prueba_instrucciones.md.
- [x] Mapeo de tareas por esfuerzo, impacto y asignación en docs/mapeo_tareas.md.
- [x] Fichas de los 3 agentes creadas en agentes/.

### Fase 2: Scripts SQL organizados
- [x] 01_entorno.sql: Warehouse XSMALL, base de datos, esquema y roles (SYSADMIN / CAFE_LECTOR).
- [x] 02_objetos.sql: Tablas VENTAS y PEDIDOS_RAW, formatos CSV_FORMAT y JSON_FORMAT, y stages internos.
- [x] 03_ventas_csv.sql: Validación, carga con ON_ERROR=CONTINUE, creación de VENTAS_RECHAZADAS y COPY_HISTORY.
- [x] 04_pedidos_json.sql: Carga con metadatos de archivo/fecha, conteo y creación de vista PEDIDOS_DETALLE.
- [x] 05_snowpipe.sql: Creación idempotente de pipe (CREATE PIPE IF NOT EXISTS), refresco, conteo e historial.
- [x] 06_consultas.sql: Consulta de ventas netas por tienda y producto líder online por ciudad.
- [x] 07_prueba_lector.sql: Comprobación de permisos de solo lectura y bloqueo de escrituras.

### Fase 3: Ejecución y validación en Snowflake (a realizar por el usuario)
- [ ] Ejecución de 01_entorno.sql en Snowflake (Pendiente de ejecución por el usuario).
- [ ] Ejecución de 02_objetos.sql en Snowflake (Pendiente de ejecución por el usuario).
- [ ] Carga manual de ventas_1.csv a VENTAS_STAGE y pedidos_1.json a PEDIDOS_STAGE (Pendiente de ejecución por el usuario).
- [ ] Ejecución de 03_ventas_csv.sql y verificación de 9 filas válidas y 1 rechazada (Pendiente de confirmación por el usuario).
- [ ] Ejecución de 04_pedidos_json.sql y verificación de 3 pedidos y 5 ítems detalle (Pendiente de confirmación por el usuario).
- [ ] Carga de pedidos_2.json a PEDIDOS_PIPE_STAGE y ejecución de 05_snowpipe.sql (Pendiente de confirmación por el usuario).
- [ ] Ejecución de 06_consultas.sql y extracción de cifras reales de ventas y pedidos (Pendiente de confirmación por el usuario).
- [ ] Ejecución de 07_prueba_lector.sql y comprobación de error por permisos (Pendiente de confirmación por el usuario).

### Fase 4: Documentación y cierre
- [x] Documentación técnica de tablas en docs/tablas.md (incluyendo VENTAS_RECHAZADAS).
- [x] Revisión técnica de scripts en resultados/revision_sql.md.
- [x] Resumen para gerencia en resultados/resumen_resultados.md (cifras calculadas a mano, pendientes de confirmación).
- [x] Lista de verificación con valores exactos esperados en resultados/lista_verificacion.md.
- [x] README.md con guía paso a paso y tabla resumen de ejecución.
