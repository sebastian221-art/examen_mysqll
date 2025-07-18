--consultas

1.Cliente con más alquileres en los últimos 6 meses

SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COUNT(a.id_alquiler) AS cantidad_alquileres
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    c.id_cliente
ORDER BY 
    cantidad_alquileres DESC
LIMIT 1;

2. Cinco películas más alquiladas en el último año

SELECT 
    p.titulo,
    COUNT(a.id_alquiler) AS total_alquileres
FROM 
    alquiler a
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula p ON i.id_pelicula = p.id_pelicula
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY 
    p.id_pelicula
ORDER BY 
    total_alquileres DESC
LIMIT 5;




3. Ingresos y cantidad de alquileres por categoría

SELECT 
    cat.nombre AS categoria,
    COUNT(a.id_alquiler) AS total_alquileres,
    SUM(pago.total) AS ingresos
FROM 
    alquiler a
JOIN 
    pago pago ON a.id_alquiler = pago.id_alquiler
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula p ON i.id_pelicula = p.id_pelicula
JOIN 
    pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN 
    categoria cat ON pc.id_categoria = cat.id_categoria
GROUP BY 
    cat.id_categoria;




4. Total de clientes por idioma en un mes específico

SELECT 
    i.nombre AS idioma,
    COUNT(DISTINCT c.id_cliente) AS total_clientes
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
JOIN 
    inventario inv ON a.id_inventario = inv.id_inventario
JOIN 
    pelicula p ON inv.id_pelicula = p.id_pelicula
JOIN 
    idioma i ON p.id_idioma = i.id_idioma
WHERE 
    MONTH(a.fecha_alquiler) = 7 AND YEAR(a.fecha_alquiler) = 2025
GROUP BY 
    i.id_idioma;


5. Clientes que han alquilado todas las películas de una categoría

SELECT 
    c.id_cliente, c.nombre, c.apellidos, cat.nombre AS categoria
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula p ON i.id_pelicula = p.id_pelicula
JOIN 
    pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN 
    categoria cat ON pc.id_categoria = cat.id_categoria
GROUP BY 
    c.id_cliente, pc.id_categoria
HAVING 
    COUNT(DISTINCT p.id_pelicula) = (
        SELECT COUNT(*) 
        FROM pelicula_categoria 
        WHERE id_categoria = pc.id_categoria
    );


 6. Tres ciudades con más clientes activos en el último trimestre

SELECT 
    ciu.nombre AS ciudad,
    COUNT(DISTINCT c.id_cliente) AS total_clientes
FROM 
    cliente c
JOIN 
    direccion d ON c.id_direccion = d.id_direccion
JOIN 
    ciudad ciu ON d.id_ciudad = ciu.id_ciudad
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY 
    ciu.id_ciudad
ORDER BY 
    total_clientes DESC
LIMIT 3;


7. Cinco categorías con menos alquileres en el último año

SELECT 
    cat.nombre AS categoria,
    COUNT(a.id_alquiler) AS total_alquileres
FROM 
    alquiler a
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula p ON i.id_pelicula = p.id_pelicula
JOIN 
    pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN 
    categoria cat ON pc.id_categoria = cat.id_categoria
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY 
    cat.id_categoria
ORDER BY 
    total_alquileres ASC
LIMIT 5;




 8. Promedio de días en que los clientes devuelven las películas

SELECT 
    AVG(DATEDIFF(fecha_devolucion, fecha_alquiler)) AS promedio_dias
FROM 
    alquiler
WHERE 
    fecha_devolucion IS NOT NULL;




9. Cinco empleados que gestionaron más alquileres en categoría 

SELECT 
    e.id_empleado,
    e.nombre,
    e.apellidos,
    COUNT(a.id_alquiler) AS total_alquileres
FROM 
    alquiler a
JOIN 
    empleado e ON a.id_empleado = e.id_empleado
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula p ON i.id_pelicula = p.id_pelicula
JOIN 
    pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN 
    categoria cat ON pc.id_categoria = cat.id_categoria
WHERE 
    cat.nombre = 'Acción'
GROUP BY 
    e.id_empleado
ORDER BY 
    total_alquileres DESC
LIMIT 5;

10 .Informe de clientes con alquileres más recurrentes

SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COUNT(a.id_alquiler) AS cantidad_alquileres,
    MAX(a.fecha_alquiler) AS ultima_vez,
    MIN(a.fecha_alquiler) AS primera_vez
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
GROUP BY 
    c.id_cliente
ORDER BY 
    cantidad_alquileres DESC
LIMIT 10;


11. Costo promedio de alquiler por idioma de las películas

SELECT 
    i.id_idioma,
    idi.nombre AS idioma,
    AVG(p.duracion_alquiler) AS promedio_duracion
FROM pelicula p
JOIN idioma idi ON p.id_idioma = idi.id_idioma
GROUP BY i.id_idioma, idi.nombre;



12. Cinco películas con mayor duración alquiladas en el último año

SELECT 
    p.id_pelicula,
    p.titulo,
    p.duracion,
    COUNT(a.id_alquiler) AS total_alquileres
FROM pelicula p
JOIN inventario i ON p.id_pelicula = i.id_pelicula
JOIN alquiler a ON i.id_inventario = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY p.id_pelicula, p.titulo, p.duracion
ORDER BY p.duracion DESC
LIMIT 5;

13. Clientes que más alquilaron películas de Comedia

SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    COUNT(*) AS total_comedias
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE cat.nombre = 'Comedia'
GROUP BY c.id_cliente, c.nombre, c.apellidos
ORDER BY total_comedias DESC;


14. Cantidad total de días alquilados por cada cliente en el último mes

SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    SUM(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS total_dias
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
  AND a.fecha_devolucion IS NOT NULL
GROUP BY c.id_cliente, c.nombre, c.apellidos;


15. Número de alquileres diarios en cada almacén durante el último trimestre

SELECT 
    a.id_almacen,
    DATE(alq.fecha_alquiler) AS fecha,
    COUNT(*) AS total_alquileres
FROM alquiler alq
JOIN inventario i ON alq.id_inventario = i.id_inventario
JOIN almacen a ON i.id_almacen = a.id_almacen
WHERE alq.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY a.id_almacen, DATE(alq.fecha_alquiler)
ORDER BY fecha, a.id_almacen;


16. Ingresos totales generados por cada almacén en el último semestre

SELECT 
    a.id_almacen,
    SUM(p.total) AS ingresos_totales
FROM pago p
JOIN alquiler alq ON p.id_alquiler = alq.id_alquiler
JOIN inventario i ON alq.id_inventario = i.id_inventario
JOIN almacen a ON i.id_almacen = a.id_almacen
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY a.id_almacen;


17. Cliente que ha realizado el alquiler más caro en el último año

SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos,
    p.total AS monto
FROM pago p
JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY p.total DESC
LIMIT 1;



18. Cinco categorías con más ingresos generados durante los últimos tres meses

SELECT 
    cat.id_categoria,
    cat.nombre,
    SUM(p.total) AS ingresos
FROM pago p
JOIN alquiler a ON p.id_alquiler = a.id_alquiler
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY cat.id_categoria, cat.nombre
ORDER BY ingresos DESC
LIMIT 5;


19. Cantidad de películas alquiladas por cada idioma en el último mes

SELECT 
    idi.id_idioma,
    idi.nombre,
    COUNT(*) AS total_alquileres
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN idioma idi ON p.id_idioma = idi.id_idioma
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY idi.id_idioma, idi.nombre;


20. Clientes que no han realizado ningún alquiler en el último año

SELECT 
    c.id_cliente,
    c.nombre,
    c.apellidos
FROM cliente c
LEFT JOIN alquiler a 
  ON c.id_cliente = a.id_cliente 
     AND a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE a.id_alquiler IS NULL;

