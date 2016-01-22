CREATE SCHEMA `contact_validator`;

CREATE TABLE `contact_validator`.`mobile_result_details` (
  `mobileResultDetailsId` int(11) NOT NULL AUTO_INCREMENT,
  `mobileNumber` char(10) NOT NULL,
  `status` int NOT NULL,
  `requestDateTime` datetime NOT NULL,
  `referenceId` int(11) DEFAULT NULL,
  `requestedMsisdn` varchar(15) DEFAULT NULL,
  `validatedMsisdn` varchar(15) DEFAULT NULL,
  `operatorName` varchar(50) DEFAULT NULL,
  `operatorAlias` varchar(50) DEFAULT NULL,
  `portedStatus` varchar(3) DEFAULT NULL,
  `portedOperatorName` varchar(50) DEFAULT NULL,
  `portedOperatorAlias` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`mobileResultDetailsId`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
  PARTITION BY LIST(`status`) (
	PARTITION p_invalid VALUES IN (0),
	PARTITION p_valid VALUES IN (1, 2, 3, 4, 5));

-- Should return 0
SELECT * FROM `contact_validator`.`mobile_result_details`;

CREATE TABLE `contact_validator`.`mobile_number_exclusion` (
  `mobileNumberExclusionId` int(11) NOT NULL AUTO_INCREMENT,
  `mobileNumber` char(10) NOT NULL,
  `exclusionStatus` varchar(20) NOT NULL,
  `startDateTime` datetime NOT NULL,
  PRIMARY KEY (`mobileNumberExclusionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Should return 0
SELECT * FROM `contact_validator`.`mobile_number_exclusion`;

CREATE TABLE `contact_validator`.`service_provider_exclusions` (
  `serviceProviderExclusionId` int(11) NOT NULL AUTO_INCREMENT,
  `providerName` varchar(50) NOT NULL,
  `exclude` bit(1) NOT NULL,
  `startDateTime` datetime NOT NULL,
  PRIMARY KEY (`serviceProviderExclusionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Should return 0
SELECT * FROM `contact_validator`.`service_provider_exclusions`;

INSERT INTO `contact_validator`.`mobile_number_exclusion` (`mobileNumber`, `exclusionStatus`, `startDateTime`) VALUES
 ('0411111111', 'TEST', '2015-12-15 00:00:00'),
 ('0400654321', 'TEST', '2015-12-15 00:00:00'),
 ('0412345678', 'TEST', '2015-12-15 00:00:00'),
 ('0404123123', 'TEST', '2015-12-15 00:00:00'),
 ('0404000000', 'TEST', '2015-12-15 00:00:00'),
 ('0404040000', 'TEST', '2015-12-15 00:00:00');

-- Should return 6
SELECT * FROM `contact_validator`.`mobile_number_exclusion`;

-- ROLLBACK
-- DROP TABLE `contact_validator`.`service_provider_exclusions`;
-- DROP TABLE `contact_validator`.`mobile_number_exclusion`;
-- DROP TABLE `contact_validator`.`mobile_result_details`;
-- DROP SCHEMA `contact_validator`;


