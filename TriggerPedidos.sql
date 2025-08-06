DROP TRIGGER IF EXISTS max_pedidos;

DELIMITER $$

CREATE TRIGGER max_pedidos
BEFORE INSERT ON pedido
FOR EACH ROW -- Para cada nuevo pedido que se inserte
BEGIN
    -- Aqui se verifica que el cliente no tenga más de 5 pedidos pendientes
    IF (SELECT COUNT(*) FROM pedido WHERE cliente_id = NEW.cliente_id) >= 5 THEN
        SIGNAL SQLSTATE '45000' -- Si el cliente tiene más de 5 pedidos, se activa un error
        SET MESSAGE_TEXT = 'MÁXIMO DE 5 PEDIDOS. FINALICE UNO ANTES DE CREAR OTRO.';
    END IF;
END$$

DELIMITER ;