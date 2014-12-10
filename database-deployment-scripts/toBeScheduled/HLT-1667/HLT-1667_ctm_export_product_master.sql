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
-- Table structure for table `export_product_master`
--

DROP TABLE IF EXISTS `export_product_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `export_product_master` (
  `ProductId` int(11) NOT NULL AUTO_INCREMENT,
  `ProductCat` char(10) NOT NULL,
  `ProductCode` varchar(45) DEFAULT NULL,
  `ProviderId` int(11) NOT NULL,
  `ShortTitle` varchar(50) NOT NULL,
  `LongTitle` varchar(128) NOT NULL,
  `EffectiveStart` date NOT NULL DEFAULT '2011-03-01',
  `EffectiveEnd` date NOT NULL DEFAULT '2040-12-31',
  `Status` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`ProductId`,`EffectiveEnd`),
  KEY `PROVIDER_CAT` (`ProviderId`,`ProductCat`,`ProductId`)
) ENGINE=InnoDB AUTO_INCREMENT=568722 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_product_master`
--

LOCK TABLES `export_product_master` WRITE;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` VALUES (568715,'HEALTH','J5A/NBHN10',15,'Young Singles Saver','Young Singles Saver','2014-04-01','2015-03-31',''),(568716,'HEALTH','J5A/DBZY10',15,'Young Singles Saver','Young Singles Saver','2014-04-01','2015-03-31',''),(568717,'HEALTH','J5A/QBHO10',15,'Young Singles Saver','Young Singles Saver','2014-04-01','2015-03-31',''),(568718,'HEALTH','J5A/SBZX10',15,'Young Singles Saver','Young Singles Saver','2014-04-01','2015-03-31',''),(568719,'HEALTH','J5A/TBHP10',15,'Young Singles Saver','Young Singles Saver','2014-04-01','2015-03-31',''),(568720,'HEALTH','J5A/VBHQ10',15,'Young Singles Saver','Young Singles Saver','2014-04-01','2015-03-31',''),(568721,'HEALTH','J5A/WBHR10',15,'Young Singles Saver','Young Singles Saver','2014-04-01','2015-03-31','');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-03 12:00:23
