CREATE TABLE `aggregator`.`email_token_type` (
  `emailTokenType` enum('app', 'bestprice', 'brochures', 'edm', 'promotion', 'quote') NOT NULL,
  `action` enum('load', 'unsubscribe') NOT NULL,
  `maxAttempts` tinyint(4) UNSIGNED NOT NULL,
  `expiryDays` tinyint(4) UNSIGNED NOT NULL,
  PRIMARY KEY (`emailTokenType`, `action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `aggregator`.`email_token` (
  `transactionId` int(11) UNSIGNED NOT NULL,
  `emailId` int(11) UNSIGNED NOT NULL,
  `emailTokenType` enum('app', 'bestprice', 'brochures', 'edm', 'promotion', 'quote') NOT NULL,
  `action` enum('load', 'unsubscribe') NOT NULL,
  `totalAttempts` tinyint(4) UNSIGNED NOT NULL,
  `effectiveStart` date NOT NULL,
  `effectiveEnd` date NOT NULL,
  PRIMARY KEY (`transactionId`,`emailId`,`emailTokenType`, `action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
  PARTITION BY KEY (emailTokenType) PARTITIONS 6;


INSERT INTO `aggregator`.`email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`)
VALUES
  ('app', 'load', 4, 60),
  ('app', 'unsubscribe', 4, 60),
  ('bestprice', 'load', 4, 60),
  ('bestprice', 'unsubscribe', 4, 60),
  ('brochures', 'load', 4, 60),
  ('brochures', 'unsubscribe', 4, 60),
  ('edm', 'load', 4, 60),
  ('edm', 'unsubscribe', 4, 60),
  ('promotion', 'load', 4, 60),
  ('promotion', 'unsubscribe', 4, 60),
  ('quote', 'load', 4, 60),
  ('quote', 'unsubscribe', 4, 60);
