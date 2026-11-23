# Estado del proyecto - Cafe Andino

## Resumen del proyecto
Implementacion del entorno, carga de datos de tiendas fisicas y tienda online, y consultas analiticas en Snowflake con apoyo del equipo de agentes.

## Checklist de tareas

### Fase 1: Equipo de agentes y contexto
- [x] Estructura de directorios creada (contexto/, agentes/, datos/, scripts/, resultados/, docs/).
- [x] Reglas generales definidas en AGENTS.md.
- [x] Contexto de negocio documentado en contexto/negocio.md.
- [x] Glosario tecnico documentado en contexto/glosario.md.
- [x] Archivos de entrada creados en datos/ con formato y datos exactos del PDF.
- [x] Permisos de solo lectura aplicados a datos/ y prueba documentada en resultados/prueba_solo_lectura.md.
- [x] Prueba de limites de instrucciones documentada en docs/prueba_instrucciones.md.
- [x] Mapeo de tareas por esfuerzo, impacto y asignacion en docs/mapeo_tareas.md.
- [x] Fichas de los 3 agentes creadas en agentes/.

### Fase 2: Scripts de Snowflake
- [x] 01_entorno.sql: Warehouse XSMALL, BD, esquema y rol CAFE_LECTOR.
- [x] 02_ventas_csv.sql: Tabla VENTAS, FILE FORMAT CSV, stage, validacion, COPY INTO con ON_ERROR=CONTINUE.
- [x] 03_pedidos_json.sql: Tabla PEDIDOS_RAW (VARIANT), stage, COPY INTO con metadata, vista PEDIDOS_DETALLE.
- [x] 04_snowpipe.sql: Stage PEDIDOS_PIPE_STAGE, PIPE con AUTO_INGEST=FALSE, ALTER PIPE REFRESH, verificacion.
- [x] 05_consultas.sql: Consulta de ventas netas por tienda y producto mas pedido online por ciudad.

### Fase 3: Trabajo de los agentes y entrega
- [x] Revision de scripts por el agente SQL (resultados/revision_sql.md).
- [x] Documentacion tecnica de tablas y vistas por el agente documentador (docs/tablas.md).
- [x] Resumen analitico por el agente de reportes con calculos manuales y marca de pendientes (resultados/resumen_resultados.md).
- [x] README.md en la raiz con proposito, estructura y pasos de ejecucion.
