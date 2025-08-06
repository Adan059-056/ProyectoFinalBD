DELIMITER $$

CREATE PROCEDURE AgregarNuevoProducto(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(1000),
    IN p_precio DECIMAL(17,2),
    IN p_stock INT,
    IN p_categoria_id INT
)
BEGIN
    -- Verificamos que el nombre ni la categoría estén duplicados
    IF EXISTS (SELECT 1 FROM producto WHERE nombre = p_nombre AND categoria_id = p_categoria_id) THEN
        SIGNAL SQLSTATE '45000' -- Si ya existe un producto con el mismo nombre en la misma categoría, se activa un error
        SET MESSAGE_TEXT = 'Ya existe un producto con este nombre en la misma categoría';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM categoria WHERE id_categoria = p_categoria_id) THEN -- Verificamos que la categoría exista
        SIGNAL SQLSTATE '45001' -- Si la categoría no existe, se activa un error
        SET MESSAGE_TEXT = 'Error: La categoría con el ID proporcionado no existe';
    END IF;
    
    -- Validamos que el precio sea mayor que 0
    IF p_precio <= 0 THEN
        SIGNAL SQLSTATE '45002' -- Si el precio es menor o igual a 0, se activa un error
        SET MESSAGE_TEXT = 'Error: El precio debe ser mayor que 0';
    END IF;

    INSERT INTO producto (nombre, descripcion, precio, stock, categoria_id) -- Insertamos el nuevo producto en la tabla
    VALUES (p_nombre, p_descripcion, p_precio, p_stock, p_categoria_id);
END$$

DELIMITER ;