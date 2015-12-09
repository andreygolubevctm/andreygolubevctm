DROP SCHEMA IF EXISTS leads;
CREATE SCHEMA leads;
USE leads;

CREATE TABLE `leads`.`sources` (
  `sourceId`   INT(11)     NOT NULL AUTO_INCREMENT,
  `sourceCode` VARCHAR(20) NOT NULL,
  `sourceName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`sourceId`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

CREATE TABLE `leads`.`leads` (
  `leadId`          INT(11) NOT NULL AUTO_INCREMENT,
  `dateTime`        DATETIME NOT NULL,
  `sourceId`        INT(11) NOT NULL,
  `transactionId`   INT(11) NOT NULL,
  `rootId`          INT(11) NOT NULL,
  `firstName`       VARCHAR(50)      DEFAULT NULL,
  `lastName`        VARCHAR(50)      DEFAULT NULL,
  `mobile`          VARCHAR(10)      DEFAULT NULL,
  `phone`           VARCHAR(10)      DEFAULT NULL,
  `email`           VARCHAR(128)     DEFAULT NULL,
  `clientIpAddress` VARCHAR(15) NOT NULL,
  `personAccountId` VARCHAR(18),
  `status`          VARCHAR(100) NOT NULL,
  PRIMARY KEY (`leadId`),
  KEY `fk_sourceId_idx` (`sourceId`),
  CONSTRAINT `fk_sourceId` FOREIGN KEY (`sourceId`) REFERENCES `sources` (`sourceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;


INSERT INTO `leads`.`sources` (`sourceCode`, `sourceName`) VALUES ('SECURE', 'Secure');