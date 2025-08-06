DROP PROCEDURE IF EXISTS RegistrarNuevoPedido;
DELIMITER $$

CREATE PROCEDURE RegistrarNuevoPedido(
    IN p_cliente_id INT,
    IN p_estado_id INT,
    IN p_productos_ids TEXT, -- Utilizamos texto teniendo el caso en el que se inserten más de un ID
    IN p_cantidades TEXT -- Utilizamos texto teniendo el caso en el que se inserten más de una cantidad
)
BEGIN
    -- Declaramos las funciones que ocuparemos
    DECLARE i INT DEFAULT 1;
    DECLARE producto_id INT;
    DECLARE cantidad INT;
    DECLARE nuevo_pedido_id INT;
    DECLARE num_productos INT;
    DECLARE producto_existe INT;
	DECLARE precio_actual DECIMAL(17,2); 
    DECLARE error_msg VARCHAR(255);  -- Variable para mensajes de error

    -- Esto nos permite detener el proceso y regresar a lo que teníamos en caso de que ocurra algún error, evitando que los datos se inserten y quede la tabla con  datos inconsistentes.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_productos_ids = '' OR p_cantidades = '' THEN -- En caso de que se ingrese una id o una cantidad vacía
        SIGNAL SQLSTATE '45000' -- Mandamos un mensaje de error
        SET MESSAGE_TEXT = 'Las listas de productos y cantidades no pueden estar vacías';
    END IF;
    
    -- Verificamos que los id´s ingresados y los productos con su cantidad sean iguales (es decir que haya ingresado 3 id´s y 3 cantidades)
    IF (LENGTH(p_productos_ids) - LENGTH(REPLACE(p_productos_ids, ',', ''))) != -- A la cadena recibida se le quitan las comas y se compara
       (LENGTH(p_cantidades) - LENGTH(REPLACE(p_cantidades, ',', ''))) THEN -- Igualmente se le quitan las comas y se compara con la cadena anterior
        SIGNAL SQLSTATE '45000' -- Si entra al if, se activa el error, mandando un mensaje de error
        SET MESSAGE_TEXT = 'La cantidad de productos y cantidades no coincide';
    END IF;
    
    -- Calculamos cuantos productos se van a insertar
    SET num_productos = (LENGTH(p_productos_ids) - LENGTH(REPLACE(p_productos_ids, ',', '')) + 1); -- Para esto, tomamos la longitud de la cadena original y se resta con una nueva cadena que quito las comas y los espacios, con esto podemos conocer cuantos productos se insertaron.

    
    -- Validamos existencia del cliente
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_cliente_id) THEN -- Se recorre la lista que se encuentra en la tabla de cliente y va comparando hasta encontrar el id del cliente
        SIGNAL SQLSTATE '45001' -- Si no se encuentra, muestra un mensaje de error
        SET MESSAGE_TEXT = 'El cliente especificado no existe';
    END IF;
    
    -- Validamos que el cliente no tenga más de 5 pedidos en pendiente
    IF (SELECT COUNT(*) FROM pedido WHERE cliente_id = p_cliente_id AND estado_id = 1) >= 5 THEN -- En la tabla de pedido, conocemos que cliente tiene pedidos con el id de pendiente (id 1 corresponde a pendiente) y iniciamos un contador que indique cuantos pendientes tiene con este estado.
        SIGNAL SQLSTATE '45005' -- Enviamos un mensaje de error que indique el máximo de pedidos pendientes
        SET MESSAGE_TEXT = 'El cliente no puede tener más de 5 pedidos pendientes';
    END IF;
    
    START TRANSACTION; -- Iniciamos una transacción que nos permite asegurar que todo lo realizado dentro de este sea insertado si todo sale como esperamos
    
    -- Validamos existencia del estado
    IF NOT EXISTS (SELECT 1 FROM estado_pedido WHERE id_estado = p_estado_id) THEN
        SIGNAL SQLSTATE '45002' -- Si se ingresa un id de estado que no esta definido, se muestra un mensaje de error
        SET MESSAGE_TEXT = 'El estado especificado no existe';
    END IF;
    
    -- Insertamos el pedido con los datos recibidos
    INSERT INTO pedido(cliente_id, estado_id, fecha_pedido)
    VALUES(p_cliente_id, p_estado_id, NOW()); -- Utilizamos NOW() para obtener la fecha y hora actual del sistema
    
	-- Se le asigna el último id a nuestro pedido insertado
    SET nuevo_pedido_id = LAST_INSERT_ID();
    
    -- Procesamos cada producto
    WHILE i <= num_productos DO -- Ciclo que se mantiene activo hasta llegar al número de productos
        SET producto_id = SUBSTRING_INDEX(SUBSTRING_INDEX(p_productos_ids, ',', i), ',', -1); -- Aquí se obtiene el id del producto, usamos SUBSTRING_INDEX para extraer la cadena que se encuentre entre nuestro delimitar que en este caso es la coma
        SET cantidad = SUBSTRING_INDEX(SUBSTRING_INDEX(p_cantidades, ',', i), ',', -1); -- Aplicamos la misma lógica para obtener cual es la cantidad que se realizó en el pedido
        SELECT precio INTO precio_actual FROM producto WHERE id_producto = producto_id; -- Obtenemos el precio del producto que se encuentra en la tabla producto, para poder calcular el total del pedido más adelante
        -- Validamos que el producto exista
        SET producto_existe = (SELECT COUNT(*) FROM producto WHERE id_producto = producto_id); --  Se recorre la tabla de producto comparando los id´ de los productos que hay en la tabla con el ingresado, en este caso tenemos un contador asignado a producto asignado como centinela, en el caso de que exista el contador será 1.
        -- Si el contador no se modificó y quedó en cero, quiere decir que el producto ingresado no existe
		IF producto_existe = 0 THEN
            SET error_msg = CONCAT('Error: El producto ID ', producto_id, ' no existe');
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = error_msg;
        END IF;
        
        -- Validamos que la cantidad sea positiva
        IF cantidad <= 0 THEN
            SET error_msg = CONCAT('Cantidad inválida para producto ID ', producto_id);
            SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = error_msg;
        END IF;
        
        -- Una vez verificado que los datos ingresados son correctos y existen, se insertan los datos a nuestra tabla detalle_pedido
        INSERT INTO detalle_pedido(pedido_id, producto_id, cantidad, precio)
        VALUES(nuevo_pedido_id, producto_id, cantidad, precio_actual);
        
        SET i = i + 1; -- Incrementamos nuestra variable para seguir con los siguientes productos
    END WHILE;
    
    COMMIT; -- Se realiza el commit con el fin de saber que no ocurrió ningún error y todo estuvo bien
END$$

DELIMITER ;
