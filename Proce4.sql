DROP PROCEDURE IF EXISTS cambiar_estado;

DELIMITER $$

CREATE PROCEDURE cambiar_estado( -- Este procedimiento permite cambiar el estado de un pedido, asegurando que el estado sea válido y que el pedido exista.
    IN id_pedidoN INT ,
    IN id_estadoN INT)
BEGIN
    IF id_estadoN > 3 THEN -- Validamos que el estado ingresado sea válido en este caso, los estados válidos son 1 (Pendiente), 2 (Enviado) y 3 (Entregado).
        SIGNAL SQLSTATE '45000' -- Si el estado es mayor a 3, se activa un error
        SET MESSAGE_TEXT = 'Estado no existente (1-3)';
    ELSEIF NOT EXISTS(SELECT 1 FROM pedido WHERE id_pedido = id_pedidoN) THEN -- Validamos que el pedido no exista
        SIGNAL SQLSTATE '45000' -- Si el pedido no existe, se activa un error
        SET MESSAGE_TEXT = 'El pedido no existe';

    ELSE -- Si el estado es válido y el pedido existe, se actualiza el estado del pedido
        UPDATE pedido SET id_estado = id_estadoN
        WHERE id_pedido = id_pedidoN;
    END IF;
END$$

DELIMITER ;
