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
-- Dumping structure for table ctm.export_product_properties_search
DROP TABLE IF EXISTS `export_product_properties_search`;
CREATE TABLE IF NOT EXISTS `export_product_properties_search` (
  `productId` int(11) NOT NULL,
  `ProductIdentifier` int(11) DEFAULT NULL,
  `state` char(3) NOT NULL,
  `membership` char(3) NOT NULL,
  `productType` char(15) NOT NULL,
  `excessAmount` int(11) NOT NULL,
  `HospitalType` char(20) NOT NULL,
  `monthlyPremium` double DEFAULT NULL,
  `monthlyLHC` double DEFAULT NULL,
  PRIMARY KEY (`productId`,`state`,`membership`,`productType`,`excessAmount`,`HospitalType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_properties_search: ~28 rows (approximately)
DELETE FROM `export_product_properties_search`;
/*!40000 ALTER TABLE `export_product_properties_search` DISABLE KEYS */;
INSERT INTO `export_product_properties_search` (`productId`, `ProductIdentifier`, `state`, `membership`, `productType`, `excessAmount`, `HospitalType`, `monthlyPremium`, `monthlyLHC`) VALUES
	(5574707, 22935, 'NSW', 'C', 'Hospital', 500, 'PrivateHospital', 178.10000610351562, 162.10000610351562),
	(5574708, 22936, 'NSW', 'F', 'Hospital', 500, 'PrivateHospital', 183.60000610351562, 166.9499969482422),
	(5574709, 22937, 'NSW', 'S', 'Hospital', 500, 'PrivateHospital', 89.05000305175781, 81.05000305175781),
	(5574710, 22938, 'NSW', 'SP', 'Hospital', 500, 'PrivateHospital', 178.10000610351562, 162.10000610351562),
	(5574711, 22939, 'NT', 'C', 'Hospital', 500, 'PrivateHospital', 64.19999694824219, 58.099998474121094),
	(5574712, 22940, 'NT', 'F', 'Hospital', 500, 'PrivateHospital', 66.1500015258789, 59.79999923706055),
	(5574713, 22941, 'NT', 'S', 'Hospital', 500, 'PrivateHospital', 32.099998474121094, 29.049999237060547),
	(5574714, 22942, 'NT', 'SP', 'Hospital', 500, 'PrivateHospital', 64.19999694824219, 58.099998474121094),
	(5574715, 22943, 'QLD', 'C', 'Hospital', 500, 'PrivateHospital', 169.39999389648438, 165.10000610351562),
	(5574716, 22944, 'QLD', 'F', 'Hospital', 500, 'PrivateHospital', 174.5, 170.0500030517578),
	(5574717, 22945, 'QLD', 'S', 'Hospital', 500, 'PrivateHospital', 84.69999694824219, 82.55000305175781),
	(5574718, 22946, 'QLD', 'SP', 'Hospital', 500, 'PrivateHospital', 169.39999389648438, 165.10000610351562),
	(5574719, 22947, 'SA', 'C', 'Hospital', 500, 'PrivateHospital', 159.89999389648438, 146.5),
	(5574720, 22948, 'SA', 'F', 'Hospital', 500, 'PrivateHospital', 164.85000610351562, 150.89999389648438),
	(5574721, 22949, 'SA', 'S', 'Hospital', 500, 'PrivateHospital', 79.94999694824219, 73.25),
	(5574722, 22950, 'SA', 'SP', 'Hospital', 500, 'PrivateHospital', 159.89999389648438, 146.5),
	(5574723, 22951, 'TAS', 'C', 'Hospital', 500, 'PrivateHospital', 177.1999969482422, 172.89999389648438),
	(5574724, 22952, 'TAS', 'F', 'Hospital', 500, 'PrivateHospital', 182.5, 178.0500030517578),
	(5574725, 22953, 'TAS', 'S', 'Hospital', 500, 'PrivateHospital', 88.5999984741211, 86.44999694824219),
	(5574726, 22954, 'TAS', 'SP', 'Hospital', 500, 'PrivateHospital', 177.1999969482422, 172.89999389648438),
	(5574727, 22955, 'VIC', 'C', 'Hospital', 500, 'PrivateHospital', 173.8000030517578, 164.6999969482422),
	(5574728, 22956, 'VIC', 'F', 'Hospital', 500, 'PrivateHospital', 179.0500030517578, 169.60000610351562),
	(5574729, 22957, 'VIC', 'S', 'Hospital', 500, 'PrivateHospital', 86.9000015258789, 82.3499984741211),
	(5574730, 22958, 'VIC', 'SP', 'Hospital', 500, 'PrivateHospital', 173.8000030517578, 164.6999969482422),
	(5574731, 22959, 'WA', 'C', 'Hospital', 500, 'PrivateHospital', 129.10000610351562, 121.30000305175781),
	(5574732, 22960, 'WA', 'F', 'Hospital', 500, 'PrivateHospital', 133, 124.9000015258789),
	(5574733, 22961, 'WA', 'S', 'Hospital', 500, 'PrivateHospital', 64.55000305175781, 60.650001525878906),
	(5574734, 22962, 'WA', 'SP', 'Hospital', 500, 'PrivateHospital', 129.10000610351562, 121.30000305175781);
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
