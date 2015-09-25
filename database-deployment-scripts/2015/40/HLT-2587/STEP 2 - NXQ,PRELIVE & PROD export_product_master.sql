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
use ctm;
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
) ENGINE=InnoDB AUTO_INCREMENT=5574735 DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_master: ~28 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5574707, 'HEALTH', 'H20I/NJJS20', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574708, 'HEALTH', 'H20I/NJJW2Y', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574709, 'HEALTH', 'H20I/NFXC10', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574710, 'HEALTH', 'H20I/NJJU1D', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574711, 'HEALTH', 'H20I/DJJY20', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574712, 'HEALTH', 'H20I/DJKC2Y', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574713, 'HEALTH', 'H20I/DJJX10', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574714, 'HEALTH', 'H20I/DJKA1D', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574715, 'HEALTH', 'H20I/QJKE20', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574716, 'HEALTH', 'H20I/QJKI2Y', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574717, 'HEALTH', 'H20I/QJKD10', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574718, 'HEALTH', 'H20I/QJKG1D', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574719, 'HEALTH', 'H20I/SJKK20', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574720, 'HEALTH', 'H20I/SJKO2Y', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574721, 'HEALTH', 'H20I/SJKJ10', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574722, 'HEALTH', 'H20I/SJKM1D', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574723, 'HEALTH', 'H20I/TJKQ20', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574724, 'HEALTH', 'H20I/TJKU2Y', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574725, 'HEALTH', 'H20I/TJKP10', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574726, 'HEALTH', 'H20I/TJKS1D', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574727, 'HEALTH', 'H20I/VJKW20', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574728, 'HEALTH', 'H20I/VJLA2Y', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574729, 'HEALTH', 'H20I/VJKV10', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574730, 'HEALTH', 'H20I/VJKY1D', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574731, 'HEALTH', 'H20I/WJLC20', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574732, 'HEALTH', 'H20I/WJLG2Y', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574733, 'HEALTH', 'H20I/WJLB10', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', ''),
	(5574734, 'HEALTH', 'H20I/WJLE1D', 2, 'Accident Only Hospital Cover', 'Accident Only Hospital Cover', '2015-08-25', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
