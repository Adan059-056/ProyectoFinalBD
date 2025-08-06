DROP TRIGGER IF EXISTS actualizar_stock;

DELIMITER $$

CREATE TRIGGER actualizar_stock
AFTER INSERT ON detalle_pedido  -- Se activa al agregar un producto al pedido
FOR EACH ROW
BEGIN
    UPDATE producto
    SET stock = stock - NEW.cantidad  -- Con NEW nos referimos a la nueva cantidad de productos que se le estan agregando al stock
    WHERE id_producto = NEW.producto_id;
END$$

DELIMITER ;