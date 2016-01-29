-- --------------------------------------------------------
-- Host:                         taws02_dbi
-- Server version:               10.0.16-MariaDB-log - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             9.1.0.4867
-- --------------------------------------------------------
use ctm;
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
) ENGINE=InnoDB AUTO_INCREMENT=5650974 DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_master: ~84 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5650890, 'HEALTH', 'H7/NAIX20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650891, 'HEALTH', 'H7/NAJJ2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650892, 'HEALTH', 'H7/NAGN10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650893, 'HEALTH', 'H7/NAJL1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650894, 'HEALTH', 'H7/DAJB20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650895, 'HEALTH', 'H7/DAJH2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650896, 'HEALTH', 'H7/DAGM10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650897, 'HEALTH', 'H7/DAJP1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650898, 'HEALTH', 'H7/QAIZ20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650899, 'HEALTH', 'H7/QAJF2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650900, 'HEALTH', 'H7/QAGO10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650901, 'HEALTH', 'H7/QAJN1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650902, 'HEALTH', 'H7/SAJA20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650903, 'HEALTH', 'H7/SAJG2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650904, 'HEALTH', 'H7/SAGP10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650905, 'HEALTH', 'H7/SAJO1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650906, 'HEALTH', 'H7/TAJC20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650907, 'HEALTH', 'H7/TAJI2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650908, 'HEALTH', 'H7/TAGQ10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650909, 'HEALTH', 'H7/TAJQ1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650910, 'HEALTH', 'H7/VAJD20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650911, 'HEALTH', 'H7/VAJE2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650912, 'HEALTH', 'H7/VAGR10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650913, 'HEALTH', 'H7/VAJR1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650914, 'HEALTH', 'H7/WAIY20', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650915, 'HEALTH', 'H7/WAJK2D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650916, 'HEALTH', 'H7/WAGS10', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650917, 'HEALTH', 'H7/WAJM1D', 12, 'Private Hospital 65%', 'Private Hospital 65%', '2015-04-01', '2016-03-31', ''),
	(5650918, 'HEALTH', 'J2/NALE20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650919, 'HEALTH', 'J2/NALH2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650920, 'HEALTH', 'J2/NAKZ10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650921, 'HEALTH', 'J2/NALG1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650922, 'HEALTH', 'J2/DALW20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650923, 'HEALTH', 'J2/DALX2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650924, 'HEALTH', 'J2/DALV10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650925, 'HEALTH', 'J2/DALU1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650926, 'HEALTH', 'J2/QAJX20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650927, 'HEALTH', 'J2/QAKA2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650928, 'HEALTH', 'J2/QAJW10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650929, 'HEALTH', 'J2/QAKB1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650930, 'HEALTH', 'J2/SALS20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650931, 'HEALTH', 'J2/SALT2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650932, 'HEALTH', 'J2/SALR10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650933, 'HEALTH', 'J2/SALQ1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650934, 'HEALTH', 'J2/TAKC20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650935, 'HEALTH', 'J2/TAKE2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650936, 'HEALTH', 'J2/TAKD10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650937, 'HEALTH', 'J2/TAKF1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650938, 'HEALTH', 'J2/VALO20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650939, 'HEALTH', 'J2/VALP2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650940, 'HEALTH', 'J2/VALN10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650941, 'HEALTH', 'J2/VALM1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650942, 'HEALTH', 'J2/WALK20', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650943, 'HEALTH', 'J2/WALL2D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650944, 'HEALTH', 'J2/WALJ10', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650945, 'HEALTH', 'J2/WALI1D', 12, 'Private Hospital 65% + Extras', 'Private Hospital 65% + Extras', '2015-04-01', '2016-03-31', ''),
	(5650946, 'HEALTH', 'J1/NALF20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650947, 'HEALTH', 'J1/NALY2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650948, 'HEALTH', 'J1/NAKY10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650949, 'HEALTH', 'J1/NALZ1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650950, 'HEALTH', 'J1/DAMI20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650951, 'HEALTH', 'J1/DAMJ2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650952, 'HEALTH', 'J1/DAMK10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650953, 'HEALTH', 'J1/DAML1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650954, 'HEALTH', 'J1/QAJZ20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650955, 'HEALTH', 'J1/QAKG2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650956, 'HEALTH', 'J1/QAJY10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650957, 'HEALTH', 'J1/QAKH1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650958, 'HEALTH', 'J1/SAME20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650959, 'HEALTH', 'J1/SAMG2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650960, 'HEALTH', 'J1/SAMF10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650961, 'HEALTH', 'J1/SAMH1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650962, 'HEALTH', 'J1/TAKK20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650963, 'HEALTH', 'J1/TAKI2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650964, 'HEALTH', 'J1/TAKL10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650965, 'HEALTH', 'J1/TAKJ1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650966, 'HEALTH', 'J1/VAMN20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650967, 'HEALTH', 'J1/VAMM2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650968, 'HEALTH', 'J1/VAMO10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650969, 'HEALTH', 'J1/VAMP1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650970, 'HEALTH', 'J1/WAMA20', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650971, 'HEALTH', 'J1/WAMC2D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650972, 'HEALTH', 'J1/WAMB10', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', ''),
	(5650973, 'HEALTH', 'J1/WAMD1D', 12, 'Private Hospital 65% + Top Extras', 'Private Hospital 65% + Top Extras', '2015-04-01', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
