-- Dumping structure for table aggregator.features_short_codes
DROP TABLE IF EXISTS aggregator.features_short_codes;
CREATE TABLE IF NOT EXISTS aggregator.features_short_codes (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `desc` varchar(45) NOT NULL,
  `score` decimal(2,1) DEFAULT '0.0',
  `vertical` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- Dumping data for table aggregator.features_short_codes: ~12 rows (approximately)
/*!40000 ALTER TABLE `features_short_codes` DISABLE KEYS */;
INSERT INTO aggregator.features_short_codes (`id`, `code`, `desc`, `score`, `vertical`) VALUES
	(1, 'AI', 'Additional Information', 0.0, 'CAR'),
	(2, 'Y', 'Yes', 1.0, 'CAR'),
	(3, 'N', 'No', 0.0, 'CAR'),
	(4, 'O', 'Optional', 0.0, 'CAR'),
	(5, 'R', 'Restricted / Conditional', 0.5, 'CAR'),
	(6, 'L', 'Limited', 0.5, 'CAR'),
	(7, 'SCH', 'As shown in schedule', 0.0, 'CAR'),
	(8, 'NA', 'Not Applicable', 0.0, 'CAR'),
	(9, 'E', 'Excluded', 0.0, 'CAR'),
	(10, 'NE', 'No Exclusion', 0.0, 'CAR'),
	(11, 'OTH', 'Free Text', 0.5, 'CAR'),
	(12, 'NS', 'No Sub Limit', 0.0, 'CAR');
/*!40000 ALTER TABLE `features_short_codes` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

