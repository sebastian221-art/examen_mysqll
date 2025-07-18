
--funciones 

1. TotalIngresosCliente(ClienteID, Año)


DELIMITER $$

CREATE FUNCTION TotalIngresosCliente(p_cliente_id SMALLINT, p_anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(total)
    INTO total
    FROM pago
    WHERE id_cliente = p_cliente_id
      AND YEAR(fecha_pago) = p_anio;

    RETURN IFNULL(total, 0);
END;
$$

DELIMITER ;


2. PromedioDuracionAlquiler(PeliculaID)


DELIMITER $$

CREATE FUNCTION PromedioDuracionAlquiler(p_pelicula_id SMALLINT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(5,2);

    SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler))
    INTO promedio
    FROM alquiler a
    JOIN inventario i ON a.id_inventario = i.id_inventario
    WHERE i.id_pelicula = p_pelicula_id
      AND a.fecha_devolucion IS NOT NULL;

    RETURN IFNULL(promedio, 0);
END;
$$

DELIMITER ;


3. IngresosPorCategoria(CategoriaID)


DELIMITER $$

CREATE FUNCTION IngresosPorCategoria(p_categoria_id TINYINT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE ingresos DECIMAL(10,2);

    SELECT SUM(p.total)
    INTO ingresos
    FROM pago p
    JOIN alquiler a ON p.id_alquiler = a.id_alquiler
    JOIN inventario i ON a.id_inventario = i.id_inventario
    JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
    WHERE pc.id_categoria = p_categoria_id;

    RETURN IFNULL(ingresos, 0);
END;
$$

DELIMITER ;
4. DescuentoFrecuenciaCliente(ClienteID)


DELIMITER $$

CREATE FUNCTION DescuentoFrecuenciaCliente(p_cliente_id SMALLINT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_alquileres INT;
    DECLARE descuento DECIMAL(5,2);

    SELECT COUNT() INTO total_alquileres
    FROM alquiler
    WHERE id_cliente = p_cliente_id;

    IF total_alquileres >= 30 THEN
        SET descuento = 0.15;
    ELSEIF total_alquileres >= 20 THEN
        SET descuento = 0.10;
    ELSEIF total_alquileres >= 10 THEN
        SET descuento = 0.05;
    ELSE
        SET descuento = 0.00;
    END IF;

    RETURN descuento;
END;
$$

DELIMITER ;




5. EsClienteVIP(ClienteID)

DELIMITER $$

CREATE FUNCTION EsClienteVIP(p_cliente_id SMALLINT)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_alquileres INT;
    DECLARE total_ingresos DECIMAL(10,2);

    SELECT COUNT() INTO total_alquileres
    FROM alquiler
    WHERE id_cliente = p_cliente_id;

    SELECT SUM(total) INTO total_ingresos
    FROM pago
    WHERE id_cliente = p_cliente_id;

    RETURN (total_alquileres >= 40 AND total_ingresos > 500);
END;
$$

DELIMITER ;