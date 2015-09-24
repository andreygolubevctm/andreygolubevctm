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

-- Dumping data for table ctm.export_product_capping_exclusions: ~28 rows (approximately)
DELETE FROM `export_product_capping_exclusions`;
/*!40000 ALTER TABLE `export_product_capping_exclusions` DISABLE KEYS */;
INSERT INTO `export_product_capping_exclusions` (`productId`, `effectiveStart`, `effectiveEnd`) VALUES
	(5572357, '2015-05-25', '2016-03-31'),
	(5572358, '2015-05-25', '2016-03-31'),
	(5572359, '2015-05-25', '2016-03-31'),
	(5572360, '2015-05-25', '2016-03-31'),
	(5572361, '2015-05-25', '2016-03-31'),
	(5572362, '2015-05-25', '2016-03-31'),
	(5572363, '2015-05-25', '2016-03-31'),
	(5572364, '2015-05-25', '2016-03-31'),
	(5572365, '2015-05-25', '2016-03-31'),
	(5572366, '2015-05-25', '2016-03-31'),
	(5572367, '2015-05-25', '2016-03-31'),
	(5572368, '2015-05-25', '2016-03-31'),
	(5572369, '2015-05-25', '2016-03-31'),
	(5572370, '2015-05-25', '2016-03-31'),
	(5572371, '2015-05-25', '2016-03-31'),
	(5572372, '2015-05-25', '2016-03-31'),
	(5572373, '2015-05-25', '2016-03-31'),
	(5572374, '2015-05-25', '2016-03-31'),
	(5572375, '2015-05-25', '2016-03-31'),
	(5572376, '2015-05-25', '2016-03-31'),
	(5572377, '2015-05-25', '2016-03-31'),
	(5572378, '2015-05-25', '2016-03-31'),
	(5572379, '2015-05-25', '2016-03-31'),
	(5572380, '2015-05-25', '2016-03-31'),
	(5572381, '2015-05-25', '2016-03-31'),
	(5572382, '2015-05-25', '2016-03-31'),
	(5572383, '2015-05-25', '2016-03-31'),
	(5572384, '2015-05-25', '2016-03-31');
/*!40000 ALTER TABLE `export_product_capping_exclusions` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
