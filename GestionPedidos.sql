-- --------------------------------------------------------
-- Host:                         LOCALHOST
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

-- Volcando datos para la tabla gestionpedidos.articulos: ~0 rows (aproximadamente)
DELETE FROM `articulos`;
INSERT INTO `articulos` (`nro_pedido`, `sku`, `cantidad`, `color`) VALUES
	(81732, 'CAVATELLI-PASTA-MAKER', 1, '-'),
	(81845, 'DP2HDMI-2', 1, 'Sin color'),
	(81845, 'DP2VGA', 1, 'Sin color'),
	(81845, 'PELTIER-TEC1-12708', 10, '-'),
	(81845, 'ROTARY-ENCODER-20PPR', 10, '-');

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

-- Volcando datos para la tabla gestionpedidos.pedidos: ~0 rows (aproximadamente)
DELETE FROM `pedidos`;
INSERT INTO `pedidos` (`nro_pedido`, `nombre_apellido`, `dni_cuit`, `fecha_creacion`, `direccion`, `cp`, `referencia`) VALUES
	(81732, 'gerardo BOLLERO', '20345678', '2024-11-18', 'matheu 43', 1082, '011 6749-1741 / 4953 8743\nlunes a viernes de 9 a 18'),
	(81845, 'Mauricio Prinzo', '27234567', '2024-11-18', 'Av. Lafuente 591', 1406, '1141443659');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
