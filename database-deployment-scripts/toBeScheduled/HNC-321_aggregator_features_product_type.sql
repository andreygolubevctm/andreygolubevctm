-- Dumping structure for table aggregator.features_product_type
DROP TABLE IF EXISTS `features_product_type`;
CREATE TABLE IF NOT EXISTS `features_product_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `code` varchar(45) NOT NULL,
  `Vertical` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`,`Vertical`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

-- Dumping data for table aggregator.features_product_type: ~9 rows (approximately)
/*!40000 ALTER TABLE `features_product_type` DISABLE KEYS */;
INSERT INTO `features_product_type` (`id`, `name`, `code`, `Vertical`) VALUES
	(1, 'Comprehensive', 'COMP', 'CAR'),
	(2, 'Third Party Fire & Theft', 'TPFT', 'CAR'),
	(3, 'Third Party Property', 'TPP', 'CAR'),
	(4, 'Home', 'HOME', 'HOME'),
	(5, 'Contents', 'CONT', 'HOME'),
	(6, 'Home & Contents', 'H&C', 'HOME'),
	(13, 'Comprehensive', 'COMP', 'CARLMI'),
	(14, 'Home', 'HOME', 'HOMELMI'),
	(15, 'Home & Contents', 'H&C', 'HOMELMI');
/*!40000 ALTER TABLE `features_product_type` ENABLE KEYS */;
