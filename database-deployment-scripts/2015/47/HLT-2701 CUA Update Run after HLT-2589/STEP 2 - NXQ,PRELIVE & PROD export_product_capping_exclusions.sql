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

-- Dumping data for table ctm.export_product_capping_exclusions: ~0 rows (approximately)
DELETE FROM `export_product_capping_exclusions`;
/*!40000 ALTER TABLE `export_product_capping_exclusions` DISABLE KEYS */;
INSERT INTO `export_product_capping_exclusions` (`productId`, `effectiveStart`, `effectiveEnd`) VALUES
	(5626569, '2015-04-01', '2016-03-31'),
	(5626570, '2015-04-01', '2016-03-31'),
	(5626571, '2015-04-01', '2016-03-31'),
	(5626572, '2015-04-01', '2016-03-31'),
	(5626573, '2015-04-01', '2016-03-31'),
	(5626574, '2015-04-01', '2016-03-31'),
	(5626575, '2015-04-01', '2016-03-31'),
	(5626576, '2015-04-01', '2016-03-31'),
	(5626577, '2015-04-01', '2016-03-31'),
	(5626578, '2015-04-01', '2016-03-31'),
	(5626579, '2015-04-01', '2016-03-31'),
	(5626580, '2015-04-01', '2016-03-31'),
	(5626581, '2015-04-01', '2016-03-31'),
	(5626582, '2015-04-01', '2016-03-31'),
	(5626583, '2015-04-01', '2016-03-31'),
	(5626584, '2015-04-01', '2016-03-31'),
	(5626585, '2015-04-01', '2016-03-31'),
	(5626586, '2015-04-01', '2016-03-31'),
	(5626587, '2015-04-01', '2016-03-31'),
	(5626588, '2015-04-01', '2016-03-31'),
	(5626589, '2015-04-01', '2016-03-31'),
	(5626590, '2015-04-01', '2016-03-31'),
	(5626591, '2015-04-01', '2016-03-31'),
	(5626592, '2015-04-01', '2016-03-31'),
	(5626593, '2015-04-01', '2016-03-31'),
	(5626594, '2015-04-01', '2016-03-31'),
	(5626595, '2015-04-01', '2016-03-31'),
	(5626596, '2015-04-01', '2016-03-31');
/*!40000 ALTER TABLE `export_product_capping_exclusions` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
