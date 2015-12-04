CREATE TABLE `aggregator`.`transaction_crm_mapping` (
  `transactionId` int(11) unsigned NOT NULL,
  `crmId` varchar(18) NOT NULL,
  `dateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;