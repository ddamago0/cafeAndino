# Mapeo de tareas del ejercicio de Snowflake

Este documento clasifica las tareas requeridas para el proyecto Cafe Andino segun su nivel de esfuerzo, impacto en el negocio y la entidad responsable de su ejecucion.

| Id | Tarea | Esfuerzo | Impacto | Responsable | Justificacion |
|---|---|---|---|---|---|
| T01 | Diseno del script de entorno (WH, BD, esquema, rol de solo lectura) | Bajo | Alto | Agente con revision humana | El script define la base de computo, aislamiento y seguridad; requiere aprobacion de parametros. |
| T02 | Ejecucion de 01_entorno.sql en Snowflake | Bajo | Alto | Persona | Regla de proyecto: el agente no tiene conexion a Snowflake. |
| T03 | Diseno de tabla VENTAS, formato CSV y stage interno | Bajo | Medio | Agente | Sintaxis estandar DDL segun definicion del CSV. |
| T04 | Subida de ventas_1.csv al stage VENTAS_STAGE (Snowsight/PUT) | Bajo | Alto | Persona | Accion manual requerida en el cliente local o consola web de Snowflake. |
| T05 | Diseno de consulta de validacion previa (RETURN_ERRORS) | Bajo | Alto | Agente | Sintaxis SQL para identificar anticipadamente inconsistencias en los datos. |
| T06 | Decision sobre manejo de filas invalidas (fila 7 con 'dos') | Medio | Alto | Agente con revision humana | Requiere evaluar impacto de negocio: se define ON_ERROR = CONTINUE para no frenar la operacion. |
| T07 | Diseno y ejecucion de COPY INTO para VENTAS | Bajo | Alto | Agente (script) / Persona (ejecucion) | El agente redacta la sentencia y el usuario la ejecuta en su cuenta. |
| T08 | Verificacion de carga de VENTAS (filas cargadas y rechazadas) | Bajo | Medio | Agente con revision humana | El usuario pega el conteo e historial; el agente valida concordancia (9 cargadas, 1 rechazada). |
| T09 | Diseno de tabla PEDIDOS_RAW, formato JSON y stage interno | Bajo | Medio | Agente | DDL para datos semiestructurados con metadatos. |
| T10 | Subida de pedidos_1.json al stage PEDIDOS_STAGE | Bajo | Medio | Persona | Transferencia manual de archivo al almacenamiento interno de Snowflake. |
| T11 | Diseno y ejecucion de COPY INTO para PEDIDOS_RAW | Bajo | Alto | Agente (script) / Persona (ejecucion) | Ingesta de semiestructurado con METADATA$FILENAME y CURRENT_TIMESTAMP(). |
| T12 | Diseno de vista relacional PEDIDOS_DETALLE con LATERAL FLATTEN | Medio | Alto | Agente con revision humana | Aplanamiento de arreglos JSON para facilitar consultas analiticas al negocio. |
| T13 | Diseno de stage nuevo y configuracion de Snowpipe (AUTO_INGEST=FALSE) | Medio | Alto | Agente con revision humana | Manejo de limitacion tecnica de stages internos que requieren REFRESH manual. |
| T14 | Subida de pedidos_2.json al stage PEDIDOS_PIPE_STAGE | Bajo | Medio | Persona | Accion manual de carga sin re-subir pedidos_1.json. |
| T15 | Refresco de pipe (ALTER PIPE REFRESH) y verificacion de estado | Bajo | Alto | Persona (ejecucion) / Agente (analisis) | Confirmacion de que el pipe proceso el lote sin duplicados (5 pedidos en total). |
| T16 | Redaccion de consulta de ventas netas por tienda | Bajo | Alto | Agente | Agregacion basica con SUM y GROUP BY ordenada descendente. |
| T17 | Redaccion de consulta de producto mas pedido por ciudad | Medio | Alto | Agente | Funcion analitica de ventana (ROW_NUMBER) particionada por ciudad. |
| T18 | Revision de resultados de consultas y resumen para gerencia | Medio | Alto | Agente con revision humana | Cotejo de calculos manuales contra salidas reales de Snowflake para emision del informe final. |
