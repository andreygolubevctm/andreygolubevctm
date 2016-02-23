DROP SCHEMA IF EXISTS ctm;
CREATE SCHEMA ctm;
USE ctm;

CREATE TABLE `vertical_master` (
  `verticalId` tinyint(3) unsigned NOT NULL,
  `verticalCode` varchar(20) NOT NULL,
  `verticalName` varchar(50) NOT NULL,
  PRIMARY KEY (`verticalId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP SCHEMA IF EXISTS aggregator;
CREATE SCHEMA aggregator;
USE aggregator;

CREATE TABLE `email_token_type` (
  `emailTokenType` enum('app','bestprice','brochures','edm','promotion','quote') NOT NULL,
  `action` enum('load','unsubscribe') NOT NULL,
  `maxAttempts` tinyint(4) unsigned NOT NULL,
  `expiryDays` tinyint(4) unsigned NOT NULL,
  PRIMARY KEY (`emailTokenType`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `email_token` (
  `transactionId` int(11) unsigned NOT NULL,
  `emailId` int(11) unsigned NOT NULL,
  `emailTokenType` enum('app','bestprice','brochures','edm','promotion','quote') NOT NULL,
  `action` enum('load','unsubscribe') NOT NULL,
  `totalAttempts` tinyint(4) unsigned NOT NULL,
  `effectiveStart` date NOT NULL,
  `effectiveEnd` date NOT NULL,
  PRIMARY KEY (`transactionId`,`emailId`,`emailTokenType`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
/*!50100 PARTITION BY KEY (emailTokenType)
PARTITIONS 6 */;


CREATE TABLE `email_master` (
  `emailAddress` varchar(256) NOT NULL,
  `styleCodeId` tinyint(4) unsigned DEFAULT NULL,
  `emailPword` varchar(44) DEFAULT NULL,
  `emailPwordHash` varchar(44) DEFAULT NULL,
  `vertical` varchar(16) NOT NULL,
  `source` varchar(24) NOT NULL,
  `firstName` char(35) NOT NULL,
  `lastName` char(35) NOT NULL,
  `createDate` date NOT NULL,
  `changeDate` date DEFAULT NULL,
  `emailId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `transactionId` int(11) unsigned DEFAULT NULL,
  `hashedEmail` varchar(40) DEFAULT NULL,
  `oldHashedEmail` varchar(40) DEFAULT NULL,
  `brand` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`emailId`),
  UNIQUE KEY `emailMaster_UNIQUE` (`styleCodeId`,`emailAddress`),
  KEY `loadQuotes` (`styleCodeId`,`hashedEmail`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1469752 DEFAULT CHARSET=latin1;


CREATE TABLE `transaction_header` (
  `TransactionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `styleCodeId` tinyint(4) unsigned NOT NULL,
  `PreviousId` int(11) unsigned NOT NULL,
  `ProductType` varchar(50) NOT NULL,
  `EmailAddress` varchar(256) DEFAULT NULL,
  `IpAddress` varchar(15) NOT NULL,
  `StartDate` date NOT NULL DEFAULT '2011-03-01',
  `StartTime` time NOT NULL,
  `StyleCode` varchar(4) NOT NULL,
  `AdvertKey` int(5) NOT NULL,
  `SessionId` varchar(64) NOT NULL,
  `Status` varchar(1) NOT NULL,
  `rootId` int(11) unsigned DEFAULT '0' COMMENT 'Is a common Id shared by all relatives of a particular transaction.',
  `prevRootId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`TransactionId`),
  KEY `StartDate` (`StartDate`),
  KEY `SimplesSearchA` (`rootId`),
  KEY `SimplesSearchC` (`EmailAddress`),
  KEY `IDX_transaction_header_ProductType` (`ProductType`)
) ENGINE=InnoDB AUTO_INCREMENT=2739049 DEFAULT CHARSET=latin1;

CREATE TABLE `transaction_header2_cold` (
  `transactionId` int(11) unsigned NOT NULL,
  `verticalId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `styleCodeId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `transactionStartDateTime` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `rootId` int(11) unsigned NOT NULL DEFAULT '0',
  `previousId` int(11) unsigned NOT NULL DEFAULT '0',
  `previousRootId` int(11) unsigned NOT NULL DEFAULT '0',
  `transactionSafeKey` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`transactionId`,`verticalId`,`styleCodeId`),
  KEY `transaction_header_idx_trans_root_prev_prevRoot_ids` (`transactionId`,`verticalId`,`rootId`,`previousId`,`previousRootId`),
  KEY `transaction_header_idx_startDateTime` (`transactionStartDateTime`),
  KEY `transaction_header_idx_rootId` (`rootId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AVG_ROW_LENGTH=50
  /*!50100 PARTITION BY LIST (verticalId)
(PARTITION pGeneric VALUES IN (0) ENGINE = InnoDB,
PARTITION pRoadside VALUES IN (1) ENGINE = InnoDB,
PARTITION pTravel VALUES IN (2) ENGINE = InnoDB,
PARTITION pCar VALUES IN (3) ENGINE = InnoDB,
PARTITION pHealth VALUES IN (4) ENGINE = InnoDB,
PARTITION pUtilities VALUES IN (5) ENGINE = InnoDB,
PARTITION pLife VALUES IN (6) ENGINE = InnoDB,
PARTITION pHome VALUES IN (7) ENGINE = InnoDB,
PARTITION pIP VALUES IN (8) ENGINE = InnoDB,
PARTITION pFuel VALUES IN (9) ENGINE = InnoDB,
PARTITION pCarLmi VALUES IN (10) ENGINE = InnoDB,
PARTITION pHomeLmi VALUES IN (11) ENGINE = InnoDB,
PARTITION pCompetition VALUES IN (12) ENGINE = InnoDB,
PARTITION pHomeLoan VALUES IN (13) ENGINE = InnoDB,
PARTITION pSimples VALUES IN (14) ENGINE = InnoDB,
PARTITION pCreditCards VALUES IN (15) ENGINE = InnoDB,
PARTITION pConfirmation VALUES IN (16) ENGINE = InnoDB) */;





