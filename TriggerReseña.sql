DROP TRIGGER IF EXISTS reseñas_cliente;

DELIMITER $$

CREATE TRIGGER reseñas_cliente
BEFORE INSERT ON reseña
FOR EACH ROW
BEGIN
	DECLARE compra INT; -- Variable para verificar si el cliente compró el producto

	SELECT COUNT(*) INTO compra -- Inicializamos un contador que nos indicará si el cliente compró el producto
	FROM detalle_pedido dp
	INNER JOIN pedido p ON dp.pedido_id = p.id_pedido
	WHERE p.cliente_id = NEW.cliente_id
	AND dp.producto_id = NEW.producto_id;

	IF compra = 0 THEN -- Si el contador es cero, quiere decir que el cliente no compró el producto
		SIGNAL SQLSTATE '45000' -- Enviamos un mensaje de error
		SET MESSAGE_TEXT = 'PARA REALIZAR UNA RESEÑA AL MENOS DEBES DE TENER UNA COMPRA DEL PRODUCTO SELECCIONADO';
	END IF;
END$$

DELIMITER ;