DROP PROCEDURE IF EXISTS ReporteStock;

DELIMITER $$

CREATE PROCEDURE ReporteStock(
    IN nivel_stock VARCHAR(10)  -- El usuario ingresa el nivel de stock, en este caso será la palabra 'bajo'.
)
BEGIN
    CASE
        WHEN nivel_stock = 'bajo' THEN -- Si el usuario ingresa 'bajo', se inicia la consulta
            SELECT 
                -- Se seleccionan los campos de los productos que queremos mostrar y que se encuntran en nuestra tabla producto y categoria.
                p.id_producto,
                p.nombre,
                p.descripcion,
                p.precio,
                p.stock,
                c.nombre as categoria, -- Creamos un alias llamada categoria que contiene el nombre de la categoría a la que pertenece el producto
                'BAJO' as nivel_stock  -- Creamos un alias llamado nivel_stock que indica que el nivel de stock es bajo
            FROM producto p INNER JOIN categoria c ON p.categoria_id = c.id_categoria
            WHERE p.stock < 5 -- Se seleccionan los productos que tienen un stock menor a 5
            ORDER BY p.stock ASC; -- Y se ordenan de forma ascendente
        ELSE
            SELECT 'Error: Nivel no válido. Use el termino bajo para ver productos en stock bajo.' as mensaje; -- Si el usuario ingresa un nivel diferente a 'bajo', se muestra un mensaje de error
    END CASE;
END$$

DELIMITER ;