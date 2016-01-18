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

-- Dumping structure for table ctm.export_product_capping_exclusions
DROP TABLE IF EXISTS `export_product_capping_exclusions`;
CREATE TABLE IF NOT EXISTS `export_product_capping_exclusions` (
  `productId` int(11) NOT NULL,
  `effectiveStart` date NOT NULL,
  `effectiveEnd` date NOT NULL,
  PRIMARY KEY (`productId`,`effectiveStart`,`effectiveEnd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_capping_exclusions: ~28 rows (approximately)
DELETE FROM `export_product_capping_exclusions`;
/*!40000 ALTER TABLE `export_product_capping_exclusions` DISABLE KEYS */;
INSERT INTO `export_product_capping_exclusions` (`productId`, `effectiveStart`, `effectiveEnd`) VALUES
	(5626905, '2015-04-01', '2016-03-31'),
	(5626906, '2015-04-01', '2016-03-31'),
	(5626907, '2015-04-01', '2016-03-31'),
	(5626908, '2015-04-01', '2016-03-31'),
	(5626909, '2015-04-01', '2016-03-31'),
	(5626910, '2015-04-01', '2016-03-31'),
	(5626911, '2015-04-01', '2016-03-31'),
	(5626912, '2015-04-01', '2016-03-31'),
	(5626913, '2015-04-01', '2016-03-31'),
	(5626914, '2015-04-01', '2016-03-31'),
	(5626915, '2015-04-01', '2016-03-31'),
	(5626916, '2015-04-01', '2016-03-31'),
	(5626917, '2015-04-01', '2016-03-31'),
	(5626918, '2015-04-01', '2016-03-31'),
	(5626919, '2015-04-01', '2016-03-31'),
	(5626920, '2015-04-01', '2016-03-31'),
	(5626921, '2015-04-01', '2016-03-31'),
	(5626922, '2015-04-01', '2016-03-31'),
	(5626923, '2015-04-01', '2016-03-31'),
	(5626924, '2015-04-01', '2016-03-31'),
	(5626925, '2015-04-01', '2016-03-31'),
	(5626926, '2015-04-01', '2016-03-31'),
	(5626927, '2015-04-01', '2016-03-31'),
	(5626928, '2015-04-01', '2016-03-31'),
	(5626929, '2015-04-01', '2016-03-31'),
	(5626930, '2015-04-01', '2016-03-31'),
	(5626931, '2015-04-01', '2016-03-31'),
	(5626932, '2015-04-01', '2016-03-31');
/*!40000 ALTER TABLE `export_product_capping_exclusions` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
