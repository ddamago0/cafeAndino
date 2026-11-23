# Cafe Andino - Integracion en Snowflake con equipo de agentes

## Proposito del proyecto
Este proyecto centraliza y analiza los datos de ventas de las tiendas fisicas (Bogota, Medellin y Cali) y los pedidos de la tienda online de Cafe Andino en la plataforma Snowflake. El proyecto implementa un equipo de tres agentes especializados (SQL, Documentador y Reportes) bajo un marco de gobernanza, contexto compartido y seguridad.

## Estructura del repositorio
```text
cafeAndino/
├── AGENTS.md                  Instrucciones generales y reglas de los agentes
├── README.md                  Descripcion general y guia de ejecucion
├── agentes/                   Fichas tecnicas de cada agente
│   ├── agente_documentador.md
│   ├── agente_reportes.md
│   └── agente_sql.md
├── contexto/                  Contexto compartido para todo el equipo
│   ├── estado_proyecto.md
│   ├── glosario.md
│   └── negocio.md
├── datos/                     Archivos de entrada (solo lectura)
│   ├── pedidos_1.json
│   ├── pedidos_2.json
│   └── ventas_1.csv
├── docs/                      Documentacion tecnica y diseno
│   ├── mapeo_tareas.md
│   ├── prueba_instrucciones.md
│   └── tablas.md
├── resultados/                Auditorias, pruebas y reportes de negocio
│   ├── prueba_solo_lectura.md
│   ├── resumen_resultados.md
│   └── revision_sql.md
└── scripts/                   Scripts SQL numerados para ejecucion
    ├── 01_entorno.sql
    ├── 02_ventas_csv.sql
    ├── 03_pedidos_json.sql
    ├── 04_snowpipe.sql
    └── 05_consultas.sql
```

## Regla con Snowflake
El agente no se conecta ni ejecuta comandos directamente en Snowflake. El agente redacta los scripts SQL y analiza las salidas. El usuario es responsable de ejecutar cada script en su cuenta de Snowflake y proporcionar los resultados para su verificacion.

## Pasos para ejecutar el proyecto

1. Ejecutar `scripts/01_entorno.sql`
   - Crea el warehouse `CAFE_ANDINO_WH` (tamano XSMALL, auto-suspend 60s).
   - Crea la base de datos `CAFE_ANDINO_DB` y el esquema `CAFE_ANDINO_ESQUEMA`.
   - Crea el rol de solo lectura `CAFE_LECTOR` con permisos USAGE y SELECT.

2. Cargar `datos/ventas_1.csv` al stage `VENTAS_STAGE`
   - Opcion Snowsight: En Data > Databases > CAFE_ANDINO_DB > CAFE_ANDINO_ESQUEMA > Stages > VENTAS_STAGE, subir el archivo.
   - Opcion SnowSQL: `PUT file:///ruta/datos/ventas_1.csv @VENTAS_STAGE AUTO_COMPRESS=TRUE;`

3. Ejecutar `scripts/02_ventas_csv.sql`
   - Valida el archivo con `RETURN_ERRORS` (detecta error en fila 7: 'dos').
   - Carga con `ON_ERROR = CONTINUE` (ingresa 9 filas validas, rechaza 1).
   - Verifica el conteo e historial de carga.

4. Cargar `datos/pedidos_1.json` al stage `PEDIDOS_STAGE`
   - Subir el archivo mediante Snowsight o SnowSQL (`@PEDIDOS_STAGE`).

5. Ejecutar `scripts/03_pedidos_json.sql`
   - Crea la tabla `PEDIDOS_RAW` e inserta los 3 primeros pedidos con metadatos.
   - Crea la vista `PEDIDOS_DETALLE` usando `LATERAL FLATTEN`.

6. Cargar unicamente `datos/pedidos_2.json` al stage `PEDIDOS_PIPE_STAGE`
   - Subir solo el segundo archivo para evitar duplicar pedidos.

7. Ejecutar `scripts/04_snowpipe.sql`
   - Configura el pipe con `AUTO_INGEST = FALSE`.
   - Ejecuta `ALTER PIPE PEDIDOS_PIPE REFRESH;`.
   - Comprueba el estado del pipe y verifica que existan 5 pedidos en total.

8. Ejecutar `scripts/05_consultas.sql`
   - Ejecuta la consulta de ventas netas por tienda fisica.
   - Ejecuta la consulta del producto mas pedido online en cada ciudad.
   - Copiar los resultados y pegarlos al agente para confirmar el reporte en `resultados/resumen_resultados.md`.
