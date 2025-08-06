DROP PROCEDURE IF EXISTS RegistrarReseña;

DELIMITER $$

CREATE PROCEDURE RegistrarReseña(
    IN cliente_id INT,
    IN producto_id INT,
    IN calificacion INT,
    IN comentario TEXT
)
BEGIN
    DECLARE compra_hecha INT; -- Variable para verificar si el cliente compró el producto
    
    -- Verificar si el cliente compró el producto
    SELECT COUNT(*) INTO compra_hecha -- Inicializamos un contador que nos indicará si el cliente compró el producto
    FROM detalle_pedido dp INNER JOIN pedido p ON dp.pedido_id = p.id_pedido
    WHERE p.cliente_id = cliente_id -- Comparamos el id del cliente con el id del cliente que se encuentra en la tabla pedido
    AND dp.producto_id = producto_id; -- También que el id del producto coincida con el id del producto que se encuentra en la tabla detalle_pedido
    
    -- Verificamos que el cliente haya comprado el producto
    IF compra_hecha = 0 THEN -- Si el contador es cero, quiere decir que el cliente no compró el producto
        SIGNAL SQLSTATE '45000' -- Enviamos un mensaje de error
        SET MESSAGE_TEXT = 'Solo clientes que compraron el producto pueden comentar';
    END IF;
    -- Verificamos tamaño del comentario
    IF LENGTH(comentario) > 1000 THEN -- Condición que verifica que el comentario no exceda los 1000 caracteres
        SIGNAL SQLSTATE '45001' -- Si se excede el límite, se muestra un mensaje de error
        SET MESSAGE_TEXT = 'El comentario excede el límite de caracteres permitido';
    END IF;
    
    -- Insertamos los datos en la tabla reseña
    INSERT INTO reseña (calificacion, comentario, fecha_comentario, cliente_id, producto_id)
    VALUES (calificacion, comentario, CURDATE(), cliente_id, producto_id); -- Utilizamos CURDATE() para obtener la fecha actual del sistema
END$$

DELIMITER ;