DROP PROCEDURE IF EXISTS EliminarReseñasProducto;

DELIMITER $$

CREATE PROCEDURE EliminarReseñasProducto(
    IN p_producto_id INT  -- ¡Agrega prefijo 'p_' al parámetro!
)
BEGIN
    DECLARE producto_existe INT;
    SELECT COUNT(*) INTO producto_existe FROM producto WHERE id_producto = p_producto_id;  -- Verificamos si el producto existe, al existir el contador será mayor a 0.
    IF producto_existe = 0 THEN -- Si el contador es 0, significa que el producto no existe
        SIGNAL SQLSTATE '45000' -- Si el producto no existe, se activa un error
        SET MESSAGE_TEXT = 'Error: El producto no existe. Verifica el ID del producto.';
    ELSE
    DELETE FROM reseña -- Si el producto existe, se procede a eliminar las reseñas asociadas a este producto
    WHERE producto_id = p_producto_id;  
    END IF;
END$$
DELIMITER ;