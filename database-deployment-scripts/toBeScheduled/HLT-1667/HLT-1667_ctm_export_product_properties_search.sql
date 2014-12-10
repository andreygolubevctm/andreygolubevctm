CREATE DATABASE  IF NOT EXISTS `ctm` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ctm`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: taws02_dbi    Database: ctm
-- ------------------------------------------------------
-- Server version	5.5.5-10.0.14-MariaDB

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
-- Table structure for table `export_product_properties_search`
--

DROP TABLE IF EXISTS `export_product_properties_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `export_product_properties_search` (
  `productId` int(11) NOT NULL,
  `ProductIdentifier` int(11) DEFAULT NULL,
  `state` char(3) NOT NULL,
  `membership` char(3) NOT NULL,
  `productType` char(15) NOT NULL,
  `excessAmount` int(11) NOT NULL,
  `HospitalType` char(20) NOT NULL,
  `monthlyPremium` double DEFAULT NULL,
  `monthlyLHC` double DEFAULT NULL,
  PRIMARY KEY (`productId`,`state`,`membership`,`productType`,`excessAmount`,`HospitalType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_product_properties_search`
--

LOCK TABLES `export_product_properties_search` WRITE;
/*!40000 ALTER TABLE `export_product_properties_search` DISABLE KEYS */;
INSERT INTO `export_product_properties_search` VALUES (568715,18151,'NSW','S','Combined',0,'PrivateHospital',109.25,61.8),(568716,18122,'NT','S','Combined',0,'PrivateHospital',81.65,53.1),(568717,18180,'QLD','S','Combined',0,'PrivateHospital',120.4,84.7),(568718,18209,'SA','S','Combined',0,'PrivateHospital',120.7,85.25),(568719,18210,'TAS','S','Combined',0,'PrivateHospital',124.95,88.25),(568720,18239,'VIC','S','Combined',0,'PrivateHospital',123.15,86.2),(568721,18268,'WA','S','Combined',0,'PrivateHospital',106.65,73.15);
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-03 12:00:22
