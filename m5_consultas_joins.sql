-- =========================================
-- M5 - Consultas con JOINs (RetailPro)
-- Archivo: m5_consultas_joins.sql
-- Compatible con SQL Server
-- =========================================

-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- Ventas con cliente, producto y categoría
SELECT 
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

-- Consulta 3 — Productos sin ventas (LEFT JOIN)
SELECT 
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_producto IS NULL;

-- Consulta 4 — Consolidado por canal (UNION ALL)
-- Ejemplo: separar ventas por fecha (antes y después de 2024-03-10)
SELECT 
    v.fecha_venta,
    (v.cantidad * v.precio_unitario) AS total,
    'Online' AS canal
FROM ventas v
WHERE v.fecha_venta <= '2024-03-10'

UNION ALL

SELECT 
    v.fecha_venta,
    (v.cantidad * v.precio_unitario) AS total,
    'Presencial' AS canal
FROM ventas v
WHERE v.fecha_venta > '2024-03-10';

-- Consolidado por canal con GROUP BY
SELECT canal, SUM(total) AS total_por_canal
FROM (
    SELECT 
        (v.cantidad * v.precio_unitario) AS total,
        'Online' AS canal
    FROM ventas v
    WHERE v.fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT 
        (v.cantidad * v.precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas v
    WHERE v.fecha_venta > '2024-03-10'
) AS union_ventas
GROUP BY canal;
