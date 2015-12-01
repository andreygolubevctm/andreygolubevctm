-- --------------------------------------------------------
-- Host:                         taws02_dbi
-- Server version:               10.0.16-MariaDB-log - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             9.1.0.4867
-- --------------------------------------------------------

USE `ctm`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table ctm.export_product_master
DROP TABLE IF EXISTS `export_product_master`;
CREATE TABLE IF NOT EXISTS `export_product_master` (
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
) ENGINE=InnoDB AUTO_INCREMENT=5636652 DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_master: ~48 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5636604, 'HEALTH', 'H2/A0000C', 16, 'Top Hospital', 'Top Hospital', '2015-04-01', '2016-03-31', ''),
	(5636605, 'HEALTH', 'H2/A0000F', 16, 'Top Hospital', 'Top Hospital', '2015-04-01', '2016-03-31', ''),
	(5636606, 'HEALTH', 'H2/A0000S', 16, 'Top Hospital', 'Top Hospital', '2015-04-01', '2016-03-31', ''),
	(5636607, 'HEALTH', 'H2/A0000P', 16, 'Top Hospital', 'Top Hospital', '2015-04-01', '2016-03-31', ''),
	(5636608, 'HEALTH', 'H2A/A0500C', 16, 'Top Hospital 250', 'Top Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5636609, 'HEALTH', 'H2A/A0500F', 16, 'Top Hospital 250', 'Top Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5636610, 'HEALTH', 'H2A/A0250S', 16, 'Top Hospital 250', 'Top Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5636611, 'HEALTH', 'H2A/A0500P', 16, 'Top Hospital 250', 'Top Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5636612, 'HEALTH', 'H2E/AACN20', 16, 'Top Hospital 250 with Essential Extras', 'Top Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636613, 'HEALTH', 'H2E/AACO2D', 16, 'Top Hospital 250 with Essential Extras', 'Top Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636614, 'HEALTH', 'H2E/AABN10', 16, 'Top Hospital 250 with Essential Extras', 'Top Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636615, 'HEALTH', 'H2E/AACP1D', 16, 'Top Hospital 250 with Essential Extras', 'Top Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636616, 'HEALTH', 'H2F/AAAK20', 16, 'Top Hospital 250 with Premium Extras', 'Top Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636617, 'HEALTH', 'H2F/AAAL2D', 16, 'Top Hospital 250 with Premium Extras', 'Top Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636618, 'HEALTH', 'H2F/AAAI10', 16, 'Top Hospital 250 with Premium Extras', 'Top Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636619, 'HEALTH', 'H2F/AAAM1D', 16, 'Top Hospital 250 with Premium Extras', 'Top Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636620, 'HEALTH', 'H2R/AAFN20', 16, 'Top Hospital 250 with Young Extras', 'Top Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636621, 'HEALTH', 'H2R/AAFT2D', 16, 'Top Hospital 250 with Young Extras', 'Top Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636622, 'HEALTH', 'H2R/AAFR10', 16, 'Top Hospital 250 with Young Extras', 'Top Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636623, 'HEALTH', 'H2R/AAFU1D', 16, 'Top Hospital 250 with Young Extras', 'Top Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636624, 'HEALTH', 'H2B/A1000C', 16, 'Top Hospital 500', 'Top Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5636625, 'HEALTH', 'H2B/A1000F', 16, 'Top Hospital 500', 'Top Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5636626, 'HEALTH', 'H2B/A0500S', 16, 'Top Hospital 500', 'Top Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5636627, 'HEALTH', 'H2B/A1000P', 16, 'Top Hospital 500', 'Top Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5636628, 'HEALTH', 'H2G/AACS20', 16, 'Top Hospital 500 with Essential Extras', 'Top Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636629, 'HEALTH', 'H2G/AACT2D', 16, 'Top Hospital 500 with Essential Extras', 'Top Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636630, 'HEALTH', 'H2G/AABO10', 16, 'Top Hospital 500 with Essential Extras', 'Top Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636631, 'HEALTH', 'H2G/AACU1D', 16, 'Top Hospital 500 with Essential Extras', 'Top Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636632, 'HEALTH', 'H2H/AAAP20', 16, 'Top Hospital 500 with Premium Extras', 'Top Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636633, 'HEALTH', 'H2H/AAAQ2D', 16, 'Top Hospital 500 with Premium Extras', 'Top Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636634, 'HEALTH', 'H2H/AAAJ10', 16, 'Top Hospital 500 with Premium Extras', 'Top Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636635, 'HEALTH', 'H2H/AAAR1D', 16, 'Top Hospital 500 with Premium Extras', 'Top Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636636, 'HEALTH', 'H2S/AAFO20', 16, 'Top Hospital 500 with Young Extras', 'Top Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636637, 'HEALTH', 'H2S/AAFW2D', 16, 'Top Hospital 500 with Young Extras', 'Top Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636638, 'HEALTH', 'H2S/AAFS10', 16, 'Top Hospital 500 with Young Extras', 'Top Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636639, 'HEALTH', 'H2S/AAFX1D', 16, 'Top Hospital 500 with Young Extras', 'Top Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636640, 'HEALTH', 'H2C/AACI20', 16, 'Top Hospital with Essential Extras', 'Top Hospital with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636641, 'HEALTH', 'H2C/AACJ2D', 16, 'Top Hospital with Essential Extras', 'Top Hospital with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636642, 'HEALTH', 'H2C/AABQ10', 16, 'Top Hospital with Essential Extras', 'Top Hospital with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636643, 'HEALTH', 'H2C/AACK1D', 16, 'Top Hospital with Essential Extras', 'Top Hospital with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5636644, 'HEALTH', 'H2D/AACD20', 16, 'Top Hospital with Premium Extras', 'Top Hospital with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636645, 'HEALTH', 'H2D/AACE2D', 16, 'Top Hospital with Premium Extras', 'Top Hospital with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636646, 'HEALTH', 'H2D/AABP10', 16, 'Top Hospital with Premium Extras', 'Top Hospital with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636647, 'HEALTH', 'H2D/AACF1D', 16, 'Top Hospital with Premium Extras', 'Top Hospital with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5636648, 'HEALTH', 'H2Q/AAFM20', 16, 'Top Hospital with Young Extras', 'Top Hospital with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636649, 'HEALTH', 'H2Q/AAFZ2D', 16, 'Top Hospital with Young Extras', 'Top Hospital with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636650, 'HEALTH', 'H2Q/AAFQ10', 16, 'Top Hospital with Young Extras', 'Top Hospital with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5636651, 'HEALTH', 'H2Q/AAGA1D', 16, 'Top Hospital with Young Extras', 'Top Hospital with Young Extras', '2015-04-01', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
