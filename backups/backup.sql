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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barrios`
--

LOCK TABLES `barrios` WRITE;
/*!40000 ALTER TABLE `barrios` DISABLE KEYS */;
INSERT INTO `barrios` VALUES (1,'Lotificación San Juan',2,'activo');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Edgard Cuevas','0862211081000J','M','+505 83919131',1,2,1,'urb san juan 1c N 1 C S. 25 VRS N.',30,1,'soltero','2026-06-15 20:35:47'),(2,'Ernesto Caseres Sutiava Nicaragua','08503060734567D','M','+505 4563 4211',2,7,NULL,'de la entrada 2 cuadras y media al norte',33,2,'casado','2026-06-15 20:49:27');
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
INSERT INTO `comentarios_clientes` VALUES (1,1,'Es un muy buen cliente','2026-06-15 20:36:09');
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cuotas`
--

LOCK TABLES `cuotas` WRITE;
/*!40000 ALTER TABLE `cuotas` DISABLE KEYS */;
INSERT INTO `cuotas` VALUES (1,1,1,'2026-06-05',1500.00,1500.00,0.00,'pagada'),(2,1,2,'2026-06-29',1500.00,1500.00,0.00,'pagada'),(3,1,3,'2026-07-06',1500.00,1500.00,0.00,'pagada'),(4,1,4,'2026-07-13',1500.00,1500.00,0.00,'pagada'),(5,1,5,'2026-07-20',1500.00,1500.00,0.00,'pagada'),(6,1,6,'2026-07-27',1500.00,1500.00,0.00,'pagada'),(7,1,7,'2026-08-03',1500.00,1500.00,0.00,'pagada'),(8,1,8,'2026-08-10',1500.00,1500.00,0.00,'pagada'),(9,2,1,'2026-06-22',275.00,275.00,0.00,'pagada'),(10,2,2,'2026-06-29',275.00,275.00,0.00,'pagada'),(11,2,3,'2026-07-06',275.00,275.00,0.00,'pagada'),(12,2,4,'2026-07-13',275.00,275.00,0.00,'pagada'),(13,3,1,'2026-07-02',3000.00,3000.00,0.00,'pagada'),(14,3,2,'2026-07-17',3000.00,3000.00,0.00,'pagada'),(15,3,3,'2026-08-01',3000.00,3030.00,0.00,'pagada'),(16,3,4,'2026-08-17',3000.00,3000.00,0.00,'pagada'),(17,4,1,'2026-06-24',1000.00,1000.00,0.00,'pagada'),(18,4,2,'2026-07-01',1000.00,1000.00,0.00,'pagada'),(19,4,3,'2026-07-08',1000.00,1000.00,0.00,'pagada'),(20,4,4,'2026-07-15',1000.00,1000.00,0.00,'pagada'),(21,4,5,'2026-07-22',1000.00,1000.00,0.00,'pagada'),(22,4,6,'2026-07-29',1000.00,1000.00,0.00,'pagada'),(23,4,7,'2026-08-05',1000.00,1000.00,0.00,'pagada'),(24,4,8,'2026-08-12',1000.00,1000.00,0.00,'pagada'),(25,4,9,'2026-08-19',1000.00,1000.00,0.00,'pagada'),(26,4,10,'2026-08-26',1000.00,1000.00,0.00,'pagada'),(27,4,11,'2026-09-02',1000.00,1000.00,0.00,'pagada'),(28,4,12,'2026-09-09',1000.00,1000.00,0.00,'pagada'),(29,5,1,'2026-06-24',1000.00,1000.00,0.00,'pagada'),(30,5,2,'2026-07-01',1000.00,1000.00,0.00,'pagada'),(31,5,3,'2026-07-08',1000.00,1000.00,0.00,'pagada'),(32,5,4,'2026-07-15',1000.00,1000.00,0.00,'pagada'),(33,5,5,'2026-07-22',1000.00,1000.00,0.00,'pagada'),(34,5,6,'2026-07-29',1000.00,1000.00,0.00,'pagada'),(35,5,7,'2026-08-05',1000.00,1100.00,0.00,'pagada'),(36,5,8,'2026-08-12',1000.00,1000.00,0.00,'pagada'),(37,5,9,'2026-08-19',1000.00,1000.00,0.00,'pagada'),(38,5,10,'2026-08-26',1000.00,1000.00,0.00,'pagada'),(39,5,11,'2026-09-02',1000.00,1000.00,0.00,'pagada'),(40,5,12,'2026-09-09',1000.00,1000.00,0.00,'pagada');
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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
INSERT INTO `pagos` VALUES (1,1,1,1500.00,'2026-06-15 20:37:19'),(2,2,1,1000.00,'2026-06-15 20:37:25'),(3,2,1,500.00,'2026-06-15 20:44:43'),(4,3,1,1500.00,'2026-06-15 20:44:45'),(5,4,1,1500.00,'2026-06-15 20:44:46'),(6,5,1,1500.00,'2026-06-15 20:44:48'),(7,6,1,1500.00,'2026-06-15 20:44:49'),(8,7,1,1500.00,'2026-06-15 20:44:51'),(9,8,1,1500.00,'2026-06-15 20:44:52'),(10,13,1,3000.00,'2026-06-17 17:05:00'),(11,14,1,1500.00,'2026-06-17 17:05:05'),(12,14,1,1500.00,'2026-06-17 17:58:26'),(13,15,1,3030.00,'2026-06-17 17:58:28'),(14,16,1,3000.00,'2026-06-17 17:58:30'),(15,9,1,275.00,'2026-06-17 17:58:34'),(16,10,1,275.00,'2026-06-17 17:58:35'),(17,11,1,275.00,'2026-06-17 17:58:36'),(18,12,1,275.00,'2026-06-17 17:58:37'),(19,17,1,1000.00,'2026-06-17 17:59:37'),(20,18,1,1000.00,'2026-06-17 17:59:38'),(21,19,1,1000.00,'2026-06-17 17:59:39'),(22,20,1,1000.00,'2026-06-17 17:59:40'),(23,21,1,1000.00,'2026-06-17 17:59:41'),(24,22,1,1000.00,'2026-06-17 17:59:42'),(25,23,1,1000.00,'2026-06-17 17:59:44'),(26,24,1,1000.00,'2026-06-17 17:59:46'),(27,25,1,1000.00,'2026-06-17 17:59:47'),(28,26,1,1000.00,'2026-06-17 17:59:51'),(29,27,1,1000.00,'2026-06-17 17:59:55'),(30,28,1,1000.00,'2026-06-17 17:59:56'),(31,29,1,1000.00,'2026-06-18 14:50:56'),(32,30,1,1000.00,'2026-06-18 14:50:57'),(33,31,1,1000.00,'2026-06-18 14:51:00'),(34,32,1,1000.00,'2026-06-18 14:51:01'),(35,33,1,1000.00,'2026-06-18 14:51:04'),(36,34,1,1000.00,'2026-06-18 14:51:05'),(37,35,1,1100.00,'2026-06-18 14:51:07'),(38,36,1,1000.00,'2026-06-18 14:51:09'),(39,37,1,1000.00,'2026-06-18 14:51:10'),(40,38,1,1000.00,'2026-06-18 14:51:11'),(41,39,1,1000.00,'2026-06-18 14:51:13'),(42,40,1,1000.00,'2026-06-18 14:51:14');
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
  PRIMARY KEY (`id`),
  KEY `idx_prestamos_cliente` (`cliente_id`),
  KEY `idx_prestamos_estado` (`estado`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prestamos`
--

LOCK TABLES `prestamos` WRITE;
/*!40000 ALTER TABLE `prestamos` DISABLE KEYS */;
INSERT INTO `prestamos` VALUES (1,1,1,10000.00,20.00,12000.00,2,'semanal','2026-06-15','finalizado','2026-06-15 20:37:06'),(2,2,2,1000.00,10.00,1100.00,1,'semanal','2026-06-15','finalizado','2026-06-15 20:50:11'),(3,1,1,10000.00,20.00,12000.00,2,'quincenal','2026-06-17','finalizado','2026-06-17 14:21:25'),(4,1,1,10000.00,20.00,12000.00,3,'semanal','2026-06-17','finalizado','2026-06-17 17:59:09'),(5,1,1,10000.00,20.00,12000.00,3,'semanal','2026-06-17','finalizado','2026-06-17 18:01:58');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recordatorios`
--

LOCK TABLES `recordatorios` WRITE;
/*!40000 ALTER TABLE `recordatorios` DISABLE KEYS */;
INSERT INTO `recordatorios` VALUES (1,1,1,'pasar manana a las 5 de la tarde','2026-06-16','pendiente',NULL,'2026-06-15 20:36:36');
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

-- Dump completed on 2026-06-18 10:33:15
