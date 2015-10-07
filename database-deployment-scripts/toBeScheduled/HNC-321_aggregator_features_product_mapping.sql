-- Dumping structure for table aggregator.features_product_mapping
DROP TABLE IF EXISTS aggregator.features_product_mapping;
CREATE TABLE IF NOT EXISTS aggregator.features_product_mapping (
  `lmi_Ref` varchar(45) NOT NULL,
  `ctm_ProductId` varchar(45) NOT NULL,
  PRIMARY KEY (`lmi_Ref`),
  KEY `ctm_productId` (`ctm_ProductId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table aggregator.features_product_mapping: ~23 rows (approximately)
/*!40000 ALTER TABLE `features_product_mapping` DISABLE KEYS */;
INSERT INTO aggregator.features_product_mapping (`lmi_Ref`, `ctm_ProductId`) VALUES
	('1st-Car_0514_18137', '1FOW-05-02'),
	('ClassicPlusCar_0914_19544', 'AI-01-01'),
	('ComprehensiveCar_0615_23185', 'AI-01-02'),
	('SmartBoxCar_0615_23186', 'AI-01-03'),
	('Budget-SD-Car_0514_18128', 'BUDD-05-01'),
	('Budget-Gold-Car_0514_18131', 'BUDD-05-04'),
	('Budget-SmartHome_1014_19970', 'BUDD-05-29'),
	('Budget-SmartHome_1014_19971', 'BUDD-05-29'),
	('Dodo-car_1014_22332', 'EXDD-05-04'),
	('AustPost-Gold-Car_0614_19467', 'EXPO-05-13'),
	('Ozicare-Gold-Car_0514_18134', 'OZIC-05-04'),
	('016_29052009_10297', 'REIN-01-01'),
	('054_0412_13251', 'REIN-01-02'),
	('056_0612_15041', 'REIN-02-01'),
	('056_0612_15155', 'REIN-02-02'),
	('Retirease-Car_0514_18140', 'RETI-05-03'),
	('Virgin-Car-PS_0714_19212', 'VIRG-05-17'),
	('Virgin-Home_0513_17152', 'VIRG-05-26'),
	('Virgin-Home_0513_17153', 'VIRG-05-26'),
	('053_0412_13486', 'WOOL-01-01'),
	('053_0412_16469', 'WOOL-01-02'),
	('056_0612_14371', 'WOOL-02-01'),
	('056_0612_14547', 'WOOL-02-02');
/*!40000 ALTER TABLE `features_product_mapping` ENABLE KEYS */;
