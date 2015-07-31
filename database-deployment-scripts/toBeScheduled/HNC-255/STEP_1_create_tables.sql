CREATE TABLE `ctm`.`home_product` (
  `homeProductId` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `reportingLabel` VARCHAR(170) NOT NULL,
  `providerId` smallint(5) UNSIGNED NOT NULL,
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`homeProductId`),
  FOREIGN KEY (`providerId`) REFERENCES `ctm`.`provider_master`(`ProviderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`home_product_content` (
  `homeProductContentId` int(11) NOT NULL AUTO_INCREMENT,
  `homeProductId` int(11),
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
  `coverType` char(2) NOT NULL,
  `offlineDiscount` varchar(10),
  `onlineDiscount` varchar(10),
  `inclusions` text,
  `optionalExtras` text,
  `benefits` text,
  `disclaimer` text,
  `specialConditions` text,
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`homeProductContentId`),
  FOREIGN KEY (`homeProductId`) REFERENCES `ctm`.`home_product`(`homeProductId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`home_product_additional_excesses` (
  `addExcessId` int(11) NOT NULL AUTO_INCREMENT,
  `homeProductContentId` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `amount` varchar(50) NOT NULL,
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`addExcessId`),
  FOREIGN KEY (`homeProductContentId`) REFERENCES `ctm`.`home_product_content`(`homeProductContentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`home_product_features` (
  `featureId` int(11) NOT NULL AUTO_INCREMENT,
  `homeProductContentId` int(11) NOT NULL,
  `code` varchar(255) NOT NULL,
  `name` varchar(255),
  `value` varchar(255) NOT NULL,
  `description` varchar(512),
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`featureId`),
  FOREIGN KEY (`homeProductContentId`) REFERENCES `ctm`.`home_product_content`(`homeProductContentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`home_product_disclosure_statements` (
  `pdsId` int(11) NOT NULL AUTO_INCREMENT,
  `homeProductContentId` int(11) NOT NULL,
  `code` varchar(255) NOT NULL,
  `title` varchar(255),
  `url` varchar(255) NOT NULL,
  `effectiveStart` date DEFAULT '2011-03-01',
  `effectiveEnd` date DEFAULT '2040-12-31',
  PRIMARY KEY (`pdsId`),
  FOREIGN KEY (`homeProductContentId`) REFERENCES `ctm`.`home_product_content`(`homeProductContentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -- rollback
-- DROP TABLE `ctm`.`home_product_disclosure_statements`;
--
-- DROP TABLE `ctm`.`home_product_features`;
--
-- DROP TABLE `ctm`.`home_product_additional_excesses`;
--
-- DROP TABLE `ctm`.`home_product_content`;
--
-- DROP TABLE `ctm`.`home_product`;


