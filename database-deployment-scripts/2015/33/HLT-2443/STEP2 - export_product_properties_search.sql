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

-- Dumping structure for table ctm.export_product_properties_search
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
	(5507224, 34981, 'NSW', 'C', 'Hospital', 500, 'PrivateHospital', 207.89999389648438, 184.89999389648438),
	(5507225, 19154, 'NSW', 'F', 'Hospital', 500, 'PrivateHospital', 207.89999389648438, 184.89999389648438),
	(5507226, 19163, 'NSW', 'S', 'Hospital', 500, 'PrivateHospital', 103.94999694824219, 92.44999694824219),
	(5507227, 19168, 'NSW', 'SP', 'Hospital', 500, 'PrivateHospital', 180.14999389648438, 157.14999389648438),
	(5507228, 34982, 'NT', 'C', 'Hospital', 500, 'PrivateHospital', 101.0999984741211, 101.0999984741211),
	(5507229, 19132, 'NT', 'F', 'Hospital', 500, 'PrivateHospital', 101.0999984741211, 101.0999984741211),
	(5507230, 19121, 'NT', 'S', 'Hospital', 500, 'PrivateHospital', 50.54999923706055, 50.54999923706055),
	(5507231, 19126, 'NT', 'SP', 'Hospital', 500, 'PrivateHospital', 85.94999694824219, 85.94999694824219),
	(5507232, 34983, 'QLD', 'C', 'Hospital', 500, 'PrivateHospital', 221.6999969482422, 221.6999969482422),
	(5507233, 19186, 'QLD', 'F', 'Hospital', 500, 'PrivateHospital', 221.6999969482422, 221.6999969482422),
	(5507234, 19200, 'QLD', 'S', 'Hospital', 500, 'PrivateHospital', 110.8499984741211, 110.8499984741211),
	(5507235, 19195, 'QLD', 'SP', 'Hospital', 500, 'PrivateHospital', 188.4499969482422, 188.4499969482422),
	(5507236, 34984, 'SA', 'C', 'Hospital', 500, 'PrivateHospital', 199.6999969482422, 199.6999969482422),
	(5507237, 19228, 'SA', 'F', 'Hospital', 500, 'PrivateHospital', 199.6999969482422, 199.6999969482422),
	(5507238, 19217, 'SA', 'S', 'Hospital', 500, 'PrivateHospital', 99.8499984741211, 99.8499984741211),
	(5507239, 19222, 'SA', 'SP', 'Hospital', 500, 'PrivateHospital', 169.75, 169.75),
	(5507240, 34985, 'TAS', 'C', 'Hospital', 500, 'PrivateHospital', 240.6999969482422, 240.6999969482422),
	(5507241, 19250, 'TAS', 'F', 'Hospital', 500, 'PrivateHospital', 240.6999969482422, 240.6999969482422),
	(5507242, 19264, 'TAS', 'S', 'Hospital', 500, 'PrivateHospital', 120.3499984741211, 120.3499984741211),
	(5507243, 19259, 'TAS', 'SP', 'Hospital', 500, 'PrivateHospital', 204.60000610351562, 204.60000610351562),
	(5507244, 34986, 'VIC', 'C', 'Hospital', 500, 'PrivateHospital', 221.6999969482422, 221.6999969482422),
	(5507245, 19292, 'VIC', 'F', 'Hospital', 500, 'PrivateHospital', 221.6999969482422, 221.6999969482422),
	(5507246, 19281, 'VIC', 'S', 'Hospital', 500, 'PrivateHospital', 110.8499984741211, 110.8499984741211),
	(5507247, 19286, 'VIC', 'SP', 'Hospital', 500, 'PrivateHospital', 188.4499969482422, 188.4499969482422),
	(5507248, 34987, 'WA', 'C', 'Hospital', 500, 'PrivateHospital', 154.10000610351562, 154.10000610351562),
	(5507249, 19324, 'WA', 'F', 'Hospital', 500, 'PrivateHospital', 154.10000610351562, 154.10000610351562),
	(5507250, 19313, 'WA', 'S', 'Hospital', 500, 'PrivateHospital', 77.05000305175781, 77.05000305175781),
	(5507251, 19318, 'WA', 'SP', 'Hospital', 500, 'PrivateHospital', 131, 131);
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
