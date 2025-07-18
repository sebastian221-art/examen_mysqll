

---eventos

1. InformeAlquileresMensual

CREATE EVENT evento_informe_alquileres
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
INSERT INTO informe_alquileres_mensual (mes_anio, total_alquileres, total_ingresos)
SELECT 
    DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m') AS mes_anio,
    COUNT(*) AS total_alquileres,
    SUM(p.total) AS total_ingresos
FROM alquiler a
JOIN pago p ON a.id_alquiler = p.id_alquiler
WHERE a.fecha_alquiler >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);


---

2 ActualizarSaldoPendienteCliente


---

3 AlertaPeliculasNoAlquiladas

CREATE EVENT evento_alerta_peliculas_inactivas
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    SELECT p.id_pelicula, p.titulo
    FROM pelicula p
    LEFT JOIN inventario i ON p.id_pelicula = i.id_pelicula
    LEFT JOIN alquiler a ON i.id_inventario = a.id_inventario
    WHERE a.fecha_alquiler IS NULL OR a.fecha_alquiler < DATE_SUB(NOW(), INTERVAL 1 YEAR);
END;


---

4 LimpiarAuditoriaCada6Meses

5 ActualizarCategoriasPopulares


CREATE TABLE categorias_populares (
    id_categoria TINYINT,
    nombre_categoria VARCHAR(50),
    total_alquileres INT,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE EVENT evento_actualizar_categorias_populares
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM categorias_populares;

    INSERT INTO categorias_populares (id_categoria, nombre_categoria, total_alquileres)
    SELECT 
        pc.id_categoria,
        c.nombre,
        COUNT(*) AS total_alquileres
    FROM pelicula_categoria pc
    JOIN categoria c ON pc.id_categoria = c.id_categoria
    JOIN inventario i ON pc.id_pelicula = i.id_pelicula
    JOIN alquiler a ON i.id_inventario = a.id_inventario
    WHERE a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
    GROUP BY pc.id_categoria
    ORDER BY total_alquileres DESC
    LIMIT 5;
END;
 
