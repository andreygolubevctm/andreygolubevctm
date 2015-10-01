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

-- Dumping data for table ctm.export_product_properties_search: ~1,344 rows (approximately)
DELETE FROM `export_product_properties_search`;
/*!40000 ALTER TABLE `export_product_properties_search` DISABLE KEYS */;
INSERT INTO `export_product_properties_search` (`productId`, `ProductIdentifier`, `state`, `membership`, `productType`, `excessAmount`, `HospitalType`, `monthlyPremium`, `monthlyLHC`) VALUES
	(5555081, 33162, 'NSW', 'C', 'GeneralHealth', 0, '', 49.900001525878906, 0),
	(5555082, 33163, 'NSW', 'F', 'GeneralHealth', 0, '', 49.900001525878906, 0),
	(5555083, 33164, 'NSW', 'S', 'GeneralHealth', 0, '', 24.950000762939453, 0),
	(5555084, 35058, 'NSW', 'SP', 'GeneralHealth', 0, '', 49.900001525878906, 0),
	(5555085, 33159, 'NT', 'C', 'GeneralHealth', 0, '', 43.20000076293945, 0),
	(5555086, 33160, 'NT', 'F', 'GeneralHealth', 0, '', 43.20000076293945, 0),
	(5555087, 33161, 'NT', 'S', 'GeneralHealth', 0, '', 21.600000381469727, 0),
	(5555088, 35059, 'NT', 'SP', 'GeneralHealth', 0, '', 43.20000076293945, 0),
	(5555089, 33165, 'QLD', 'C', 'GeneralHealth', 0, '', 48.900001525878906, 0),
	(5555090, 33167, 'QLD', 'F', 'GeneralHealth', 0, '', 48.900001525878906, 0),
	(5555091, 33166, 'QLD', 'S', 'GeneralHealth', 0, '', 24.450000762939453, 0),
	(5555092, 35060, 'QLD', 'SP', 'GeneralHealth', 0, '', 48.900001525878906, 0),
	(5555093, 33168, 'SA', 'C', 'GeneralHealth', 0, '', 55.29999923706055, 0),
	(5555094, 33170, 'SA', 'F', 'GeneralHealth', 0, '', 55.29999923706055, 0),
	(5555095, 33169, 'SA', 'S', 'GeneralHealth', 0, '', 27.649999618530273, 0),
	(5555096, 35061, 'SA', 'SP', 'GeneralHealth', 0, '', 55.29999923706055, 0),
	(5555097, 33171, 'TAS', 'C', 'GeneralHealth', 0, '', 43.20000076293945, 0),
	(5555098, 33172, 'TAS', 'F', 'GeneralHealth', 0, '', 43.20000076293945, 0),
	(5555099, 33173, 'TAS', 'S', 'GeneralHealth', 0, '', 21.600000381469727, 0),
	(5555100, 35062, 'TAS', 'SP', 'GeneralHealth', 0, '', 43.20000076293945, 0),
	(5555101, 33174, 'VIC', 'C', 'GeneralHealth', 0, '', 51.099998474121094, 0),
	(5555102, 33175, 'VIC', 'F', 'GeneralHealth', 0, '', 51.099998474121094, 0),
	(5555103, 33176, 'VIC', 'S', 'GeneralHealth', 0, '', 25.549999237060547, 0),
	(5555104, 35063, 'VIC', 'SP', 'GeneralHealth', 0, '', 51.099998474121094, 0),
	(5555105, 33177, 'WA', 'C', 'GeneralHealth', 0, '', 45.900001525878906, 0),
	(5555106, 33178, 'WA', 'F', 'GeneralHealth', 0, '', 45.900001525878906, 0),
	(5555107, 33179, 'WA', 'S', 'GeneralHealth', 0, '', 22.950000762939453, 0),
	(5555108, 35064, 'WA', 'SP', 'GeneralHealth', 0, '', 45.900001525878906, 0),
	(5555361, 35212, 'NSW', 'C', 'GeneralHealth', 0, '', 228.1999969482422, 0),
	(5555362, 35213, 'NSW', 'F', 'GeneralHealth', 0, '', 228.1999969482422, 0),
	(5555363, 35214, 'NSW', 'S', 'GeneralHealth', 0, '', 114.0999984741211, 0),
	(5555364, 35215, 'NSW', 'SP', 'GeneralHealth', 0, '', 228.1999969482422, 0),
	(5555365, 35216, 'NT', 'C', 'GeneralHealth', 0, '', 149, 0),
	(5555366, 35217, 'NT', 'F', 'GeneralHealth', 0, '', 149, 0),
	(5555367, 35218, 'NT', 'S', 'GeneralHealth', 0, '', 74.5, 0),
	(5555368, 35219, 'NT', 'SP', 'GeneralHealth', 0, '', 149, 0),
	(5555369, 35220, 'QLD', 'C', 'GeneralHealth', 0, '', 207.1999969482422, 0),
	(5555370, 35221, 'QLD', 'F', 'GeneralHealth', 0, '', 207.1999969482422, 0),
	(5555371, 35222, 'QLD', 'S', 'GeneralHealth', 0, '', 103.5999984741211, 0),
	(5555372, 35223, 'QLD', 'SP', 'GeneralHealth', 0, '', 207.1999969482422, 0),
	(5555373, 35224, 'SA', 'C', 'GeneralHealth', 0, '', 220.39999389648438, 0),
	(5555374, 35225, 'SA', 'F', 'GeneralHealth', 0, '', 220.39999389648438, 0),
	(5555375, 35226, 'SA', 'S', 'GeneralHealth', 0, '', 110.19999694824219, 0),
	(5555376, 35227, 'SA', 'SP', 'GeneralHealth', 0, '', 220.39999389648438, 0),
	(5555377, 35228, 'TAS', 'C', 'GeneralHealth', 0, '', 169.10000610351562, 0),
	(5555378, 35229, 'TAS', 'F', 'GeneralHealth', 0, '', 169.10000610351562, 0),
	(5555379, 35230, 'TAS', 'S', 'GeneralHealth', 0, '', 84.55000305175781, 0),
	(5555380, 35231, 'TAS', 'SP', 'GeneralHealth', 0, '', 169.10000610351562, 0),
	(5555381, 35232, 'VIC', 'C', 'GeneralHealth', 0, '', 216.1999969482422, 0),
	(5555382, 35233, 'VIC', 'F', 'GeneralHealth', 0, '', 216.1999969482422, 0),
	(5555383, 35234, 'VIC', 'S', 'GeneralHealth', 0, '', 108.0999984741211, 0),
	(5555384, 35235, 'VIC', 'SP', 'GeneralHealth', 0, '', 216.1999969482422, 0),
	(5555385, 35236, 'WA', 'C', 'GeneralHealth', 0, '', 185.39999389648438, 0),
	(5555386, 35237, 'WA', 'F', 'GeneralHealth', 0, '', 185.39999389648438, 0),
	(5555387, 35238, 'WA', 'S', 'GeneralHealth', 0, '', 92.69999694824219, 0),
	(5555388, 35239, 'WA', 'SP', 'GeneralHealth', 0, '', 185.39999389648438, 0),
	(5555389, 33142, 'NSW', 'C', 'GeneralHealth', 0, '', 151, 0),
	(5555390, 33143, 'NSW', 'F', 'GeneralHealth', 0, '', 151, 0),
	(5555391, 33141, 'NSW', 'S', 'GeneralHealth', 0, '', 75.5, 0),
	(5555392, 35065, 'NSW', 'SP', 'GeneralHealth', 0, '', 151, 0),
	(5555393, 33139, 'NT', 'C', 'GeneralHealth', 0, '', 113.9000015258789, 0),
	(5555394, 33140, 'NT', 'F', 'GeneralHealth', 0, '', 113.9000015258789, 0),
	(5555395, 33138, 'NT', 'S', 'GeneralHealth', 0, '', 56.95000076293945, 0),
	(5555396, 35066, 'NT', 'SP', 'GeneralHealth', 0, '', 113.9000015258789, 0),
	(5555397, 33145, 'QLD', 'C', 'GeneralHealth', 0, '', 126.5, 0),
	(5555398, 33146, 'QLD', 'F', 'GeneralHealth', 0, '', 126.5, 0),
	(5555399, 33144, 'QLD', 'S', 'GeneralHealth', 0, '', 63.25, 0),
	(5555400, 35067, 'QLD', 'SP', 'GeneralHealth', 0, '', 126.5, 0),
	(5555401, 33148, 'SA', 'C', 'GeneralHealth', 0, '', 131.6999969482422, 0),
	(5555402, 33149, 'SA', 'F', 'GeneralHealth', 0, '', 131.6999969482422, 0),
	(5555403, 33147, 'SA', 'S', 'GeneralHealth', 0, '', 65.8499984741211, 0),
	(5555404, 35068, 'SA', 'SP', 'GeneralHealth', 0, '', 131.6999969482422, 0),
	(5555405, 33151, 'TAS', 'C', 'GeneralHealth', 0, '', 104, 0),
	(5555406, 33152, 'TAS', 'F', 'GeneralHealth', 0, '', 104, 0),
	(5555407, 33150, 'TAS', 'S', 'GeneralHealth', 0, '', 52, 0),
	(5555408, 35069, 'TAS', 'SP', 'GeneralHealth', 0, '', 104, 0),
	(5555409, 33154, 'VIC', 'C', 'GeneralHealth', 0, '', 140.3000030517578, 0),
	(5555410, 33155, 'VIC', 'F', 'GeneralHealth', 0, '', 140.3000030517578, 0),
	(5555411, 33153, 'VIC', 'S', 'GeneralHealth', 0, '', 70.1500015258789, 0),
	(5555412, 35070, 'VIC', 'SP', 'GeneralHealth', 0, '', 140.3000030517578, 0),
	(5555413, 33157, 'WA', 'C', 'GeneralHealth', 0, '', 122.4000015258789, 0),
	(5555414, 33158, 'WA', 'F', 'GeneralHealth', 0, '', 122.4000015258789, 0),
	(5555415, 33156, 'WA', 'S', 'GeneralHealth', 0, '', 61.20000076293945, 0),
	(5555416, 35071, 'WA', 'SP', 'GeneralHealth', 0, '', 122.4000015258789, 0);
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
