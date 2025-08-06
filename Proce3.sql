DROP PROCEDURE IF EXISTS ActualizarStockProducto;

DELIMITER $$

CREATE PROCEDURE ActualizarStockProducto( -- Este procedimiento permite actualizar el stock de un producto, después de que se haya realizado un pedido o se requiera añadir producto al stock.
    IN producto_id INT,
    IN cantidad INT
)
BEGIN
    DECLARE nuevo_stock INT; -- Variable para calcular el nuevo stock del producto

    -- Obtenemos el stock actual del producto y le sumamos la cantidad que se recibe como parámetro, este método es valido para cuando se añade o se resta stock, ya que si se desea restar, solo se envía una cantidad negativa.
    SET nuevo_stock = (SELECT stock FROM producto WHERE id_producto = producto_id) + cantidad; -- Nota. Para el caso de que se desee restar stock, se debe de colocar el simbolo de resta.
    
    IF nuevo_stock < 0 THEN -- Validamos que el nuevo stock no sea negativo
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El stock no puede ser negativo';
    END IF;
    
    UPDATE producto
    SET stock = nuevo_stock -- Actualizamos el stock del producto con el nuevo valor calculado
    WHERE id_producto = producto_id;
END$$

DELIMITER ;