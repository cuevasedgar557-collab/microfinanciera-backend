-- MySQL dump 10.13  Distrib 9.7.1, for Win64 (x86_64)
--
-- Host: localhost    Database: microfinanciera
-- ------------------------------------------------------
-- Server version	9.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `barrios`
--

DROP TABLE IF EXISTS `barrios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barrios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `municipio_id` int DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'pendiente',
  PRIMARY KEY (`id`),
  KEY `idx_barrios_municipio` (`municipio_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barrios`
--

LOCK TABLES `barrios` WRITE;
/*!40000 ALTER TABLE `barrios` DISABLE KEYS */;
INSERT INTO `barrios` VALUES (1,'Lotificación San Juan',2,'activo'),(2,'aurerio carrasco',2,'activo');
/*!40000 ALTER TABLE `barrios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `cedula` varchar(50) DEFAULT NULL,
  `sexo` varchar(20) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `departamento_id` int DEFAULT NULL,
  `municipio_id` int DEFAULT NULL,
  `barrio_id` int DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `trabajo_id` int DEFAULT NULL,
  `usuario_id` int DEFAULT NULL,
  `estado_civil` varchar(50) DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cedula` (`cedula`),
  KEY `idx_clientes_usuario` (`usuario_id`),
  KEY `idx_clientes_departamento` (`departamento_id`),
  KEY `idx_clientes_municipio` (`municipio_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (2,'Ernesto Caseres Sutiava Nicaragua','08503060734567D','M','+505 7511 9515',1,2,2,'de la entrada 2 cuadras y media al norte',30,2,'casado','2026-06-15 20:49:27'),(3,'Maria Esperanza Guerrero Mendes','086 150785 5435F','F','+505 76751188',1,2,1,'de la entrada 1 cuadra al norte una al oeste 25VRS al norte',30,1,'casado','2026-06-21 23:36:40'),(4,'Milagros Yarizeidy Moncada Caseres','0862308108547J','F','+505 85742156',1,2,2,'de la entrada 3 cuadras al nor este 4 al sur',32,2,'soltero','2026-06-24 20:05:54');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comentarios_clientes`
--

DROP TABLE IF EXISTS `comentarios_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comentarios_clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `comentario` text NOT NULL,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comentarios_clientes`
--

LOCK TABLES `comentarios_clientes` WRITE;
/*!40000 ALTER TABLE `comentarios_clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `comentarios_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cuotas`
--

DROP TABLE IF EXISTS `cuotas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuotas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prestamo_id` int NOT NULL,
  `numero` int NOT NULL,
  `fecha_pago` date DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `pagado` decimal(10,2) DEFAULT '0.00',
  `saldo` decimal(10,2) DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'pendiente',
  PRIMARY KEY (`id`),
  KEY `idx_cuotas_prestamo` (`prestamo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuotas`
--

LOCK TABLES `cuotas` WRITE;
/*!40000 ALTER TABLE `cuotas` DISABLE KEYS */;
INSERT INTO `cuotas` VALUES (9,2,1,'2026-06-22',275.00,275.00,0.00,'pagada'),(10,2,2,'2026-06-29',275.00,275.00,0.00,'pagada'),(11,2,3,'2026-07-06',275.00,275.00,0.00,'pagada'),(12,2,4,'2026-07-13',275.00,275.00,0.00,'pagada'),(53,8,1,'2026-06-29',1000.00,1000.00,0.00,'pagada'),(54,8,2,'2026-07-06',1000.00,1000.00,0.00,'pagada'),(55,8,3,'2026-07-13',1000.00,1000.00,0.00,'pagada'),(56,8,4,'2026-07-20',1000.00,1000.00,0.00,'pagada'),(57,8,5,'2026-07-27',1000.00,1000.00,0.00,'pagada'),(58,8,6,'2026-08-03',1000.00,1000.00,0.00,'pagada'),(59,8,7,'2026-08-10',1000.00,1000.00,0.00,'pagada'),(60,8,8,'2026-08-17',1000.00,1000.00,0.00,'pagada'),(61,8,9,'2026-08-24',1000.00,1000.00,0.00,'pagada'),(62,8,10,'2026-08-31',1000.00,1000.00,0.00,'pagada'),(63,8,11,'2026-09-07',1000.00,1000.00,0.00,'pagada'),(64,8,12,'2026-09-16',1000.00,1000.00,0.00,'pagada'),(65,9,1,'2026-06-29',1000.00,1000.00,0.00,'pagada'),(66,9,2,'2026-07-06',1000.00,1000.00,0.00,'pagada'),(67,9,3,'2026-07-13',1000.00,1000.00,0.00,'pagada'),(68,9,4,'2026-07-20',1000.00,1000.00,0.00,'pagada'),(69,9,5,'2026-07-27',1000.00,1000.00,0.00,'pagada'),(70,9,6,'2026-08-03',1000.00,1000.00,0.00,'pagada'),(71,9,7,'2026-08-10',1000.00,1000.00,0.00,'pagada'),(72,9,8,'2026-08-17',1000.00,1000.00,0.00,'pagada'),(73,9,9,'2026-08-24',1000.00,1000.00,0.00,'pagada'),(74,9,10,'2026-08-31',1000.00,1000.00,0.00,'pagada'),(75,9,11,'2026-09-07',1000.00,1000.00,0.00,'pagada'),(76,9,12,'2026-09-16',1000.00,1000.00,0.00,'pagada'),(77,10,1,'2026-06-25',108.00,0.00,NULL,'pendiente'),(78,10,2,'2026-06-26',108.00,0.00,NULL,'pendiente'),(79,10,3,'2026-06-27',108.00,0.00,NULL,'pendiente'),(80,10,4,'2026-06-29',108.00,0.00,NULL,'pendiente'),(81,10,5,'2026-06-30',108.00,0.00,NULL,'pendiente'),(82,10,6,'2026-07-01',108.00,0.00,NULL,'pendiente'),(83,10,7,'2026-07-02',108.00,0.00,NULL,'pendiente'),(84,10,8,'2026-07-03',108.00,0.00,NULL,'pendiente'),(85,10,9,'2026-07-04',108.00,0.00,NULL,'pendiente'),(86,10,10,'2026-07-06',108.00,0.00,NULL,'pendiente'),(87,10,11,'2026-07-07',108.00,0.00,NULL,'pendiente'),(88,10,12,'2026-07-08',108.00,0.00,NULL,'pendiente'),(89,10,13,'2026-07-09',108.00,0.00,NULL,'pendiente'),(90,10,14,'2026-07-10',108.00,0.00,NULL,'pendiente'),(91,10,15,'2026-07-11',108.00,0.00,NULL,'pendiente'),(92,10,16,'2026-07-13',108.00,0.00,NULL,'pendiente'),(93,10,17,'2026-07-14',108.00,0.00,NULL,'pendiente'),(94,10,18,'2026-07-15',108.00,0.00,NULL,'pendiente'),(95,10,19,'2026-07-16',108.00,0.00,NULL,'pendiente'),(96,10,20,'2026-07-17',108.00,0.00,NULL,'pendiente'),(97,10,21,'2026-07-18',108.00,0.00,NULL,'pendiente'),(98,10,22,'2026-07-20',108.00,0.00,NULL,'pendiente'),(99,10,23,'2026-07-21',108.00,0.00,NULL,'pendiente'),(100,10,24,'2026-07-22',108.00,0.00,NULL,'pendiente'),(101,10,25,'2026-07-23',108.00,0.00,NULL,'pendiente'),(102,10,26,'2026-07-24',108.00,0.00,NULL,'pendiente'),(103,10,27,'2026-07-25',108.00,0.00,NULL,'pendiente'),(104,10,28,'2026-07-27',108.00,0.00,NULL,'pendiente'),(105,10,29,'2026-07-28',108.00,0.00,NULL,'pendiente'),(106,10,30,'2026-07-29',108.00,0.00,NULL,'pendiente'),(107,11,1,'2026-06-25',108.00,0.00,NULL,'pendiente'),(108,11,2,'2026-06-26',108.00,0.00,NULL,'pendiente'),(109,11,3,'2026-06-27',108.00,0.00,NULL,'pendiente'),(110,11,4,'2026-06-29',108.00,0.00,NULL,'pendiente'),(111,11,5,'2026-06-30',108.00,0.00,NULL,'pendiente'),(112,11,6,'2026-07-01',108.00,0.00,NULL,'pendiente'),(113,11,7,'2026-07-02',108.00,0.00,NULL,'pendiente'),(114,11,8,'2026-07-03',108.00,0.00,NULL,'pendiente'),(115,11,9,'2026-07-04',108.00,0.00,NULL,'pendiente'),(116,11,10,'2026-07-06',108.00,0.00,NULL,'pendiente'),(117,11,11,'2026-07-07',108.00,0.00,NULL,'pendiente'),(118,11,12,'2026-07-08',108.00,0.00,NULL,'pendiente'),(119,11,13,'2026-07-09',108.00,0.00,NULL,'pendiente'),(120,11,14,'2026-07-10',108.00,0.00,NULL,'pendiente'),(121,11,15,'2026-07-11',108.00,0.00,NULL,'pendiente'),(122,11,16,'2026-07-13',108.00,0.00,NULL,'pendiente'),(123,11,17,'2026-07-14',108.00,0.00,NULL,'pendiente'),(124,11,18,'2026-07-15',108.00,0.00,NULL,'pendiente'),(125,11,19,'2026-07-16',108.00,0.00,NULL,'pendiente'),(126,11,20,'2026-07-17',108.00,0.00,NULL,'pendiente'),(127,11,21,'2026-07-18',108.00,0.00,NULL,'pendiente'),(128,11,22,'2026-07-20',108.00,0.00,NULL,'pendiente'),(129,11,23,'2026-07-21',108.00,0.00,NULL,'pendiente'),(130,11,24,'2026-07-22',108.00,0.00,NULL,'pendiente'),(131,11,25,'2026-07-23',108.00,0.00,NULL,'pendiente'),(132,11,26,'2026-07-24',108.00,0.00,NULL,'pendiente'),(133,11,27,'2026-07-25',108.00,0.00,NULL,'pendiente'),(134,11,28,'2026-07-27',108.00,0.00,NULL,'pendiente'),(135,11,29,'2026-07-28',108.00,0.00,NULL,'pendiente'),(136,11,30,'2026-07-29',108.00,0.00,NULL,'pendiente'),(137,12,1,'2026-06-25',108.00,108.00,0.00,'pagada'),(138,12,2,'2026-06-26',108.00,108.00,0.00,'pagada'),(139,12,3,'2026-06-27',108.00,108.00,0.00,'pagada'),(140,12,4,'2026-06-29',108.00,0.00,NULL,'pendiente'),(141,12,5,'2026-06-30',108.00,0.00,NULL,'pendiente'),(142,12,6,'2026-07-01',108.00,0.00,NULL,'pendiente'),(143,12,7,'2026-07-02',108.00,0.00,NULL,'pendiente'),(144,12,8,'2026-07-03',108.00,0.00,NULL,'pendiente'),(145,12,9,'2026-07-04',108.00,0.00,NULL,'pendiente'),(146,12,10,'2026-07-06',108.00,0.00,NULL,'pendiente'),(147,12,11,'2026-07-07',108.00,0.00,NULL,'pendiente'),(148,12,12,'2026-07-08',108.00,0.00,NULL,'pendiente'),(149,12,13,'2026-07-09',108.00,0.00,NULL,'pendiente'),(150,12,14,'2026-07-10',108.00,0.00,NULL,'pendiente'),(151,12,15,'2026-07-11',108.00,0.00,NULL,'pendiente'),(152,12,16,'2026-07-13',108.00,0.00,NULL,'pendiente'),(153,12,17,'2026-07-14',108.00,0.00,NULL,'pendiente'),(154,12,18,'2026-07-15',108.00,0.00,NULL,'pendiente'),(155,12,19,'2026-07-16',108.00,0.00,NULL,'pendiente'),(156,12,20,'2026-07-17',108.00,0.00,NULL,'pendiente'),(157,12,21,'2026-07-18',108.00,0.00,NULL,'pendiente'),(158,12,22,'2026-07-20',108.00,0.00,NULL,'pendiente'),(159,12,23,'2026-07-21',108.00,0.00,NULL,'pendiente'),(160,12,24,'2026-07-22',108.00,0.00,NULL,'pendiente'),(161,12,25,'2026-07-23',108.00,0.00,NULL,'pendiente'),(162,12,26,'2026-07-24',108.00,0.00,NULL,'pendiente'),(163,12,27,'2026-07-25',108.00,0.00,NULL,'pendiente'),(164,12,28,'2026-07-27',108.00,0.00,NULL,'pendiente'),(165,12,29,'2026-07-28',108.00,0.00,NULL,'pendiente'),(166,12,30,'2026-07-29',108.00,0.00,NULL,'pendiente');
/*!40000 ALTER TABLE `cuotas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departamentos`
--

DROP TABLE IF EXISTS `departamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamentos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamentos`
--

LOCK TABLES `departamentos` WRITE;
/*!40000 ALTER TABLE `departamentos` DISABLE KEYS */;
INSERT INTO `departamentos` VALUES (1,'Chinandega'),(2,'León');
/*!40000 ALTER TABLE `departamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fiadores`
--

DROP TABLE IF EXISTS `fiadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fiadores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prestamo_id` int DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `cedula` varchar(50) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` text,
  `parentesco` varchar(50) DEFAULT NULL,
  `sexo` varchar(10) DEFAULT NULL,
  `estado_civil` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prestamo_id` (`prestamo_id`),
  CONSTRAINT `fiadores_ibfk_1` FOREIGN KEY (`prestamo_id`) REFERENCES `prestamos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fiadores`
--

LOCK TABLES `fiadores` WRITE;
/*!40000 ALTER TABLE `fiadores` DISABLE KEYS */;
INSERT INTO `fiadores` VALUES (2,9,'Edgard Francisco Cuevas Guerrero','086  221108 1000J','+505 83919131','de la entrada 2 cudaras y media al norte','amigo','M','soltero');
/*!40000 ALTER TABLE `fiadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moras_mensuales`
--

DROP TABLE IF EXISTS `moras_mensuales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moras_mensuales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prestamo_id` int NOT NULL,
  `fecha` date DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'pendiente',
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ciclo` varchar(7) DEFAULT NULL,
  `total_base` decimal(10,2) DEFAULT NULL,
  `tasa_mora` decimal(5,2) DEFAULT NULL,
  `mora_calculada` decimal(10,2) DEFAULT NULL,
  `fecha_calculo` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unico_prestamo_ciclo` (`prestamo_id`,`ciclo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moras_mensuales`
--

LOCK TABLES `moras_mensuales` WRITE;
/*!40000 ALTER TABLE `moras_mensuales` DISABLE KEYS */;
INSERT INTO `moras_mensuales` VALUES (4,3,NULL,'aplicada','2026-06-17 17:37:12','2026-07',1500.00,2.00,30.00,'2026-06-17'),(5,5,NULL,'aplicada','2026-06-18 13:47:13','2026-07',5000.00,2.00,100.00,'2026-06-18');
/*!40000 ALTER TABLE `moras_mensuales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moras_mensuales_cuotas`
--

DROP TABLE IF EXISTS `moras_mensuales_cuotas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `moras_mensuales_cuotas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mora_mensual_id` int NOT NULL,
  `cuota_id` int NOT NULL,
  `monto_asignado` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moras_mensuales_cuotas`
--

LOCK TABLES `moras_mensuales_cuotas` WRITE;
/*!40000 ALTER TABLE `moras_mensuales_cuotas` DISABLE KEYS */;
INSERT INTO `moras_mensuales_cuotas` VALUES (3,4,15,0.00),(4,5,35,0.00);
/*!40000 ALTER TABLE `moras_mensuales_cuotas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `municipios`
--

DROP TABLE IF EXISTS `municipios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `municipios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `departamento_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `municipios`
--

LOCK TABLES `municipios` WRITE;
/*!40000 ALTER TABLE `municipios` DISABLE KEYS */;
INSERT INTO `municipios` VALUES (1,'Chinandega',1),(2,'El Viejo',1),(3,'Corinto',1),(4,'Chichigalpa',1),(5,'Posoltega',1),(6,'Somotillo',1),(7,'León',2),(8,'Nagarote',2),(9,'La Paz Centro',2),(10,'Telica',2),(11,'Quezalguaque',2);
/*!40000 ALTER TABLE `municipios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cuota_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pagos_cuota` (`cuota_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
INSERT INTO `pagos` VALUES (1,1,1,1500.00,'2026-06-15 20:37:19'),(2,2,1,1000.00,'2026-06-15 20:37:25'),(3,2,1,500.00,'2026-06-15 20:44:43'),(4,3,1,1500.00,'2026-06-15 20:44:45'),(5,4,1,1500.00,'2026-06-15 20:44:46'),(6,5,1,1500.00,'2026-06-15 20:44:48'),(7,6,1,1500.00,'2026-06-15 20:44:49'),(8,7,1,1500.00,'2026-06-15 20:44:51'),(9,8,1,1500.00,'2026-06-15 20:44:52'),(10,13,1,3000.00,'2026-06-17 17:05:00'),(11,14,1,1500.00,'2026-06-17 17:05:05'),(12,14,1,1500.00,'2026-06-17 17:58:26'),(13,15,1,3030.00,'2026-06-17 17:58:28'),(14,16,1,3000.00,'2026-06-17 17:58:30'),(15,9,1,275.00,'2026-06-17 17:58:34'),(16,10,1,275.00,'2026-06-17 17:58:35'),(17,11,1,275.00,'2026-06-17 17:58:36'),(18,12,1,275.00,'2026-06-17 17:58:37'),(19,17,1,1000.00,'2026-06-17 17:59:37'),(20,18,1,1000.00,'2026-06-17 17:59:38'),(21,19,1,1000.00,'2026-06-17 17:59:39'),(22,20,1,1000.00,'2026-06-17 17:59:40'),(23,21,1,1000.00,'2026-06-17 17:59:41'),(24,22,1,1000.00,'2026-06-17 17:59:42'),(25,23,1,1000.00,'2026-06-17 17:59:44'),(26,24,1,1000.00,'2026-06-17 17:59:46'),(27,25,1,1000.00,'2026-06-17 17:59:47'),(28,26,1,1000.00,'2026-06-17 17:59:51'),(29,27,1,1000.00,'2026-06-17 17:59:55'),(30,28,1,1000.00,'2026-06-17 17:59:56'),(31,29,1,1000.00,'2026-06-18 14:50:56'),(32,30,1,1000.00,'2026-06-18 14:50:57'),(33,31,1,1000.00,'2026-06-18 14:51:00'),(34,32,1,1000.00,'2026-06-18 14:51:01'),(35,33,1,1000.00,'2026-06-18 14:51:04'),(36,34,1,1000.00,'2026-06-18 14:51:05'),(37,35,1,1100.00,'2026-06-18 14:51:07'),(38,36,1,1000.00,'2026-06-18 14:51:09'),(39,37,1,1000.00,'2026-06-18 14:51:10'),(40,38,1,1000.00,'2026-06-18 14:51:11'),(41,39,1,1000.00,'2026-06-18 14:51:13'),(42,40,1,1000.00,'2026-06-18 14:51:14'),(43,41,1,1000.00,'2026-06-21 19:23:22'),(44,53,1,1000.00,'2026-06-21 23:38:07'),(45,54,1,1000.00,'2026-06-21 23:41:15'),(46,55,1,1000.00,'2026-06-22 13:25:16'),(47,65,2,1000.00,'2026-06-22 13:44:04'),(48,66,2,1000.00,'2026-06-22 13:51:08'),(49,42,1,1000.00,'2026-06-24 20:01:55'),(50,43,1,1000.00,'2026-06-24 20:01:56'),(51,44,1,1000.00,'2026-06-24 20:01:58'),(52,45,1,1000.00,'2026-06-24 20:01:59'),(53,46,1,1000.00,'2026-06-24 20:02:02'),(54,47,1,1000.00,'2026-06-24 20:02:03'),(55,48,1,1000.00,'2026-06-24 20:02:04'),(56,49,1,1000.00,'2026-06-24 20:02:06'),(57,50,1,1000.00,'2026-06-24 20:02:07'),(58,51,1,1000.00,'2026-06-24 20:02:09'),(59,52,1,1000.00,'2026-06-24 20:02:11'),(60,56,1,1000.00,'2026-06-24 20:02:59'),(61,57,1,1000.00,'2026-06-24 20:03:01'),(62,58,1,1000.00,'2026-06-24 20:03:02'),(63,59,1,1000.00,'2026-06-24 20:03:04'),(64,60,1,1000.00,'2026-06-24 20:03:06'),(65,61,1,1000.00,'2026-06-24 20:03:07'),(66,62,1,1000.00,'2026-06-24 20:03:09'),(67,63,1,1000.00,'2026-06-24 20:03:10'),(68,64,1,1000.00,'2026-06-24 20:03:12'),(69,67,1,1000.00,'2026-06-24 20:03:41'),(70,68,1,1000.00,'2026-06-24 20:03:43'),(71,69,1,1000.00,'2026-06-24 20:03:44'),(72,70,1,1000.00,'2026-06-24 20:03:45'),(73,71,1,1000.00,'2026-06-24 20:03:47'),(74,72,1,1000.00,'2026-06-24 20:03:48'),(75,73,1,1000.00,'2026-06-24 20:03:51'),(76,74,1,1000.00,'2026-06-24 20:03:53'),(77,75,1,1000.00,'2026-06-24 20:03:54'),(78,76,1,1000.00,'2026-06-24 20:03:55'),(79,137,1,108.00,'2026-06-26 13:33:56'),(80,138,1,108.00,'2026-06-26 13:40:18'),(81,139,1,108.00,'2026-06-26 13:40:25');
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prestamos`
--

DROP TABLE IF EXISTS `prestamos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prestamos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `interes` decimal(5,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `plazo` int NOT NULL,
  `tipo_cuota` varchar(20) NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'activo',
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo_respaldo` enum('fiador','garantia') NOT NULL,
  `garantia` text,
  PRIMARY KEY (`id`),
  KEY `idx_prestamos_cliente` (`cliente_id`),
  KEY `idx_prestamos_estado` (`estado`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prestamos`
--

LOCK TABLES `prestamos` WRITE;
/*!40000 ALTER TABLE `prestamos` DISABLE KEYS */;
INSERT INTO `prestamos` VALUES (2,2,2,1000.00,10.00,1100.00,1,'semanal','2026-06-15','finalizado','2026-06-15 20:50:11','fiador',NULL),(8,3,1,10000.00,20.00,12000.00,3,'semanal','2026-06-21','finalizado','2026-06-21 23:37:50','garantia','Una moto Luky 2019\nUna estufa marca Stamer 2013\nun gabetero de 5 puertas'),(9,2,2,10000.00,20.00,12000.00,3,'semanal','2026-06-22','finalizado','2026-06-22 13:43:16','fiador',NULL),(10,4,2,2700.00,20.00,3240.00,1,'diaria','2026-06-24','activo','2026-06-24 20:07:19','garantia','Dos abanicos de 3 piezas\nuna cama Queen side matrimonial\ndos bisicletas de gama alta '),(11,2,2,2700.00,20.00,3240.00,1,'diaria','2026-06-24','activo','2026-06-24 20:08:13','garantia','casa de 3 pisos en el sur del pais'),(12,3,1,2700.00,20.00,3240.00,1,'diaria','2026-06-24','activo','2026-06-24 20:10:16','garantia','jd;awhdf;adhf;kahds;fka;kdfv');
/*!40000 ALTER TABLE `prestamos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recordatorios`
--

DROP TABLE IF EXISTS `recordatorios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recordatorios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `texto` text NOT NULL,
  `fecha_recordatorio` date DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'pendiente',
  `fecha_hecho` date DEFAULT NULL,
  `fecha_creado` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_recordatorios_cliente` (`cliente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recordatorios`
--

LOCK TABLES `recordatorios` WRITE;
/*!40000 ALTER TABLE `recordatorios` DISABLE KEYS */;
INSERT INTO `recordatorios` VALUES (2,4,2,'Pasar manana hasta las 5 de la tarde','2026-06-25','hecho','2026-06-26','2026-06-24 20:09:20'),(3,3,1,'Decirle al usuario 2 que pase a cobrarle','2026-06-25','pendiente',NULL,'2026-06-24 20:10:56'),(4,4,1,'pasar a las tres de la tarde','2026-06-26','pendiente',NULL,'2026-06-26 13:35:44');
/*!40000 ALTER TABLE `recordatorios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'administrador'),(2,'trabajador');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trabajos`
--

DROP TABLE IF EXISTS `trabajos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trabajos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trabajos`
--

LOCK TABLES `trabajos` WRITE;
/*!40000 ALTER TABLE `trabajos` DISABLE KEYS */;
INSERT INTO `trabajos` VALUES (1,'BLOQUERA'),(2,'CALZADO NUEVO'),(3,'CALZADO USADO'),(4,'CARNE DE RES Y CERDO'),(5,'CARPINTERIAS'),(6,'CELULARES Y ACCESORIOS'),(7,'CENTRO DE EDUCACION PRIVADA'),(8,'CERDOS EN PIE'),(9,'CHATARRA'),(10,'CHINERIA EN GENERAL'),(11,'CLINICA PRIVADA DE SALUD'),(12,'COMIDA AMBULANTE'),(13,'COMIDA RAPIDA'),(14,'COMPUTADORAS Y ACCESORIOS'),(15,'CONSULTORIO MEDICO, SICOLOGICO, ODONTOLOGICO'),(16,'CONSULTORIOS DENTISTAS'),(17,'CONSULTORIOS MEDICOS'),(18,'CONTRATISTA'),(19,'EBANISTERIA'),(20,'ELECTRODOMESTICOS'),(21,'ESPECIES Y CONDIMENTOS'),(22,'ESTILISTA A DOMICILIO'),(23,'FARMACIA'),(24,'FERRETERIA'),(25,'FRITANGA'),(26,'FRUTAS'),(27,'ABARROTERIA'),(28,'ACARREO COMERCIAL'),(29,'ALGODON DE AZUCAR PALOMITAS Y OTROS DULCES'),(30,'ASALARIADO PRIVADO'),(31,'ASALARIADO PUBLICO'),(32,'ATELIE'),(33,'AUTO LAVADO'),(34,'AUTO PARTES Y LUBRICANTES'),(35,'AUTOLAVADOS'),(36,'BAR Y COMEDOR'),(37,'BARBERIA'),(38,'BILLARES'),(39,'MERCADERIA EN GENERAL'),(40,'MODISTA'),(41,'MOLINO'),(42,'MOTEL'),(43,'MUEBLERIA'),(44,'NACATAMALES, SOPAS, COMIDAS'),(45,'PAN Y REFRESCOS'),(46,'PANADERIAS'),(47,'PENSIONADOS'),(48,'PERECEDEROS'),(49,'PLASTICOS VARIADOS'),(50,'POLLO Y HUEVOS'),(51,'PRODUCTOS DE ASEO Y LIMPIEZA'),(52,'PUBLICIDAD'),(53,'PULGUERO'),(54,'PULPERIAS'),(55,'PUPUSAS'),(56,'RECICLAJE DE PLASTICOS'),(57,'REFRESQUERIA Y REPOSTERIA'),(58,'REMESAS ACTIVAS'),(59,'REPARACION DE CELULARES'),(60,'REPARACION DE COMPUTADORAS'),(61,'REPUESTOS DE BICICLETA Y MOTOCICLETA'),(62,'ROPA USADA'),(63,'SALON DE BELLEZA'),(64,'SASTRERIA'),(65,'SUBLIMACION Y SERIGRAFIA'),(66,'TALLER ARTESANAL DE PRODUCTOS DE ALUMINIO'),(67,'TALLER DE ALUMINIO Y VIDRIO'),(68,'TALLER DE ARTESANIAS'),(69,'TALLER DE ELECTRICIDAD'),(70,'TALLER DE ELECTROMECANICA'),(71,'TALLER DE MECANICA'),(72,'TALLER DE MOTOCICLETA'),(73,'TALLER DE SOLDADURA'),(74,'TALLER DE TRISICLOS'),(75,'TAPICERIA Y TALABARTERIAS'),(76,'TAXI'),(77,'TIENDA DE ROPA NUEVA'),(78,'TORTILLERIA, GUIRILAS, PUPUSAS'),(79,'TRANSPORTE DE BUSES EXPRESOS'),(80,'TRANSPORTE DE BUSES RUTEADOS'),(81,'TRANSPORTE DE RUTAS INTERLOCALES'),(82,'TRANSPORTE RUTAS LOCALES'),(83,'TRANSPORTE TRICICLO'),(84,'VENTA DE BISUTERIAS'),(85,'VENTA DE DESAYUNOS Y ALMUERSOS'),(86,'VENTA DE QUESO'),(87,'VENTA DE REFRESCOS'),(88,'VENTA DE ROPA NUEVA'),(89,'VENTA DE VERDURAS'),(90,'VIGORON Y CHANCHO CON YUCA'),(91,'VISUTERIA'),(92,'VULCANIZACION'),(93,'FUNERARIA'),(94,'GANADO EN PIE'),(95,'GRANJA AVIAR'),(96,'GRANJA PORCINA'),(97,'KIOSCOS ESCOLARES'),(98,'LABORATORIO CLINICO'),(99,'LACTEOS Y DERIVADOS'),(100,'LIBRERIA'),(101,'LICORERIA'),(102,'MANUALIDADES Y ARREGLOS'),(103,'MARISCOS'),(104,'MEDICINA NATURAL'),(105,'MEDICINA POPULAR');
/*!40000 ALTER TABLE `trabajos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol_id` int NOT NULL,
  `activo` tinyint DEFAULT '1',
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Administrador','admin','$2b$10$mBt57z02f/8Xz.UAQ9j07.qTrlcfo6yF4W8QK5XUwgGiApeev0bSi',1,1,'2026-06-15 20:28:02'),(2,'Edgard Francisco Cuevas Guerrero','edgard1','$2b$10$leaU3TQ7/GAyJk54TEdpw.PAc7/GWmdaFGYIymJzBYtNwMkoQZ4HO',2,1,'2026-06-15 20:46:41');
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

-- Dump completed on 2026-06-26  7:54:44
