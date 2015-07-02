/** Updater **/
CREATE TABLE IF NOT EXISTS ctm.rego_lookup_usage (
  regoLookup_id int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  regoLookup_datetime datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  regoLookup_rego varchar(7) NOT NULL,
  regoLookup_state varchar(3) NOT NULL,
  regoLookup_transactionId int(11) UNSIGNED NOT NULL,
  regoLookup_status varchar(45) NOT NULL,
  PRIMARY KEY (regoLookup_id),
  KEY regoLookup_transactionId (regoLookup_transactionId),
  KEY regoLookup_datetime (regoLookup_datetime),
  KEY regoLookup_status (regoLookup_status)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Stores basic information on registration lookups performed';

/** Checker **/
SHOW TABLES FROM `ctm` LIKE 'rego_lookup_usage';

/** Rollback **/
DROP TABLE IF EXISTS ctm.rego_lookup_usage;