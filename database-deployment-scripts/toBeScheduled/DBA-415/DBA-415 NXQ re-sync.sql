--------------------------------------------------------------------------------------------------------
-- It was supposed to be dropped in AGG-1644/PRJWHL-26
-- It is used in NXQREFRESH/Testing Talend project
--------------------------------------------------------------------------------------------------------
DROP TABLE `aggregator`.`amex_product_properties`;
DROP TABLE `aggregator`.`best_price`;
DROP TABLE `aggregator`.`easy_props`;
DROP TABLE `aggregator`.`email_master_neo`;
DROP TABLE `aggregator`.`email_properties_neo`;
DROP TABLE `aggregator`.`product_properties_20121120`;
DROP TABLE `aggregator`.`product_properties_allianz`;
DROP TABLE `aggregator`.`product_properties_budget`;
DROP TABLE `aggregator`.`product_properties_fastcover`;
DROP TABLE `aggregator`.`ranking_details_neo`;
DROP TABLE `aggregator`.`ranking_master_neo`;
DROP TABLE `aggregator`.`roadside_product_master`;
DROP TABLE `aggregator`.`roadside_product_properties`;
DROP TABLE `aggregator`.`roadside_property_master`;
DROP TABLE `aggregator`.`statistic_details_neo`;
DROP TABLE `aggregator`.`statistic_master_neo`;
DROP TABLE `aggregator`.`transaction_details_neo`;
DROP TABLE `aggregator`.`wc_new_props`;
DROP TABLE `aggregator`.`wc_orig_props`;
DROP TABLE `aggregator`.`property_input_values`;
DROP TABLE `aggregator`.`property_master`;
DROP TABLE `aggregator`.`provider_master`;
DROP TABLE `aggregator`.`provider_properties`;


--------------------------------------------------------------------------------------------------------
-- Exist only in NXQ with empty declaration
DROP VIEW `aggregator`.`health_moreinfo_transaction_details`;
--------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
-- Exist in NXI and PRO with declaration and empty declaration in NXQ and there's no code using them.
--------------------------------------------------------------------------------------------------------
-- DROP VIEW `aggregator`.`health_moreinfo_transaction_details_data`;
-- DROP VIEW `aggregator`.`health_search_transaction_details`;
-- DROP VIEW `aggregator`.`health_search_transaction_details_data`;
-- DROP VIEW `aggregator`.`health_search_transaction_header`;

--------------------------------------------------------------------------------------------------------
-- Exist in PRO, not in NXI. NXQ has empty declaration and there's no code using them
--------------------------------------------------------------------------------------------------------
DROP VIEW `aggregator`.`health_search_transaction_header_inc_status`;
-- DROP VIEW `aggregator`.`health_transaction_benefits`;

--------------------------------------------------------------------------------------------------------
-- It is different from PRO.
--------------------------------------------------------------------------------------------------------
DROP PROCEDURE `aggregator`.`populatePopularVehicleModels`;

CREATE DEFINER=`ctmroot`@`192.168.11.162` PROCEDURE `populatePopularVehicleModels`()
BEGIN

 -- Limit popular models per make to this variable
 DECLARE model_limit INT DEFAULT 10;

 -- Used to confirm records found before flushing live popular models table
 DECLARE records_found INT;

 -- Vars needed for the CURSOR to limit the popular models to 'model_limit' per make
 DECLARE _make CHAR(4);
 DECLARE _model CHAR(7);
 DECLARE _count INT;
 DECLARE search_finished INTEGER DEFAULT 0;
 DECLARE active_make CHAR(4);
 DECLARE inserted_count INT DEFAULT 0;
 DECLARE make_inserted_count INT DEFAULT 0;
 DECLARE popular_models_cursor CURSOR FOR
   SELECT v.make, v.model, COUNT(v.model) AS count
    FROM temp_redbook_codes r
    LEFT JOIN vehicles AS v ON v.redbookCode = r.redbookCode
    WHERE v.model IS NOT NULL AND v.make IN (
     SELECT code FROM aggregator.general WHERE type = 'make' AND orderSeq <= 16 ORDER BY orderSeq
    )
    GROUP BY v.model
    ORDER BY v.make ASC, count DESC, v.model ASC;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET search_finished = 1;

 -- Need to increase the memory to account for data needed in temporary tables
 -- especially re temp_redbook_codes
 SET tmp_table_size = 1024 * 1024 * 256;
 SET max_heap_table_size = 1024 * 1024 * 256;

 -- Date limit for searching transaction header to get application transactions
 SET @dateLimit = DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH);

 -- [1] Create temporary table to store a subset of transactions details data - only
 -- 	   need the redbook codes to search through. We'll use this table to join on later
 DROP TEMPORARY TABLE IF EXISTS temp_redbook_codes;
 CREATE TEMPORARY TABLE temp_redbook_codes
 ENGINE=MEMORY
 SELECT d.textValue AS redbookCode
  FROM transaction_details AS d
  JOIN transaction_header AS h
   ON (h.transactionId = d.transactionId AND h.ProductType = 'CAR' AND h.StartDate > @dateLimit)
  WHERE d.xpath = 'quote/vehicle/redbookCode' AND d.textValue != ''
  ORDER BY d.transactionId DESC
  LIMIT 250000;

 -- [2] Create a temporary table to store popular model counts. We'll populate this table with data
 -- 	   and when finished we'll push them all at once to vehicle_popular_models
 DROP TEMPORARY TABLE IF EXISTS temp_vehicle_popular_models;
 CREATE TEMPORARY TABLE temp_vehicle_popular_models (
  make CHAR(4) NOT NULL,
  model CHAR(7) NOT NULL,
  count INT NOT NULL,
  last_update DATETIME NOT NULL,
  PRIMARY KEY (`make`, `model`)
 )
 ENGINE=MEMORY;

 -- [3] Source the current popular models data and push into temporary table
 -- 	   Use CURSOR to loop through results and only insert 'model_limit' per make
 OPEN popular_models_cursor;
 get_popular_models:LOOP
  FETCH popular_models_cursor INTO _make, _model, _count;
  -- Jump out now if at end of results
  IF search_finished = 1 THEN
   LEAVE get_popular_models;
  END IF;
  -- Set default active make
  IF(inserted_count = 0) THEN
   SET active_make = _make;
  END IF;
  -- Only insert if new make or still inside limit per make
  IF(active_make != _make OR make_inserted_count < model_limit) THEN
   INSERT INTO temp_vehicle_popular_models (make, model, count, last_update) VALUES (_make, _model, _count, CURRENT_TIMESTAMP);
   SET inserted_count = inserted_count + 1;
   IF(active_make != _make) THEN
    SET active_make = _make;
    SET make_inserted_count = 0;
   END IF;
   SET make_inserted_count = make_inserted_count + 1;
  END IF;
 END LOOP get_popular_models;
 CLOSE popular_models_cursor;

 -- [4] Check we have results in temporary table - otherwise leave the live table as is
 SELECT COUNT(model) INTO records_found
  FROM temp_vehicle_popular_models;
 IF(records_found > 0) THEN

 -- [5] Flush existing popular models data
  TRUNCATE vehicle_popular_models;

 -- [6] Publish the temporary popular models data to live popular models table
  INSERT INTO vehicle_popular_models (make, model, count, last_update)
  SELECT make, model, count, last_update FROM temp_vehicle_popular_models;

 END IF;

 -- [7] Drop all temporary tables and free up da memory
 DROP TEMPORARY TABLE temp_redbook_codes;
 DROP TEMPORARY TABLE temp_vehicle_popular_models;

END;

------------------------------------------------------------------------------
-- NXI and PRO are the same. NXQ is different.
------------------------------------------------------------------------------
DROP PROCEDURE `aggregator`.`sp_transactions_to_warm_cold`;

CREATE DEFINER=`server`@`%` PROCEDURE `sp_transactions_to_warm_cold`()
BEGIN

-- Declaring the variables for being used
DECLARE $transactionEmailsTotal SMALLINT UNSIGNED DEFAULT 0;
DECLARE $transactionHeadersTotal SMALLINT UNSIGNED DEFAULT 0;
DECLARE $transactionDetailsTotal MEDIUMINT UNSIGNED DEFAULT 0;
DECLARE $transactionIdMin INT UNSIGNED DEFAULT 0;
DECLARE $transactionIdMax INT UNSIGNED DEFAULT 0;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
 ROLLBACK;
 CALL logging.doLog('sp_transactions_to_warm_cold: exception occurred', 'MK-20004');
 CALL logging.saveLog();
 SELECT 'An error has occurred in: sp_transactions_to_warm_cold, operation rollbacked and the stored procedure was terminated' AS errorMessage;
 RESIGNAL;
END;

 /* Procedure
	1. Select the correct transaction headers
	2. Move the email Addresses to the reference table
	3. Move the transaction headers to the new table
	4. Move the transaction details to the new table
	5. Confirm the details and clear tmp tables that were used
	*/

 -- Create a tmp table for the transactionIds to live in
 DROP TEMPORARY TABLE IF EXISTS tmp_transactions_to_warm_cold;
  CREATE TEMPORARY TABLE tmp_transactions_to_warm_cold (
  `transactionId` INT UNSIGNED
  ) ENGINE = MEMORY;

 -- Insert the transactionIds into the tmp table for referencing
 INSERT INTO tmp_transactions_to_warm_cold(transactionId)
  SELECT transactionID FROM aggregator.transaction_header
  WHERE startDate < CURDATE() - INTERVAL 68 DAY
  -- These are quality checks
  AND productType IN(SELECT verticalCode FROM ctm.vertical_master)
  AND styleCodeId IN(SELECT styleCodeId from ctm.stylecodes)
  ORDER BY transactionId
  LIMIT 1000;

  SET $transactionIdMin = (SELECT MIN(transactionID) FROM tmp_transactions_to_warm_cold);
  SET $transactionIdMax = (SELECT MAX(transactionID) FROM tmp_transactions_to_warm_cold);

 START TRANSACTION;

  -- Save the email references
  INSERT INTO `aggregator`.`transaction_emails`(transactionId,emailId)
   SELECT th.transactionId, em.emailId FROM aggregator.transaction_header th
    JOIN aggregator.email_master em ON th.emailAddress = em.emailAddress AND th.styleCodeId = em.styleCodeID
   WHERE th.transactionId BETWEEN $transactionIdMin AND $transactionIdMax
   AND th.transactionID IN(SELECT transactionID FROM tmp_transactions_to_warm_cold)
   AND th.emailAddress != '';

  SET $transactionEmailsTotal = ROW_COUNT();

  -- Save the transaction_headers
  INSERT INTO `aggregator`.`transaction_header2_cold`(transactionId,verticalId,styleCodeId,transactionStartDateTime,rootId,previousId,previousRootId,transactionSafeKey)
   SELECT transactionId, (SELECT verticalID from ctm.vertical_master WHERE th.productType = verticalCode) As verticalId, styleCodeId, CONCAT(StartDate, ' ', StartTime) as transactionStartDateTime, rootId, PreviousId, IFNULL(prevRootId,0) AS prevRootId, (SELECT FLOOR(RAND() * (65535 - 11111 + 1)) + 11111) AS transactionSafeKey
   FROM aggregator.transaction_header th
   WHERE th.transactionId BETWEEN $transactionIdMin AND $transactionIdMax
   AND th.transactionID IN(SELECT transactionID FROM tmp_transactions_to_warm_cold)
   AND styleCodeId IN (SELECT `styleCodeId` FROM `ctm`.`stylecodes`)
   HAVING verticalId IS NOT NULL;

  SET $transactionHeadersTotal = ROW_COUNT();

   INSERT INTO `aggregator`.`transaction_header2_properties_cold`(transactionId,transactionIpAddress,transactionSessionId)
    SELECT TransactionId, IpAddress, SessionId
    FROM aggregator.transaction_header th
    WHERE th.transactionId BETWEEN $transactionIdMin AND $transactionIdMax
    AND th.transactionID IN(SELECT transactionID FROM tmp_transactions_to_warm_cold);

  -- Save the transaction_details
  INSERT INTO `aggregator`.`transaction_details2_cold`(transactionId,verticalId,fieldId,touchId,textValue)
   SELECT transactionId, (SELECT verticalID from ctm.vertical_master WHERE (SELECT productType FROM aggregator.transaction_header WHERE td.transactionId = transactionId)  = verticalCode) AS verticalID, (SELECT fieldID FROM aggregator.transaction_fields WHERE td.xpath = fieldCode) AS fieldId, (SELECT IFNULL(MAX(id),0) FROM ctm.touches WHERE transaction_id = td.transactionId) AS touchId, textValue
   FROM aggregator.transaction_details td
   WHERE td.transactionId BETWEEN $transactionIdMin AND $transactionIdMax
   AND td.transactionID IN(SELECT transactionID FROM tmp_transactions_to_warm_cold)
   AND td.textValue != ''
   AND td.xpath IN (SELECT `fieldCode` FROM `aggregator`.`transaction_fields`)
   HAVING verticalId IN (SELECT `verticalID` FROM `ctm`.`vertical_master`)
  ON DUPLICATE KEY UPDATE `textValue`=VALUES(`textValue`);

  SET $transactionDetailsTotal = ROW_COUNT();

  /*
		DBA-392
		Transaction migration to also move orphans to a new table
		*/
  -- Orphaned transaction_header
  INSERT INTO `aggregator`.`transaction_header_orphaned`(TransactionId,styleCodeId,PreviousId,ProductType,EmailAddress,IpAddress,StartDate,StartTime,StyleCode,AdvertKey,SessionId,Status,rootId,prevRootId)
    SELECT TransactionId,styleCodeId,PreviousId,ProductType,EmailAddress,IpAddress,StartDate,StartTime,StyleCode,AdvertKey,SessionId,Status,rootId,prevRootId
   FROM aggregator.transaction_header th
   WHERE th.transactionId BETWEEN $transactionIdMin AND $transactionIdMax
   AND (styleCodeId NOT IN (SELECT `styleCodeId` FROM `ctm`.`stylecodes`) OR productType NOT IN (SELECT verticalID from ctm.vertical_master));

  SET $transactionHeadersTotal = $transactionHeadersTotal  + ROW_COUNT();

  -- Orphaned transaction_details
  INSERT INTO `aggregator`.`transaction_details_orphaned`(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
   SELECT transactionId,sequenceNo,xpath,textValue,numericValue,dateValue
   FROM aggregator.transaction_details td
   WHERE td.transactionId BETWEEN $transactionIdMin AND $transactionIdMax
   AND xpath NOT IN (SELECT fieldCode FROM aggregator.transaction_fields)
  ON DUPLICATE KEY UPDATE `textValue`=VALUES(`textValue`);

  SET $transactionDetailsTotal = $transactionDetailsTotal + ROW_COUNT();

  DELETE FROM aggregator.transaction_header
   WHERE transactionID BETWEEN $transactionIdMin AND $transactionIdMax
   AND transactionId IN(SELECT transactionID FROM tmp_transactions_to_warm_cold)
   AND productType IN(SELECT verticalCode FROM ctm.vertical_master)
   AND transactionId > 0;

  DELETE FROM aggregator.transaction_details
   WHERE transactionID BETWEEN $transactionIdMin AND $transactionIdMax
   AND transactionId IN(SELECT transactionID FROM tmp_transactions_to_warm_cold)
   AND xpath IN (SELECT fieldCode FROM aggregator.transaction_fields)
   AND transactionId > 0
   AND sequenceNo IS NOT NULL;

  -- Orphaned Stranded Details
  INSERT INTO `aggregator`.`transaction_details_orphaned`(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
   SELECT transactionId,sequenceNo,xpath,textValue,numericValue,dateValue
   FROM aggregator.transaction_details td
   WHERE td.transactionId BETWEEN $transactionIdMin AND $transactionIdMax
   AND td.textValue != ''
   AND td.xpath IN (SELECT fieldCode FROM aggregator.transaction_fields)
  ON DUPLICATE KEY UPDATE `textValue`=VALUES(`textValue`);

  SET $transactionDetailsTotal = $transactionDetailsTotal + ROW_COUNT();

  DELETE FROM aggregator.transaction_header WHERE transactionID BETWEEN $transactionIdMin AND $transactionIdMax;
  DELETE FROM aggregator.transaction_details WHERE transactionID BETWEEN $transactionIdMin AND $transactionIdMax AND sequenceNo IS NOT NULL;

  /*
		END - DBA-392
		*/

  -- Delete the transaction_headers
  /*DELETE FROM aggregator.transaction_header
			WHERE transactionID BETWEEN $transactionIdMin AND $transactionIdMax
			AND transactionId IN(SELECT transactionID FROM tmp_transactions_to_warm_cold)
			AND productType IN(SELECT verticalCode FROM ctm.vertical_master)
			AND transactionId > 0;*/

  -- Delete the transaction_details: NOTE: there will be some remnants left over, as only items able to be saved in the first-place will be removed
  -- THIS IS AN ISSUE...
  /*DELETE FROM aggregator.transaction_details
			WHERE transactionID BETWEEN $transactionIdMin AND $transactionIdMax
			AND transactionId IN(SELECT transactionID FROM tmp_transactions_to_warm_cold)
			AND xpath IN (SELECT fieldCode FROM aggregator.transaction_fields)
			AND transactionId > 0
			AND sequenceNo IS NOT NULL;*/

  -- Close the tmp table off
  TRUNCATE tmp_transactions_to_warm_cold;

 COMMIT;

 -- Create the statistics
 CALL logging.doLog(CONCAT('sp_transactions_to_warm_cold: ',$transactionHeadersTotal,' header inserted with ', $transactionDetailsTotal,' details saved ', $transactionEmailsTotal,' email references converted'), 'MK-20002');
 CALL logging.saveLog();

END;


--------------------------------------------------------------------------------------------------------
-- TABLE `aggregator`.`email_master`
--------------------------------------------------------------------------------------------------------
ALTER ONLINE TABLE `aggregator`.`email_master` MODIFY `emailPword` `emailPword` VARCHAR(44);
ALTER ONLINE  TABLE `aggregator`.`email_master` ADD INDEX `hashedemail` (`hashedemail`)

--------------------------------------------------------------------------------------------------------
-- TABLE `aggregator`.`email_properties`
--------------------------------------------------------------------------------------------------------
DROP INDEX `emailId` ON `aggregator`.`email_properties`;
ALTER ONLINE  TABLE `aggregator`.`email_properties` ADD INDEX `emailId` (`emailId`)


--------------------------------------------------------------------------------------------------------
-- TABLE `aggregator`.`features_details`: Id is a primary key
--------------------------------------------------------------------------------------------------------
DROP INDEX `id_UNIQUE` ON `aggregator`.`features_details`;


--------------------------------------------------------------------------------------------------------
-- It exists in NXI and PRO. It is used in category_select.tag
--------------------------------------------------------------------------------------------------------
CREATE TABLE `aggregator`.`product_catagory_master` (
 `ProductCat` char(10) NOT NULL,
 `Description` varchar(45) NOT NULL,
 `EffectiveStart` date NOT NULL DEFAULT '2011-03-01',
 `EffectiveEnd` date NOT NULL DEFAULT '2040-12-31',
 `Status` char(1) NOT NULL,
 PRIMARY KEY  ( `ProductCat` )
)
ENGINE = InnoDB
CHARACTER SET = latin1
ROW_FORMAT = COMPACT;

--------------------------------------------------------------------------------------------------------
-- `aggregator`.`street_number` is VERY different from NXI and PRO
--------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS `aggregator`.`_temp_street_number`;

CREATE TABLE `aggregator`.`_temp_street_number` (
 `streetId` int(11) NOT NULL,
 `houseNo` char(10) NOT NULL,
 `unitType` char(2) NOT NULL,
 `unitNo` char(10) NOT NULL,
 `floorNo` char(36) NOT NULL,
 `lotNo` char(5) NOT NULL,
 `dpId` int(8) NOT NULL,
 KEY `houseNo` ( `houseNo` ),
 PRIMARY KEY  ( `dpId` ),
 KEY `streetId` ( `streetId` )
)
ENGINE = InnoDB
CHARACTER SET = latin1
AVG_ROW_LENGTH = 170
ROW_FORMAT = COMPACT
/*!50500 PARTITION BY RANGE  COLUMNS(dpId)
(PARTITION p_dpid1 VALUES LESS THAN (1000000) ENGINE = InnoDB,
 PARTITION p_dpid2 VALUES LESS THAN (2000000) ENGINE = InnoDB,
 PARTITION p_dpid3 VALUES LESS THAN (3000000) ENGINE = InnoDB,
 PARTITION p_dpid4 VALUES LESS THAN (4000000) ENGINE = InnoDB,
 PARTITION p_dpid5 VALUES LESS THAN (5000000) ENGINE = InnoDB,
 PARTITION p_dpid6 VALUES LESS THAN (6000000) ENGINE = InnoDB,
 PARTITION p_dpid7 VALUES LESS THAN (7000000) ENGINE = InnoDB,
 PARTITION p_dpid8 VALUES LESS THAN (8000000) ENGINE = InnoDB,
 PARTITION p_dpid9 VALUES LESS THAN (9000000) ENGINE = InnoDB,
 PARTITION p_dpid10 VALUES LESS THAN (10000000) ENGINE = InnoDB,
 PARTITION p_dpid11 VALUES LESS THAN (11000000) ENGINE = InnoDB,
 PARTITION p_dpid12 VALUES LESS THAN (12000000) ENGINE = InnoDB,
 PARTITION p_dpid13 VALUES LESS THAN (13000000) ENGINE = InnoDB,
 PARTITION p_dpidmax VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB) */;

INSERT INTO `aggregator`.`_temp_street_number`(`dpId`,
                                               `floorNo`,
                                               `houseNo`,
                                               `lotNo`,
                                               `streetId`,
                                               `unitNo`,
                                               `unitType`)
   SELECT `dpId`,
          `floorNo`,
          `houseNo`,
          `lotNo`,
          `streetId`,
          `unitNo`,
          `unitType`
     FROM `aggregator`.`street_number`;

DROP TABLE `aggregator`.`street_number`;

ALTER TABLE `aggregator`.`_temp_street_number`
   RENAME `street_number`;


--------------------------------------------------------------------------------------------------------
-- Orphaned tables for transaction_header/transaction_details
--------------------------------------------------------------------------------------------------------
CREATE TABLE `aggregator`.`transaction_header_orphaned` (
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
  PRIMARY KEY (`TransactionId`)
) ENGINE=InnoDB AUTO_INCREMENT=2411966 DEFAULT CHARSET=latin1;


CREATE TABLE `aggregator`.`transaction_details_orphaned` (
  `transactionId` int(11) NOT NULL,
  `sequenceNo` int(11) NOT NULL,
  `xpath` varchar(128) NOT NULL,
  `textValue` varchar(1000) NOT NULL DEFAULT '',
  `numericValue` decimal(15,2) NOT NULL DEFAULT '0.00',
  `dateValue` date NOT NULL DEFAULT '0001-01-01',
  PRIMARY KEY (`transactionId`,`sequenceNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



SET @TransactionIdColdMax = (SELECT max(transactionId) FROM aggregator.transaction_header2_cold);


-- Test before INSERT: Number of affected records
SELECT TransactionId,styleCodeId,PreviousId,ProductType,EmailAddress,IpAddress,StartDate,StartTime,StyleCode,AdvertKey,SessionId,Status,rootId,prevRootId
	FROM aggregator.transaction_header th
	WHERE th.transactionId <= @TransactionIdColdMax;

INSERT INTO `aggregator`.`transaction_header_orphaned`(TransactionId,styleCodeId,PreviousId,ProductType,EmailAddress,IpAddress,StartDate,StartTime,StyleCode,AdvertKey,SessionId,Status,rootId,prevRootId)
  SELECT TransactionId,styleCodeId,PreviousId,ProductType,EmailAddress,IpAddress,StartDate,StartTime,StyleCode,AdvertKey,SessionId,Status,rootId,prevRootId
	FROM aggregator.transaction_header th
	WHERE th.transactionId <= @TransactionIdColdMax;


-- Test before INSERT: Number of affected records
SELECT transactionId,sequenceNo,xpath,textValue,numericValue,dateValue
	FROM aggregator.transaction_details td
	WHERE td.transactionId <= @TransactionIdColdMax
	AND xpath NOT IN (SELECT fieldCode FROM aggregator.transaction_fields);

INSERT INTO `aggregator`.`transaction_details_orphaned`(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
	SELECT transactionId,sequenceNo,xpath,textValue,numericValue,dateValue
	FROM aggregator.transaction_details td
	WHERE td.transactionId <= @TransactionIdColdMax
	AND xpath NOT IN (SELECT fieldCode FROM aggregator.transaction_fields)
ON DUPLICATE KEY UPDATE `textValue`=VALUES(`textValue`);


-- Test before INSERT: Number of affected records
SELECT transactionId,sequenceNo,xpath,textValue,numericValue,dateValue
	FROM aggregator.transaction_details td
	WHERE td.transactionId <= @TransactionIdColdMax
	AND td.xpath IN (SELECT fieldCode FROM aggregator.transaction_fields);

INSERT INTO `aggregator`.`transaction_details_orphaned`(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
	SELECT transactionId,sequenceNo,xpath,textValue,numericValue,dateValue
	FROM aggregator.transaction_details td
	WHERE td.transactionId <= @TransactionIdColdMax
	AND td.xpath IN (SELECT fieldCode FROM aggregator.transaction_fields)
ON DUPLICATE KEY UPDATE `textValue`=VALUES(`textValue`);


DELETE FROM aggregator.transaction_header
WHERE transactionID <= @TransactionIdColdMax;

DELETE
FROM aggregator.transaction_details
WHERE transactionId <= @TransactionIdColdMax;

--------------------------------------------------------------------------------------------------------
-- Tables created on the wrong schema. They exist in ctm schema.
--------------------------------------------------------------------------------------------------------
DROP TABLE `aggregator`.`export_product_master`;
DROP TABLE `aggregator`.`export_product_properties`;
DROP TABLE `aggregator`.`export_product_properties_ext`;
DROP TABLE `aggregator`.`export_product_properties_search`;


ALTER VIEW `aggregator`.`vw_health_cover`
AS
   SELECT `aggregator`.`general`.`code` AS `code`,
          `aggregator`.`general`.`description` AS `description`
     FROM `aggregator`.`general`
    WHERE (`aggregator`.`general`.`type` = 'healthCvr')
   ORDER BY `aggregator`.`general`.`orderSeq`;



ALTER ONLINE TABLE `aggregator`.`error_log` CHANGE transactionId transactionId UNSIGNED INT(11) DEFAULT NULL;