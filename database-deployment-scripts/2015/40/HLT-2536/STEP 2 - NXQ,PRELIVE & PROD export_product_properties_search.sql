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

-- Dumping data for table ctm.export_product_properties_search: ~98 rows (approximately)
DELETE FROM `export_product_properties_search`;
/*!40000 ALTER TABLE `export_product_properties_search` DISABLE KEYS */;
INSERT INTO `export_product_properties_search` (`productId`, `ProductIdentifier`, `state`, `membership`, `productType`, `excessAmount`, `HospitalType`, `monthlyPremium`, `monthlyLHC`) VALUES
	(5559312, 36989, 'NSW', 'C', 'Combined', 500, 'PrivateHospital', 350, 251.02000427246094),
	(5559313, 36991, 'NSW', 'F', 'Combined', 500, 'PrivateHospital', 382.70001220703125, 276.1199951171875),
	(5559314, 36988, 'NSW', 'S', 'Combined', 500, 'PrivateHospital', 175, 125.51000213623047),
	(5559315, 36990, 'NSW', 'SP', 'Combined', 500, 'PrivateHospital', 300.95001220703125, 213.3699951171875),
	(5559316, 37073, 'NT', 'C', 'Combined', 500, 'PrivateHospital', 196.5, 111.13999938964844),
	(5559317, 37075, 'NT', 'F', 'Combined', 500, 'PrivateHospital', 216.14999389648438, 122.26000213623047),
	(5559318, 37072, 'NT', 'S', 'Combined', 500, 'PrivateHospital', 98.25, 55.56999969482422),
	(5559319, 37074, 'NT', 'SP', 'Combined', 500, 'PrivateHospital', 167.0500030517578, 94.48999786376953),
	(5559320, 37017, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 362.20001220703125, 281.0400085449219),
	(5559321, 37019, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 398.3999938964844, 309.1300048828125),
	(5559322, 37016, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 181.10000610351562, 140.52000427246094),
	(5559323, 37018, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 307.8500061035156, 238.8699951171875),
	(5559324, 37031, 'SA', 'C', 'Combined', 500, 'PrivateHospital', 358.29998779296875, 277),
	(5559325, 37033, 'SA', 'F', 'Combined', 500, 'PrivateHospital', 394.1499938964844, 304.7200012207031),
	(5559326, 37030, 'SA', 'S', 'Combined', 500, 'PrivateHospital', 179.14999389648438, 138.5),
	(5559327, 37032, 'SA', 'SP', 'Combined', 500, 'PrivateHospital', 304.54998779296875, 235.4499969482422),
	(5559328, 37059, 'TAS', 'C', 'Combined', 500, 'PrivateHospital', 344.3999938964844, 263.010009765625),
	(5559329, 37061, 'TAS', 'F', 'Combined', 500, 'PrivateHospital', 378.8500061035156, 289.32000732421875),
	(5559330, 37058, 'TAS', 'S', 'Combined', 500, 'PrivateHospital', 172.1999969482422, 131.5),
	(5559331, 37060, 'TAS', 'SP', 'Combined', 500, 'PrivateHospital', 292.75, 223.55999755859375),
	(5559332, 37003, 'VIC', 'C', 'Combined', 500, 'PrivateHospital', 343.8999938964844, 262.54998779296875),
	(5559333, 37005, 'VIC', 'F', 'Combined', 500, 'PrivateHospital', 378.29998779296875, 288.80999755859375),
	(5559334, 37002, 'VIC', 'S', 'Combined', 500, 'PrivateHospital', 171.9499969482422, 131.27000427246094),
	(5559335, 37004, 'VIC', 'SP', 'Combined', 500, 'PrivateHospital', 292.29998779296875, 223.14999389648438),
	(5559336, 37045, 'WA', 'C', 'Combined', 500, 'PrivateHospital', 298.29998779296875, 216.02999877929688),
	(5559337, 37047, 'WA', 'F', 'Combined', 500, 'PrivateHospital', 328.1499938964844, 237.63999938964844),
	(5559338, 37044, 'WA', 'S', 'Combined', 500, 'PrivateHospital', 149.14999389648438, 108.01000213623047),
	(5559339, 37046, 'WA', 'SP', 'Combined', 500, 'PrivateHospital', 253.5500030517578, 183.6199951171875),
	(5559340, 36993, 'NSW', 'C', 'Combined', 500, 'PrivateHospital', 433, 311.8399963378906),
	(5559341, 36995, 'NSW', 'F', 'Combined', 500, 'PrivateHospital', 474, 343.0299987792969),
	(5559342, 36992, 'NSW', 'S', 'Combined', 500, 'PrivateHospital', 216.5, 155.9199981689453),
	(5559343, 36994, 'NSW', 'SP', 'Combined', 500, 'PrivateHospital', 371.5, 265.07000732421875),
	(5559344, 37077, 'NT', 'C', 'Combined', 500, 'PrivateHospital', 248.3000030517578, 143.5800018310547),
	(5559345, 37079, 'NT', 'F', 'Combined', 500, 'PrivateHospital', 273.1499938964844, 157.9499969482422),
	(5559346, 37076, 'NT', 'S', 'Combined', 500, 'PrivateHospital', 124.1500015258789, 71.79000091552734),
	(5559347, 37078, 'NT', 'SP', 'Combined', 500, 'PrivateHospital', 211.0500030517578, 122.04000091552734),
	(5559348, 37021, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 451.29998779296875, 347.7099914550781),
	(5559349, 37023, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 496.45001220703125, 382.5),
	(5559350, 37020, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 225.64999389648438, 173.86000061035156),
	(5559351, 37022, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 383.6000061035156, 295.54998779296875),
	(5559352, 37035, 'SA', 'C', 'Combined', 500, 'PrivateHospital', 416.1000061035156, 311.9800109863281),
	(5559353, 37037, 'SA', 'F', 'Combined', 500, 'PrivateHospital', 457.70001220703125, 343.1700134277344),
	(5559354, 37034, 'SA', 'S', 'Combined', 500, 'PrivateHospital', 208.0500030517578, 155.99000549316406),
	(5559355, 37036, 'SA', 'SP', 'Combined', 500, 'PrivateHospital', 353.70001220703125, 265.20001220703125),
	(5559356, 37063, 'TAS', 'C', 'Combined', 500, 'PrivateHospital', 435.29998779296875, 331.42999267578125),
	(5559357, 37065, 'TAS', 'F', 'Combined', 500, 'PrivateHospital', 478.8500061035156, 364.5899963378906),
	(5559358, 37062, 'TAS', 'S', 'Combined', 500, 'PrivateHospital', 217.64999389648438, 165.72000122070312),
	(5559359, 37064, 'TAS', 'SP', 'Combined', 500, 'PrivateHospital', 370, 281.7200012207031),
	(5559360, 37007, 'VIC', 'C', 'Combined', 500, 'PrivateHospital', 439.20001220703125, 335.5199890136719),
	(5559361, 37009, 'VIC', 'F', 'Combined', 500, 'PrivateHospital', 483.1000061035156, 369.04998779296875),
	(5559362, 37006, 'VIC', 'S', 'Combined', 500, 'PrivateHospital', 219.60000610351562, 167.75999450683594),
	(5559363, 37008, 'VIC', 'SP', 'Combined', 500, 'PrivateHospital', 373.29998779296875, 285.17999267578125),
	(5559364, 37049, 'WA', 'C', 'Combined', 500, 'PrivateHospital', 377.3999938964844, 272.7200012207031),
	(5559365, 37051, 'WA', 'F', 'Combined', 500, 'PrivateHospital', 415.1499938964844, 300),
	(5559366, 37048, 'WA', 'S', 'Combined', 500, 'PrivateHospital', 188.6999969482422, 136.36000061035156),
	(5559367, 37050, 'WA', 'SP', 'Combined', 500, 'PrivateHospital', 320.79998779296875, 231.82000732421875),
	(5559368, 36985, 'NSW', 'C', 'Combined', 500, 'PrivateHospital', 250.39999389648438, 165.25999450683594),
	(5559369, 36987, 'NSW', 'F', 'Combined', 500, 'PrivateHospital', 273.1499938964844, 181.7899932861328),
	(5559370, 36984, 'NSW', 'S', 'Combined', 500, 'PrivateHospital', 125.19999694824219, 82.62999725341797),
	(5559371, 36986, 'NSW', 'SP', 'Combined', 500, 'PrivateHospital', 216.3000030517578, 140.47999572753906),
	(5559372, 37069, 'NT', 'C', 'Combined', 500, 'PrivateHospital', 140.39999389648438, 66.98999786376953),
	(5559373, 37071, 'NT', 'F', 'Combined', 500, 'PrivateHospital', 154.4499969482422, 73.69000244140625),
	(5559374, 37068, 'NT', 'S', 'Combined', 500, 'PrivateHospital', 70.19999694824219, 33.4900016784668),
	(5559375, 37070, 'NT', 'SP', 'Combined', 500, 'PrivateHospital', 119.3499984741211, 56.939998626708984),
	(5559376, 37013, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 249.1999969482422, 180.77999877929688),
	(5559377, 37015, 'QLD', 'F', 'Combined', 500, 'PrivateHospital', 274.1000061035156, 198.85000610351562),
	(5559378, 37012, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 124.5999984741211, 90.38999938964844),
	(5559379, 37014, 'QLD', 'SP', 'Combined', 500, 'PrivateHospital', 211.8000030517578, 153.64999389648438),
	(5559380, 37027, 'SA', 'C', 'Combined', 500, 'PrivateHospital', 238.6999969482422, 169.9199981689453),
	(5559381, 37029, 'SA', 'F', 'Combined', 500, 'PrivateHospital', 262.54998779296875, 186.89999389648438),
	(5559382, 37026, 'SA', 'S', 'Combined', 500, 'PrivateHospital', 119.3499984741211, 84.95999908447266),
	(5559383, 37028, 'SA', 'SP', 'Combined', 500, 'PrivateHospital', 202.89999389648438, 144.42999267578125),
	(5559384, 37055, 'TAS', 'C', 'Combined', 500, 'PrivateHospital', 262.20001220703125, 194.05999755859375),
	(5559385, 37057, 'TAS', 'F', 'Combined', 500, 'PrivateHospital', 288.3999938964844, 213.4499969482422),
	(5559386, 37054, 'TAS', 'S', 'Combined', 500, 'PrivateHospital', 131.10000610351562, 97.02999877929688),
	(5559387, 37056, 'TAS', 'SP', 'Combined', 500, 'PrivateHospital', 222.85000610351562, 164.92999267578125),
	(5559388, 36999, 'VIC', 'C', 'Combined', 500, 'PrivateHospital', 250, 181.5),
	(5559389, 37001, 'VIC', 'F', 'Combined', 500, 'PrivateHospital', 275, 199.64999389648438),
	(5559390, 36998, 'VIC', 'S', 'Combined', 500, 'PrivateHospital', 125, 90.75),
	(5559391, 37000, 'VIC', 'SP', 'Combined', 500, 'PrivateHospital', 212.5, 154.27999877929688),
	(5559392, 37041, 'WA', 'C', 'Combined', 500, 'PrivateHospital', 199.10000610351562, 129.3000030517578),
	(5559393, 37043, 'WA', 'F', 'Combined', 500, 'PrivateHospital', 219, 142.22000122070312),
	(5559394, 37040, 'WA', 'S', 'Combined', 500, 'PrivateHospital', 99.55000305175781, 64.6500015258789),
	(5559395, 37042, 'WA', 'SP', 'Combined', 500, 'PrivateHospital', 169.25, 109.91000366210938),
	(5559396, 36983, 'NSW', 'C', 'Combined', 500, 'PrivateHospital', 200, 150.97999572753906),
	(5559397, 36982, 'NSW', 'S', 'Combined', 500, 'PrivateHospital', 100, 75.48999786376953),
	(5559398, 37067, 'NT', 'C', 'Combined', 500, 'PrivateHospital', 90.4000015258789, 59.2599983215332),
	(5559399, 37066, 'NT', 'S', 'Combined', 500, 'PrivateHospital', 45.20000076293945, 29.6299991607666),
	(5559400, 37011, 'QLD', 'C', 'Combined', 500, 'PrivateHospital', 197.8000030517578, 168.4199981689453),
	(5559401, 37010, 'QLD', 'S', 'Combined', 500, 'PrivateHospital', 98.9000015258789, 84.20999908447266),
	(5559402, 37025, 'SA', 'C', 'Combined', 500, 'PrivateHospital', 187.8000030517578, 158.30999755859375),
	(5559403, 37024, 'SA', 'S', 'Combined', 500, 'PrivateHospital', 93.9000015258789, 79.1500015258789),
	(5559404, 37053, 'TAS', 'C', 'Combined', 500, 'PrivateHospital', 210.5, 181.11000061035156),
	(5559405, 37052, 'TAS', 'S', 'Combined', 500, 'PrivateHospital', 105.25, 90.55000305175781),
	(5559406, 36997, 'VIC', 'C', 'Combined', 500, 'PrivateHospital', 198.6999969482422, 169.27000427246094),
	(5559407, 36996, 'VIC', 'S', 'Combined', 500, 'PrivateHospital', 99.3499984741211, 84.62999725341797),
	(5559408, 37039, 'WA', 'C', 'Combined', 500, 'PrivateHospital', 149.10000610351562, 119.27999877929688),
	(5559409, 37038, 'WA', 'S', 'Combined', 500, 'PrivateHospital', 74.55000305175781, 59.63999938964844);
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
