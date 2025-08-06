DROP PROCEDURE IF EXISTS ActualizarCliente;

DELIMITER $$

CREATE PROCEDURE ActualizarCliente(
    -- Requerimos los datos del cliente a actualizar
    IN p_cliente_id INT,
    IN p_nombre VARCHAR(500),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(500)
)
BEGIN
    -- Validamos que el cliente exista en nuestra tabla de cliente
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_cliente_id) THEN
        SIGNAL SQLSTATE '45000' -- Si el cliente no existe, se muestra un error
        SET MESSAGE_TEXT = 'Error: El cliente no existe.';
    END IF;
    
    -- Mencionamos que se actualizarán campos del cliente
    UPDATE cliente
    SET -- Con la condición de que si se ingresa el texto 'sin cambios', ese campo no se actualizará y mantendrá su campo actual
        nombre = IF(p_nombre = 'sin cambios', nombre, p_nombre),
        email = IF(p_correo = 'sin cambios', email, p_correo),
        telefono = IF(p_telefono = 'sin cambios', telefono, p_telefono),
        direccion = IF(p_direccion = 'sin cambios', direccion, p_direccion)
    WHERE id_cliente = p_cliente_id; -- Se actualiza el cliente con el ID proporcionado
    
END$$

DELIMITER ;