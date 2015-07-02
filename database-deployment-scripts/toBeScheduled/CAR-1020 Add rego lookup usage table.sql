/** Updater **/
CREATE TABLE `rego_lookup_usage` (
  `regoLookupId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `regoLookupDatetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `regoLookupPlate` varchar(10) NOT NULL,
  `regoLookupState` varchar(3) NOT NULL,
  `regoLookupTransactionId` int(11) unsigned NOT NULL,
  `regoLookupStatus` varchar(45) NOT NULL,
  PRIMARY KEY (`regoLookupId`),
  KEY `regoLookup_transactionId` (`regoLookupTransactionId`),
  KEY `regoLookup_datetime` (`regoLookupDatetime`),
  KEY `regoLookup_status` (`regoLookupStatus`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=latin1 COMMENT='Stores basic information on registration lookups performed';

/** Checker **/
SHOW TABLES FROM `ctm` LIKE 'rego_lookup_usage';

/** Rollback **/
DROP TABLE IF EXISTS ctm.rego_lookup_usage;