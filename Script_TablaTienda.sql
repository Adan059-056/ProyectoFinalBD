CREATE DATABASE Tienda_Online;
USE Tienda_Online;

CREATE TABLE categoria (
	id_categoria INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	descripcion VARCHAR(1000)
);

CREATE TABLE cliente (
	id_cliente INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(500) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	direccion VARCHAR(500) NOT NULL,
	telefono VARCHAR(20) NOT NULL
);

CREATE TABLE estado_pedido (
	id_estado INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(10) NOT NULL UNIQUE,
	descripción VARCHAR (100) NOT NULL
);

CREATE TABLE producto (
	id_producto INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	descripcion VARCHAR(1000) NOT NULL,
	precio DECIMAL(17,2) NOT NULL CHECK (precio > 0),
	stock INT NOT NULL CHECK (stock >= 0),
	categoria_id INT NOT NULL,
	FOREIGN KEY (categoria_id) REFERENCES categoria(id_categoria)
);

CREATE TABLE pedido (
	id_pedido INT AUTO_INCREMENT PRIMARY KEY,
	fecha_pedido DATE NOT NULL,
	estado_id INT NOT NULL DEFAULT 1,
	FOREIGN KEY (estado_id) REFERENCES estado_pedido(id_estado),
	cliente_id INT NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES cliente(id_cliente)
);

CREATE TABLE detalle_pedido (
	producto_id INT NOT NULL,
	FOREIGN KEY (producto_id) REFERENCES producto (id_producto),
	pedido_id INT NOT NULL,
	FOREIGN KEY (pedido_id) REFERENCES pedido (id_pedido),
	cantidad INT NOT NULL CHECK (cantidad > 0),
	precio DECIMAL (17,2) NOT NULL,
	PRIMARY KEY (pedido_id, producto_id)
);

CREATE TABLE reseña (
	id_reseña INT AUTO_INCREMENT PRIMARY KEY,
	calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
	comentario VARCHAR (1000) NOT NULL,
	fecha_comentario DATE NOT NULL,
	cliente_id INT NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES cliente (id_cliente),
	producto_id INT NOT NULL,
	FOREIGN KEY (producto_id) REFERENCES producto(id_producto)
);