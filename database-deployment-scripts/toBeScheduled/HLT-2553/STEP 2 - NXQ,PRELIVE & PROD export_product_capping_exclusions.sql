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

-- Dumping structure for table ctm.export_product_capping_exclusions
DROP TABLE IF EXISTS `export_product_capping_exclusions`;
CREATE TABLE IF NOT EXISTS `export_product_capping_exclusions` (
  `productId` int(11) NOT NULL,
  `effectiveStart` date NOT NULL,
  `effectiveEnd` date NOT NULL,
  PRIMARY KEY (`productId`,`effectiveStart`,`effectiveEnd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_capping_exclusions: ~0 rows (approximately)
DELETE FROM `export_product_capping_exclusions`;
/*!40000 ALTER TABLE `export_product_capping_exclusions` DISABLE KEYS */;
INSERT INTO `export_product_capping_exclusions` (`productId`, `effectiveStart`, `effectiveEnd`) VALUES
	(5568801, '2015-05-25', '2016-03-31'),
	(5568802, '2015-05-25', '2016-03-31'),
	(5568803, '2015-05-25', '2016-03-31'),
	(5568804, '2015-05-25', '2016-03-31'),
	(5568805, '2015-05-25', '2016-03-31'),
	(5568806, '2015-05-25', '2016-03-31'),
	(5568807, '2015-05-25', '2016-03-31'),
	(5568808, '2015-05-25', '2016-03-31'),
	(5568809, '2015-05-25', '2016-03-31'),
	(5568810, '2015-05-25', '2016-03-31'),
	(5568811, '2015-05-25', '2016-03-31'),
	(5568812, '2015-05-25', '2016-03-31'),
	(5568813, '2015-05-25', '2016-03-31'),
	(5568814, '2015-05-25', '2016-03-31'),
	(5568815, '2015-05-25', '2016-03-31'),
	(5568816, '2015-05-25', '2016-03-31'),
	(5568817, '2015-05-25', '2016-03-31'),
	(5568818, '2015-05-25', '2016-03-31'),
	(5568819, '2015-05-25', '2016-03-31'),
	(5568820, '2015-05-25', '2016-03-31'),
	(5568821, '2015-05-25', '2016-03-31'),
	(5568822, '2015-05-25', '2016-03-31'),
	(5568823, '2015-05-25', '2016-03-31'),
	(5568824, '2015-05-25', '2016-03-31'),
	(5568825, '2015-05-25', '2016-03-31'),
	(5568826, '2015-05-25', '2016-03-31'),
	(5568827, '2015-05-25', '2016-03-31'),
	(5568828, '2015-05-25', '2016-03-31');
/*!40000 ALTER TABLE `export_product_capping_exclusions` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
