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
) ENGINE=InnoDB AUTO_INCREMENT=5650414 DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_master: ~84 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5650330, 'HEALTH', 'H7/NAIX20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650331, 'HEALTH', 'H7/NAJJ2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650332, 'HEALTH', 'H7/NAGN10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650333, 'HEALTH', 'H7/NAJL1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650334, 'HEALTH', 'H7/DAJB20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650335, 'HEALTH', 'H7/DAJH2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650336, 'HEALTH', 'H7/DAGM10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650337, 'HEALTH', 'H7/DAJP1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650338, 'HEALTH', 'H7/QAIZ20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650339, 'HEALTH', 'H7/QAJF2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650340, 'HEALTH', 'H7/QAGO10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650341, 'HEALTH', 'H7/QAJN1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650342, 'HEALTH', 'H7/SAJA20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650343, 'HEALTH', 'H7/SAJG2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650344, 'HEALTH', 'H7/SAGP10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650345, 'HEALTH', 'H7/SAJO1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650346, 'HEALTH', 'H7/TAJC20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650347, 'HEALTH', 'H7/TAJI2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650348, 'HEALTH', 'H7/TAGQ10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650349, 'HEALTH', 'H7/TAJQ1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650350, 'HEALTH', 'H7/VAJD20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650351, 'HEALTH', 'H7/VAJE2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650352, 'HEALTH', 'H7/VAGR10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650353, 'HEALTH', 'H7/VAJR1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650354, 'HEALTH', 'H7/WAIY20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650355, 'HEALTH', 'H7/WAJK2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650356, 'HEALTH', 'H7/WAGS10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650357, 'HEALTH', 'H7/WAJM1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650358, 'HEALTH', 'J2/NALE20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650359, 'HEALTH', 'J2/NALH2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650360, 'HEALTH', 'J2/NAKZ10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650361, 'HEALTH', 'J2/NALG1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650362, 'HEALTH', 'J2/DALW20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650363, 'HEALTH', 'J2/DALX2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650364, 'HEALTH', 'J2/DALV10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650365, 'HEALTH', 'J2/DALU1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650366, 'HEALTH', 'J2/QAJX20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650367, 'HEALTH', 'J2/QAKA2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650368, 'HEALTH', 'J2/QAJW10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650369, 'HEALTH', 'J2/QAKB1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650370, 'HEALTH', 'J2/SALS20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650371, 'HEALTH', 'J2/SALT2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650372, 'HEALTH', 'J2/SALR10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650373, 'HEALTH', 'J2/SALQ1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650374, 'HEALTH', 'J2/TAKC20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650375, 'HEALTH', 'J2/TAKE2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650376, 'HEALTH', 'J2/TAKD10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650377, 'HEALTH', 'J2/TAKF1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650378, 'HEALTH', 'J2/VALO20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650379, 'HEALTH', 'J2/VALP2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650380, 'HEALTH', 'J2/VALN10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650381, 'HEALTH', 'J2/VALM1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650382, 'HEALTH', 'J2/WALK20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650383, 'HEALTH', 'J2/WALL2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650384, 'HEALTH', 'J2/WALJ10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650385, 'HEALTH', 'J2/WALI1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650386, 'HEALTH', 'J1/NALF20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650387, 'HEALTH', 'J1/NALY2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650388, 'HEALTH', 'J1/NAKY10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650389, 'HEALTH', 'J1/NALZ1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650390, 'HEALTH', 'J1/DAMI20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650391, 'HEALTH', 'J1/DAMJ2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650392, 'HEALTH', 'J1/DAMK10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650393, 'HEALTH', 'J1/DAML1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650394, 'HEALTH', 'J1/QAJZ20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650395, 'HEALTH', 'J1/QAKG2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650396, 'HEALTH', 'J1/QAJY10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650397, 'HEALTH', 'J1/QAKH1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650398, 'HEALTH', 'J1/SAME20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650399, 'HEALTH', 'J1/SAMG2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650400, 'HEALTH', 'J1/SAMF10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650401, 'HEALTH', 'J1/SAMH1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650402, 'HEALTH', 'J1/TAKK20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650403, 'HEALTH', 'J1/TAKI2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650404, 'HEALTH', 'J1/TAKL10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650405, 'HEALTH', 'J1/TAKJ1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650406, 'HEALTH', 'J1/VAMN20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650407, 'HEALTH', 'J1/VAMM2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650408, 'HEALTH', 'J1/VAMO10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650409, 'HEALTH', 'J1/VAMP1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650410, 'HEALTH', 'J1/WAMA20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650411, 'HEALTH', 'J1/WAMC2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650412, 'HEALTH', 'J1/WAMB10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650413, 'HEALTH', 'J1/WAMD1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
