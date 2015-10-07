CREATE TABLE `aggregator`.`email_token_type` (
  `emailTokenType` varchar(45) NOT NULL,
  `action` varchar(45) NOT NULL,
  `maxAttempts` tinyint(4) UNSIGNED NOT NULL,
  `expiryDays` tinyint(4) UNSIGNED NOT NULL,
  PRIMARY KEY (`emailTokenType`, `action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `aggregator`.`email_token` (
  `transactionId` int(11) UNSIGNED NOT NULL,
  `emailId` int(11) UNSIGNED NOT NULL,
  `emailTokenType` varchar(45) NOT NULL,
  `action` varchar(45) NOT NULL,
  `totalAttempts` tinyint(4) UNSIGNED NOT NULL,
  `effectiveStart` date NOT NULL,
  `effectiveEnd` date NOT NULL,
  `productId` int(11) unsigned DEFAULT NULL,
  `campaignId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`transactionId`,`emailId`,`emailTokenType`, `action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




