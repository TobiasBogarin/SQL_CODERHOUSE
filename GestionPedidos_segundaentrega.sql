-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.0.39 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para gestionpedidos
CREATE DATABASE IF NOT EXISTS `gestionpedidos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gestionpedidos`;

-- Volcando estructura para tabla gestionpedidos.articulos
CREATE TABLE IF NOT EXISTS `articulos` (
  `nro_pedido` int NOT NULL,
  `sku` varchar(50) NOT NULL,
  `cantidad` int NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`nro_pedido`,`sku`),
  CONSTRAINT `articulos_ibfk_1` FOREIGN KEY (`nro_pedido`) REFERENCES `pedidos` (`nro_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla gestionpedidos.articulos: ~5 rows (aproximadamente)
DELETE FROM `articulos`;
INSERT INTO `articulos` (`nro_pedido`, `sku`, `cantidad`, `color`) VALUES
	(4, 'SKU123', 2, 'Rojo'),
	(4, 'SKU456', 3, 'Azul'),
	(81732, 'CAVATELLI-PASTA-MAKER', 1, '-'),
	(81845, 'DP2HDMI-2', 1, 'Sin color'),
	(81845, 'DP2VGA', 1, 'Sin color'),
	(81845, 'PELTIER-TEC1-12708', 10, '-'),
	(81845, 'ROTARY-ENCODER-20PPR', 10, '-');

-- Volcando estructura para tabla gestionpedidos.auditoria_pedidos
CREATE TABLE IF NOT EXISTS `auditoria_pedidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nro_pedido` int NOT NULL,
  `accion` varchar(50) NOT NULL,
  `fecha_accion` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla gestionpedidos.auditoria_pedidos: ~2 rows (aproximadamente)
DELETE FROM `auditoria_pedidos`;
INSERT INTO `auditoria_pedidos` (`id`, `nro_pedido`, `accion`, `fecha_accion`) VALUES
	(1, 2, 'INSERT', '2024-12-22 18:54:56'),
	(2, 4, 'INSERT', '2024-12-22 18:55:48');

-- Volcando estructura para procedimiento gestionpedidos.insertar_pedido
DELIMITER //
CREATE PROCEDURE `insertar_pedido`(
    IN pedido_id INT,
    IN cliente_nombre VARCHAR(100),
    IN fecha DATE,
    IN direccion_entrega VARCHAR(255),
    IN codigo_postal INT,
    IN referencia TEXT
)
BEGIN
    -- Insertar el pedido en la tabla pedidos
    INSERT INTO pedidos (nro_pedido, nombre_apellido, fecha_creacion, direccion, cp, referencia)
    VALUES (pedido_id, cliente_nombre, fecha, direccion_entrega, codigo_postal, referencia);

    -- Insertar los artículos asociados
    -- Se espera que los datos de los artículos ya estén en la tabla temporal 'temp_articulos'
    INSERT INTO articulos (nro_pedido, sku, cantidad, color)
    SELECT pedido_id, sku, cantidad, color FROM temp_articulos;
END//
DELIMITER ;

-- Volcando estructura para tabla gestionpedidos.pedidos
CREATE TABLE IF NOT EXISTS `pedidos` (
  `nro_pedido` int NOT NULL,
  `nombre_apellido` varchar(100) NOT NULL,
  `dni_cuit` varchar(20) DEFAULT NULL,
  `fecha_creacion` date NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `cp` int NOT NULL,
  `referencia` text,
  PRIMARY KEY (`nro_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla gestionpedidos.pedidos: ~2 rows (aproximadamente)
DELETE FROM `pedidos`;
INSERT INTO `pedidos` (`nro_pedido`, `nombre_apellido`, `dni_cuit`, `fecha_creacion`, `direccion`, `cp`, `referencia`) VALUES
	(2, 'Ana Gómez', NULL, '2024-12-02', 'Av. Siempreviva 742', 12346, 'Entrega por la tarde'),
	(4, 'Ana Gómez', NULL, '2024-12-02', 'Av. Siempreviva 742', 12346, 'Entrega por la tarde'),
	(81732, 'gerardo BOLLERO', '20345678', '2024-11-18', 'matheu 43', 1082, '011 6749-1741 / 4953 8743\nlunes a viernes de 9 a 18'),
	(81845, 'Mauricio Prinzo', '27234567', '2024-11-18', 'Av. Lafuente 591', 1406, '1141443659');

-- Volcando estructura para función gestionpedidos.total_articulos_por_pedido
DELIMITER //
CREATE FUNCTION `total_articulos_por_pedido`(pedido_id INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT 
        COALESCE(SUM(cantidad), 0) 
    INTO 
        total
    FROM 
        articulos
    WHERE 
        nro_pedido = pedido_id;
    RETURN total;
END//
DELIMITER ;

-- Volcando estructura para vista gestionpedidos.vista_pedidos_multiples
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `vista_pedidos_multiples` (
	`nro_pedido` INT NOT NULL,
	`nombre_apellido` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`cantidad_articulos` BIGINT NOT NULL
) ENGINE=MyISAM;

-- Volcando estructura para vista gestionpedidos.vista_pedidos_por_fecha
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `vista_pedidos_por_fecha` (
	`nro_pedido` INT NOT NULL,
	`nombre_apellido` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`fecha_creacion` DATE NOT NULL,
	`direccion` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`cp` INT NOT NULL
) ENGINE=MyISAM;

-- Volcando estructura para disparador gestionpedidos.auditoria_pedidos_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `auditoria_pedidos_insert` AFTER INSERT ON `pedidos` FOR EACH ROW BEGIN
    INSERT INTO auditoria_pedidos (nro_pedido, accion, fecha_accion)
    VALUES (NEW.nro_pedido, 'INSERT', NOW());
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `vista_pedidos_multiples`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vista_pedidos_multiples` AS select `p`.`nro_pedido` AS `nro_pedido`,`p`.`nombre_apellido` AS `nombre_apellido`,count(`a`.`sku`) AS `cantidad_articulos` from (`pedidos` `p` join `articulos` `a` on((`p`.`nro_pedido` = `a`.`nro_pedido`))) group by `p`.`nro_pedido`,`p`.`nombre_apellido` having (count(`a`.`sku`) > 1);

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `vista_pedidos_por_fecha`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vista_pedidos_por_fecha` AS select `pedidos`.`nro_pedido` AS `nro_pedido`,`pedidos`.`nombre_apellido` AS `nombre_apellido`,`pedidos`.`fecha_creacion` AS `fecha_creacion`,`pedidos`.`direccion` AS `direccion`,`pedidos`.`cp` AS `cp` from `pedidos` where (`pedidos`.`fecha_creacion` between '2024-01-01' and '2024-12-31');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;


DROP VIEW IF EXISTS vista_pedidos_por_fecha;

CREATE ALGORITHM=UNDEFINED 
DEFINER=`root`@`localhost` 
SQL SECURITY DEFINER 
VIEW `vista_pedidos_por_fecha` AS 
SELECT `pedidos`.`nro_pedido`, `pedidos`.`nombre_apellido`, 
       `pedidos`.`fecha_creacion`, `pedidos`.`direccion`, `pedidos`.`cp` 
FROM `pedidos`;
