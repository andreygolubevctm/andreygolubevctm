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
-- Dumping data for table ctm.export_product_master: ~56 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5593158, 'HEALTH', 'H4/NALH10', 11, 'GoldSaver Hospital $200 Excess', 'GoldSaver Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593159, 'HEALTH', 'H4/DALI10', 11, 'GoldSaver Hospital $200 Excess', 'GoldSaver Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593160, 'HEALTH', 'H4/QACS10', 11, 'GoldSaver Hospital $200 Excess', 'GoldSaver Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593161, 'HEALTH', 'H4/SALJ10', 11, 'GoldSaver Hospital $200 Excess', 'GoldSaver Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593162, 'HEALTH', 'H4/TALA10', 11, 'GoldSaver Hospital $200 Excess', 'GoldSaver Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593163, 'HEALTH', 'H4/VALK10', 11, 'GoldSaver Hospital $200 Excess', 'GoldSaver Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593164, 'HEALTH', 'H4/WALL10', 11, 'GoldSaver Hospital $200 Excess', 'GoldSaver Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593165, 'HEALTH', 'H4/NALH10^I5/AAAB10', 11, 'GoldSaver Hospital $200 Excess and Saver Options', 'GoldSaver Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593166, 'HEALTH', 'H4/DALI10^I5/AAAB10', 11, 'GoldSaver Hospital $200 Excess and Saver Options', 'GoldSaver Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593167, 'HEALTH', 'H4/QACS10^I5/AAAB10', 11, 'GoldSaver Hospital $200 Excess and Saver Options', 'GoldSaver Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593168, 'HEALTH', 'H4/SALJ10^I5/AAAB10', 11, 'GoldSaver Hospital $200 Excess and Saver Options', 'GoldSaver Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593169, 'HEALTH', 'H4/TALA10^I5/AAAB10', 11, 'GoldSaver Hospital $200 Excess and Saver Options', 'GoldSaver Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593170, 'HEALTH', 'H4/VALK10^I5/AAAB10', 11, 'GoldSaver Hospital $200 Excess and Saver Options', 'GoldSaver Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593171, 'HEALTH', 'H4/WALL10^I5/AAAB10', 11, 'GoldSaver Hospital $200 Excess and Saver Options', 'GoldSaver Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593172, 'HEALTH', 'H4/NALH10^I3/A0000S', 11, 'GoldSaver Hospital $200 Excess and Special Options', 'GoldSaver Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593173, 'HEALTH', 'H4/DALI10^I3/A0000S', 11, 'GoldSaver Hospital $200 Excess and Special Options', 'GoldSaver Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593174, 'HEALTH', 'H4/QACS10^I3/A0000S', 11, 'GoldSaver Hospital $200 Excess and Special Options', 'GoldSaver Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593175, 'HEALTH', 'H4/SALJ10^I3/A0000S', 11, 'GoldSaver Hospital $200 Excess and Special Options', 'GoldSaver Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593176, 'HEALTH', 'H4/TALA10^I3/A0000S', 11, 'GoldSaver Hospital $200 Excess and Special Options', 'GoldSaver Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593177, 'HEALTH', 'H4/VALK10^I3/A0000S', 11, 'GoldSaver Hospital $200 Excess and Special Options', 'GoldSaver Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593178, 'HEALTH', 'H4/WALL10^I3/A0000S', 11, 'GoldSaver Hospital $200 Excess and Special Options', 'GoldSaver Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593179, 'HEALTH', 'H4/NALH10^I2/A0000S', 11, 'GoldSaver Hospital $200 Excess and Super Options', 'GoldSaver Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593180, 'HEALTH', 'H4/DALI10^I2/A0000S', 11, 'GoldSaver Hospital $200 Excess and Super Options', 'GoldSaver Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593181, 'HEALTH', 'H4/QACS10^I2/A0000S', 11, 'GoldSaver Hospital $200 Excess and Super Options', 'GoldSaver Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593182, 'HEALTH', 'H4/SALJ10^I2/A0000S', 11, 'GoldSaver Hospital $200 Excess and Super Options', 'GoldSaver Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593183, 'HEALTH', 'H4/TALA10^I2/A0000S', 11, 'GoldSaver Hospital $200 Excess and Super Options', 'GoldSaver Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593184, 'HEALTH', 'H4/VALK10^I2/A0000S', 11, 'GoldSaver Hospital $200 Excess and Super Options', 'GoldSaver Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593185, 'HEALTH', 'H4/WALL10^I2/A0000S', 11, 'GoldSaver Hospital $200 Excess and Super Options', 'GoldSaver Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593186, 'HEALTH', 'H6/NAKG10', 11, 'GoldStarter Hospital $200 Excess', 'GoldStarter Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593187, 'HEALTH', 'H6/DAKH10', 11, 'GoldStarter Hospital $200 Excess', 'GoldStarter Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593188, 'HEALTH', 'H6/QACT10', 11, 'GoldStarter Hospital $200 Excess', 'GoldStarter Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593189, 'HEALTH', 'H6/SAKI10', 11, 'GoldStarter Hospital $200 Excess', 'GoldStarter Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593190, 'HEALTH', 'H6/TAJY10', 11, 'GoldStarter Hospital $200 Excess', 'GoldStarter Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593191, 'HEALTH', 'H6/VAKJ10', 11, 'GoldStarter Hospital $200 Excess', 'GoldStarter Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593192, 'HEALTH', 'H6/WAKK10', 11, 'GoldStarter Hospital $200 Excess', 'GoldStarter Hospital $200 Excess', '2015-04-01', '2016-03-31', ''),
	(5593193, 'HEALTH', 'H6/NAKG10^I5/AAAB10', 11, 'GoldStarter Hospital $200 Excess and Saver Options', 'GoldStarter Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593194, 'HEALTH', 'H6/DAKH10^I5/AAAB10', 11, 'GoldStarter Hospital $200 Excess and Saver Options', 'GoldStarter Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593195, 'HEALTH', 'H6/QACT10^I5/AAAB10', 11, 'GoldStarter Hospital $200 Excess and Saver Options', 'GoldStarter Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593196, 'HEALTH', 'H6/SAKI10^I5/AAAB10', 11, 'GoldStarter Hospital $200 Excess and Saver Options', 'GoldStarter Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593197, 'HEALTH', 'H6/TAJY10^I5/AAAB10', 11, 'GoldStarter Hospital $200 Excess and Saver Options', 'GoldStarter Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593198, 'HEALTH', 'H6/VAKJ10^I5/AAAB10', 11, 'GoldStarter Hospital $200 Excess and Saver Options', 'GoldStarter Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593199, 'HEALTH', 'H6/WAKK10^I5/AAAB10', 11, 'GoldStarter Hospital $200 Excess and Saver Options', 'GoldStarter Hospital $200 Excess and Saver Options', '2015-04-01', '2016-03-31', ''),
	(5593200, 'HEALTH', 'H6/NAKG10^I3/A0000S', 11, 'GoldStarter Hospital $200 Excess and Special Optio', 'GoldStarter Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593201, 'HEALTH', 'H6/DAKH10^I3/A0000S', 11, 'GoldStarter Hospital $200 Excess and Special Optio', 'GoldStarter Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593202, 'HEALTH', 'H6/QACT10^I3/A0000S', 11, 'GoldStarter Hospital $200 Excess and Special Optio', 'GoldStarter Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593203, 'HEALTH', 'H6/SAKI10^I3/A0000S', 11, 'GoldStarter Hospital $200 Excess and Special Optio', 'GoldStarter Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593204, 'HEALTH', 'H6/TAJY10^I3/A0000S', 11, 'GoldStarter Hospital $200 Excess and Special Optio', 'GoldStarter Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593205, 'HEALTH', 'H6/VAKJ10^I3/A0000S', 11, 'GoldStarter Hospital $200 Excess and Special Optio', 'GoldStarter Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593206, 'HEALTH', 'H6/WAKK10^I3/A0000S', 11, 'GoldStarter Hospital $200 Excess and Special Optio', 'GoldStarter Hospital $200 Excess and Special Options', '2015-04-01', '2016-03-31', ''),
	(5593207, 'HEALTH', 'H6/NAKG10^I2/A0000S', 11, 'GoldStarter Hospital $200 Excess and Super Options', 'GoldStarter Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593208, 'HEALTH', 'H6/DAKH10^I2/A0000S', 11, 'GoldStarter Hospital $200 Excess and Super Options', 'GoldStarter Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593209, 'HEALTH', 'H6/QACT10^I2/A0000S', 11, 'GoldStarter Hospital $200 Excess and Super Options', 'GoldStarter Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593210, 'HEALTH', 'H6/SAKI10^I2/A0000S', 11, 'GoldStarter Hospital $200 Excess and Super Options', 'GoldStarter Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593211, 'HEALTH', 'H6/TAJY10^I2/A0000S', 11, 'GoldStarter Hospital $200 Excess and Super Options', 'GoldStarter Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593212, 'HEALTH', 'H6/VAKJ10^I2/A0000S', 11, 'GoldStarter Hospital $200 Excess and Super Options', 'GoldStarter Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', ''),
	(5593213, 'HEALTH', 'H6/WAKK10^I2/A0000S', 11, 'GoldStarter Hospital $200 Excess and Super Options', 'GoldStarter Hospital $200 Excess and Super Options', '2015-04-01', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
