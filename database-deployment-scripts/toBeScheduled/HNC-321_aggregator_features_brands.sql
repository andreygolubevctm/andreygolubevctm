-- --------------------------------------------------------
-- Host:                         taws02_dbi
-- Server version:               5.5.5-10.0.16-MariaDB-log - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             8.0.0.4458
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table aggregator.features_brands
DROP TABLE IF EXISTS aggregator.features_brands;
CREATE TABLE IF NOT EXISTS aggregator.features_brands (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `displayName` varchar(150) NOT NULL,
  `realName` varchar(150) NOT NULL,
  `status` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4773 DEFAULT CHARSET=latin1 COMMENT='Set to InnoDB for transactional use.';

-- Dumping data for table aggregator.features_brands: ~318 rows (approximately)
/*!40000 ALTER TABLE `features_brands` DISABLE KEYS */;
INSERT INTO aggregator.features_brands (`id`, `displayName`, `realName`, `status`) VALUES
	(1472, '1st For Women', '1st For Women', 'Y'),
	(1473, 'AAMI', 'AAMI', 'Y'),
	(1474, 'AI Insurance', 'AI Insurance', 'Y'),
	(1475, 'Allianz', 'Allianz', 'Y'),
	(1476, 'ANZ', 'ANZ', 'Y'),
	(1477, 'APIA', 'APIA', 'Y'),
	(1478, 'Australia Post', 'Australia Post', 'Y'),
	(1479, 'Australian Seniors Insurance Agency', 'Australian Seniors Insurance Agency', 'Y'),
	(1480, 'Bingle', 'Bingle.com Pty Ltd', 'Y'),
	(1481, 'Budget Direct', 'Budget Direct', 'Y'),
	(1482, 'Cashback', 'Cashback', 'Y'),
	(1483, 'CGU Insurance Ltd', 'CGU Insurance Ltd', 'Y'),
	(1484, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(1485, 'CommInsure', 'CommInsure', 'Y'),
	(1486, 'Dodo Insurance', 'Dodo Insurance Pty Ltd', 'Y'),
	(1487, 'GIO', 'GIO General Limited', 'Y'),
	(1488, 'ibuyeco', 'ibuyeco', 'Y'),
	(1489, 'Just Car Insurance', 'Just Car Insurance', 'Y'),
	(1490, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(1491, 'Ozicare', 'Ozicare', 'Y'),
	(1492, 'Progressive Direct', 'Progressive Direct', 'Y'),
	(1493, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(1494, 'RAA', 'RAA', 'Y'),
	(1495, 'RACQI', 'RACQI', 'Y'),
	(1496, 'RACT Insurance Pty Ltd', 'RACT Insurance Pty Ltd', 'Y'),
	(1497, 'RACV', 'RACV', 'Y'),
	(1498, 'RACWA', 'RACWA', 'Y'),
	(1499, 'Real Insurance', 'Real Insurance', 'Y'),
	(1500, 'Resilium', 'Resilium', 'Y'),
	(1501, 'Retirease', 'Retirease', 'Y'),
	(1502, 'SGIC', 'SGIC', 'Y'),
	(1503, 'SGIO', 'SGIO', 'Y'),
	(1504, 'Shannons', 'Shannons', 'Y'),
	(1505, 'Suncorp', 'Suncorp Metway Insurance Limited', 'Y'),
	(1506, 'Vero', 'Vero (Australia)', 'Y'),
	(1507, 'Virgin Money', 'Virgin Money', 'Y'),
	(1508, 'Westpac', 'Westpac (Australia)', 'Y'),
	(1509, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(1510, 'Youi Insurance', 'Youi Insurance', 'Y'),
	(1511, '1st For Women', '1st For Women', 'Y'),
	(1512, 'AAMI', 'AAMI', 'Y'),
	(1513, 'AI Insurance', 'AI Insurance', 'Y'),
	(1514, 'Allianz', 'Allianz', 'Y'),
	(1515, 'ANZ', 'ANZ', 'Y'),
	(1516, 'APIA', 'APIA', 'Y'),
	(1517, 'Australia Post', 'Australia Post', 'Y'),
	(1518, 'Australian Seniors Insurance Agency', 'Australian Seniors Insurance Agency', 'Y'),
	(1519, 'Bingle', 'Bingle.com Pty Ltd', 'Y'),
	(1520, 'Budget Direct', 'Budget Direct', 'Y'),
	(1521, 'Cashback', 'Cashback', 'Y'),
	(1522, 'CGU Insurance Ltd', 'CGU Insurance Ltd', 'Y'),
	(1523, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(1524, 'CommInsure', 'CommInsure', 'Y'),
	(1525, 'Dodo Insurance', 'Dodo Insurance Pty Ltd', 'Y'),
	(1526, 'GIO', 'GIO General Limited', 'Y'),
	(1527, 'ibuyeco', 'ibuyeco', 'Y'),
	(1528, 'Just Car Insurance', 'Just Car Insurance', 'Y'),
	(1529, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(1530, 'Ozicare', 'Ozicare', 'Y'),
	(1531, 'Progressive Direct', 'Progressive Direct', 'Y'),
	(1532, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(1533, 'RAA', 'RAA', 'Y'),
	(1534, 'RACQI', 'RACQI', 'Y'),
	(1535, 'RACT Insurance Pty Ltd', 'RACT Insurance Pty Ltd', 'Y'),
	(1536, 'RACV', 'RACV', 'Y'),
	(1537, 'RACWA', 'RACWA', 'Y'),
	(1538, 'Real Insurance', 'Real Insurance', 'Y'),
	(1539, 'Resilium', 'Resilium', 'Y'),
	(1540, 'Retirease', 'Retirease', 'Y'),
	(1541, 'SGIC', 'SGIC', 'Y'),
	(1542, 'SGIO', 'SGIO', 'Y'),
	(1543, 'Shannons', 'Shannons', 'Y'),
	(1544, 'Suncorp', 'Suncorp Metway Insurance Limited', 'Y'),
	(1545, 'Vero', 'Vero (Australia)', 'Y'),
	(1546, 'Virgin Money', 'Virgin Money', 'Y'),
	(1547, 'Westpac', 'Westpac (Australia)', 'Y'),
	(1548, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(1549, 'Youi Insurance', 'Youi Insurance', 'Y'),
	(1667, '1st For Women', '1st For Women', 'Y'),
	(1668, 'AAMI', 'AAMI', 'Y'),
	(1669, 'AI Insurance', 'AI Insurance', 'Y'),
	(1670, 'Allianz', 'Allianz', 'Y'),
	(1671, 'ANZ', 'ANZ', 'Y'),
	(1672, 'APIA', 'APIA', 'Y'),
	(1673, 'Australia Post', 'Australia Post', 'Y'),
	(1674, 'Australian Seniors Insurance Agency', 'Australian Seniors Insurance Agency', 'Y'),
	(1675, 'Bingle', 'Bingle.com Pty Ltd', 'Y'),
	(1676, 'Budget Direct', 'Budget Direct', 'Y'),
	(1677, 'Cashback', 'Cashback', 'Y'),
	(1678, 'CGU Insurance Ltd', 'CGU Insurance Ltd', 'Y'),
	(1679, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(1680, 'CommInsure', 'CommInsure', 'Y'),
	(1681, 'Dodo Insurance', 'Dodo Insurance Pty Ltd', 'Y'),
	(1682, 'GIO General Limited', 'GIO General Limited', 'Y'),
	(1683, 'ibuyeco', 'ibuyeco', 'Y'),
	(1684, 'Just Car Insurance', 'Just Car Insurance', 'Y'),
	(1685, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(1686, 'Ozicare', 'Ozicare', 'Y'),
	(1687, 'Progressive Direct', 'Progressive Direct', 'Y'),
	(1688, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(1689, 'RAA', 'RAA', 'Y'),
	(1690, 'RACQI', 'RACQI', 'Y'),
	(1691, 'RACT Insurance Pty Ltd', 'RACT Insurance Pty Ltd', 'Y'),
	(1692, 'RACV', 'RACV', 'Y'),
	(1693, 'RACWA', 'RACWA', 'Y'),
	(1694, 'Real Insurance', 'Real Insurance', 'Y'),
	(1695, 'Resilium', 'Resilium', 'Y'),
	(1696, 'Retirease', 'Retirease', 'Y'),
	(1697, 'SGIC', 'SGIC', 'Y'),
	(1698, 'SGIO', 'SGIO', 'Y'),
	(1699, 'Shannons', 'Shannons', 'Y'),
	(1700, 'Suncorp Metway Insurance Limited', 'Suncorp Metway Insurance Limited', 'Y'),
	(1701, 'Vero', 'Vero (Australia)', 'Y'),
	(1702, 'Virgin Money', 'Virgin Money', 'Y'),
	(1703, 'Westpac', 'Westpac (Australia)', 'Y'),
	(1704, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(1705, 'Youi Insurance', 'Youi Insurance', 'Y'),
	(1952, '1st For Women', '1st For Women', 'Y'),
	(1953, 'AAMI', 'AAMI', 'Y'),
	(1954, 'AI Insurance', 'AI Insurance', 'Y'),
	(1955, 'Allianz', 'Allianz', 'Y'),
	(1956, 'ANZ', 'ANZ', 'Y'),
	(1957, 'APIA', 'APIA', 'Y'),
	(1958, 'Australia Post', 'Australia Post', 'Y'),
	(1959, 'Australian Seniors Insurance Agency', 'Australian Seniors Insurance Agency', 'Y'),
	(1960, 'Bingle', 'Bingle.com Pty Ltd', 'Y'),
	(1961, 'Budget Direct', 'Budget Direct', 'Y'),
	(1962, 'Cashback', 'Cashback', 'Y'),
	(1963, 'CGU Insurance Ltd', 'CGU Insurance Ltd', 'Y'),
	(1964, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(1965, 'CommInsure', 'CommInsure', 'Y'),
	(1966, 'Dodo Insurance', 'Dodo Insurance Pty Ltd', 'Y'),
	(1967, 'GIO', 'GIO General Limited', 'Y'),
	(1968, 'ibuyeco', 'ibuyeco', 'Y'),
	(1969, 'Just Car Insurance', 'Just Car Insurance', 'Y'),
	(1970, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(1971, 'Ozicare', 'Ozicare', 'Y'),
	(1972, 'Progressive Direct', 'Progressive Direct', 'Y'),
	(1973, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(1974, 'RAA', 'RAA', 'Y'),
	(1975, 'RACQI', 'RACQI', 'Y'),
	(1976, 'RACT Insurance Pty Ltd', 'RACT Insurance Pty Ltd', 'Y'),
	(1977, 'RACV', 'RACV', 'Y'),
	(1978, 'RACWA', 'RACWA', 'Y'),
	(1979, 'Real Insurance', 'Real Insurance', 'Y'),
	(1980, 'Resilium', 'Resilium', 'Y'),
	(1981, 'Retirease', 'Retirease', 'Y'),
	(1982, 'SGIC', 'SGIC', 'Y'),
	(1983, 'SGIO', 'SGIO', 'Y'),
	(1984, 'Shannons', 'Shannons', 'Y'),
	(1985, 'Suncorp', 'Suncorp Metway Insurance Limited', 'Y'),
	(1986, 'Vero', 'Vero (Australia)', 'Y'),
	(1987, 'Virgin Money', 'Virgin Money', 'Y'),
	(1988, 'Westpac', 'Westpac (Australia)', 'Y'),
	(1989, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(1990, 'Youi Insurance', 'Youi Insurance', 'Y'),
	(1991, '1st For Women', '1st For Women', 'Y'),
	(1992, 'AAMI', 'AAMI', 'Y'),
	(1993, 'AI Insurance', 'AI Insurance', 'Y'),
	(1994, 'Allianz', 'Allianz', 'Y'),
	(1995, 'ANZ', 'ANZ', 'Y'),
	(1996, 'APIA', 'APIA', 'Y'),
	(1997, 'Australia Post', 'Australia Post', 'Y'),
	(1998, 'Australian Seniors Insurance Agency', 'Australian Seniors Insurance Agency', 'Y'),
	(1999, 'Bingle', 'Bingle.com Pty Ltd', 'Y'),
	(2000, 'Budget Direct', 'Budget Direct', 'Y'),
	(2001, 'Cashback', 'Cashback', 'Y'),
	(2002, 'CGU Insurance Ltd', 'CGU Insurance Ltd', 'Y'),
	(2003, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(2004, 'CommInsure', 'CommInsure', 'Y'),
	(2005, 'Dodo Insurance', 'Dodo Insurance Pty Ltd', 'Y'),
	(2006, 'GIO', 'GIO General Limited', 'Y'),
	(2007, 'ibuyeco', 'ibuyeco', 'Y'),
	(2008, 'Just Car Insurance', 'Just Car Insurance', 'Y'),
	(2009, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(2010, 'Ozicare', 'Ozicare', 'Y'),
	(2011, 'Progressive Direct', 'Progressive Direct', 'Y'),
	(2012, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(2013, 'RAA', 'RAA', 'Y'),
	(2014, 'RACQI', 'RACQI', 'Y'),
	(2015, 'RACT Insurance Pty Ltd', 'RACT Insurance Pty Ltd', 'Y'),
	(2016, 'RACV', 'RACV', 'Y'),
	(2017, 'RACWA', 'RACWA', 'Y'),
	(2018, 'Real Insurance', 'Real Insurance', 'Y'),
	(2019, 'Resilium', 'Resilium', 'Y'),
	(2020, 'Retirease', 'Retirease', 'Y'),
	(2021, 'SGIC', 'SGIC', 'Y'),
	(2022, 'SGIO', 'SGIO', 'Y'),
	(2023, 'Shannons', 'Shannons', 'Y'),
	(2024, 'Suncorp', 'Suncorp Metway Insurance Limited', 'Y'),
	(2025, 'Vero', 'Vero (Australia)', 'Y'),
	(2026, 'Virgin Money', 'Virgin Money', 'Y'),
	(2027, 'Westpac', 'Westpac (Australia)', 'Y'),
	(2028, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(2029, 'Youi Insurance', 'Youi Insurance', 'Y'),
	(2030, '1st For Women', '1st For Women', 'Y'),
	(2031, 'AAMI', 'AAMI', 'Y'),
	(2032, 'Allianz', 'Allianz', 'Y'),
	(2033, 'ANZ', 'ANZ', 'Y'),
	(2034, 'APIA', 'APIA', 'Y'),
	(2035, 'Australian Unity', 'Australian Unity Personal Financial Services Ltd', 'Y'),
	(2036, 'Budget Direct', 'Budget Direct', 'Y'),
	(2037, 'Calliden Insurance', 'Calliden Insurance', 'Y'),
	(2038, 'CGU Insurance', 'CGU Insurance Ltd', 'Y'),
	(2039, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(2040, 'CommInsure', 'CommInsure', 'Y'),
	(2041, 'Dodo', 'Dodo Insurance Pty Ltd', 'Y'),
	(2042, 'GIO', 'GIO General Limited', 'Y'),
	(2043, 'National Australia Bank', 'National Australia Bank Limited', 'Y'),
	(2044, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(2045, 'Ozicare', 'Ozicare', 'Y'),
	(2046, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(2047, 'RAA', 'RAA', 'Y'),
	(2048, 'RACQI', 'RACQI', 'Y'),
	(2049, 'RACV', 'RACV', 'Y'),
	(2050, 'RACWA', 'RACWA', 'Y'),
	(2051, 'Real Insurance', 'Real Insurance', 'Y'),
	(2052, 'Shannons', 'Shannons', 'Y'),
	(2053, 'Suncorp', 'Suncorp Metway Insurance Limited', 'Y'),
	(2054, 'Virgin Money', 'Virgin Money', 'Y'),
	(2055, 'Westpac', 'Westpac (Australia)', 'Y'),
	(2056, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(2057, 'Youi Insurance', 'Youi Insurance', 'Y'),
	(2086, '1st For Women', '1st For Women', 'Y'),
	(2087, 'AAMI', 'AAMI', 'Y'),
	(2088, 'Allianz', 'Allianz', 'Y'),
	(2089, 'ANZ', 'ANZ', 'Y'),
	(2090, 'APIA', 'APIA', 'Y'),
	(2091, 'Australian Unity', 'Australian Unity Personal Financial Services Ltd', 'Y'),
	(2092, 'Budget Direct', 'Budget Direct', 'Y'),
	(2093, 'Calliden Insurance', 'Calliden Insurance', 'Y'),
	(2094, 'CGU Insurance', 'CGU Insurance Ltd', 'Y'),
	(2095, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(2096, 'CommInsure', 'CommInsure', 'Y'),
	(2097, 'Dodo', 'Dodo Insurance Pty Ltd', 'Y'),
	(2098, 'GIO', 'GIO General Limited', 'Y'),
	(2099, 'National Australia Bank', 'National Australia Bank Limited', 'Y'),
	(2100, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(2101, 'Ozicare', 'Ozicare', 'Y'),
	(2102, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(2103, 'RAA', 'RAA', 'Y'),
	(2104, 'RACQI', 'RACQI', 'Y'),
	(2105, 'RACV', 'RACV', 'Y'),
	(2106, 'RACWA', 'RACWA', 'Y'),
	(2107, 'Real Insurance', 'Real Insurance', 'Y'),
	(2108, 'Shannons', 'Shannons', 'Y'),
	(2109, 'Suncorp', 'Suncorp Metway Insurance Limited', 'Y'),
	(2110, 'Virgin Money', 'Virgin Money', 'Y'),
	(2111, 'Westpac', 'Westpac (Australia)', 'Y'),
	(2112, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(2113, 'Youi Insurance', 'Youi Insurance', 'Y'),
	(3698, '1st For Women', '1st For Women', 'Y'),
	(3699, 'AAMI', 'AAMI', 'Y'),
	(3700, 'AI Insurance', 'AI Insurance', 'Y'),
	(3701, 'Allianz', 'Allianz', 'Y'),
	(3702, 'ANZ', 'ANZ', 'Y'),
	(3703, 'APIA', 'APIA', 'Y'),
	(3704, 'Australia Post', 'Australia Post', 'Y'),
	(3705, 'Australian Seniors Insurance Agency', 'Australian Seniors Insurance Agency', 'Y'),
	(3706, 'Bingle', 'Bingle.com Pty Ltd', 'Y'),
	(3707, 'Budget Direct', 'Budget Direct', 'Y'),
	(3708, 'Cashback', 'Cashback', 'Y'),
	(3709, 'CGU Insurance ', 'CGU Insurance Ltd', 'Y'),
	(3710, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(3711, 'CommInsure', 'CommInsure', 'Y'),
	(3712, 'Dodo Insurance Pty Ltd', 'Dodo Insurance Pty Ltd', 'Y'),
	(3713, 'GIO', 'GIO General Limited', 'Y'),
	(3714, 'ibuyeco', 'ibuyeco', 'Y'),
	(3715, 'Just Car Insurance', 'Just Car Insurance', 'Y'),
	(3716, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(3717, 'Ozicare', 'Ozicare', 'Y'),
	(3718, 'Progressive Direct', 'Progressive Direct', 'Y'),
	(3719, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(3720, 'RAA', 'RAA', 'Y'),
	(3721, 'RACQ', 'RACQI', 'Y'),
	(3722, 'RACT', 'RACT Insurance Pty Ltd', 'Y'),
	(3723, 'RACV', 'RACV', 'Y'),
	(3724, 'RACWA', 'RACWA', 'Y'),
	(3725, 'Real Insurance', 'Real Insurance', 'Y'),
	(3726, 'Resilium', 'Resilium', 'Y'),
	(3727, 'Retirease', 'Retirease', 'Y'),
	(3728, 'SGIC', 'SGIC', 'Y'),
	(3729, 'SGIO', 'SGIO', 'Y'),
	(3730, 'Shannons', 'Shannons', 'Y'),
	(3731, 'Suncorp', 'Suncorp Metway Insurance Limited', 'Y'),
	(3732, 'Vero', 'Vero (Australia)', 'Y'),
	(3733, 'Virgin Money', 'Virgin Money', 'Y'),
	(3734, 'Westpac', 'Westpac (Australia)', 'Y'),
	(3735, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(3736, 'Youi Insurance', 'Youi Insurance', 'Y'),
	(4745, '1st For Women', '1st For Women', 'Y'),
	(4746, 'AAMI', 'AAMI', 'Y'),
	(4747, 'Allianz', 'Allianz', 'Y'),
	(4748, 'ANZ', 'ANZ', 'Y'),
	(4749, 'APIA', 'APIA', 'Y'),
	(4750, 'Australian Unity', 'Australian Unity Personal Financial Services Ltd', 'Y'),
	(4751, 'Budget Direct', 'Budget Direct', 'Y'),
	(4752, 'Calliden Insurance', 'Calliden Insurance', 'Y'),
	(4753, 'CGU Insurance', 'CGU Insurance Ltd', 'Y'),
	(4754, 'Coles Insurance', 'Coles Insurance', 'Y'),
	(4755, 'CommInsure', 'CommInsure', 'Y'),
	(4756, 'Dodo', 'Dodo Insurance Pty Ltd', 'Y'),
	(4757, 'GIO', 'GIO General Limited', 'Y'),
	(4758, 'National Australia Bank', 'National Australia Bank Limited', 'Y'),
	(4759, 'NRMA Insurance', 'NRMA Insurance', 'Y'),
	(4760, 'Ozicare', 'Ozicare', 'Y'),
	(4761, 'QBE Insurance', 'QBE Insurance Australia Ltd', 'Y'),
	(4762, 'RAA', 'RAA', 'Y'),
	(4763, 'RACQ', 'RACQI', 'Y'),
	(4764, 'RACV', 'RACV', 'Y'),
	(4765, 'RACWA', 'RACWA', 'Y'),
	(4766, 'Real Insurance', 'Real Insurance', 'Y'),
	(4767, 'Shannons', 'Shannons', 'Y'),
	(4768, 'Suncorp', 'Suncorp Metway Insurance Limited', 'Y'),
	(4769, 'Virgin Money', 'Virgin Money', 'Y'),
	(4770, 'Westpac', 'Westpac (Australia)', 'Y'),
	(4771, 'Woolworths Insurance', 'Woolworths Insurance', 'Y'),
	(4772, 'Youi Insurance', 'Youi Insurance', 'Y');
/*!40000 ALTER TABLE `features_brands` ENABLE KEYS */;

