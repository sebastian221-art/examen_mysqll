CREATE TABLE IF NOT EXISTS pais (
    id_pais SMALLINT UNSIGNED,
    nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_pais)
);

CREATE TABLE IF NOT EXISTS actor (
    id_actor SMALLINT UNSIGNED,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_actor)
);

CREATE TABLE IF NOT EXISTS ciudad (
    id_ciudad SMALLINT UNSIGNED,
    nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP,
    id_pais SMALLINT UNSIGNED,
    CONSTRAINT Fk_idpais_ci FOREIGN KEY(id_pais) REFERENCES pais(id_pais),
    PRIMARY KEY(id_ciudad)
);

CREATE TABLE IF NOT EXISTS direccion (
    id_direccion SMALLINT UNSIGNED,
    direccion VARCHAR(50),
    direccion2 VARCHAR(50),
    distrito VARCHAR(20),
    codigo_postal VARCHAR(10),
    telefono VARCHAR(20),
    ultima_actualizacion TIMESTAMP,
    id_ciudad SMALLINT UNSIGNED,
    CONSTRAINT Fk_idciudad_di FOREIGN KEY(id_ciudad) REFERENCES ciudad(id_ciudad),
    PRIMARY KEY(id_direccion)
);

CREATE TABLE IF NOT EXISTS categoria (
    id_categoria TINYINT UNSIGNED,
    nombre VARCHAR(25),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_categoria)
);

CREATE TABLE IF NOT EXISTS idioma (
    id_idioma TINYINT UNSIGNED,
    nombre VARCHAR(20),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_idioma)
);

CREATE TABLE IF NOT EXISTS pelicula (
    id_pelicula SMALLINT UNSIGNED,
    titulo VARCHAR(255),
    descripcion TEXT,
    anyo_lanzamiento YEAR,
    id_idioma TINYINT UNSIGNED,
    CONSTRAINT FK_id_idioma_pelicula FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma),
    id_idioma_original TINYINT UNSIGNED,
    CONSTRAINT FK_id_idioma_original_pelicula FOREIGN KEY (id_idioma_original) REFERENCES idioma(id_idioma),
    duracion_alquiler TINYINT UNSIGNED,
    rental_rate DECIMAL(4,2),
    duracion SMALLINT UNSIGNED,
    replacement_cost DECIMAL(5,2),
    clasificacion ENUM('G','PG','PG-13','R','NC-17'),
    caracteristicas_especiales SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_pelicula)
);

CREATE TABLE IF NOT EXISTS almacen (
    id_almacen TINYINT UNSIGNED,
    id_direccion SMALLINT UNSIGNED,
    CONSTRAINT Fk_direccion FOREIGN KEY(id_direccion) REFERENCES direccion(id_direccion),
    PRIMARY KEY(id_almacen)
);

CREATE TABLE IF NOT EXISTS empleado (
    id_empleado TINYINT UNSIGNED,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    id_direccion SMALLINT UNSIGNED,
    imagen BLOB,
    email VARCHAR(50),
    id_almacen TINYINT UNSIGNED,
    activo TINYINT(1),
    username VARCHAR(16),
    password VARCHAR(40),
    ultima_actualizacion TIMESTAMP,
    CONSTRAINT Fk_almacen_em FOREIGN KEY(id_almacen) REFERENCES almacen(id_almacen),
    CONSTRAINT Fk_direccionem_em FOREIGN KEY(id_direccion) REFERENCES direccion(id_direccion),
    PRIMARY KEY(id_empleado)
);

CREATE TABLE IF NOT EXISTS pelicula_actor (
    id_actor SMALLINT UNSIGNED,
    id_pelicula SMALLINT UNSIGNED,
    PRIMARY KEY(id_pelicula, id_actor),
    CONSTRAINT FK_id_actor FOREIGN KEY (id_actor) REFERENCES actor(id_actor),
    CONSTRAINT FK_id_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    ultima_actualizacion TIMESTAMP
);

CREATE TABLE IF NOT EXISTS pelicula_categoria (
    id_categoria TINYINT UNSIGNED,
    id_pelicula SMALLINT UNSIGNED,
    PRIMARY KEY(id_pelicula, id_categoria),
    CONSTRAINT FK_id_categoria2 FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    CONSTRAINT FK_id_pelicula2 FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    ultima_actualizacion TIMESTAMP
);

CREATE TABLE IF NOT EXISTS inventario (
    id_inventario MEDIUMINT UNSIGNED NOT NULL,
    id_pelicula SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT FK_id_pelicula_inv FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    id_almacen TINYINT UNSIGNED NOT NULL,
    CONSTRAINT FK_id_almacen_inv FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen),
    PRIMARY KEY(id_inventario),
    ultima_actualizacion TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS cliente (
    id_cliente SMALLINT UNSIGNED,
    id_almacen TINYINT UNSIGNED,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    id_direccion SMALLINT UNSIGNED,
    email VARCHAR(50),
    activo TINYINT(1),
    fecha_creacion DATETIME,
    ultima_actualizacion TIMESTAMP,
    CONSTRAINT Fk_almacen FOREIGN KEY(id_almacen) REFERENCES almacen(id_almacen),
    CONSTRAINT Fk_direccion5 FOREIGN KEY(id_direccion) REFERENCES direccion(id_direccion),
    PRIMARY KEY(id_cliente)
);

CREATE TABLE IF NOT EXISTS alquiler (
    id_alquiler INT UNSIGNED NOT NULL,
    fecha_alquiler DATETIME NOT NULL,
    id_inventario MEDIUMINT UNSIGNED NOT NULL,
    CONSTRAINT FK_id_inventario_al FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario),
    id_cliente SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT FK_id_cliente_al FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    fecha_devolucion DATETIME NOT NULL,
    id_empleado TINYINT UNSIGNED NOT NULL,
    CONSTRAINT FK_id_empleado_al FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    PRIMARY KEY(id_alquiler),
    ultima_actualizacion TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS pago (
    id_pago SMALLINT UNSIGNED NOT NULL,
    id_cliente SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT FK_id_cliente_pag FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    id_empleado TINYINT UNSIGNED NOT NULL,
    CONSTRAINT FK_id_empleado_pag FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    id_alquiler INT UNSIGNED NOT NULL,
    CONSTRAINT FK_id_alquiler_pag FOREIGN KEY (id_alquiler) REFERENCES alquiler(id_alquiler),
    total DECIMAL(5,2) NOT NULL,
    PRIMARY KEY(id_pago),
    fecha_pago DATETIME NOT NULL,
    ultima_actualizacion TIMESTAMP NOT NULL
);

