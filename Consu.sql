-- Consulta que genera una lista de productos disponibles por categoría, ordenados por precio

SELECT 
	c.nombre as Categoria,
	p.nombre as Producto,
	p.descripcion as Descripcion,
	p.precio as Precio,
	p.stock as Stock
FROM producto p INNER JOIN categoria c ON p.categoria_id = c.id_categoria
WHERE p.stock > 0 -- Limitamos a aquellos productos que tengan un stock mayor a cero
ORDER BY p.precio; -- Ordenamos por precio

-- Consulta que muestra clientes con pedidos pendientes y el total de compras

SELECT 
	cl.nombre as Cliente,
	COUNT(DISTINCT p.id_pedido) as Pedidos_Pendientes, -- Se cuentan los pedidos, se utiliza DISTINCT para evitar duplicados si es que algún cliente tiene un pedido con más de un producto. 
	COALESCE(SUM(dp.cantidad * dp.precio), 0) as Total_Compras -- COALESE permite mostrar un cero en lugar de NULL si por algún motivo en la tabla detalles pedido o detalles precio no hay datos, lo que 										permite que la suma siga su curso y no muestre al final NULL.

FROM cliente cl INNER JOIN pedido p ON cl.id_cliente = p.cliente_id INNER JOIN estado_pedido ep ON p.estado_id = ep.id_estado LEFT JOIN detalle_pedido dp ON p.id_pedido = dp.pedido_id
WHERE ep.nombre = 'pendiente' -- Solicitamos aquellos pedidos que se encuentran en pendiente
GROUP BY cl.id_cliente, cl.nombre;

-- Consulta que muestra el reporte de los 5 productos con mejor calificación promedio en reseñas

SELECT 
	p.nombre as Producto,
	c.nombre as Categoria,
	ROUND(AVG(r.calificacion), 2) as Calificacion_Promedio, -- Se realiza el promedio con AVG tomando las calificaciones que se encuentran en nuestra tabla de reseñas y redondemoas lo obtenido con ROUND a 								dos decimales  
	COUNT(r.id_reseña) as Total_Resenas -- Se realiza un conteo para mostrar cuantas reseñas tiene ese producto
FROM reseña r INNER JOIN producto p ON r.producto_id = p.id_producto INNER JOIN categoria c ON p.categoria_id = c.id_categoria
GROUP BY p.id_producto, p.nombre, c.nombre
ORDER BY Calificacion_Promedio DESC -- Ordenamos la lista en forma descendente, obteniendo así los promedios más altos hasta arriba.
LIMIT 5; -- La lista se limita solo a los 5 productos con mejor calificación
