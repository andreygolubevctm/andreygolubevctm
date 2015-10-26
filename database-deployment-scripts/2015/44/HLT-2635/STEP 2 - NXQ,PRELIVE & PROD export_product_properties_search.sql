-- --------------------------------------------------------
-- Host:                         taws02_dbi
-- Server version:               10.0.16-MariaDB-log - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             9.1.0.4867
-- --------------------------------------------------------

USE ctm;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- Dumping data for table ctm.export_product_properties_search: ~56 rows (approximately)
DELETE FROM `export_product_properties_search`;
/*!40000 ALTER TABLE `export_product_properties_search` DISABLE KEYS */;
INSERT INTO `export_product_properties_search` (`productId`, `ProductIdentifier`, `state`, `membership`, `productType`, `excessAmount`, `HospitalType`, `monthlyPremium`, `monthlyLHC`) VALUES
	(5593158, 2995, 'NSW', 'S', 'Hospital', 200, 'PrivateHospital', 123.44999694824219, 123.44999694824219),
	(5593159, 2961, 'NT', 'S', 'Hospital', 200, 'PrivateHospital', 107.94999694824219, 107.94999694824219),
	(5593160, 3017, 'QLD', 'S', 'Hospital', 200, 'PrivateHospital', 127.19999694824219, 127.19999694824219),
	(5593161, 3063, 'SA', 'S', 'Hospital', 200, 'PrivateHospital', 123.44999694824219, 123.44999694824219),
	(5593162, 3097, 'TAS', 'S', 'Hospital', 200, 'PrivateHospital', 127.19999694824219, 127.19999694824219),
	(5593163, 3131, 'VIC', 'S', 'Hospital', 200, 'PrivateHospital', 127.19999694824219, 127.19999694824219),
	(5593164, 3165, 'WA', 'S', 'Hospital', 200, 'PrivateHospital', 110.9000015258789, 110.9000015258789),
	(5593165, 2999, 'NSW', 'S', 'Combined', 200, 'PrivateHospital', 150, 123.44999694824219),
	(5593166, 2965, 'NT', 'S', 'Combined', 200, 'PrivateHospital', 134.5, 107.94999694824219),
	(5593167, 3021, 'QLD', 'S', 'Combined', 200, 'PrivateHospital', 153.75, 127.19999694824219),
	(5593168, 3067, 'SA', 'S', 'Combined', 200, 'PrivateHospital', 150, 123.44999694824219),
	(5593169, 3101, 'TAS', 'S', 'Combined', 200, 'PrivateHospital', 153.75, 127.19999694824219),
	(5593170, 3135, 'VIC', 'S', 'Combined', 200, 'PrivateHospital', 153.75, 127.19999694824219),
	(5593171, 3169, 'WA', 'S', 'Combined', 200, 'PrivateHospital', 137.4499969482422, 110.9000015258789),
	(5593172, 2998, 'NSW', 'S', 'Combined', 200, 'PrivateHospital', 167.1999969482422, 123.44999694824219),
	(5593173, 2964, 'NT', 'S', 'Combined', 200, 'PrivateHospital', 151.6999969482422, 107.94999694824219),
	(5593174, 3020, 'QLD', 'S', 'Combined', 200, 'PrivateHospital', 170.9499969482422, 127.19999694824219),
	(5593175, 3066, 'SA', 'S', 'Combined', 200, 'PrivateHospital', 167.1999969482422, 123.44999694824219),
	(5593176, 3100, 'TAS', 'S', 'Combined', 200, 'PrivateHospital', 170.9499969482422, 127.19999694824219),
	(5593177, 3134, 'VIC', 'S', 'Combined', 200, 'PrivateHospital', 170.9499969482422, 127.19999694824219),
	(5593178, 3168, 'WA', 'S', 'Combined', 200, 'PrivateHospital', 154.64999389648438, 110.9000015258789),
	(5593179, 2997, 'NSW', 'S', 'Combined', 200, 'PrivateHospital', 193.1999969482422, 123.44999694824219),
	(5593180, 2963, 'NT', 'S', 'Combined', 200, 'PrivateHospital', 177.6999969482422, 107.94999694824219),
	(5593181, 3019, 'QLD', 'S', 'Combined', 200, 'PrivateHospital', 196.9499969482422, 127.19999694824219),
	(5593182, 3065, 'SA', 'S', 'Combined', 200, 'PrivateHospital', 193.1999969482422, 123.44999694824219),
	(5593183, 3099, 'TAS', 'S', 'Combined', 200, 'PrivateHospital', 196.9499969482422, 127.19999694824219),
	(5593184, 3133, 'VIC', 'S', 'Combined', 200, 'PrivateHospital', 196.9499969482422, 127.19999694824219),
	(5593185, 3167, 'WA', 'S', 'Combined', 200, 'PrivateHospital', 180.64999389648438, 110.9000015258789),
	(5593186, 3357, 'NSW', 'S', 'Hospital', 200, 'PrivateHospital', 80.05000305175781, 80.05000305175781),
	(5593187, 3315, 'NT', 'S', 'Hospital', 200, 'PrivateHospital', 70.05000305175781, 70.05000305175781),
	(5593188, 3383, 'QLD', 'S', 'Hospital', 200, 'PrivateHospital', 82.8499984741211, 82.8499984741211),
	(5593189, 3441, 'SA', 'S', 'Hospital', 200, 'PrivateHospital', 80.05000305175781, 80.05000305175781),
	(5593190, 3483, 'TAS', 'S', 'Hospital', 200, 'PrivateHospital', 82.8499984741211, 82.8499984741211),
	(5593191, 3525, 'VIC', 'S', 'Hospital', 200, 'PrivateHospital', 82.8499984741211, 82.8499984741211),
	(5593192, 3567, 'WA', 'S', 'Hospital', 200, 'PrivateHospital', 72, 72),
	(5593193, 3361, 'NSW', 'S', 'Combined', 200, 'PrivateHospital', 106.5999984741211, 80.05000305175781),
	(5593194, 3319, 'NT', 'S', 'Combined', 200, 'PrivateHospital', 96.5999984741211, 70.05000305175781),
	(5593195, 3387, 'QLD', 'S', 'Combined', 200, 'PrivateHospital', 109.4000015258789, 82.8499984741211),
	(5593196, 3445, 'SA', 'S', 'Combined', 200, 'PrivateHospital', 106.5999984741211, 80.05000305175781),
	(5593197, 3487, 'TAS', 'S', 'Combined', 200, 'PrivateHospital', 109.4000015258789, 82.8499984741211),
	(5593198, 3529, 'VIC', 'S', 'Combined', 200, 'PrivateHospital', 109.4000015258789, 82.8499984741211),
	(5593199, 3571, 'WA', 'S', 'Combined', 200, 'PrivateHospital', 98.55000305175781, 72),
	(5593200, 3360, 'NSW', 'S', 'Combined', 200, 'PrivateHospital', 123.80000305175781, 80.05000305175781),
	(5593201, 3318, 'NT', 'S', 'Combined', 200, 'PrivateHospital', 113.80000305175781, 70.05000305175781),
	(5593202, 3386, 'QLD', 'S', 'Combined', 200, 'PrivateHospital', 126.5999984741211, 82.8499984741211),
	(5593203, 3444, 'SA', 'S', 'Combined', 200, 'PrivateHospital', 123.80000305175781, 80.05000305175781),
	(5593204, 3486, 'TAS', 'S', 'Combined', 200, 'PrivateHospital', 126.5999984741211, 82.8499984741211),
	(5593205, 3528, 'VIC', 'S', 'Combined', 200, 'PrivateHospital', 126.5999984741211, 82.8499984741211),
	(5593206, 3570, 'WA', 'S', 'Combined', 200, 'PrivateHospital', 115.75, 72),
	(5593207, 3359, 'NSW', 'S', 'Combined', 200, 'PrivateHospital', 149.8000030517578, 80.05000305175781),
	(5593208, 3317, 'NT', 'S', 'Combined', 200, 'PrivateHospital', 139.8000030517578, 70.05000305175781),
	(5593209, 3385, 'QLD', 'S', 'Combined', 200, 'PrivateHospital', 152.60000610351562, 82.8499984741211),
	(5593210, 3443, 'SA', 'S', 'Combined', 200, 'PrivateHospital', 149.8000030517578, 80.05000305175781),
	(5593211, 3485, 'TAS', 'S', 'Combined', 200, 'PrivateHospital', 152.60000610351562, 82.8499984741211),
	(5593212, 3527, 'VIC', 'S', 'Combined', 200, 'PrivateHospital', 152.60000610351562, 82.8499984741211),
	(5593213, 3569, 'WA', 'S', 'Combined', 200, 'PrivateHospital', 141.75, 72);
/*!40000 ALTER TABLE `export_product_properties_search` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
