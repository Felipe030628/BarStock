CREATE DATABASE  IF NOT EXISTS `barstock` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `barstock`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: barstock
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `idCategorias` int(11) NOT NULL AUTO_INCREMENT,
  `nom_categoria` varchar(45) NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`idCategorias`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Bebidas','Categoría para todas las bebidas'),(2,'comida','todo rico'),(3,'Comida','Papas'),(4,'Bebidas','Bebidas frias y calientes'),(5,'Comida','Papas');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado_pedido`
--

DROP TABLE IF EXISTS `estado_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_pedido` (
  `idEstado_Pedido` int(11) NOT NULL AUTO_INCREMENT,
  `estado_pedidoCol` varchar(45) NOT NULL,
  PRIMARY KEY (`idEstado_Pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado_pedido`
--

LOCK TABLES `estado_pedido` WRITE;
/*!40000 ALTER TABLE `estado_pedido` DISABLE KEYS */;
INSERT INTO `estado_pedido` VALUES (1,'Pendiente'),(2,'Servido');
/*!40000 ALTER TABLE `estado_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_pag`
--

DROP TABLE IF EXISTS `estados_pag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_pag` (
  `idEstados_Pag` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion_EstadoPago` varchar(45) NOT NULL,
  PRIMARY KEY (`idEstados_Pag`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_pag`
--

LOCK TABLES `estados_pag` WRITE;
/*!40000 ALTER TABLE `estados_pag` DISABLE KEYS */;
INSERT INTO `estados_pag` VALUES (1,'Pago exitoso');
/*!40000 ALTER TABLE `estados_pag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mesa`
--

DROP TABLE IF EXISTS `mesa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mesa` (
  `idMesa` varchar(45) NOT NULL,
  `cod_mesa` int(11) NOT NULL,
  `num_mesa` varchar(45) NOT NULL,
  PRIMARY KEY (`idMesa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mesa`
--

LOCK TABLES `mesa` WRITE;
/*!40000 ALTER TABLE `mesa` DISABLE KEYS */;
INSERT INTO `mesa` VALUES ('1',1,'10');
/*!40000 ALTER TABLE `mesa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodos_pago`
--

DROP TABLE IF EXISTS `metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodos_pago` (
  `idMetodos_Pago` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion_Metodo` varchar(45) NOT NULL,
  PRIMARY KEY (`idMetodos_Pago`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodos_pago`
--

LOCK TABLES `metodos_pago` WRITE;
/*!40000 ALTER TABLE `metodos_pago` DISABLE KEYS */;
INSERT INTO `metodos_pago` VALUES (1,'NEQUI');
/*!40000 ALTER TABLE `metodos_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientos_stock`
--

DROP TABLE IF EXISTS `movimientos_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimientos_stock` (
  `idMovimientos_stock` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_movimiento` datetime DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `motivo` varchar(45) NOT NULL,
  `productos_idProductos` int(11) NOT NULL,
  PRIMARY KEY (`idMovimientos_stock`),
  KEY `fk_movimientos_stock_productos1_idx` (`productos_idProductos`),
  CONSTRAINT `fk_movimientos_stock_productos1` FOREIGN KEY (`productos_idProductos`) REFERENCES `productos` (`idProductos`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos_stock`
--

LOCK TABLES `movimientos_stock` WRITE;
/*!40000 ALTER TABLE `movimientos_stock` DISABLE KEYS */;
INSERT INTO `movimientos_stock` VALUES (2,'2025-11-23 00:00:00',20,'agotamiento',2);
/*!40000 ALTER TABLE `movimientos_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `idPagos` int(11) NOT NULL AUTO_INCREMENT,
  `monto` decimal(10,2) NOT NULL,
  `pedido_Cabecera_idPedido` int(11) NOT NULL,
  `estados_Pag_idEstados_Pag` int(11) NOT NULL,
  `metodos_Pago_idMetodos_Pago` int(11) NOT NULL,
  PRIMARY KEY (`idPagos`),
  KEY `Pedido_Cabecera_idPedido` (`pedido_Cabecera_idPedido`),
  KEY `Estados_Pag_idEstados_Pag` (`estados_Pag_idEstados_Pag`),
  KEY `Metodos_Pago_idMetodos_Pago` (`metodos_Pago_idMetodos_Pago`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`pedido_Cabecera_idPedido`) REFERENCES `pedido_cabecera` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pagos_ibfk_2` FOREIGN KEY (`estados_Pag_idEstados_Pag`) REFERENCES `estados_pag` (`idEstados_Pag`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pagos_ibfk_3` FOREIGN KEY (`metodos_Pago_idMetodos_Pago`) REFERENCES `metodos_pago` (`idMetodos_Pago`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_cabecera`
--

DROP TABLE IF EXISTS `pedido_cabecera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_cabecera` (
  `idPedido` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_hora` datetime NOT NULL,
  `usuarios_idUsuarios` int(11) NOT NULL,
  `mesa_idMesa` varchar(45) NOT NULL,
  PRIMARY KEY (`idPedido`),
  KEY `Usuarios_idUsuarios` (`usuarios_idUsuarios`),
  KEY `Mesa_idMesa` (`mesa_idMesa`),
  CONSTRAINT `pedido_cabecera_ibfk_1` FOREIGN KEY (`usuarios_idUsuarios`) REFERENCES `usuarios` (`idUsuarios`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pedido_cabecera_ibfk_2` FOREIGN KEY (`mesa_idMesa`) REFERENCES `mesa` (`idMesa`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_cabecera`
--

LOCK TABLES `pedido_cabecera` WRITE;
/*!40000 ALTER TABLE `pedido_cabecera` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_cabecera` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `idProductos` int(11) NOT NULL AUTO_INCREMENT,
  `num_productos` varchar(45) NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `Stock` int(11) NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `categorias_idCategorias` int(11) NOT NULL,
  PRIMARY KEY (`idProductos`),
  KEY `Categorias_idCategorias` (`categorias_idCategorias`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categorias_idCategorias`) REFERENCES `categorias` (`idCategorias`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (2,'30','papas',3500.00,40,'2026-07-25',2),(3,'P-500','Cerveza Importada',8900.00,50,'2026-01-20',1),(4,'3','papas',3000.00,30,'2026-08-26',2);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seguimientopedido`
--

DROP TABLE IF EXISTS `seguimientopedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seguimientopedido` (
  `idSeguimientoPedido` int(11) NOT NULL AUTO_INCREMENT,
  `seguimientoPedidoCol` varchar(45) NOT NULL,
  `estado_Pedido_idEstado_Pedido` int(11) NOT NULL,
  `pedido_idPedido` int(11) NOT NULL,
  PRIMARY KEY (`idSeguimientoPedido`),
  KEY `Estado_Pedido_idEstado_Pedido` (`estado_Pedido_idEstado_Pedido`),
  KEY `Pedido_idPedido` (`pedido_idPedido`),
  CONSTRAINT `seguimientopedido_ibfk_1` FOREIGN KEY (`estado_Pedido_idEstado_Pedido`) REFERENCES `estado_pedido` (`idEstado_Pedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `seguimientopedido_ibfk_2` FOREIGN KEY (`pedido_idPedido`) REFERENCES `pedido_cabecera` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seguimientopedido`
--

LOCK TABLES `seguimientopedido` WRITE;
/*!40000 ALTER TABLE `seguimientopedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `seguimientopedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_documentos`
--

DROP TABLE IF EXISTS `tipos_documentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_documentos` (
  `idTipos_documentos` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion_Doc` varchar(45) NOT NULL,
  `consecutivo` int(11) NOT NULL,
  `usuarios_idUsuarios` int(11) NOT NULL,
  PRIMARY KEY (`idTipos_documentos`),
  KEY `fk_tipos_documentos_usuarios1_idx` (`usuarios_idUsuarios`),
  CONSTRAINT `fk_tipos_documentos_usuarios1` FOREIGN KEY (`usuarios_idUsuarios`) REFERENCES `usuarios` (`idUsuarios`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_documentos`
--

LOCK TABLES `tipos_documentos` WRITE;
/*!40000 ALTER TABLE `tipos_documentos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipos_documentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `idUsuarios` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `tel` int(11) NOT NULL,
  PRIMARY KEY (`idUsuarios`),
  UNIQUE KEY `nombre` (`nombre`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `tel` (`tel`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Andres','andresq0128@gmail.com',7769876);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-26 22:09:00
