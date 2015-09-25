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

-- Dumping structure for table ctm.export_product_master
DROP TABLE IF EXISTS `export_product_master`;
CREATE TABLE IF NOT EXISTS `export_product_master` (
  `ProductId` int(11) NOT NULL AUTO_INCREMENT,
  `ProductCat` char(10) NOT NULL,
  `ProductCode` varchar(45) DEFAULT NULL,
  `ProviderId` int(11) NOT NULL,
  `ShortTitle` varchar(50) NOT NULL,
  `LongTitle` varchar(128) NOT NULL,
  `EffectiveStart` date NOT NULL DEFAULT '2011-03-01',
  `EffectiveEnd` date NOT NULL DEFAULT '2040-12-31',
  `Status` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`ProductId`,`EffectiveEnd`),
  KEY `PROVIDER_CAT` (`ProviderId`,`ProductCat`,`ProductId`)
) ENGINE=InnoDB AUTO_INCREMENT=5560373 DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_master: ~92 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5560281, 'HEALTH', 'H2/A0000C', 16, 'Top Hospital', 'Top Hospital', '2015-04-01', '2016-03-31', ''),
	(5560282, 'HEALTH', 'H2/A0000F', 16, 'Top Hospital', 'Top Hospital', '2015-04-01', '2016-03-31', ''),
	(5560283, 'HEALTH', 'H2/A0000P', 16, 'Top Hospital', 'Top Hospital', '2015-04-01', '2016-03-31', ''),
	(5560284, 'HEALTH', 'H2/A0000S', 16, 'Top Hospital', 'Top Hospital', '2015-04-01', '2016-03-31', ''),
	(5560285, 'HEALTH', 'H2A/A0250S', 16, 'Top Hospital 250', 'Top Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5560286, 'HEALTH', 'H2A/A0500C', 16, 'Top Hospital 250', 'Top Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5560287, 'HEALTH', 'H2A/A0500F', 16, 'Top Hospital 250', 'Top Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5560288, 'HEALTH', 'H2A/A0500P', 16, 'Top Hospital 250', 'Top Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5560289, 'HEALTH', 'H2B/A0500S', 16, 'Top Hospital 500', 'Top Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5560290, 'HEALTH', 'H2B/A1000C', 16, 'Top Hospital 500', 'Top Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5560291, 'HEALTH', 'H2B/A1000F', 16, 'Top Hospital 500', 'Top Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5560292, 'HEALTH', 'H2B/A1000P', 16, 'Top Hospital 500', 'Top Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5560293, 'HEALTH', 'H2C/AABQ10', 16, 'Top Hospital with Essential Extras', 'Top Hospital with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560294, 'HEALTH', 'H2C/AACI20', 16, 'Top Hospital with Essential Extras', 'Top Hospital with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560295, 'HEALTH', 'H2C/AACJ2D', 16, 'Top Hospital with Essential Extras', 'Top Hospital with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560296, 'HEALTH', 'H2C/AACK1D', 16, 'Top Hospital with Essential Extras', 'Top Hospital with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560297, 'HEALTH', 'H3P/AAHE10', 16, 'Intermediate Hospital 250 with Premium Extras', 'Intermediate Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560298, 'HEALTH', 'H3P/AAHF20', 16, 'Intermediate Hospital 250 with Premium Extras', 'Intermediate Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560299, 'HEALTH', 'H3P/AAHG2D', 16, 'Intermediate Hospital 250 with Premium Extras', 'Intermediate Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560300, 'HEALTH', 'H3P/AAHH1D', 16, 'Intermediate Hospital 250 with Premium Extras', 'Intermediate Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560301, 'HEALTH', 'H2E/AABN10', 16, 'Top Hospital 250 with Essential Extras', 'Top Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560302, 'HEALTH', 'H2E/AACN20', 16, 'Top Hospital 250 with Essential Extras', 'Top Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560303, 'HEALTH', 'H2E/AACO2D', 16, 'Top Hospital 250 with Essential Extras', 'Top Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560304, 'HEALTH', 'H2E/AACP1D', 16, 'Top Hospital 250 with Essential Extras', 'Top Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560305, 'HEALTH', 'H3P/AAHJ10', 16, 'Intermediate Hospital 500 with Premium Extras', 'Intermediate Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560306, 'HEALTH', 'H3P/AAHK20', 16, 'Intermediate Hospital 500 with Premium Extras', 'Intermediate Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560307, 'HEALTH', 'H3P/AAHL2D', 16, 'Intermediate Hospital 500 with Premium Extras', 'Intermediate Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560308, 'HEALTH', 'H3P/AAHN1D', 16, 'Intermediate Hospital 500 with Premium Extras', 'Intermediate Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560309, 'HEALTH', 'H2G/AABO10', 16, 'Top Hospital 500 with Essential Extras', 'Top Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560310, 'HEALTH', 'H2G/AACS20', 16, 'Top Hospital 500 with Essential Extras', 'Top Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560311, 'HEALTH', 'H2G/AACT2D', 16, 'Top Hospital 500 with Essential Extras', 'Top Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560312, 'HEALTH', 'H2G/AACU1D', 16, 'Top Hospital 500 with Essential Extras', 'Top Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560313, 'HEALTH', 'H2F/AAAK20', 16, 'Top Hospital 250 with Premium Extras', 'Top Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560314, 'HEALTH', 'H2F/AAAL2D', 16, 'Top Hospital 250 with Premium Extras', 'Top Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560315, 'HEALTH', 'H2F/AAAM1D', 16, 'Top Hospital 250 with Premium Extras', 'Top Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560316, 'HEALTH', 'H2F/AAAI10', 16, 'Top Hospital 250 with Premium Extras', 'Top Hospital 250 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560317, 'HEALTH', 'H2I/AAAA10', 16, 'Singles & Couples 250 Combined', 'Singles & Couples 250 Combined', '2015-04-01', '2016-03-31', ''),
	(5560318, 'HEALTH', 'H2I/AAAC20', 16, 'Singles & Couples 250 Combined', 'Singles & Couples 250 Combined', '2015-04-01', '2016-03-31', ''),
	(5560319, 'HEALTH', 'H2I/AAAE2D', 16, 'Singles & Couples 250 Combined', 'Singles & Couples 250 Combined', '2015-04-01', '2016-03-31', ''),
	(5560320, 'HEALTH', 'H2I/AAAG1D', 16, 'Singles & Couples 250 Combined', 'Singles & Couples 250 Combined', '2015-04-01', '2016-03-31', ''),
	(5560321, 'HEALTH', 'H2J/AAAB10', 16, 'Singles & Couples 500 Combined', 'Singles & Couples 500 Combined', '2015-04-01', '2016-03-31', ''),
	(5560322, 'HEALTH', 'H2J/AAAD20', 16, 'Singles & Couples 500 Combined', 'Singles & Couples 500 Combined', '2015-04-01', '2016-03-31', ''),
	(5560323, 'HEALTH', 'H2J/AAAF2D', 16, 'Singles & Couples 500 Combined', 'Singles & Couples 500 Combined', '2015-04-01', '2016-03-31', ''),
	(5560324, 'HEALTH', 'H2J/AAAH1D', 16, 'Singles & Couples 500 Combined', 'Singles & Couples 500 Combined', '2015-04-01', '2016-03-31', ''),
	(5560325, 'HEALTH', 'H2Q/AAFM20', 16, 'Top Hospital with Young Extras', 'Top Hospital with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560326, 'HEALTH', 'H2Q/AAFQ10', 16, 'Top Hospital with Young Extras', 'Top Hospital with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560327, 'HEALTH', 'H2Q/AAFZ2D', 16, 'Top Hospital with Young Extras', 'Top Hospital with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560328, 'HEALTH', 'H2Q/AAGA1D', 16, 'Top Hospital with Young Extras', 'Top Hospital with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560329, 'HEALTH', 'H2R/AAFN20', 16, 'Top Hospital 250 with Young Extras', 'Top Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560330, 'HEALTH', 'H2R/AAFR10', 16, 'Top Hospital 250 with Young Extras', 'Top Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560331, 'HEALTH', 'H2R/AAFT2D', 16, 'Top Hospital 250 with Young Extras', 'Top Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560332, 'HEALTH', 'H2R/AAFU1D', 16, 'Top Hospital 250 with Young Extras', 'Top Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560333, 'HEALTH', 'H2S/AAFO20', 16, 'Top Hospital 500 with Young Extras', 'Top Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560334, 'HEALTH', 'H2S/AAFS10', 16, 'Top Hospital 500 with Young Extras', 'Top Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560335, 'HEALTH', 'H2S/AAFW2D', 16, 'Top Hospital 500 with Young Extras', 'Top Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560336, 'HEALTH', 'H2S/AAFX1D', 16, 'Top Hospital 500 with Young Extras', 'Top Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560337, 'HEALTH', 'H3/AAGJ10', 16, 'Intermediate Hospital 250', 'Intermediate Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5560338, 'HEALTH', 'H3/AAGK20', 16, 'Intermediate Hospital 250', 'Intermediate Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5560339, 'HEALTH', 'H3/AAGL2D', 16, 'Intermediate Hospital 250', 'Intermediate Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5560340, 'HEALTH', 'H3/AAGM1D', 16, 'Intermediate Hospital 250', 'Intermediate Hospital 250', '2015-04-01', '2016-03-31', ''),
	(5560341, 'HEALTH', 'H3/AAGO10', 16, 'Intermediate Hospital 500', 'Intermediate Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5560342, 'HEALTH', 'H3/AAGQ20', 16, 'Intermediate Hospital 500', 'Intermediate Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5560343, 'HEALTH', 'H3/AAGR2D', 16, 'Intermediate Hospital 500', 'Intermediate Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5560344, 'HEALTH', 'H3/AAGS1D', 16, 'Intermediate Hospital 500', 'Intermediate Hospital 500', '2015-04-01', '2016-03-31', ''),
	(5560345, 'HEALTH', 'H3E/AAGU10', 16, 'Intermediate Hospital 250 with Essential Extras', 'Intermediate Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560346, 'HEALTH', 'H3E/AAGV20', 16, 'Intermediate Hospital 250 with Essential Extras', 'Intermediate Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560347, 'HEALTH', 'H3E/AAGW2D', 16, 'Intermediate Hospital 250 with Essential Extras', 'Intermediate Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560348, 'HEALTH', 'H3E/AAGX1D', 16, 'Intermediate Hospital 250 with Essential Extras', 'Intermediate Hospital 250 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560349, 'HEALTH', 'H3E/AAGZ10', 16, 'Intermediate Hospital 500 with Essential Extras', 'Intermediate Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560350, 'HEALTH', 'H3E/AAHA20', 16, 'Intermediate Hospital 500 with Essential Extras', 'Intermediate Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560351, 'HEALTH', 'H3E/AAHB2D', 16, 'Intermediate Hospital 500 with Essential Extras', 'Intermediate Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560352, 'HEALTH', 'H3E/AAHC1D', 16, 'Intermediate Hospital 500 with Essential Extras', 'Intermediate Hospital 500 with Essential Extras', '2015-04-01', '2016-03-31', ''),
	(5560353, 'HEALTH', 'H2H/AAAP20', 16, 'Top Hospital 500 with Premium Extras', 'Top Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560354, 'HEALTH', 'H2H/AAAQ2D', 16, 'Top Hospital 500 with Premium Extras', 'Top Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560355, 'HEALTH', 'H2H/AAAR1D', 16, 'Top Hospital 500 with Premium Extras', 'Top Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560356, 'HEALTH', 'H2H/AAAJ10', 16, 'Top Hospital 500 with Premium Extras', 'Top Hospital 500 with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560357, 'HEALTH', 'H2D/AABP10', 16, 'Top Hospital with Premium Extras', 'Top Hospital with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560358, 'HEALTH', 'H2D/AACD20', 16, 'Top Hospital with Premium Extras', 'Top Hospital with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560359, 'HEALTH', 'H2D/AACE2D', 16, 'Top Hospital with Premium Extras', 'Top Hospital with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560360, 'HEALTH', 'H2D/AACF1D', 16, 'Top Hospital with Premium Extras', 'Top Hospital with Premium Extras', '2015-04-01', '2016-03-31', ''),
	(5560361, 'HEALTH', 'H3Y/AAHP10', 16, 'Intermediate Hospital 250 with Young Extras', 'Intermediate Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560362, 'HEALTH', 'H3Y/AAHQ20', 16, 'Intermediate Hospital 250 with Young Extras', 'Intermediate Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560363, 'HEALTH', 'H3Y/AAHR2D', 16, 'Intermediate Hospital 250 with Young Extras', 'Intermediate Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560364, 'HEALTH', 'H3Y/AAHS1D', 16, 'Intermediate Hospital 250 with Young Extras', 'Intermediate Hospital 250 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560365, 'HEALTH', 'H3Y/AAHU10', 16, 'Intermediate Hospital 500 with Young Extras', 'Intermediate Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560366, 'HEALTH', 'H3Y/AAHV20', 16, 'Intermediate Hospital 500 with Young Extras', 'Intermediate Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560367, 'HEALTH', 'H3Y/AAHW2D', 16, 'Intermediate Hospital 500 with Young Extras', 'Intermediate Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560368, 'HEALTH', 'H3Y/AAHX1D', 16, 'Intermediate Hospital 500 with Young Extras', 'Intermediate Hospital 500 with Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560369, 'HEALTH', 'I3/AAET10', 16, 'Young Extras', 'Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560370, 'HEALTH', 'I3/AAFK20', 16, 'Young Extras', 'Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560371, 'HEALTH', 'I3/AAGF2D', 16, 'Young Extras', 'Young Extras', '2015-04-01', '2016-03-31', ''),
	(5560372, 'HEALTH', 'I3/AAGH1D', 16, 'Young Extras', 'Young Extras', '2015-04-01', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
