
---Triggers


1.ActualizarTotalAlquileresEmpleado

DELIMITER $$

CREATE TRIGGER trg_actualizar_total_alquileres
AFTER INSERT ON alquiler
FOR EACH ROW
BEGIN
    INSERT INTO total_alquileres_empleado (id_empleado, total_alquileres)
    VALUES (NEW.id_empleado, 1)
    ON DUPLICATE KEY UPDATE total_alquileres = total_alquileres + 1;
END;
$$

DELIMITER ;


---

2 AuditarActualizacionCliente

DELIMITER $$

CREATE TRIGGER trg_auditar_actualizacion_cliente
BEFORE UPDATE ON cliente
FOR EACH ROW
BEGIN
    IF OLD.nombre <> NEW.nombre THEN
        INSERT INTO cliente_auditoria (id_cliente, campo_modificado, valor_anterior, valor_nuevo, usuario_modifico)
        VALUES (OLD.id_cliente, 'nombre', OLD.nombre, NEW.nombre, CURRENT_USER());
    END IF;

    IF OLD.apellidos <> NEW.apellidos THEN
        INSERT INTO cliente_auditoria (id_cliente, campo_modificado, valor_anterior, valor_nuevo, usuario_modifico)
        VALUES (OLD.id_cliente, 'apellidos', OLD.apellidos, NEW.apellidos, CURRENT_USER());
    END IF;
END;
$$

DELIMITER ;


---

3 RegistrarHistorialDeCosto

DELIMITER $$

CREATE TRIGGER trg_historial_costo_pelicula
BEFORE UPDATE ON pelicula
FOR EACH ROW
BEGIN
    IF OLD.duracion_alquiler <> NEW.duracion_alquiler THEN
        INSERT INTO historial_costo_pelicula (id_pelicula, costo_anterior, costo_nuevo)
        VALUES (OLD.id_pelicula, OLD.duracion_alquiler, NEW.duracion_alquiler);
    END IF;
END;
$$

DELIMITER ;
4 NotificarEliminacionAlquiler

DELIMITER $$

CREATE TRIGGER trg_notificar_eliminacion_alquiler
BEFORE DELETE ON alquiler
FOR EACH ROW
BEGIN
    INSERT INTO notificaciones_eliminacion (id_alquiler, mensaje)
    VALUES (OLD.id_alquiler, CONCAT('El alquiler con ID ', OLD.id_alquiler, ' ha sido eliminado.'));
END;
$$

DELIMITER ;




5 RestringirAlquilerConSaldoPendiente


DELIMITER $$

CREATE TRIGGER trg_restringir_alquiler
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    DECLARE deuda DECIMAL(10,2);

    SELECT SUM(total)
    INTO deuda
    FROM pago
    WHERE id_cliente = NEW.id_cliente AND total < 0;

    IF deuda IS NOT NULL AND deuda < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente tiene saldo pendiente y no puede alquilar.';
    END IF;
END;
$$

DELIMITER ;
