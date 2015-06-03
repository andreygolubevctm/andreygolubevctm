delimiter $$

CREATE TABLE `ref_tbProfanityList` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Regex` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `regex_idx` (`Regex`)
) ENGINE=InnoDB AUTO_INCREMENT=2145 DEFAULT CHARSET=latin1$$

