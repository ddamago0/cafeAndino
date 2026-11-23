# Café Andino - Integración en Snowflake con equipo de agentes

## Propósito del proyecto
Este proyecto centraliza y analiza los datos de ventas de las tiendas físicas (Bogotá, Medellín y Cali) y los pedidos de la tienda online de Café Andino en la plataforma Snowflake. El proyecto implementa un equipo de tres agentes especializados (Ingeniería SQL, Documentación Técnica y Reportes) bajo un marco de gobernanza, contexto compartido, desacoplamiento de objetos y seguridad de solo lectura.

## Estructura del repositorio
```text
cafeAndino/
├── AGENTS.md                  Instrucciones generales y reglas de los agentes
├── README.md                  Descripción general y guía de ejecución
├── agentes/                   Fichas técnicas de cada agente
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
├── docs/                      Documentación técnica y diseño
│   ├── mapeo_tareas.md
│   ├── prueba_instrucciones.md
│   └── tablas.md
├── resultados/                Auditorías, pruebas y reportes de negocio
│   ├── lista_verificacion.md
│   ├── prueba_solo_lectura.md
│   ├── resumen_resultados.md
│   └── revision_sql.md
└── scripts/                   Scripts SQL numerados para ejecución
    ├── 01_entorno.sql
    ├── 02_objetos.sql
    ├── 03_ventas_csv.sql
    ├── 04_pedidos_json.sql
    ├── 05_snowpipe.sql
    ├── 06_consultas.sql
    └── 07_prueba_lector.sql
```

## Regla con Snowflake
El agente no se conecta ni ejecuta comandos directamente en Snowflake. El agente redacta los scripts SQL y analiza las salidas. El usuario es el único responsable de ejecutar cada script en su cuenta de Snowflake y proporcionar los resultados para su verificación y contraste.

## Flujo paso a paso de ejecución

1. **Ejecutar `scripts/01_entorno.sql`**
   - Configura el contexto base con `SYSADMIN`, crea el warehouse `CAFE_ANDINO_WH` (XSMALL, auto-suspend 60 s), la base de datos `CAFE_ANDINO_DB` y el esquema `CAFE_ANDINO_ESQUEMA`.
   - Con `ACCOUNTADMIN`, crea el rol `CAFE_LECTOR`, otorga sus privilegios de consulta y lo asigna a `SYSADMIN`.
   - Vuelve a `SYSADMIN`.

2. **Ejecutar `scripts/02_objetos.sql`**
   - Crea los formatos de archivo `CSV_FORMAT` y `JSON_FORMAT`.
   - Crea las tablas base `VENTAS` y `PEDIDOS_RAW`.
   - Crea los stages internos `VENTAS_STAGE`, `PEDIDOS_STAGE` y `PEDIDOS_PIPE_STAGE`.

3. **Subir los primeros archivos a sus stages**
   - Subir `datos/ventas_1.csv` al stage `VENTAS_STAGE`:
     - *Opción Snowsight:* En Data > Databases > CAFE_ANDINO_DB > CAFE_ANDINO_ESQUEMA > Stages > VENTAS_STAGE, presionar `+ Files`.
     - *Opción SnowSQL:* `PUT file:///ruta/datos/ventas_1.csv @VENTAS_STAGE AUTO_COMPRESS=TRUE;`
   - Subir `datos/pedidos_1.json` al stage `PEDIDOS_STAGE`:
     - *Opción Snowsight:* En Stages > PEDIDOS_STAGE, presionar `+ Files`.
     - *Opción SnowSQL:* `PUT file:///ruta/datos/pedidos_1.json @PEDIDOS_STAGE AUTO_COMPRESS=TRUE;`

4. **Ejecutar `scripts/03_ventas_csv.sql`**
   - Valida el stage y detecta el error en la fila 7 mediante `RETURN_ERRORS`.
   - Carga las filas válidas en `VENTAS` con `ON_ERROR = CONTINUE`.
   - Registra la fila inválida en la tabla `VENTAS_RECHAZADAS` mediante la función `VALIDATE`.
   - Consulta el conteo (9 filas) y audita con `COPY_HISTORY`.

5. **Ejecutar `scripts/04_pedidos_json.sql`**
   - Verifica el stage e inserta los 3 primeros pedidos en `PEDIDOS_RAW` con metadatos de archivo y fecha.
   - Crea la vista relacional `PEDIDOS_DETALLE` usando `LATERAL FLATTEN`.
   - Verifica 3 pedidos en la tabla cruda y 5 registros en la vista.

6. **Subir el segundo archivo de pedidos**
   - Subir **únicamente** `datos/pedidos_2.json` al stage `PEDIDOS_PIPE_STAGE`:
     - *Opción Snowsight:* En Stages > PEDIDOS_PIPE_STAGE, presionar `+ Files`.
     - *Opción SnowSQL:* `PUT file:///ruta/datos/pedidos_2.json @PEDIDOS_PIPE_STAGE AUTO_COMPRESS=TRUE;`

7. **Ejecutar `scripts/05_snowpipe.sql`**
   - Crea el pipe con `CREATE PIPE IF NOT EXISTS PEDIDOS_PIPE` (`AUTO_INGEST = FALSE`).
   - Ejecuta `ALTER PIPE PEDIDOS_PIPE REFRESH;`.
   - Consulta `SYSTEM$PIPE_STATUS` y verifica que `PEDIDOS_RAW` tenga 5 pedidos sin duplicados y `PEDIDOS_DETALLE` tenga 8 ítems.

8. **Ejecutar `scripts/06_consultas.sql`**
   - Consulta 1: Ventas netas por tienda física de mayor a menor.
   - Consulta 2: Producto más solicitado online por ciudad.
   - Copiar los resultados y contrastarlos con `resultados/resumen_resultados.md` y `resultados/lista_verificacion.md`.

9. **Ejecutar `scripts/07_prueba_lector.sql`**
   - Comprueba con el rol `CAFE_LECTOR` que las consultas `SELECT` se permiten y que la sentencia `INSERT` es bloqueada por permisos insuficientes.

---

## Tabla resumen de scripts y salidas esperadas

| Script | Qué hace | Qué debe ver el usuario |
|---|---|---|
| `01_entorno.sql` | Crea warehouse, base de datos, esquema y rol lector | Objetos creados y contexto activo en SYSADMIN |
| `02_objetos.sql` | Crea formatos CSV/JSON, tablas base y 3 stages | Stages listos para recibir archivos |
| `03_ventas_csv.sql` | Valida, carga filas válidas y aísla error en tabla de rechazadas | 9 filas en VENTAS, 1 fila en VENTAS_RECHAZADAS |
| `04_pedidos_json.sql` | Carga JSON inicial y crea vista relacional desanidada | 3 pedidos en PEDIDOS_RAW y 5 filas en PEDIDOS_DETALLE |
| `05_snowpipe.sql` | Configura canalización continua sin duplicados y refresca | Pipe en RUNNING, 5 pedidos en PEDIDOS_RAW y 8 en PEDIDOS_DETALLE |
| `06_consultas.sql` | Responde las preguntas analíticas de negocio de la gerencia | Tabla de ventas netas por tienda y producto líder online por ciudad |
| `07_prueba_lector.sql` | Evalúa la seguridad de solo lectura en Snowflake | SELECT exitosos e INSERT bloqueado por permisos |

---

## Notas

- **Archivos comprimidos en stage:** Si se utilizó la opción `AUTO_COMPRESS=TRUE` en el comando `PUT` de SnowSQL, el comando `LIST` mostrará el nombre con extensión comprimida (ejemplo: `ventas_1.csv.gz` o `pedidos_1.json.gz`). Snowflake descomprime el archivo de forma transparente durante el `COPY INTO`.
- **Número de línea en validación:** La consulta de validación puede indicar la línea 8 en lugar de la fila 7, debido a que el motor cuenta la fila del encabezado como la primera línea física del archivo CSV.
- **Tildes en datos:** Los registros del CSV y JSON preservan su codificación UTF-8 con tildes (Bogotá, Medellín, Café americano). Las consultas analíticas agrupan y devuelven los nombres con su ortografía original.
- **Asignación del rol lector a tu usuario:** En la última línea de `scripts/01_entorno.sql` se dejó la sentencia comentada `-- GRANT ROLE CAFE_LECTOR TO USER <TU_USUARIO>;`. Para ejecutar `scripts/07_prueba_lector.sql` con tu usuario en Snowsight, reemplaza `<TU_USUARIO>` por tu identificador de usuario en Snowflake y ejecuta esa sentencia bajo el rol `ACCOUNTADMIN`.
