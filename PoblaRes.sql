-- Insertando 10 reseñas de clientes

INSERT INTO reseña (calificacion, comentario, fecha_comentario, cliente_id, producto_id) VALUES

-- Reseñas de Canelo
(1, 'Las hoodies tardaron mucho en llegar, tuve que ir a atención del cliente y al llegar note que la tela era de mala calidad', '2025-01-17', 10, 20),
(4, 'La cámara cumple con las expectativas, hubo un pequeño golpe en la caja', '2025-02-14', 10, 5),
(5, 'Sin duda una maravilla, las piezas vienen completas y la pieza es igual a la de la foto', '2025-05-10', 10, 26),

-- Reseñas de Miguel
(3, 'Un poco espaciosa, los materiales podrían ser de mejor calidad', '2025-01-25', 9, 9),

-- Reseñas de Cristiano
(5, 'Las cuatro consolas llegaron a la perfección, sin dudas un lugar confiable', '2025-03-05', 14, 22),
(4, 'El producto  es bueno pero el envío tardó más de lo esperado', '2025-06-06', 14, 17),

-- Reseñas de Adán
(5, 'Los productos llegaron en buenas condiciones e incluso llegaron antes de lo previsto', '2025-04-22', 1, 12),
(2, 'Los AirPods se desconectan frecuentemente, no los recomiendo', '2025-07-13', 1, 2),
(4, 'La consola tiene un buen rendimiento en general', '2025-05-13', 1, 21),
(5, 'La cámara tiene un lente muy bueno y los accesorios ayudan a que esto sea un mejor producto', '2025-06-01', 1, 4);