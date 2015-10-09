USE `aggregator`;

DELIMITER $$

DROP TRIGGER IF EXISTS aggregator.trg_transaction_details_i_lookup$$
USE `aggregator`$$
CREATE DEFINER=`events_sp_mgr`@`localhost` TRIGGER aggregator.trg_transaction_details_i_lookup
AFTER INSERT
ON aggregator.transaction_details
FOR EACH ROW
BEGIN
  IF new.xpath = 'health/contactDetails/contactNumber'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textValue);
  ELSEIF new.xpath = 'health/contactDetails/contactNumber/mobile'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textValue);
  ELSEIF new.xpath = 'health/application/mobile'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/application/other'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/contactNumber/other'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/flexiContactNumber'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/email'
    THEN
    INSERT IGNORE INTO aggregator.email_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/application/email'
    THEN
    INSERT IGNORE INTO aggregator.email_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/name'
    THEN
    INSERT IGNORE INTO aggregator.person_lookup
      VALUES (NULL, new.transactionid, new.textvalue, NULL);
  ELSEIF new.xpath = 'health/application/primary/surname'
    THEN
    INSERT IGNORE INTO aggregator.person_lookup
      VALUES (NULL, new.transactionid, NULL, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/lastname'
    THEN
    INSERT IGNORE INTO aggregator.person_lookup
      VALUES (NULL, new.transactionid, NULL, new.textvalue);
  END IF;

END$$
DELIMITER ;

USE `aggregator`;

DELIMITER $$

DROP TRIGGER IF EXISTS aggregator.trg_transaction_details_u_lookup$$
USE `aggregator`$$
CREATE DEFINER=`events_sp_mgr`@`localhost` TRIGGER aggregator.trg_transaction_details_u_lookup
AFTER UPDATE
ON aggregator.transaction_details
FOR EACH ROW
BEGIN
  IF new.xpath = 'health/contactDetails/contactNumber'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textValue);
  ELSEIF new.xpath = 'health/contactDetails/contactNumber/mobile'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textValue);
  ELSEIF new.xpath = 'health/application/mobile'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/application/other'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/contactNumber/other'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/flexiContactNumber'
    THEN
    INSERT IGNORE INTO aggregator.phone_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/email'
    THEN
    INSERT IGNORE INTO aggregator.email_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/application/email'
    THEN
    INSERT IGNORE INTO aggregator.email_lookup
      VALUES (NULL, new.transactionid, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/name'
    THEN
    INSERT IGNORE INTO aggregator.person_lookup
      VALUES (NULL, new.transactionid, new.textvalue, NULL);
  ELSEIF new.xpath = 'health/application/primary/surname'
    THEN
    INSERT IGNORE INTO aggregator.person_lookup
      VALUES (NULL, new.transactionid, NULL, new.textvalue);
  ELSEIF new.xpath = 'health/contactDetails/lastname'
    THEN
    INSERT IGNORE INTO aggregator.person_lookup
      VALUES (NULL, new.transactionid, NULL, new.textvalue);
  END IF;

END$$
DELIMITER ;
