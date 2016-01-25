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
  `situationFilter` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`productId`,`state`,`membership`,`productType`,`excessAmount`,`HospitalType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_properties_search: ~84 rows (approximately)
DELETE FROM `export_product_properties_search`;
/*!40000 ALTER TABLE `export_product_properties_search` DISABLE KEYS */;
INSERT INTO `export_product_properties_search` (`productId`, `ProductIdentifier`, `state`, `membership`, `productType`, `excessAmount`, `HospitalType`, `monthlyPremium`, `monthlyLHC`, `situationFilter`) VALUES
	(5650890, 3908, 'NSW', 'C', 'Hospital', 0, 'PrivateHospital', 213.22000122070312, 213.22000122070312, NULL),
	(5650891, 3909, 'NSW', 'F', 'Hospital', 0, 'PrivateHospital', 213.22000122070312, 213.22000122070312, NULL),
	(5650892, 3861, 'NSW', 'S', 'Hospital', 0, 'PrivateHospital', 106.5999984741211, 106.5999984741211, NULL),
	(5650893, 3924, 'NSW', 'SP', 'Hospital', 0, 'PrivateHospital', 170.57000732421875, 170.57000732421875, NULL),
	(5650894, 3722, 'NT', 'C', 'Hospital', 0, 'PrivateHospital', 230.50999450683594, 230.50999450683594, NULL),
	(5650895, 3723, 'NT', 'F', 'Hospital', 0, 'PrivateHospital', 230.50999450683594, 230.50999450683594, NULL),
	(5650896, 3689, 'NT', 'S', 'Hospital', 0, 'PrivateHospital', 115.25, 115.25, NULL),
	(5650897, 3752, 'NT', 'SP', 'Hospital', 0, 'PrivateHospital', 184.41000366210938, 184.41000366210938, NULL),
	(5650898, 4073, 'QLD', 'C', 'Hospital', 0, 'PrivateHospital', 230.50999450683594, 230.50999450683594, NULL),
	(5650899, 4074, 'QLD', 'F', 'Hospital', 0, 'PrivateHospital', 230.50999450683594, 230.50999450683594, NULL),
	(5650900, 4033, 'QLD', 'S', 'Hospital', 0, 'PrivateHospital', 115.25, 115.25, NULL),
	(5650901, 4075, 'QLD', 'SP', 'Hospital', 0, 'PrivateHospital', 184.41000366210938, 184.41000366210938, NULL),
	(5650902, 4238, 'SA', 'C', 'Hospital', 0, 'PrivateHospital', 224.74000549316406, 224.74000549316406, NULL),
	(5650903, 4239, 'SA', 'F', 'Hospital', 0, 'PrivateHospital', 224.74000549316406, 224.74000549316406, NULL),
	(5650904, 4205, 'SA', 'S', 'Hospital', 0, 'PrivateHospital', 112.37000274658203, 112.37000274658203, NULL),
	(5650905, 4240, 'SA', 'SP', 'Hospital', 0, 'PrivateHospital', 179.8000030517578, 179.8000030517578, NULL),
	(5650906, 4410, 'TAS', 'C', 'Hospital', 0, 'PrivateHospital', 230.50999450683594, 230.50999450683594, NULL),
	(5650907, 4411, 'TAS', 'F', 'Hospital', 0, 'PrivateHospital', 230.50999450683594, 230.50999450683594, NULL),
	(5650908, 4377, 'TAS', 'S', 'Hospital', 0, 'PrivateHospital', 115.25, 115.25, NULL),
	(5650909, 4412, 'TAS', 'SP', 'Hospital', 0, 'PrivateHospital', 184.41000366210938, 184.41000366210938, NULL),
	(5650910, 4582, 'VIC', 'C', 'Hospital', 0, 'PrivateHospital', 230.50999450683594, 230.50999450683594, NULL),
	(5650911, 4583, 'VIC', 'F', 'Hospital', 0, 'PrivateHospital', 230.50999450683594, 230.50999450683594, NULL),
	(5650912, 4549, 'VIC', 'S', 'Hospital', 0, 'PrivateHospital', 115.25, 115.25, NULL),
	(5650913, 4584, 'VIC', 'SP', 'Hospital', 0, 'PrivateHospital', 184.41000366210938, 184.41000366210938, NULL),
	(5650914, 4782, 'WA', 'C', 'Hospital', 0, 'PrivateHospital', 190.14999389648438, 190.14999389648438, NULL),
	(5650915, 4783, 'WA', 'F', 'Hospital', 0, 'PrivateHospital', 190.14999389648438, 190.14999389648438, NULL),
	(5650916, 4721, 'WA', 'S', 'Hospital', 0, 'PrivateHospital', 95.08000183105469, 95.08000183105469, NULL),
	(5650917, 4784, 'WA', 'SP', 'Hospital', 0, 'PrivateHospital', 152.10000610351562, 152.10000610351562, NULL),
	(5650918, 9026, 'NSW', 'C', 'Combined', 0, 'PrivateHospital', 299.4599914550781, 213.22000122070312, NULL),
	(5650919, 9027, 'NSW', 'F', 'Combined', 0, 'PrivateHospital', 299.4599914550781, 213.22000122070312, NULL),
	(5650920, 9024, 'NSW', 'S', 'Combined', 0, 'PrivateHospital', 149.72000122070312, 106.5999984741211, NULL),
	(5650921, 9025, 'NSW', 'SP', 'Combined', 0, 'PrivateHospital', 256.80999755859375, 170.57000732421875, NULL),
	(5650922, 9010, 'NT', 'C', 'Combined', 0, 'PrivateHospital', 316.7699890136719, 230.50999450683594, NULL),
	(5650923, 9011, 'NT', 'F', 'Combined', 0, 'PrivateHospital', 316.7699890136719, 230.50999450683594, NULL),
	(5650924, 9009, 'NT', 'S', 'Combined', 0, 'PrivateHospital', 158.3800048828125, 115.25, NULL),
	(5650925, 9008, 'NT', 'SP', 'Combined', 0, 'PrivateHospital', 270.6700134277344, 184.41000366210938, NULL),
	(5650926, 9041, 'QLD', 'C', 'Combined', 0, 'PrivateHospital', 316.7699890136719, 230.50999450683594, NULL),
	(5650927, 9042, 'QLD', 'F', 'Combined', 0, 'PrivateHospital', 316.7699890136719, 230.50999450683594, NULL),
	(5650928, 9040, 'QLD', 'S', 'Combined', 0, 'PrivateHospital', 158.3800048828125, 115.25, NULL),
	(5650929, 9043, 'QLD', 'SP', 'Combined', 0, 'PrivateHospital', 270.6700134277344, 184.41000366210938, NULL),
	(5650930, 9058, 'SA', 'C', 'Combined', 0, 'PrivateHospital', 313.1600036621094, 224.74000549316406, NULL),
	(5650931, 9059, 'SA', 'F', 'Combined', 0, 'PrivateHospital', 313.1600036621094, 224.74000549316406, NULL),
	(5650932, 9057, 'SA', 'S', 'Combined', 0, 'PrivateHospital', 156.5800018310547, 112.37000274658203, NULL),
	(5650933, 9056, 'SA', 'SP', 'Combined', 0, 'PrivateHospital', 268.2200012207031, 179.8000030517578, NULL),
	(5650934, 9073, 'TAS', 'C', 'Combined', 0, 'PrivateHospital', 312.45001220703125, 230.50999450683594, NULL),
	(5650935, 9074, 'TAS', 'F', 'Combined', 0, 'PrivateHospital', 312.45001220703125, 230.50999450683594, NULL),
	(5650936, 9072, 'TAS', 'S', 'Combined', 0, 'PrivateHospital', 156.22000122070312, 115.25, NULL),
	(5650937, 9075, 'TAS', 'SP', 'Combined', 0, 'PrivateHospital', 266.3500061035156, 184.41000366210938, NULL),
	(5650938, 9090, 'VIC', 'C', 'Combined', 0, 'PrivateHospital', 308.1300048828125, 230.50999450683594, NULL),
	(5650939, 9091, 'VIC', 'F', 'Combined', 0, 'PrivateHospital', 308.1300048828125, 230.50999450683594, NULL),
	(5650940, 9089, 'VIC', 'S', 'Combined', 0, 'PrivateHospital', 154.05999755859375, 115.25, NULL),
	(5650941, 9088, 'VIC', 'SP', 'Combined', 0, 'PrivateHospital', 262.0299987792969, 184.41000366210938, NULL),
	(5650942, 9106, 'WA', 'C', 'Combined', 0, 'PrivateHospital', 269.92999267578125, 190.14999389648438, NULL),
	(5650943, 9107, 'WA', 'F', 'Combined', 0, 'PrivateHospital', 269.92999267578125, 190.14999389648438, NULL),
	(5650944, 9105, 'WA', 'S', 'Combined', 0, 'PrivateHospital', 134.97000122070312, 95.08000183105469, NULL),
	(5650945, 9104, 'WA', 'SP', 'Combined', 0, 'PrivateHospital', 231.8800048828125, 152.10000610351562, NULL),
	(5650946, 6828, 'NSW', 'C', 'Combined', 0, 'PrivateHospital', 377.0199890136719, 213.22000122070312, NULL),
	(5650947, 6829, 'NSW', 'F', 'Combined', 0, 'PrivateHospital', 377.0199890136719, 213.22000122070312, NULL),
	(5650948, 6826, 'NSW', 'S', 'Combined', 0, 'PrivateHospital', 188.5, 106.5999984741211, NULL),
	(5650949, 6832, 'NSW', 'SP', 'Combined', 0, 'PrivateHospital', 334.3699951171875, 170.57000732421875, NULL),
	(5650950, 6809, 'NT', 'C', 'Combined', 0, 'PrivateHospital', 394.30999755859375, 230.50999450683594, NULL),
	(5650951, 6810, 'NT', 'F', 'Combined', 0, 'PrivateHospital', 394.30999755859375, 230.50999450683594, NULL),
	(5650952, 6813, 'NT', 'S', 'Combined', 0, 'PrivateHospital', 197.14999389648438, 115.25, NULL),
	(5650953, 6815, 'NT', 'SP', 'Combined', 0, 'PrivateHospital', 348.2099914550781, 184.41000366210938, NULL),
	(5650954, 6845, 'QLD', 'C', 'Combined', 0, 'PrivateHospital', 394.30999755859375, 230.50999450683594, NULL),
	(5650955, 6846, 'QLD', 'F', 'Combined', 0, 'PrivateHospital', 394.30999755859375, 230.50999450683594, NULL),
	(5650956, 6843, 'QLD', 'S', 'Combined', 0, 'PrivateHospital', 197.14999389648438, 115.25, NULL),
	(5650957, 6849, 'QLD', 'SP', 'Combined', 0, 'PrivateHospital', 348.2099914550781, 184.41000366210938, NULL),
	(5650958, 6862, 'SA', 'C', 'Combined', 0, 'PrivateHospital', 392.6199951171875, 224.74000549316406, NULL),
	(5650959, 6863, 'SA', 'F', 'Combined', 0, 'PrivateHospital', 392.6199951171875, 224.74000549316406, NULL),
	(5650960, 6860, 'SA', 'S', 'Combined', 0, 'PrivateHospital', 196.30999755859375, 112.37000274658203, NULL),
	(5650961, 6866, 'SA', 'SP', 'Combined', 0, 'PrivateHospital', 347.67999267578125, 179.8000030517578, NULL),
	(5650962, 6877, 'TAS', 'C', 'Combined', 0, 'PrivateHospital', 386.1099853515625, 230.50999450683594, NULL),
	(5650963, 6878, 'TAS', 'F', 'Combined', 0, 'PrivateHospital', 386.1099853515625, 230.50999450683594, NULL),
	(5650964, 6883, 'TAS', 'S', 'Combined', 0, 'PrivateHospital', 193.0500030517578, 115.25, NULL),
	(5650965, 6881, 'TAS', 'SP', 'Combined', 0, 'PrivateHospital', 340.010009765625, 184.41000366210938, NULL),
	(5650966, 6894, 'VIC', 'C', 'Combined', 0, 'PrivateHospital', 377.9100036621094, 230.50999450683594, NULL),
	(5650967, 6895, 'VIC', 'F', 'Combined', 0, 'PrivateHospital', 377.9100036621094, 230.50999450683594, NULL),
	(5650968, 6898, 'VIC', 'S', 'Combined', 0, 'PrivateHospital', 188.9499969482422, 115.25, NULL),
	(5650969, 6900, 'VIC', 'SP', 'Combined', 0, 'PrivateHospital', 331.80999755859375, 184.41000366210938, NULL),
	(5650970, 6913, 'WA', 'C', 'Combined', 0, 'PrivateHospital', 341.6499938964844, 190.14999389648438, NULL),
	(5650971, 6914, 'WA', 'F', 'Combined', 0, 'PrivateHospital', 341.6499938964844, 190.14999389648438, NULL),
	(5650972, 6911, 'WA', 'S', 'Combined', 0, 'PrivateHospital', 170.8300018310547, 95.08000183105469, NULL),
	(5650973, 6917, 'WA', 'SP', 'Combined', 0, 'PrivateHospital', 303.6000061035156, 152.10000610351562, NULL);
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
