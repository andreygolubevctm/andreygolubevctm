DROP SCHEMA IF EXISTS ctm;
CREATE SCHEMA ctm;
USE ctm;

DROP SCHEMA IF EXISTS aggregator;
CREATE SCHEMA aggregator;
USE aggregator;

CREATE TABLE `transaction_details` (
  `transactionId` int(11) unsigned NOT NULL,
  `sequenceNo` int(11) NOT NULL,
  `xpath` varchar(128) NOT NULL,
  `textValue` varchar(1000) NOT NULL DEFAULT '',
  `numericValue` decimal(15,2) NOT NULL DEFAULT '0.00',
  `dateValue` date NOT NULL DEFAULT '0001-01-01',
  `lastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`transactionId`,`sequenceNo`),
  KEY `xpath` (`xpath`,`transactionId`,`sequenceNo`),
  KEY `transactionId` (`transactionId`),
  KEY `sequenceNo` (`sequenceNo`),
  KEY `textValue` (`textValue`(767)),
  KEY `transdate` (`dateValue`,`transactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

