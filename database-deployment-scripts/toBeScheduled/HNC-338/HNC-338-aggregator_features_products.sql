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
-- Table structure for table `features_products`
--

DROP TABLE IF EXISTS `features_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `features_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `ref` varchar(45) NOT NULL,
  `vertical` varchar(10) NOT NULL,
  `brandId` varchar(45) NOT NULL,
  `product_type` int(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9426 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `features_products`
--

LOCK TABLES `features_products` WRITE;
/*!40000 ALTER TABLE `features_products` DISABLE KEYS */;
INSERT INTO `features_products` VALUES (3199,'Lady Driver Standard Car Insurance','2015-06-22','1st-Car_0514_18137','CAR','1991',1),(3200,'Comprehensive Car Insurance','2015-06-22','A01641_0214C_22780','CAR','1992',1),(3201,'Comprehensive Car Insurance','2015-06-22','CompCar_V4_0615_20434','CAR','1993',1),(3202,'Smart Box Car Insurance','2015-06-22','SmartBoxCar_0615_20435','CAR','1993',1),(3203,'Classic Plus Car Insurance','2015-06-22','ClassicPlusCar_0914_19544','CAR','1993',1),(3204,'Classic Motor Insurance','2015-06-22','POL139CLUB_1014_17529','CAR','1994',1),(3205,'SureCover Plus Motor Insurance','2015-06-22','POL001DIR_1014_20862','CAR','1994',1),(3206,'Car Insurance','2015-06-22','QM2091_0114_17531','CAR','1995',1),(3207,'Advantage Car Insurance','2015-06-22','AP02571_0814B_19508','CAR','1996',1),(3208,'Gold Car Insurance','2015-06-22','AustPost-Gold-Car_0614_19467','CAR','1997',1),(3209,'Car Insurance','2015-06-22','055_0512_13582','CAR','1998',1),(3210,'Car Insurance','2015-06-22','B03204_0615_23187','CAR','1999',1),(3211,'Third Party Property Damage Car Insurance','2015-06-22','B03203_0615_23188','CAR','1999',1),(3212,'Standard Car Insurance','2015-06-22','Budget-SD-Car_0514_18128','CAR','2000',1),(3213,'Gold Car Insurance','2015-06-22','Budget-Gold-Car_0514_18131','CAR','2000',1),(3214,'Accelerator Car Insurance','2015-06-22','Cashback-Car_0514_18136','CAR','2001',1),(3215,'Motor Vehicle Insurance','2015-06-22','PID0301_REV12_0314-CV440_REV3_0614_22397','CAR','2002',1),(3216,'Car Insurance','2015-06-22','COLPDS95000_0914_20079','CAR','2003',1),(3217,'Car Insurance','2015-06-22','CIL474_0115_20933','CAR','2004',1),(3218,'Gold Car Insurance Policy','2015-06-22','Dodo-Car_1014_22332','CAR','2005',1),(3219,'Car Insurance','2015-06-22','04795_1014_19959','CAR','2006',1),(3220,'Car Insurance - Optional Platinum Cover','2015-06-22','04795_1014_19960','CAR','2006',1),(3221,'Carbon Offset Car Insurance','2015-06-22','ibuyeco-Car_0514_18126','CAR','2007',1),(3222,'Comprehensive Car Insurance','2015-06-22','J01425_0914_22333','CAR','2008',1),(3223,'Motor Insurance (NSW, QLD, ACT & TAS) Comprehensive','2015-06-22','G012826_0314_17544','CAR','2009',1),(3224,'Motor Insurance (NSW QLD ACT & TAS) Comprehensive Plus','2015-06-22','G012826_0314_17607','CAR','2009',1),(3225,'Gold Car Insurance','2015-06-22','Ozicare-Gold-Car_0514_18134','CAR','2010',1),(3226,'Motor Vehicle Insurance','2015-06-22','08P00591_0411_10852','CAR','2011',1),(3227,'Motor Vehicle Insurance','2015-06-22','QM1711_1110_10278','CAR','2012',1),(3228,'Comprehensive Car Insurance','2015-06-22','MVPDS_0315_22822','CAR','2013',1),(3229,'Comprehensive H2P Insurance','2015-06-22','H2PPDS_0614_19117','CAR','2013',1),(3230,'Motor Vehicle Insurance','2015-06-22','RCMV2_1113_16520','CAR','2014',1),(3231,'Unique Vehicle Insurance','2015-06-22','RCMUV2_0111_10382','CAR','2014',1),(3232,'Comprehensive Car and Third Party Insurance','2015-06-22','F674_1013_16351','CAR','2015',1),(3233,'Motor Insurance','2015-06-22','G012976_0315_22618','CAR','2016',1),(3234,'Car Insurance','2015-06-22','RACI013_0714_18141','CAR','2017',1),(3235,'Pay as You Drive Comprehensive Car Insurance','2015-06-22','016_29052009_10297','CAR','2018',1),(3236,'Comprehensive Car Insurance','2015-06-22','054_0412_13251','CAR','2018',1),(3237,'Motor Vehicle Insurance','2015-06-22','R00022_0713_15437','CAR','2019',1),(3238,'Motor Vehicle Insurance (Optional Platinum Cover)','2015-06-22','R00022_0713_15588','CAR','2019',1),(3239,'Retired Driver Car Insurance','2015-06-22','Retirease-Car_0514_18140','CAR','2020',1),(3240,'Motor Insurance - Comprehensive','2015-06-22','G012975_0314_17537','CAR','2021',1),(3241,'Motor Insurance - Comprehensive Plus','2015-06-22','G012974_0314_17538','CAR','2022',1),(3242,'Car Insurance','2015-06-22','SH02984a_0713_15916','CAR','2023',1),(3243,'Car Insurance - Advantages','2015-06-22','05100_0514_18357','CAR','2024',1),(3244,'Car Insurance - Comprehensive','2015-06-22','05100_0514_18358','CAR','2024',1),(3245,'Car Insurance - Extras','2015-06-22','05100_0514_18359','CAR','2024',1),(3246,'Secure Motor Plus Insurance','2015-06-22','V3812_0914_19724','CAR','2025',1),(3247,'Car Insurance - Price Saver','2015-06-22','Virgin-Car-PS_0714_19212','CAR','2026',1),(3248,'Car Insurance','2015-06-22','178408_1114_22392','CAR','2027',1),(3249,'Car Insurance - Comprehensive Cover','2015-06-22','053_0412_13486','CAR','2028',1),(3250,'Car Insurance - Optional Comprehensive Drive Less Pay Less','2015-06-22','053_0412_16469','CAR','2028',1),(3251,'Car Insurance','2015-06-22','YouiCar_0215_22245','CAR','2029',1),(3320,'Home Insurance - Defined Events','2015-06-15','1st-Home_0513a_17168','HOME','2086',6),(3321,'Home Insurance - Optional Accidental Damage','2015-06-15','1st_Home_0513a_17167','HOME','2086',6),(3322,'Home Building Insurance','2015-06-15','A01463_0214_17162','HOME','2087',6),(3323,'Home Contents Insurance','2015-06-15','A01464_0214_17163','HOME','2087',6),(3324,'SureCover Gold Home Insurance','2015-06-15','POL005DIR_1014_20859','HOME','2088',6),(3325,'SureCover Home Insurance','2015-06-15','POL003DIR_1014_20861','HOME','2088',6),(3326,'SureCover Plus Home Insurance','2015-06-15','POL004DIR_1014_20860','HOME','2088',6),(3327,'Home Insurance','2015-06-15','QM2087_0114_17532','HOME','2089',6),(3328,'Home and Contents Extra Insurance','2015-06-15','AP02655_0615_22978','HOME','2090',6),(3329,'Home and Contents Insurance','2015-06-15','AP02580_0615_22977','HOME','2090',6),(3330,'Elite Care Home and Contents Insurance','2015-06-15','GI072_0514_18165','HOME','2091',6),(3331,'Everyday Care Home and Contents Insurance','2015-06-15','GI010_0514_18163','HOME','2091',6),(3332,'Extra Care Home and Contents Insurance','2015-06-15','GI025B_0514_18164','HOME','2091',6),(3333,'Smart Home and Contents Insurance - Defined Events','2015-06-15','Budget-SmartHome_1014_19970','HOME','2092',6),(3334,'Smart Home and Contents Insurance - Optional Accidental Damage','2015-06-15','Budget-SmartHome_1014_19971','HOME','2092',6),(3335,'Elite Care Home and Contents Insurance','2015-06-15','GI012_0115_20774','HOME','2093',6),(3336,'Extra Care Home and Contents Insurance','2015-06-15','GI025_0115_20775','HOME','2093',6),(3337,'Accidental Damage Home and Contents with Flood Cover','2015-06-15','C0019-F_REV4_0314-CV398-F_REV1_0914_22193','HOME','2094',6),(3338,'Fundamentals Home with Flood Cover','2015-06-15','PID1259-F_REV6_1214-CV458-F_REV1_0415_22395','HOME','2094',6),(3339,'Listed Events Home with Flood Cover','2015-06-15','CV460-F_REV0_1111-C0012-F_REV4_0314_22396','HOME','2094',6),(3340,'Home Insurance','2015-06-15','COLPDS95002_1114_20436','HOME','2095',6),(3341,'Home Insurance - Defined Events','2015-06-15','CIL1516_0515_22819','HOME','2096',6),(3342,'Home Insurance - Optional Accidental Damage','2015-06-15','CIL1516_0515_22820','HOME','2096',6),(3343,'Home Insurance - Defined Events','2015-06-15','Dodo-Home_1014_22615','HOME','2097',6),(3344,'Home Insurance - Optional Accidental Damage','2015-06-15','Dodo-Home_1014_22614','HOME','2097',6),(3345,'55 Up Home and Contents Insurance - Defined Events','2015-06-15','12320_0713_15636','HOME','2098',6),(3346,'55 Up Home and Contents Insurance - Optional Accidental Damage','2015-06-15','12320_0713_15450','HOME','2098',6),(3347,'Home and Contents Insurance - Classic Defined Events','2015-06-15','12318_1014_19963','HOME','2098',6),(3348,'Home and Contents Insurance - Classic Extras','2015-06-15','12318_1014_19964','HOME','2098',6),(3349,'Home and Contents Insurance - Classic Optional Accidental Damage','2015-06-15','12318_1014_19965','HOME','2098',6),(3350,'Home and Contents Insurance - Platinum','2015-06-15','12318_1014_19966','HOME','2098',6),(3351,'Home Insurance Essentials Policy','2015-06-15','NHIE-PDS_1014_20772','HOME','2099',6),(3352,'Home Insurance Policy','2015-06-15','NHI-PDS_1014_20773','HOME','2099',6),(3353,'Home Insurance - Defined Events (NSW/ACT/TAS)','2015-06-15','G013129_0414_17757','HOME','2100',6),(3354,'Home Insurance - Defined Events (QLD)','2015-06-15','G013947_0515_22832','HOME','2100',6),(3355,'Home Plus Insurance - Optional Accidental Damage (NSW/ACT/TAS)','2015-06-15','G013129_0414_17758','HOME','2100',6),(3356,'Home Plus Insurance - Optional Accidental Damage (QLD)','2015-06-15','G013947_0515_22831','HOME','2100',6),(3357,'Home Insurance - Defined Events','2015-06-15','Ozicare-Home_0513_15771','HOME','2101',6),(3358,'Home Insurance - Optional Accidental Damage','2015-06-15','Ozicare-Home_0513_15770','HOME','2101',6),(3359,'Home Cover - Defined Events','2015-06-15','QM2571_0114_16728','HOME','2102',6),(3360,'Home Cover - Optional Accidental Damage','2015-06-15','QM2571_0114_16729','HOME','2102',6),(3361,'Home Cover Prestige','2015-06-15','QM4342_0114_17027','HOME','2102',6),(3362,'Home and Contents Insurance','2015-06-15','HHPDS_0614_19046','HOME','2103',6),(3363,'Household Insurance - Advanced Cover - Optional AD','2015-06-15','RHHB2_0914_19579','HOME','2104',6),(3364,'Household Insurance - Defined Events','2015-06-15','RHHB2_0914_19580','HOME','2104',6),(3365,'Home Insurance - Defined Events','2015-06-15','G014243_0315_22617','HOME','2105',6),(3366,'Home Insurance - Optional Accidental Damage','2015-06-15','G014243_0315_22616','HOME','2105',6),(3367,'Building Contents and Personal Valuable Insurance','2015-06-15','RACI014_1014_19929','HOME','2106',6),(3368,'Renters Contents and Personal Valuables Insurance','2015-06-15','RACI016_0913_16281','HOME','2106',6),(3369,'Home and Contents Insurance - Essential Cover - Defined Events','2015-06-15','056_0612_15155','HOME','2107',6),(3370,'Home and Contents Insurance - Top Cover - Optional AD','2015-06-15','056_0612_15041','HOME','2107',6),(3371,'Home and Contents Insurance - Defined Events','2015-06-15','SH02906_0713_15638','HOME','2108',6),(3372,'Home and Contents Insurance - Optional Accidental Damage','2015-06-15','SH02906_0713_15429','HOME','2108',6),(3373,'55 Up Home and Contents Insurance - Defined Events','2015-06-15','12316_0712_15378','HOME','2109',6),(3374,'55 Up Home and Contents Insurance - Optional Accidental Damage','2015-06-15','12316_0712_13946','HOME','2109',6),(3375,'Home and Contents Classic Insurance - Advantages','2015-06-15','12314_0514C_22833','HOME','2109',6),(3376,'Home and Contents Classic Insurance - Defined Events','2015-06-15','12314_0514C_22834','HOME','2109',6),(3377,'Home and Contents Classic Insurance - Extras','2015-06-15','12314_0514C_22835','HOME','2109',6),(3378,'Home and Contents Classic Insurance - Optional Accidental Damage','2015-06-15','12314_0514C_22836','HOME','2109',6),(3379,'Platinum Home and Contents Insurance','2015-06-15','12317_0712_13947','HOME','2109',6),(3380,'Home Insurance - Defined Events','2015-06-15','Virgin-Home_0513_17153','HOME','2110',6),(3381,'Home Insurance - Optional Accidental Damage','2015-06-15','Virgin-Home_0513_17152','HOME','2110',6),(3382,'Home and Contents Insurance - Essential Care','2015-06-15','INS100_0814_20873','HOME','2111',6),(3383,'Home and Contents Insurance - Premier Care','2015-06-15','INS100_0814_21974','HOME','2111',6),(3384,'Home and Contents Insurance - Quality Care','2015-06-15','INS100_0814_21975','HOME','2111',6),(3385,'Home Insurance - Comprehensive Cover - Optional AD','2015-06-15','056_0612_14547','HOME','2112',6),(3386,'Home Insurance - Standard Cover - Defined Events','2015-06-15','056_0612_14371','HOME','2112',6),(3387,'Home Insurance','2015-06-15','Youi-Home_0814_19292','HOME','2113',6),(9105,'Lady Driver Standard Car Insurance','2015-10-05','1st-Car_0514_18137','CARLMI','5241',13),(9106,'Comprehensive Car Insurance','2015-10-05','A01641_0214C_22780','CARLMI','5242',13),(9107,'Classic Plus Car Insurance','2015-10-05','ClassicPlusCar_0914_19544','CARLMI','5243',13),(9108,'Elegant Cover Car Insurance','2015-10-05','ComprehensiveCar_0615_23185','CARLMI','5243',13),(9109,'Smart Box Car Insurance','2015-10-05','SmartBoxCar_0615_23186','CARLMI','5243',13),(9110,'Classic Motor Insurance','2015-10-05','POL139CLUB_1014_23164','CARLMI','5244',13),(9111,'SureCover Plus Motor Insurance','2015-10-05','POL001DIR_1014_20862','CARLMI','5244',13),(9112,'Car Insurance','2015-10-05','QM2091_0815_23631','CARLMI','5245',13),(9113,'Advantage Car Insurance','2015-10-05','AP02571_0814B_19508','CARLMI','5246',13),(9114,'Gold Car Insurance','2015-10-05','AustPost-Gold-Car_0614_19467','CARLMI','5247',13),(9115,'Car Insurance','2015-10-05','060_0915_24070','CARLMI','5248',13),(9116,'Comprehensive Car Insurance','2015-10-05','B03204_0615_23187','CARLMI','5249',13),(9117,'Third Party Property Damage Car Insurance','2015-10-05','B03203_0615_23188','CARLMI','5249',13),(9118,'Gold Car Insurance','2015-10-05','Budget-Gold-Car_0514_18131','CARLMI','5250',13),(9119,'Standard Car Insurance','2015-10-05','Budget-SD-Car_0514_18128','CARLMI','5250',13),(9120,'Accelerator Car Insurance','2015-10-05','Cashback-Car_0514_18136','CARLMI','5251',13),(9121,'Motor Vehicle Insurance','2015-10-05','PID0301_REV13_0415-CV440_REV4_1014_23347','CARLMI','5252',13),(9122,'Car Insurance','2015-10-05','COLPDS95000_0914_20079','CARLMI','5253',13),(9123,'Car Insurance','2015-10-05','CIL474_0815 _23771','CARLMI','5254',13),(9124,'Gold Car Insurance','2015-10-05','Dodo-Car_1014_22332','CARLMI','5255',13),(9125,'Car Insurance','2015-10-05','04795_0715_23621','CARLMI','5256',13),(9126,'Car Insurance - Optional Platinum Cover','2015-10-05','04795_0715_23622','CARLMI','5256',13),(9127,'Carbon Offset Car Insurance','2015-10-05','ibuyeco-Car_0514_18126','CARLMI','5257',13),(9128,'Comprehensive Car Insurance','2015-10-05','J01425_0914_22333','CARLMI','5258',13),(9129,'Motor Insurance (NSW QLD ACT & TAS) Comprehensive Plus','2015-10-05','G012826_0314_17607','CARLMI','5259',13),(9130,'Motor Insurance (NSW, QLD, ACT & TAS) Comprehensive','2015-10-05','G012826_0314_17544','CARLMI','5259',13),(9131,'Gold Car Insurance','2015-10-05','Ozicare-Gold-Car_0514_18134','CARLMI','5260',13),(9132,'Motor Vehicle Insurance','2015-10-05','08P00591_0411_10852','CARLMI','5261',13),(9133,'Motor Vehicle Insurance','2015-10-05','QM1711_1110_10278','CARLMI','5262',13),(9134,'Comprehensive Car Insurance','2015-10-05','MVPDS_0315_22822','CARLMI','5263',13),(9135,'Comprehensive H2P Insurance','2015-10-05','H2PPDS_0614_19117','CARLMI','5263',13),(9136,'Motor Vehicle Insurance','2015-10-05','RCMV2_0715_23386','CARLMI','5264',13),(9137,'Unique Vehicle Insurance','2015-10-05','RCMUV2_0715_23387','CARLMI','5264',13),(9138,'Comprehensive Car and Third Party Insurance','2015-10-05','F674_1013_16351','CARLMI','5265',13),(9139,'Motor Insurance','2015-10-05','G012976_0315_22618','CARLMI','5266',13),(9140,'Car Insurance','2015-10-05','RACI013_0714_18141','CARLMI','5267',13),(9141,'Comprehensive Car Insurance','2015-10-05','059_0915_24071','CARLMI','5268',13),(9142,'Pay as You Drive Comprehensive Car Insurance','2015-10-05','016_29052009_10297','CARLMI','5268',13),(9143,'Motor Vehicle Insurance','2015-10-05','R00022_0713_15437','CARLMI','5269',13),(9144,'Motor Vehicle Insurance (Optional Platinum Cover)','2015-10-05','R00022_0713_15588','CARLMI','5269',13),(9145,'Retired Driver Car Insurance','2015-10-05','Retirease-Car_0514_18140','CARLMI','5270',13),(9146,'Motor Insurance - Comprehensive','2015-10-05','G012975_0314_17537','CARLMI','5271',13),(9147,'Motor Insurance - Comprehensive Plus','2015-10-05','G012974_0314_17538','CARLMI','5272',13),(9148,'Car Insurance','2015-10-05','SH02984a_0713_15916','CARLMI','5273',13),(9149,'Car Insurance - Advantages','2015-10-05','05100_0715_23635','CARLMI','5274',13),(9150,'Car Insurance - Comprehensive','2015-10-05','05100_0715_23636','CARLMI','5274',13),(9151,'Car Insurance - Extras','2015-10-05','05100_0715_23637','CARLMI','5274',13),(9152,'Secure Motor Plus Insurance','2015-10-05','V3812_0914E_23831','CARLMI','5275',13),(9153,'Car Insurance - Price Saver','2015-10-05','Virgin-Car-PS_0714_19212','CARLMI','5276',13),(9154,'Car Insurance','2015-10-05','178408_1114_22392','CARLMI','5277',13),(9155,'Car Insurance - Comprehensive Cover','2015-10-05','053_0412_13486','CARLMI','5278',13),(9156,'Car Insurance - Optional Comprehensive Drive Less Pay Less','2015-10-05','053_0412_16469','CARLMI','5278',13),(9157,'Car Insurance','2015-10-05','YouiCar_0715_23343','CARLMI','5279',13),(9359,'Home Insurance - Defined Events','2015-11-16','1st-Home_1015_24353','HOMELMI','5364',15),(9360,'Home Insurance - Optional Accidental Damage','2015-11-16','1st-Home_1015_24352','HOMELMI','5364',15),(9361,'Home Building Insurance','2015-11-16','A01463_0214_17162','HOMELMI','5365',15),(9362,'Home Contents Insurance','2015-11-16','A01464_0214_17163','HOMELMI','5365',15),(9363,'SureCover Gold Home Insurance','2015-11-16','POL005DIR_1014_20859','HOMELMI','5366',15),(9364,'SureCover Home Insurance','2015-11-16','POL003DIR_1014_20861','HOMELMI','5366',15),(9365,'SureCover Plus Home Insurance','2015-11-16','POL004DIR_1014_20860','HOMELMI','5366',15),(9366,'Home Insurance','2015-11-16','QM2087_0815_23630','HOMELMI','5367',15),(9367,'Home and Contents Extra Insurance','2015-11-16','AP02655_0615_22978','HOMELMI','5368',15),(9368,'Home and Contents Insurance','2015-11-16','AP02580_0615_22977','HOMELMI','5368',15),(9369,'Home Cover Prestige Home and Contents Insurance','2015-11-16','QM7156_1115_24450','HOMELMI','5369',15),(9370,'Home Cover Home and Contents Insurance','2015-11-16','QM7491_1115_24451','HOMELMI','5369',15),(9371,'Smart Home and Contents Insurance - Defined Events','2015-11-16','Budget-SmartHome_1015_24358','HOMELMI','5370',15),(9372,'Smart Home and Contents Insurance - Optional Accidental Damage','2015-11-16','Budget-SmartHome_1015_24359','HOMELMI','5370',15),(9373,'Elite Care Home and Contents Insurance','2015-11-16','ACE-CAL-EL_1115_24086','HOMELMI','5371',15),(9374,'Extra Care Home and Contents Insurance','2015-11-16','ACE-CAL-EX_1115_24087','HOMELMI','5371',15),(9375,'Accidental Damage Home and Contents with Flood Cover','2015-11-16','C0019-F_REV5_0515-CV398-F_REV1_0914_23344','HOMELMI','5372',15),(9376,'Fundamentals Home with Flood Cover','2015-11-16','PID1259-F_REV6_1214-CV458-F_REV1_0415_23166','HOMELMI','5372',15),(9377,'Listed Events Home with Flood Cover','2015-11-16','C0012-F_REV5_0515-CV460-F_REV1_0415_23345','HOMELMI','5372',15),(9378,'Home Insurance','2015-11-16','COLPDS95002_0515_23632','HOMELMI','5373',15),(9379,'Home Insurance - Defined Events','2015-11-16','CIL1516_0815_23768','HOMELMI','5374',15),(9380,'Home Insurance - Optional Accidental Damage','2015-11-16','CIL1516_0815_23769','HOMELMI','5374',15),(9381,'Home Insurance - Defined Events','2015-11-16','Dodo-Home_1014_22615','HOMELMI','5375',15),(9382,'Home Insurance - Optional Accidental Damage','2015-11-16','Dodo-Home_1014_22614','HOMELMI','5375',15),(9383,'55 Up Home and Contents Insurance - Defined Events','2015-11-16','12320_0713_15636','HOMELMI','5376',15),(9384,'55 Up Home and Contents Insurance - Optional Accidental Damage','2015-11-16','12320_0713_15450','HOMELMI','5376',15),(9385,'Home and Contents Insurance - Classic Defined Events','2015-11-16','12318_1014_19963','HOMELMI','5376',15),(9386,'Home and Contents Insurance - Classic Extras','2015-11-16','12318_1014_19964','HOMELMI','5376',15),(9387,'Home and Contents Insurance - Classic Optional Accidental Damage','2015-11-16','12318_1014_19965','HOMELMI','5376',15),(9388,'Home and Contents Insurance - Platinum','2015-11-16','12318_1014_19966','HOMELMI','5376',15),(9389,'Home Insurance Essentials Policy','2015-11-16','NHIE-PDS_1014_20772','HOMELMI','5377',15),(9390,'Home Insurance Policy','2015-11-16','NHI-PDS_1014_20773','HOMELMI','5377',15),(9391,'Home Insurance - Defined Events (NSW/ACT/TAS)','2015-11-16','G013129_0414_17757','HOMELMI','5378',15),(9392,'Home Insurance - Defined Events (QLD)','2015-11-16','G013947_0515_22832','HOMELMI','5378',15),(9393,'Home Plus Insurance - Optional Accidental Damage (NSW/ACT/TAS)','2015-11-16','G013129_0414_17758','HOMELMI','5378',15),(9394,'Home Plus Insurance - Optional Accidental Damage (QLD)','2015-11-16','G013947_0515_22831','HOMELMI','5378',15),(9395,'Home Insurance - Defined Events','2015-11-16','Ozicare-Home_1015_24367','HOMELMI','5379',15),(9396,'Home Insurance - Optional Accidental Damage','2015-11-16','Ozicare-Home_1015_24368','HOMELMI','5379',15),(9397,'Home Cover - Defined Events','2015-11-16','QM2571_0114_16728','HOMELMI','5380',15),(9398,'Home Cover - Optional Accidental Damage','2015-11-16','QM2571_0114_16729','HOMELMI','5380',15),(9399,'Home Cover Prestige','2015-11-16','QM4342_0114_17027','HOMELMI','5380',15),(9400,'Home and Contents Insurance','2015-11-16','HHPDS_0614_19046','HOMELMI','5381',15),(9401,'Household Insurance - Advanced Cover - Optional AD','2015-11-16','RHHB2_0715_23388','HOMELMI','5382',15),(9402,'Household Insurance - Defined Events','2015-11-16','RHHB2_0715_23389','HOMELMI','5382',15),(9403,'Home Insurance - Defined Events','2015-11-16','G014243_0915_24009','HOMELMI','5383',15),(9404,'Home Insurance - Optional Accidental Damage','2015-11-16','G014243_0915_24010','HOMELMI','5383',15),(9405,'Building Contents and Personal Valuable Insurance','2015-11-16','RINS0381_0715_23114','HOMELMI','5384',15),(9406,'Renters Contents and Personal Valuables Insurance','2015-11-16','RACI016_0715_23115','HOMELMI','5384',15),(9407,'Home and Contents Insurance - Essential Cover - Defined Events','2015-11-16','061_1015_24452','HOMELMI','5385',15),(9408,'Home and Contents Insurance - Top Cover - Optional AD','2015-11-16','061_1015_24459','HOMELMI','5385',15),(9409,'Home and Contents Insurance - Defined Events','2015-11-16','SH02906_0713_15638','HOMELMI','5386',15),(9410,'Home and Contents Insurance - Optional Accidental Damage','2015-11-16','SH02906_0713_15429','HOMELMI','5386',15),(9411,'55 Up Home and Contents Insurance - Defined Events','2015-11-16','12316_0712_15378','HOMELMI','5387',15),(9412,'55 Up Home and Contents Insurance - Optional Accidental Damage','2015-11-16','12316_0712_13946','HOMELMI','5387',15),(9413,'Home and Contents Classic Insurance - Advantages','2015-11-16','12314_1115_24561','HOMELMI','5387',15),(9414,'Home and Contents Classic Insurance - Defined Events','2015-11-16','12314_1115_24562','HOMELMI','5387',15),(9415,'Home and Contents Classic Insurance - Extras','2015-11-16','12314_1115_24563','HOMELMI','5387',15),(9416,'Home and Contents Classic Insurance - Optional Accidental Damage','2015-11-16','12314_1115_24564','HOMELMI','5387',15),(9417,'Platinum Home and Contents Insurance','2015-11-16','12317_0712_13947','HOMELMI','5387',15),(9418,'Home Insurance - Defined Events','2015-11-16','Virgin-Home_1015_24371','HOMELMI','5388',15),(9419,'Home Insurance - Optional Accidental Damage','2015-11-16','Virgin-Home_1015_24372','HOMELMI','5388',15),(9420,'Home and Contents Insurance - Essential Care','2015-11-16','INS100_1115_24453','HOMELMI','5389',15),(9421,'Home and Contents Insurance - Premier Care','2015-11-16','INS100_1115_24454','HOMELMI','5389',15),(9422,'Home and Contents Insurance - Quality Care','2015-11-16','INS100_1115_24455','HOMELMI','5389',15),(9423,'Home Insurance - Comprehensive Cover - Optional AD','2015-11-16','063_1015_24457','HOMELMI','5390',15),(9424,'Home Insurance - Standard Cover - Defined Events','2015-11-16','063_1015_24458','HOMELMI','5390',15),(9425,'Home Insurance','2015-11-16','Youi-Home_0715_23342','HOMELMI','5391',15);
/*!40000 ALTER TABLE `features_products` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-19 16:26:39
