DROP SCHEMA IF EXISTS ctm;
CREATE SCHEMA ctm;
USE ctm;

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

