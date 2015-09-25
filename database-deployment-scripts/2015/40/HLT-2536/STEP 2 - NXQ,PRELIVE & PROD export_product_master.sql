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
use ctm;
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
) ENGINE=InnoDB AUTO_INCREMENT=5559410 DEFAULT CHARSET=latin1;

-- Dumping data for table ctm.export_product_master: ~98 rows (approximately)
DELETE FROM `export_product_master`;
/*!40000 ALTER TABLE `export_product_master` DISABLE KEYS */;
INSERT INTO `export_product_master` (`ProductId`, `ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`, `Status`) VALUES
	(5559312, 'HEALTH', 'J67/NBIJ20', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559313, 'HEALTH', 'J67/NBIL2D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559314, 'HEALTH', 'J67/NBGG10', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559315, 'HEALTH', 'J67/NBIK1D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559316, 'HEALTH', 'J67/DBJT20', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559317, 'HEALTH', 'J67/DBJV2D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559318, 'HEALTH', 'J67/DBJS10', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559319, 'HEALTH', 'J67/DBJU1D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559320, 'HEALTH', 'J67/QBIP20', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559321, 'HEALTH', 'J67/QBIR2D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559322, 'HEALTH', 'J67/QBIO10', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559323, 'HEALTH', 'J67/QBIQ1D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559324, 'HEALTH', 'J67/SBJH20', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559325, 'HEALTH', 'J67/SBJJ2D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559326, 'HEALTH', 'J67/SBJG10', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559327, 'HEALTH', 'J67/SBJI1D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559328, 'HEALTH', 'J67/TBIV20', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559329, 'HEALTH', 'J67/TBIX2D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559330, 'HEALTH', 'J67/TBIU10', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559331, 'HEALTH', 'J67/TBIW1D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559332, 'HEALTH', 'J67/VBJB20', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559333, 'HEALTH', 'J67/VBJD2D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559334, 'HEALTH', 'J67/VBJA10', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559335, 'HEALTH', 'J67/VBJC1D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559336, 'HEALTH', 'J67/WBJN20', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559337, 'HEALTH', 'J67/WBJP2D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559338, 'HEALTH', 'J67/WBJM10', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559339, 'HEALTH', 'J67/WBJO1D', 9, 'black+white classic', 'black+white classic', '2015-04-01', '2016-03-31', ''),
	(5559340, 'HEALTH', 'J68/NBLN20', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559341, 'HEALTH', 'J68/NBLP2D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559342, 'HEALTH', 'J68/NBGH10', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559343, 'HEALTH', 'J68/NBLO1D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559344, 'HEALTH', 'J68/DBMX20', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559345, 'HEALTH', 'J68/DBMZ2D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559346, 'HEALTH', 'J68/DBMW10', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559347, 'HEALTH', 'J68/DBMY1D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559348, 'HEALTH', 'J68/QBLT20', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559349, 'HEALTH', 'J68/QBLV2D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559350, 'HEALTH', 'J68/QBLS10', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559351, 'HEALTH', 'J68/QBLU1D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559352, 'HEALTH', 'J68/SBML20', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559353, 'HEALTH', 'J68/SBMN2D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559354, 'HEALTH', 'J68/SBMK10', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559355, 'HEALTH', 'J68/SBMM1D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559356, 'HEALTH', 'J68/TBLZ20', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559357, 'HEALTH', 'J68/TBMB2D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559358, 'HEALTH', 'J68/TBLY10', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559359, 'HEALTH', 'J68/TBMA1D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559360, 'HEALTH', 'J68/VBMF20', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559361, 'HEALTH', 'J68/VBMH2D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559362, 'HEALTH', 'J68/VBME10', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559363, 'HEALTH', 'J68/VBMG1D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559364, 'HEALTH', 'J68/WBMR20', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559365, 'HEALTH', 'J68/WBMT2D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559366, 'HEALTH', 'J68/WBMQ10', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559367, 'HEALTH', 'J68/WBMS1D', 9, 'black+white deluxe', 'black+white deluxe', '2015-04-01', '2016-03-31', ''),
	(5559368, 'HEALTH', 'J66/NBHV20', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559369, 'HEALTH', 'J66/NBHI2D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559370, 'HEALTH', 'J66/NBGF10', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559371, 'HEALTH', 'J66/NBHW1D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559372, 'HEALTH', 'J66/DBHT20', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559373, 'HEALTH', 'J66/DBHU2D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559374, 'HEALTH', 'J66/DBHS10', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559375, 'HEALTH', 'J66/DBII1D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559376, 'HEALTH', 'J66/QBHK20', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559377, 'HEALTH', 'J66/QBHL2D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559378, 'HEALTH', 'J66/QBHJ10', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559379, 'HEALTH', 'J66/QBHX1D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559380, 'HEALTH', 'J66/SBHQ20', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559381, 'HEALTH', 'J66/SBHR2D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559382, 'HEALTH', 'J66/SBHP10', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559383, 'HEALTH', 'J66/SBID1D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559384, 'HEALTH', 'J66/TBHN20', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559385, 'HEALTH', 'J66/TBHO2D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559386, 'HEALTH', 'J66/TBHM10', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559387, 'HEALTH', 'J66/TBHY1D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559388, 'HEALTH', 'J66/VBIA20', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559389, 'HEALTH', 'J66/VBIC2D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559390, 'HEALTH', 'J66/VBHZ10', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559391, 'HEALTH', 'J66/VBIB1D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559392, 'HEALTH', 'J66/WBIF20', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559393, 'HEALTH', 'J66/WBIH2D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559394, 'HEALTH', 'J66/WBIE10', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559395, 'HEALTH', 'J66/WBIG1D', 9, 'black+white lite', 'black+white lite', '2015-04-01', '2016-03-31', ''),
	(5559396, 'HEALTH', 'J65/NBGI20', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559397, 'HEALTH', 'J65/NBGE10', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559398, 'HEALTH', 'J65/DBGU20', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559399, 'HEALTH', 'J65/DBGT10', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559400, 'HEALTH', 'J65/QBGK20', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559401, 'HEALTH', 'J65/QBGJ10', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559402, 'HEALTH', 'J65/SBGQ20', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559403, 'HEALTH', 'J65/SBGP10', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559404, 'HEALTH', 'J65/TBGM20', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559405, 'HEALTH', 'J65/TBGL10', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559406, 'HEALTH', 'J65/VBGO20', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559407, 'HEALTH', 'J65/VBGN10', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559408, 'HEALTH', 'J65/WBGS20', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', ''),
	(5559409, 'HEALTH', 'J65/WBGR10', 9, 'black+white starter', 'black+white starter', '2015-04-01', '2016-03-31', '');
/*!40000 ALTER TABLE `export_product_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
