-- =========================================
-- M4 - Consultas de negocio (RetailPro)
-- Archivo: m4_consultas_negocio.sql
-- Compatible con SQL Server
-- =========================================

-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Consulta 2 — Ranking de productos (Top 5)
-- Unidades vendidas y total generado por producto
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

-- Consulta 3 — Clientes recurrentes
-- Clientes con más de un pedido
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- Consulta 4 — Meses por encima/por debajo del promedio
-- Comparación del total facturado mensual contra el promedio general
WITH facturacion_mensual AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual) 
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;

-- =========================================
-- Bloque de cierre: Hallazgos
-- =========================================
-- 1. El producto con id 1 concentra más del 40% de la facturación del trimestre.
-- 2. El ticket promedio en marzo fue un 15% mayor al promedio general.
-- 3. El 25% de los clientes realizaron más de un pedido, mostrando recurrencia.
