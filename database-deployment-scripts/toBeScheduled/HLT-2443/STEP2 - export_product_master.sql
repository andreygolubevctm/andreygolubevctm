-- --------------------------------------------------------
-- Host:                         taws02_dbi
-- Server version:               10.0.16-MariaDB-log - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             9.1.0.4867
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table ctm.export_product_master
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
) ENGINE=InnoDB AUTO_INCREMENT=5507252 DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_master: ~28 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5507224, 'HEALTH', 'J8/NAMT20', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507225, 'HEALTH', 'J8/NAMU2D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507226, 'HEALTH', 'J8/NAMV10', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507227, 'HEALTH', 'J8/NAMW1D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507228, 'HEALTH', 'J8/DANG20', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507229, 'HEALTH', 'J8/DANF2D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507230, 'HEALTH', 'J8/DAMX10', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507231, 'HEALTH', 'J8/DANB1D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507232, 'HEALTH', 'J8/QANN20', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507233, 'HEALTH', 'J8/QANO2D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507234, 'HEALTH', 'J8/QANQ10', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507235, 'HEALTH', 'J8/QANP1D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507236, 'HEALTH', 'J8/SANH20', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507237, 'HEALTH', 'J8/SANJ2D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507238, 'HEALTH', 'J8/SAMY10', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507239, 'HEALTH', 'J8/SANC1D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507240, 'HEALTH', 'J8/TANT20', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507241, 'HEALTH', 'J8/TANR2D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507242, 'HEALTH', 'J8/TANU10', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507243, 'HEALTH', 'J8/TANS1D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507244, 'HEALTH', 'J8/VANM20', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507245, 'HEALTH', 'J8/VANL2D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507246, 'HEALTH', 'J8/VAMZ10', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507247, 'HEALTH', 'J8/VAND1D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507248, 'HEALTH', 'J8/WANK20', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507249, 'HEALTH', 'J8/WANI2D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507250, 'HEALTH', 'J8/WANA10', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', ''),
	(5507251, 'HEALTH', 'J8/WANE1D', 9, 'Budget Hospital', 'Budget Hospital', '2015-04-01', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
