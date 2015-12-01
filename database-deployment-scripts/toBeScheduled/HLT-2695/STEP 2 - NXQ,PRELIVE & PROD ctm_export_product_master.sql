CREATE DATABASE  IF NOT EXISTS `ctm` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ctm`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: taws02_dbi    Database: ctm
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
) ENGINE=InnoDB AUTO_INCREMENT=5634525 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_product_master`
--

LOCK TABLES `export_product_master` WRITE;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` VALUES (5634021,'HEALTH','H34A/NDQP20^I16/NBLN20',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634022,'HEALTH','H34A/NDQY2D^I16/NBLO2D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634023,'HEALTH','H34A/NDRF10^I16/NBLM10',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634024,'HEALTH','H34A/NDRM1D^I16/NBLP1D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634025,'HEALTH','H34A/DDQS20^I16/DBQI20',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634026,'HEALTH','H34A/DDQZ2D^I16/DBQK2D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634027,'HEALTH','H34A/DDRG10^I16/DBPC10',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634028,'HEALTH','H34A/DDRN1D^I16/DBPI1D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634029,'HEALTH','H34A/QDQQ20^I16/QBMC20',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634030,'HEALTH','H34A/QDQW2D^I16/QBMD2D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634031,'HEALTH','H34A/QDRD10^I16/QBMB10',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634032,'HEALTH','H34A/QDRK1D^I16/QBME1D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634033,'HEALTH','H34A/SDQT20^I16/SBPF20',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634034,'HEALTH','H34A/SDRA2D^I16/SBPK2D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634035,'HEALTH','H34A/SDRH10^I16/SBPD10',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634036,'HEALTH','H34A/SDRO1D^I16/SBPL1D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634037,'HEALTH','H34A/TDQR20^I16/TBLX20',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634038,'HEALTH','H34A/TDQX2D^I16/TBLY2D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634039,'HEALTH','H34A/TDRE10^I16/TBLW10',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634040,'HEALTH','H34A/TDRL1D^I16/TBLZ1D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634041,'HEALTH','H34A/VDQU20^I16/VBLH20',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634042,'HEALTH','H34A/VDRB2D^I16/VBLJ2D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634043,'HEALTH','H34A/VDRI10^I16/VBLG10',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634044,'HEALTH','H34A/VDRP1D^I16/VBLK1D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634045,'HEALTH','H34A/WDQV20^I16/WBLS20',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634046,'HEALTH','H34A/WDRC2D^I16/WBLT2D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634047,'HEALTH','H34A/WDRJ10^I16/WBLR10',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634048,'HEALTH','H34A/WDRQ1D^I16/WBLU1D',15,'Budget Hospital $250 Excess & Gold Extras','Budget Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634105,'HEALTH','H34B/NDSH20^I16/NBLN20',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634106,'HEALTH','H34B/NDSO2D^I16/NBLO2D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634107,'HEALTH','H34B/NDSV10^I16/NBLM10',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634108,'HEALTH','H34B/NDTC1D^I16/NBLP1D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634109,'HEALTH','H34B/DDSI20^I16/DBQI20',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634110,'HEALTH','H34B/DDSP2D^I16/DBQK2D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634111,'HEALTH','H34B/DDSW10^I16/DBPC10',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634112,'HEALTH','H34B/DDTD1D^I16/DBPI1D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634113,'HEALTH','H34B/QDSF20^I16/QBMC20',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634114,'HEALTH','H34B/QDSM2D^I16/QBMD2D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634115,'HEALTH','H34B/QDST10^I16/QBMB10',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634116,'HEALTH','H34B/QDTA1D^I16/QBME1D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634117,'HEALTH','H34B/SDSJ20^I16/SBPF20',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634118,'HEALTH','H34B/SDSQ2D^I16/SBPK2D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634119,'HEALTH','H34B/SDSX10^I16/SBPD10',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634120,'HEALTH','H34B/SDTE1D^I16/SBPL1D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634121,'HEALTH','H34B/TDSG20^I16/TBLX20',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634122,'HEALTH','H34B/TDSN2D^I16/TBLY2D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634123,'HEALTH','H34B/TDSU10^I16/TBLW10',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634124,'HEALTH','H34B/TDTB1D^I16/TBLZ1D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634125,'HEALTH','H34B/VDSK20^I16/VBLH20',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634126,'HEALTH','H34B/VDSR2D^I16/VBLJ2D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634127,'HEALTH','H34B/VDSY10^I16/VBLG10',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634128,'HEALTH','H34B/VDTF1D^I16/VBLK1D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634129,'HEALTH','H34B/WDSL20^I16/WBLS20',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634130,'HEALTH','H34B/WDSS2D^I16/WBLT2D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634131,'HEALTH','H34B/WDSZ10^I16/WBLR10',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634132,'HEALTH','H34B/WDTG1D^I16/WBLU1D',15,'Budget Hospital $500 Excess & Gold Extras','Budget Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634217,'HEALTH','I16/NBLN20',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634218,'HEALTH','I16/NBLO2D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634219,'HEALTH','I16/NBLM10',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634220,'HEALTH','I16/NBLP1D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634221,'HEALTH','I16/DBQI20',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634222,'HEALTH','I16/DBQK2D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634223,'HEALTH','I16/DBPC10',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634224,'HEALTH','I16/DBPI1D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634225,'HEALTH','I16/QBMC20',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634226,'HEALTH','I16/QBMD2D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634227,'HEALTH','I16/QBMB10',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634228,'HEALTH','I16/QBME1D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634229,'HEALTH','I16/SBPF20',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634230,'HEALTH','I16/SBPK2D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634231,'HEALTH','I16/SBPD10',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634232,'HEALTH','I16/SBPL1D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634233,'HEALTH','I16/TBLX20',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634234,'HEALTH','I16/TBLY2D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634235,'HEALTH','I16/TBLW10',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634236,'HEALTH','I16/TBLZ1D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634237,'HEALTH','I16/VBLH20',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634238,'HEALTH','I16/VBLJ2D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634239,'HEALTH','I16/VBLG10',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634240,'HEALTH','I16/VBLK1D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634241,'HEALTH','I16/WBLS20',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634242,'HEALTH','I16/WBLT2D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634243,'HEALTH','I16/WBLR10',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634244,'HEALTH','I16/WBLU1D',15,'Gold Extras','Gold Extras','2015-11-20','2016-03-31',''),(5634301,'HEALTH','H1B/NDIV20^I16/NBLN20',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634302,'HEALTH','H1B/NDJC2D^I16/NBLO2D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634303,'HEALTH','H1B/NDIM10^I16/NBLM10',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634304,'HEALTH','H1B/NDJJ1D^I16/NBLP1D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634305,'HEALTH','H1B/DDIW20^I16/DBQI20',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634306,'HEALTH','H1B/DDJD2D^I16/DBQK2D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634307,'HEALTH','H1B/DDIN10^I16/DBPC10',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634308,'HEALTH','H1B/DDJK1D^I16/DBPI1D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634309,'HEALTH','H1B/QDIT20^I16/QBMC20',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634310,'HEALTH','H1B/QDJB2D^I16/QBMD2D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634311,'HEALTH','H1B/QDIR10^I16/QBMB10',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634312,'HEALTH','H1B/QDJH1D^I16/QBME1D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634313,'HEALTH','H1B/SDIX20^I16/SBPF20',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634314,'HEALTH','H1B/SDJE2D^I16/SBPK2D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634315,'HEALTH','H1B/SDIO10^I16/SBPD10',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634316,'HEALTH','H1B/SDJL1D^I16/SBPL1D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634317,'HEALTH','H1B/TDIU20^I16/TBLX20',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634318,'HEALTH','H1B/TDJA2D^I16/TBLY2D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634319,'HEALTH','H1B/TDIS10^I16/TBLW10',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634320,'HEALTH','H1B/TDJI1D^I16/TBLZ1D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634321,'HEALTH','H1B/VDIY20^I16/VBLH20',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634322,'HEALTH','H1B/VDJG2D^I16/VBLJ2D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634323,'HEALTH','H1B/VDIP10^I16/VBLG10',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634324,'HEALTH','H1B/VDJM1D^I16/VBLK1D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634325,'HEALTH','H1B/WDIZ20^I16/WBLS20',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634326,'HEALTH','H1B/WDJF2D^I16/WBLT2D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634327,'HEALTH','H1B/WDIQ10^I16/WBLR10',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634328,'HEALTH','H1B/WDJN1D^I16/WBLU1D',15,'Top Hospital $250 Excess & Gold Extras','Top Hospital $250 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634385,'HEALTH','H1C/NDKL20^I16/NBLN20',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634386,'HEALTH','H1C/NDKS2D^I16/NBLO2D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634387,'HEALTH','H1C/NDKE10^I16/NBLM10',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634388,'HEALTH','H1C/NDKZ1D^I16/NBLP1D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634389,'HEALTH','H1C/DDKM20^I16/DBQI20',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634390,'HEALTH','H1C/DDKT2D^I16/DBQK2D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634391,'HEALTH','H1C/DDKF10^I16/DBPC10',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634392,'HEALTH','H1C/DDLA1D^I16/DBPI1D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634393,'HEALTH','H1C/QDKJ20^I16/QBMC20',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634394,'HEALTH','H1C/QDKQ2D^I16/QBMD2D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634395,'HEALTH','H1C/QDKC10^I16/QBMB10',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634396,'HEALTH','H1C/QDKX1D^I16/QBME1D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634397,'HEALTH','H1C/SDKN20^I16/SBPF20',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634398,'HEALTH','H1C/SDKU2D^I16/SBPK2D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634399,'HEALTH','H1C/SDKG10^I16/SBPD10',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634400,'HEALTH','H1C/SDLB1D^I16/SBPL1D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634401,'HEALTH','H1C/TDKK20^I16/TBLX20',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634402,'HEALTH','H1C/TDKR2D^I16/TBLY2D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634403,'HEALTH','H1C/TDKD10^I16/TBLW10',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634404,'HEALTH','H1C/TDKY1D^I16/TBLZ1D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634405,'HEALTH','H1C/VDKO20^I16/VBLH20',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634406,'HEALTH','H1C/VDKV2D^I16/VBLJ2D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634407,'HEALTH','H1C/VDKH10^I16/VBLG10',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634408,'HEALTH','H1C/VDLC1D^I16/VBLK1D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634409,'HEALTH','H1C/WDKP20^I16/WBLS20',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634410,'HEALTH','H1C/WDKW2D^I16/WBLT2D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634411,'HEALTH','H1C/WDKI10^I16/WBLR10',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634412,'HEALTH','H1C/WDLD1D^I16/WBLU1D',15,'Top Hospital $500 Excess & Gold Extras','Top Hospital $500 Excess & Gold Extras','2015-11-20','2016-03-31',''),(5634497,'HEALTH','H1A/NAAA20^I16/NBLN20',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634498,'HEALTH','H1A/NAAC2D^I16/NBLO2D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634499,'HEALTH','H1A/NAAE10^I16/NBLM10',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634500,'HEALTH','H1A/NAAD1D^I16/NBLP1D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634501,'HEALTH','H1A/DBST20^I16/DBQI20',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634502,'HEALTH','H1A/DBSW2D^I16/DBQK2D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634503,'HEALTH','H1A/DBSP10^I16/DBPC10',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634504,'HEALTH','H1A/DBTN1D^I16/DBPI1D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634505,'HEALTH','H1A/QAAF20^I16/QBMC20',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634506,'HEALTH','H1A/QAAH2D^I16/QBMD2D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634507,'HEALTH','H1A/QAAJ10^I16/QBMB10',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634508,'HEALTH','H1A/QAAI1D^I16/QBME1D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634509,'HEALTH','H1A/SBSS20^I16/SBPF20',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634510,'HEALTH','H1A/SBSX2D^I16/SBPK2D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634511,'HEALTH','H1A/SBSO10^I16/SBPD10',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634512,'HEALTH','H1A/SBTK1D^I16/SBPL1D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634513,'HEALTH','H1A/TAAK20^I16/TBLX20',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634514,'HEALTH','H1A/TAAM2D^I16/TBLY2D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634515,'HEALTH','H1A/TAAO10^I16/TBLW10',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634516,'HEALTH','H1A/TAAN1D^I16/TBLZ1D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634517,'HEALTH','H1A/VAAP20^I16/VBLH20',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634518,'HEALTH','H1A/VAAR2D^I16/VBLJ2D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634519,'HEALTH','H1A/VAAT10^I16/VBLG10',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634520,'HEALTH','H1A/VAAS1D^I16/VBLK1D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634521,'HEALTH','H1A/WBZW20^I16/WBLS20',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634522,'HEALTH','H1A/WAAW2D^I16/WBLT2D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634523,'HEALTH','H1A/WAAY10^I16/WBLR10',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31',''),(5634524,'HEALTH','H1A/WAAX1D^I16/WBLU1D',15,'Top Hospital Cover & Gold Extras','Top Hospital Cover & Gold Extras','2015-11-20','2016-03-31','');
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

-- Dump completed on 2015-11-24 15:03:44