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
  `situationFilter` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`productId`,`state`,`membership`,`productType`,`excessAmount`,`HospitalType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_properties_search: ~0 rows (approximately)
DELETE FROM `export_product_properties_search`;
/*!40000 ALTER TABLE `export_product_properties_search` DISABLE KEYS */;
INSERT INTO `export_product_properties_search` (`productId`, `ProductIdentifier`, `state`, `membership`, `productType`, `excessAmount`, `HospitalType`, `monthlyPremium`, `monthlyLHC`, `situationFilter`) VALUES
	(5636604, 34220, 'QLD', 'C', 'Hospital', 0, 'PrivateHospital', 394.04998779296875, 394.04998779296875, 'N'),
	(5636605, 34221, 'QLD', 'F', 'Hospital', 0, 'PrivateHospital', 394.04998779296875, 394.04998779296875, 'N'),
	(5636606, 34223, 'QLD', 'S', 'Hospital', 0, 'PrivateHospital', 197.0500030517578, 197.0500030517578, 'N'),
	(5636607, 34222, 'QLD', 'SP', 'Hospital', 0, 'PrivateHospital', 315.1499938964844, 315.1499938964844, 'N'),
	(5636608, 34225, 'QLD', 'C', 'Hospital', 250, 'PrivateHospital', 354.25, 354.25, 'N'),
	(5636609, 34226, 'QLD', 'F', 'Hospital', 250, 'PrivateHospital', 354.25, 354.25, 'N'),
	(5636610, 34224, 'QLD', 'S', 'Hospital', 250, 'PrivateHospital', 177.10000610351562, 177.10000610351562, 'N'),
	(5636611, 34227, 'QLD', 'SP', 'Hospital', 250, 'PrivateHospital', 283.25, 283.25, 'N'),
	(5636612, 34241, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 431.3999938964844, 354.25, 'N'),
	(5636613, 34242, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 431.3999938964844, 354.25, 'N'),
	(5636614, 34240, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 215.64999389648438, 177.10000610351562, 'N'),
	(5636615, 34243, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 360.3999938964844, 283.25, 'N'),
	(5636616, 34245, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 487.6499938964844, 354.25, 'N'),
	(5636617, 34246, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 487.6499938964844, 354.25, 'N'),
	(5636618, 34244, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 243.8000030517578, 177.10000610351562, 'N'),
	(5636619, 34247, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 416.70001220703125, 283.25, 'N'),
	(5636620, 34268, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 413.54998779296875, 354.25, 'N'),
	(5636621, 34270, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 413.54998779296875, 354.25, 'N'),
	(5636622, 34269, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 206.75, 177.10000610351562, 'N'),
	(5636623, 34271, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 342.6000061035156, 283.25, 'N'),
	(5636624, 34229, 'QLD', 'C', 'Hospital', 500, 'PrivateHospital', 311.70001220703125, 311.70001220703125, 'N'),
	(5636625, 34230, 'QLD', 'F', 'Hospital', 500, 'PrivateHospital', 311.70001220703125, 311.70001220703125, 'N'),
	(5636626, 34228, 'QLD', 'S', 'Hospital', 500, 'PrivateHospital', 155.85000610351562, 155.85000610351562, 'N'),
	(5636627, 34231, 'QLD', 'SP', 'Hospital', 500, 'PrivateHospital', 249.1999969482422, 249.1999969482422, 'N'),
	(5636628, 34249, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 388.79998779296875, 311.70001220703125, 'N'),
	(5636629, 34250, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 388.79998779296875, 311.70001220703125, 'N'),
	(5636630, 34248, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 194.39999389648438, 155.85000610351562, 'N'),
	(5636631, 34251, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 326.3500061035156, 249.1999969482422, 'N'),
	(5636632, 34253, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 445.1000061035156, 311.70001220703125, 'N'),
	(5636633, 34254, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 445.1000061035156, 311.70001220703125, 'N'),
	(5636634, 34252, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 222.5, 155.85000610351562, 'N'),
	(5636635, 34255, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 382.6499938964844, 249.1999969482422, 'N'),
	(5636636, 34272, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 371, 311.70001220703125, 'N'),
	(5636637, 34274, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 371, 311.70001220703125, 'N'),
	(5636638, 34273, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 185.4499969482422, 155.85000610351562, 'N'),
	(5636639, 34275, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 308.54998779296875, 249.1999969482422, 'N'),
	(5636640, 34233, 'QLD', 'C', 'Combined', 0, 'PrivateHospital', 471.1499938964844, 394.04998779296875, 'N'),
	(5636641, 34234, 'QLD', 'F', 'Combined', 0, 'PrivateHospital', 471.1499938964844, 394.04998779296875, 'N'),
	(5636642, 34232, 'QLD', 'S', 'Combined', 0, 'PrivateHospital', 235.60000610351562, 197.0500030517578, 'N'),
	(5636643, 34235, 'QLD', 'SP', 'Combined', 0, 'PrivateHospital', 392.29998779296875, 315.1499938964844, 'N'),
	(5636644, 34237, 'QLD', 'C', 'Combined', 0, 'PrivateHospital', 527.4500122070312, 394.04998779296875, 'N'),
	(5636645, 34238, 'QLD', 'F', 'Combined', 0, 'PrivateHospital', 527.4500122070312, 394.04998779296875, 'N'),
	(5636646, 34236, 'QLD', 'S', 'Combined', 0, 'PrivateHospital', 263.75, 197.0500030517578, 'N'),
	(5636647, 34239, 'QLD', 'SP', 'Combined', 0, 'PrivateHospital', 448.6000061035156, 315.1499938964844, 'N'),
	(5636648, 34264, 'QLD', 'C', 'Combined', 0, 'PrivateHospital', 453.3500061035156, 394.04998779296875, 'N'),
	(5636649, 34266, 'QLD', 'F', 'Combined', 0, 'PrivateHospital', 453.3500061035156, 394.04998779296875, 'N'),
	(5636650, 34265, 'QLD', 'S', 'Combined', 0, 'PrivateHospital', 226.6999969482422, 197.0500030517578, 'N'),
	(5636651, 34267, 'QLD', 'SP', 'Combined', 0, 'PrivateHospital', 374.5, 315.1499938964844, 'N');
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
