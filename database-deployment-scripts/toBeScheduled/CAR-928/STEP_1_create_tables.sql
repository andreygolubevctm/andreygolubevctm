CREATE TABLE `ctm`.`car_product` (
  `carProductId` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `reportingLabel` VARCHAR(170) NOT NULL,
  `providerId` smallint(5) UNSIGNED NOT NULL,
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`carProductId`),
  FOREIGN KEY (`providerId`) REFERENCES `ctm`.`provider_master`(`ProviderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`car_product_content` (
  `carProductContentId` int(11) NOT NULL AUTO_INCREMENT,
  `carProductId` int(11) NOT NULL,
  `styleCodeId` int(4),
  `providerProductName` varchar(255),
  `name` varchar(170),
  `description` varchar(512),
  `discountOffer` varchar(512),
  `discountOfferTerms` varchar(1024),
  `underwriterName`	varchar(100),
  `underwriterABN` varchar(25),
  `underwriterACN` varchar(50),
  `underwriterAFSLicenceNo`	varchar(50),
  `allowCallMeBack`	char(1),
  `allowCallDirect`	char(1),
  `callCentreHours`	varchar(100),
  `phoneNumber` varchar(50),
  `inclusions` text,
  `optionalExtras` text,
  `benefits` text,
  `disclaimer` text,
  `specialConditions` text,
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`carProductContentId`),
  FOREIGN KEY (`carProductId`) REFERENCES `ctm`.`car_product`(`carProductId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`car_product_additional_excesses` (
  `addExcessId` int(11) NOT NULL AUTO_INCREMENT,
  `carProductContentId` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `amount` varchar(50) NOT NULL,
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`addExcessId`),
  FOREIGN KEY (`carProductContentId`) REFERENCES `ctm`.`car_product_content`(`carProductContentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`car_product_features` (
  `featureId` int(11) NOT NULL AUTO_INCREMENT,
  `carProductContentId` int(11) NOT NULL,
  `code` varchar(255) NOT NULL,
  `name` varchar(255),
  `value` varchar(255) NOT NULL,
  `description` varchar(512),
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`featureId`),
  FOREIGN KEY (`carProductContentId`) REFERENCES `ctm`.`car_product_content`(`carProductContentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`car_product_disclosure_statements` (
  `pdsId` int(11) NOT NULL AUTO_INCREMENT,
  `carProductContentId` int(11) NOT NULL,
  `code` varchar(255) NOT NULL,
  `title` varchar(255),
  `url` varchar(255) NOT NULL,
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`pdsId`),
  FOREIGN KEY (`carProductContentId`) REFERENCES `ctm`.`car_product_content`(`carProductContentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- rollback
-- DROP TABLE `ctm`.`car_product_disclosure_statements`;
--
-- DROP TABLE `ctm`.`car_product_features`;
--
-- DROP TABLE `ctm`.`car_product_additional_excesses`;
--
-- DROP TABLE `ctm`.`car_product_content`;
--
-- DROP TABLE `ctm`.`car_product`;


