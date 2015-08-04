CREATE DATABASE  IF NOT EXISTS `aggregator` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `aggregator`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: taws02_dbi    Database: aggregator
-- ------------------------------------------------------
-- Server version	5.5.5-10.0.16-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `features_product_mapping`
--

DROP TABLE IF EXISTS `features_product_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `features_product_mapping` (
  `lmi_Ref` varchar(45) NOT NULL,
  `ctm_ProductId` varchar(45) NOT NULL,
  PRIMARY KEY (`lmi_Ref`),
  KEY `ctm_productId` (`ctm_ProductId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `features_product_mapping`
--

LOCK TABLES `features_product_mapping` WRITE;
/*!40000 ALTER TABLE `features_product_mapping` DISABLE KEYS */;
INSERT INTO `features_product_mapping` VALUES ('1st-Car_0514_18137','1FOW-05-02'),('ClassicPlusCar_0914_19544','AI-01-01'),('CompCar_V4_0615_20434','AI-01-02'),('SmartBoxCar_0615_20435','AI-01-03'),('Budget-SD-Car_0514_18128','BUDD-05-01'),('Budget-Gold-Car_0514_18131','BUDD-05-04'),('Budget-SmartHome_1014_19970','BUDD-05-29'),('Budget-SmartHome_1014_19971','BUDD-05-29'),('Dodo-car_1014_22332','EXDD-05-04'),('AustPost-Gold-Car_0614_19467','EXPO-05-13'),('Ozicare-Gold-Car_0514_18134','OZIC-05-04'),('016_29052009_10297','REIN-01-01'),('054_0412_13251','REIN-01-02'),('056_0612_15041','REIN-02-01'),('056_0612_15155','REIN-02-02'),('Retirease-Car_0514_18140','RETI-05-03'),('Virgin-Car-PS_0714_19212','VIRG-05-17'),('Virgin-Home_0513_17152','VIRG-05-26'),('Virgin-Home_0513_17153','VIRG-05-26'),('053_0412_13486','WOOL-01-01'),('053_0412_16469','WOOL-01-02'),('056_0612_14371','WOOL-02-01'),('056_0612_14547','WOOL-02-02');
/*!40000 ALTER TABLE `features_product_mapping` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-07-22 16:42:33
