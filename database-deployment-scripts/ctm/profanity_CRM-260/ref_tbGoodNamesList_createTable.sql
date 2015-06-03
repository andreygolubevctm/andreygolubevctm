delimiter $$

CREATE TABLE `ref_tbGoodNamesList` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(150) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Name_Idx` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=797 DEFAULT CHARSET=latin1$$