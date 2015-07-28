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
-- Table structure for table `features_category`
--

DROP TABLE IF EXISTS `features_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `features_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `sequence` int(3) DEFAULT NULL,
  `vertical` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=709 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `features_category`
--

LOCK TABLES `features_category` WRITE;
/*!40000 ALTER TABLE `features_category` DISABLE KEYS */;
INSERT INTO `features_category` VALUES (599,'Type of Policy',1,'CAR'),(600,'Part of Vehicle Definition',3,'CAR'),(601,'Features and Benefits - Comprehensive Policies',2,'CAR'),(602,'Features and Benefits - Third Party Property Damage',8,'CAR'),(603,'Features and Benefits - Third Party Fire and Theft',7,'CAR'),(604,'Legal Liability',4,'CAR'),(605,'Excess',5,'CAR'),(606,'Conditions and Exclusions',9,'CAR'),(607,'Additional Information',6,'CAR'),(622,'Type of Cover',1,'HOME'),(623,'Basis of Cover',2,'HOME'),(624,'Related Benefits',7,'HOME'),(625,'Limits of Cover at Risk Address',4,'HOME'),(626,'Personal Effects and Valuables (additional to Temporary Removal)',8,'HOME'),(627,'Workers Compensation',14,'HOME'),(628,'Legal Liability',5,'HOME'),(629,'Occupancy of Building',13,'HOME'),(630,'Definition',3,'HOME'),(631,'Part of Building Definition',9,'HOME'),(632,'Part of Contents Definition',10,'HOME'),(633,'Exclusions and Conditions',12,'HOME'),(634,'Separate Basis of Settlement Clause',11,'HOME'),(635,'Additional Information',6,'HOME'),(645,'Type of Cover',1,'HOME'),(646,'Basis of Cover',2,'HOME'),(647,'Related Benefits',7,'HOME'),(648,'Limits of Cover at Risk Address',4,'HOME'),(649,'Personal Effects and Valuables (additional to Temporary Removal)',8,'HOME'),(650,'Workers Compensation',14,'HOME'),(651,'Legal Liability',5,'HOME'),(652,'Occupancy of Building',13,'HOME'),(653,'Definition',3,'HOME'),(654,'Part of Building Definition',9,'HOME'),(655,'Part of Contents Definition',10,'HOME'),(656,'Exclusions and Conditions',12,'HOME'),(657,'Separate Basis of Settlement Clause',11,'HOME'),(658,'Additional Information',6,'HOME'),(686,'Type of Policy',1,'CARLMI'),(687,'Part of Vehicle Definition',3,'CARLMI'),(688,'Features and Benefits - Comprehensive Policies',2,'CARLMI'),(689,'Features and Benefits - Third Party Property Damage',8,'CARLMI'),(690,'Features and Benefits - Third Party Fire and Theft',7,'CARLMI'),(691,'Legal Liability',4,'CARLMI'),(692,'Excess',5,'CARLMI'),(693,'Conditions and Exclusions',9,'CARLMI'),(694,'Additional Information',6,'CARLMI'),(695,'Type of Cover',1,'HOMELMI'),(696,'Basis of Cover',2,'HOMELMI'),(697,'Related Benefits',7,'HOMELMI'),(698,'Limits of Cover at Risk Address',4,'HOMELMI'),(699,'Personal Effects and Valuables (additional to Temporary Removal)',8,'HOMELMI'),(700,'Workers Compensation',14,'HOMELMI'),(701,'Legal Liability',5,'HOMELMI'),(702,'Occupancy of Building',13,'HOMELMI'),(703,'Definition',3,'HOMELMI'),(704,'Part of Building Definition',9,'HOMELMI'),(705,'Part of Contents Definition',10,'HOMELMI'),(706,'Exclusions and Conditions',12,'HOMELMI'),(707,'Separate Basis of Settlement Clause',11,'HOMELMI'),(708,'Additional Information',6,'HOMELMI');
/*!40000 ALTER TABLE `features_category` ENABLE KEYS */;
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
