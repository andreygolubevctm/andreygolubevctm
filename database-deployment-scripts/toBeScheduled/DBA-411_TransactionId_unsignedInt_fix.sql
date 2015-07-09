

-- Changes to align TransactionID fields - correct data type
ALTER TABLE aggregator.cross_sales_leads
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED NOT NULL DEFAULT 0,
  CHANGE COLUMN transactionIdNew transactionIdNew INT(11) UNSIGNED NOT NULL DEFAULT 0;
  
ALTER TABLE aggregator.results_properties
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED NOT NULL;

ALTER TABLE aggregator.statistic_master
  CHANGE COLUMN TransactionId TransactionId INT(11) UNSIGNED NOT NULL;


ALTER TABLE aggregator.transaction_locks
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED NOT NULL;

ALTER TABLE aggregator.ranking_master
  CHANGE COLUMN TransactionId TransactionId INT(11) UNSIGNED NOT NULL;

ALTER TABLE aggregator.ranking_details
  CHANGE COLUMN TransactionId TransactionId INT(11) UNSIGNED NOT NULL;

ALTER TABLE aggregator.statistic_details
  CHANGE COLUMN TransactionId TransactionId INT(11) UNSIGNED NOT NULL;

ALTER TABLE aggregator.statistic_description
  CHANGE COLUMN TransactionId TransactionId INT(11) UNSIGNED NOT NULL;

ALTER TABLE aggregator.transaction_emails
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED NOT NULL COMMENT 'FK to the transaction header table, however this can be ''split'' after archiving.';  
  
ALTER TABLE aggregator.transaction_details
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED NOT NULL;
  
ALTER TABLE aggregator.error_log
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED DEFAULT NULL;
  
--
ALTER TABLE aggregator.ranking_details
  CHANGE COLUMN TransactionId TransactionId INT(11) UNSIGNED NOT NULL;

ALTER TABLE ctm.handover_confirmations
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED NOT NULL;

ALTER TABLE ctm.stamping_tmp
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED DEFAULT NULL;

ALTER TABLE simples.cross_sales_leads
  CHANGE COLUMN transactionId transactionId INT(11) UNSIGNED NOT NULL DEFAULT 0;

ALTER TABLE ctm.touches
  CHANGE COLUMN transaction_id transaction_id INT(11) UNSIGNED NOT NULL;
ALTER TABLE ctm.confirmations
  CHANGE COLUMN TransID TransID INT(11) UNSIGNED NOT NULL;
  