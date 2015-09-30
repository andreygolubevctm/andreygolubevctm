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
) ENGINE=InnoDB AUTO_INCREMENT=5553254 DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_master: ~1,344 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5555081, 'HEALTH', 'I28/NEHH20', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555082, 'HEALTH', 'I28/NEHU2D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555083, 'HEALTH', 'I28/NEIK10', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555084, 'HEALTH', 'I28/NEIC1D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555085, 'HEALTH', 'I28/DEHJ20', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555086, 'HEALTH', 'I28/DEHV2D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555087, 'HEALTH', 'I28/DEIL10', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555088, 'HEALTH', 'I28/DEID1D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555089, 'HEALTH', 'I28/QEHI20', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555090, 'HEALTH', 'I28/QEIP2D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555091, 'HEALTH', 'I28/QEIO10', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555092, 'HEALTH', 'I28/QEIR1D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555093, 'HEALTH', 'I28/SEHK20', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555094, 'HEALTH', 'I28/SEHQ2D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555095, 'HEALTH', 'I28/SEHP10', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555096, 'HEALTH', 'I28/SEHS1D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555097, 'HEALTH', 'I28/TEHN20', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555098, 'HEALTH', 'I28/TEIT2D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555099, 'HEALTH', 'I28/TEIV10', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555100, 'HEALTH', 'I28/TEIW1D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555101, 'HEALTH', 'I28/VEHL20', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555102, 'HEALTH', 'I28/VEHW2D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555103, 'HEALTH', 'I28/VEIM10', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555104, 'HEALTH', 'I28/VEIF1D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555105, 'HEALTH', 'I28/WEHM20', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555106, 'HEALTH', 'I28/WEHX2D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555107, 'HEALTH', 'I28/WEIN10', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555108, 'HEALTH', 'I28/WEIE1D', 15, 'Bronze Extras', 'Bronze Extras', '2015-04-01', '2016-03-31', ''),
	(5555361, 'HEALTH', 'I16/NBLN20', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555362, 'HEALTH', 'I16/NBLO2D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555363, 'HEALTH', 'I16/NBLM10', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555364, 'HEALTH', 'I16/NBLP1D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555365, 'HEALTH', 'I16/DBQI20', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555366, 'HEALTH', 'I16/DBQK2D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555367, 'HEALTH', 'I16/DBPC10', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555368, 'HEALTH', 'I16/DBPI1D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555369, 'HEALTH', 'I16/QBMC20', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555370, 'HEALTH', 'I16/QBMD2D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555371, 'HEALTH', 'I16/QBMB10', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555372, 'HEALTH', 'I16/QBME1D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555373, 'HEALTH', 'I16/SBPF20', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555374, 'HEALTH', 'I16/SBPK2D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555375, 'HEALTH', 'I16/SBPD10', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555376, 'HEALTH', 'I16/SBPL1D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555377, 'HEALTH', 'I16/TBLX20', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555378, 'HEALTH', 'I16/TBLY2D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555379, 'HEALTH', 'I16/TBLW10', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555380, 'HEALTH', 'I16/TBLZ1D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555381, 'HEALTH', 'I16/VBLH20', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555382, 'HEALTH', 'I16/VBLJ2D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555383, 'HEALTH', 'I16/VBLG10', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555384, 'HEALTH', 'I16/VBLK1D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555385, 'HEALTH', 'I16/WBLS20', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555386, 'HEALTH', 'I16/WBLT2D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555387, 'HEALTH', 'I16/WBLR10', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555388, 'HEALTH', 'I16/WBLU1D', 15, 'Gold Extras', 'Gold Extras', '2015-04-01', '2016-03-31', ''),
	(5555389, 'HEALTH', 'I17/NBMN20', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555390, 'HEALTH', 'I17/NBMO2D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555391, 'HEALTH', 'I17/NBMM10', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555392, 'HEALTH', 'I17/NBMP1D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555393, 'HEALTH', 'I17/DBQQ20', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555394, 'HEALTH', 'I17/DBQT2D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555395, 'HEALTH', 'I17/DBPO10', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555396, 'HEALTH', 'I17/DBQU1D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555397, 'HEALTH', 'I17/QBND20', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555398, 'HEALTH', 'I17/QBNE2D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555399, 'HEALTH', 'I17/QBNC10', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555400, 'HEALTH', 'I17/QBNF1D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555401, 'HEALTH', 'I17/SBPQ20', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555402, 'HEALTH', 'I17/SBPS2D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555403, 'HEALTH', 'I17/SBPN10', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555404, 'HEALTH', 'I17/SBPU1D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555405, 'HEALTH', 'I17/TBMY20', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555406, 'HEALTH', 'I17/TBMZ2D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555407, 'HEALTH', 'I17/TBMX10', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555408, 'HEALTH', 'I17/TBNA1D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555409, 'HEALTH', 'I17/VBMH20', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555410, 'HEALTH', 'I17/VBMJ2D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555411, 'HEALTH', 'I17/VBMG10', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555412, 'HEALTH', 'I17/VBMK1D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555413, 'HEALTH', 'I17/WBMS20', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555414, 'HEALTH', 'I17/WBMT2D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555415, 'HEALTH', 'I17/WBMR10', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', ''),
	(5555416, 'HEALTH', 'I17/WBMV1D', 15, 'Silver Extras', 'Silver Extras', '2015-04-01', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
