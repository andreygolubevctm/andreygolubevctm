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

-- Dumping data for table ctm.export_product_properties_search: ~0 rows (approximately)
DELETE FROM `export_product_properties_search`;
/*!40000 ALTER TABLE `export_product_properties_search` DISABLE KEYS */;
INSERT INTO `export_product_properties_search` (`productId`, `ProductIdentifier`, `state`, `membership`, `productType`, `excessAmount`, `HospitalType`, `monthlyPremium`, `monthlyLHC`) VALUES
	(5560281, 34220, 'QLD', 'C', 'Hospital', 0, 'PrivateHospital', 394.04998779296875, 394.04998779296875),
	(5560282, 34221, 'QLD', 'F', 'Hospital', 0, 'PrivateHospital', 394.04998779296875, 394.04998779296875),
	(5560283, 34222, 'QLD', 'SP', 'Hospital', 0, 'PrivateHospital', 315.1499938964844, 315.1499938964844),
	(5560284, 34223, 'QLD', 'S', 'Hospital', 0, 'PrivateHospital', 197.0500030517578, 197.0500030517578),
	(5560285, 34224, 'QLD', 'S', 'Hospital', 250, 'PrivateHospital', 177.10000610351562, 177.10000610351562),
	(5560286, 34225, 'QLD', 'C', 'Hospital', 250, 'PrivateHospital', 354.25, 354.25),
	(5560287, 34226, 'QLD', 'F', 'Hospital', 250, 'PrivateHospital', 354.25, 354.25),
	(5560288, 34227, 'QLD', 'SP', 'Hospital', 250, 'PrivateHospital', 283.25, 283.25),
	(5560289, 34228, 'QLD', 'S', 'Hospital', 500, 'PrivateHospital', 155.85000610351562, 155.85000610351562),
	(5560290, 34229, 'QLD', 'C', 'Hospital', 500, 'PrivateHospital', 311.70001220703125, 311.70001220703125),
	(5560291, 34230, 'QLD', 'F', 'Hospital', 500, 'PrivateHospital', 311.70001220703125, 311.70001220703125),
	(5560292, 34231, 'QLD', 'SP', 'Hospital', 500, 'PrivateHospital', 249.1999969482422, 249.1999969482422),
	(5560293, 34232, 'QLD', 'S', 'Combined', 0, 'PrivateHospital', 235.60000610351562, 197.0500030517578),
	(5560294, 34233, 'QLD', 'C', 'Combined', 0, 'PrivateHospital', 471.1499938964844, 394.04998779296875),
	(5560295, 34234, 'QLD', 'F', 'Combined', 0, 'PrivateHospital', 471.1499938964844, 394.04998779296875),
	(5560296, 34235, 'QLD', 'SP', 'Combined', 0, 'PrivateHospital', 392.29998779296875, 315.1499938964844),
	(5560297, 34292, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 184.6999969482422, 118),
	(5560298, 34293, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 369.20001220703125, 235.75),
	(5560299, 34294, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 369.20001220703125, 235.75),
	(5560300, 34295, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 369.20001220703125, 235.75),
	(5560301, 34240, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 215.64999389648438, 177.10000610351562),
	(5560302, 34241, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 431.3999938964844, 354.25),
	(5560303, 34242, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 431.3999938964844, 354.25),
	(5560304, 34243, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 360.3999938964844, 283.25),
	(5560305, 34296, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 167.3000030517578, 100.5999984741211),
	(5560306, 34297, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 334.6000061035156, 201.1999969482422),
	(5560307, 34298, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 334.6000061035156, 201.1999969482422),
	(5560308, 34299, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 334.6000061035156, 201.1999969482422),
	(5560309, 34248, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 194.39999389648438, 155.85000610351562),
	(5560310, 34249, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 388.79998779296875, 311.70001220703125),
	(5560311, 34250, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 388.79998779296875, 311.70001220703125),
	(5560312, 34251, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 326.3500061035156, 249.1999969482422),
	(5560313, 34245, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 487.6499938964844, 354.25),
	(5560314, 34246, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 487.6499938964844, 354.25),
	(5560315, 34247, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 416.70001220703125, 283.25),
	(5560316, 34244, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 243.8000030517578, 177.10000610351562),
	(5560317, 34256, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 149.4499969482422, 115.25),
	(5560318, 34257, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 299, 230.3000030517578),
	(5560319, 34258, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 299, 230.3000030517578),
	(5560320, 34259, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 299, 230.3000030517578),
	(5560321, 34260, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 132.3000030517578, 98),
	(5560322, 34261, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 264.6499938964844, 196.0500030517578),
	(5560323, 34262, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 264.6499938964844, 196.0500030517578),
	(5560324, 34263, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 264.6499938964844, 196.0500030517578),
	(5560325, 34264, 'QLD', 'C', 'Combined', 0, 'PrivateHospital', 453.3500061035156, 394.04998779296875),
	(5560326, 34265, 'QLD', 'S', 'Combined', 0, 'PrivateHospital', 226.6999969482422, 197.0500030517578),
	(5560327, 34266, 'QLD', 'F', 'Combined', 0, 'PrivateHospital', 453.3500061035156, 394.04998779296875),
	(5560328, 34267, 'QLD', 'SP', 'Combined', 0, 'PrivateHospital', 374.5, 315.1499938964844),
	(5560329, 34268, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 413.54998779296875, 354.25),
	(5560330, 34269, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 206.75, 177.10000610351562),
	(5560331, 34270, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 413.54998779296875, 354.25),
	(5560332, 34271, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 342.6000061035156, 283.25),
	(5560333, 34272, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 371, 311.70001220703125),
	(5560334, 34273, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 185.4499969482422, 155.85000610351562),
	(5560335, 34274, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 371, 311.70001220703125),
	(5560336, 34275, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 308.54998779296875, 249.1999969482422),
	(5560337, 34276, 'QLD', 'S', 'Hospital', 250, 'PrivateHospital', 118, 118),
	(5560338, 34277, 'QLD', 'C', 'Hospital', 250, 'PrivateHospital', 235.75, 235.75),
	(5560339, 34278, 'QLD', 'F', 'Hospital', 250, 'PrivateHospital', 235.75, 235.75),
	(5560340, 34279, 'QLD', 'SP', 'Hospital', 250, 'PrivateHospital', 235.75, 235.75),
	(5560341, 34280, 'QLD', 'S', 'Hospital', 500, 'PrivateHospital', 100.5999984741211, 100.5999984741211),
	(5560342, 34281, 'QLD', 'C', 'Hospital', 500, 'PrivateHospital', 201.1999969482422, 201.1999969482422),
	(5560343, 34282, 'QLD', 'F', 'Hospital', 500, 'PrivateHospital', 201.1999969482422, 201.1999969482422),
	(5560344, 34283, 'QLD', 'SP', 'Hospital', 500, 'PrivateHospital', 201.1999969482422, 201.1999969482422),
	(5560345, 34284, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 156.5500030517578, 118),
	(5560346, 34285, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 312.8999938964844, 235.75),
	(5560347, 34286, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 312.8999938964844, 235.75),
	(5560348, 34287, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 312.8999938964844, 235.75),
	(5560349, 34288, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 139.1999969482422, 100.5999984741211),
	(5560350, 34289, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 278.3500061035156, 201.1999969482422),
	(5560351, 34290, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 278.3500061035156, 201.1999969482422),
	(5560352, 34291, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 278.3500061035156, 201.1999969482422),
	(5560353, 34253, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 445.1000061035156, 311.70001220703125),
	(5560354, 34254, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 445.1000061035156, 311.70001220703125),
	(5560355, 34255, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 382.6499938964844, 249.1999969482422),
	(5560356, 34252, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 222.5, 155.85000610351562),
	(5560357, 34236, 'QLD', 'S', 'Combined', 0, 'PrivateHospital', 263.75, 197.0500030517578),
	(5560358, 34237, 'QLD', 'C', 'Combined', 0, 'PrivateHospital', 527.4500122070312, 394.04998779296875),
	(5560359, 34238, 'QLD', 'F', 'Combined', 0, 'PrivateHospital', 527.4500122070312, 394.04998779296875),
	(5560360, 34239, 'QLD', 'SP', 'Combined', 0, 'PrivateHospital', 448.6000061035156, 315.1499938964844),
	(5560361, 34300, 'QLD', 'S', 'Combined', 250, 'PrivateHospital', 147.64999389648438, 118),
	(5560362, 34301, 'QLD', 'C', 'Combined', 250, 'PrivateHospital', 295.1000061035156, 235.75),
	(5560363, 34302, 'QLD', 'F', 'Combined', 250, 'PrivateHospital', 295.1000061035156, 235.75),
	(5560364, 34303, 'QLD', 'SP', 'Combined', 250, 'PrivateHospital', 295.1000061035156, 235.75),
	(5560365, 34304, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 130.25, 100.5999984741211),
	(5560366, 34305, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 260.5, 201.1999969482422),
	(5560367, 34306, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 260.5, 201.1999969482422),
	(5560368, 34307, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 260.5, 201.1999969482422),
	(5560369, 34308, 'QLD', 'S', 'GeneralHealth', 0, '', 29.649999618530273, 0),
	(5560370, 34309, 'QLD', 'C', 'GeneralHealth', 0, '', 59.29999923706055, 0),
	(5560371, 34310, 'QLD', 'F', 'GeneralHealth', 0, '', 59.29999923706055, 0),
	(5560372, 34311, 'QLD', 'SP', 'GeneralHealth', 0, '', 59.29999923706055, 0);
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
