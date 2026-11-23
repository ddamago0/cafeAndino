# Mapeo de tareas del ejercicio de Snowflake

Este documento clasifica las tareas requeridas para el proyecto Café Andino según su nivel de esfuerzo, impacto en el negocio y la entidad responsable de su ejecución.

| Id | Tarea | Esfuerzo | Impacto | Responsable | Justificación |
|---|---|---|---|---|---|
| T01 | Diseño de 01_entorno.sql (warehouse XSMALL, base de datos, esquema, roles SYSADMIN y CAFE_LECTOR) | Bajo | Alto | Agente con revisión humana | Define los recursos de cómputo, seguridad y aislamiento del proyecto. |
| T02 | Ejecución de 01_entorno.sql en Snowflake | Bajo | Alto | Persona | Regla de proyecto: el agente no tiene conexión directa a Snowflake. |
| T03 | Diseño de 02_objetos.sql (tablas VENTAS y PEDIDOS_RAW, formatos CSV/JSON y los tres stages) | Bajo | Alto | Agente | Centraliza la infraestructura base previa a la subida de archivos físicos. |
| T04 | Ejecución de 02_objetos.sql en Snowflake | Bajo | Alto | Persona | Crea los stages requeridos para la recepción de archivos. |
| T05 | Subida de ventas_1.csv a VENTAS_STAGE y pedidos_1.json a PEDIDOS_STAGE | Bajo | Alto | Persona | Transferencia inicial de datos mediante Snowsight o SnowSQL. |
| T06 | Diseño de 03_ventas_csv.sql (validación, carga con ON_ERROR=CONTINUE y tabla VENTAS_RECHAZADAS) | Medio | Alto | Agente con revisión humana | Garantiza la ingesta de las 9 filas válidas y aisla el error de la fila 7 con VALIDATE. |
| T07 | Ejecución de 03_ventas_csv.sql y verificación en Snowflake | Bajo | Alto | Persona (ejecución) / Agente (análisis) | Confirma 9 filas en VENTAS, 1 fila en VENTAS_RECHAZADAS y auditoría en COPY_HISTORY. |
| T08 | Diseño de 04_pedidos_json.sql (carga de pedidos_1.json con metadatos y vista PEDIDOS_DETALLE) | Medio | Alto | Agente con revisión humana | Ingesta semiestructurada con trazabilidad y aplanamiento relacional mediante LATERAL FLATTEN. |
| T09 | Ejecución de 04_pedidos_json.sql en Snowflake | Bajo | Alto | Persona (ejecución) / Agente (análisis) | Confirma 3 pedidos en PEDIDOS_RAW y 5 filas en PEDIDOS_DETALLE. |
| T10 | Subida de pedidos_2.json al stage PEDIDOS_PIPE_STAGE | Bajo | Medio | Persona | Carga manual exclusiva del segundo archivo para evitar duplicados. |
| T11 | Diseño de 05_snowpipe.sql (CREATE PIPE IF NOT EXISTS, ALTER PIPE REFRESH y monitoreo) | Medio | Alto | Agente con revisión humana | Ingesta idempotente que no pierde historial ni duplica datos al reejecutarse. |
| T12 | Ejecución de 05_snowpipe.sql y verificación de estado | Bajo | Alto | Persona (ejecución) / Agente (análisis) | Confirma estado RUNNING, total de 5 pedidos en PEDIDOS_RAW y 8 filas en PEDIDOS_DETALLE. |
| T13 | Diseño de 06_consultas.sql (ventas netas y producto líder online) | Bajo | Alto | Agente | Consultas analíticas básicas utilizando GROUP BY, SUM y ROW_NUMBER. |
| T14 | Ejecución de 06_consultas.sql en Snowflake | Bajo | Alto | Persona | Extracción de los resultados reales para evaluación gerencial. |
| T15 | Diseño de 07_prueba_lector.sql (comprobación de rol CAFE_LECTOR) | Bajo | Medio | Agente | Sentencias de validación con SELECT permitidos e INSERT bloqueado por permisos. |
| T16 | Ejecución de 07_prueba_lector.sql en Snowflake | Bajo | Medio | Persona | Comprobación empírica de la seguridad de solo lectura en la nube. |
| T17 | Revisión de resultados y resumen gerencial (resumen_resultados.md y lista_verificacion.md) | Medio | Alto | Agente con revisión humana | Contraste de salidas reales con cálculos de control y advertencia sobre fila rechazada. |
