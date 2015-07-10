/*
STEP 1: convert all quotes to car, so that vertical master has matches when moving over
*/
-- TEST
SELECT count(*) FROM aggregator.transaction_header
WHERE productType = 'QUOTE';

-- UPDATE
UPDATE aggregator.transaction_header
SET `productType` = 'CAR'
WHERE `productType` = 'QUOTE'
AND transactionId > 0;

-- REPAIR PRODUCT TYPES
-- See other file for repairing product types

INSERT INTO `ctm`.`vertical_master` (`verticalId`, `verticalCode`, `verticalName`) VALUES ('16', 'CONFIRMATION', 'Confirmations');


/*
STEP 2: Create the transaction field table
SEE RELATED FILE
*/

/*
STEP 3: Create the transaction header2 cold table
*/
CREATE TABLE `aggregator`.`transaction_header2_cold` (
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
 PARTITION pCreditCards VALUES IN (15) ENGINE = InnoDB) */;



/*
STEP 4: Create the transaction header cold properties table
*/ 
CREATE TABLE `aggregator`.`transaction_header2_properties_cold` (
  `transactionId` int(11) unsigned NOT NULL,
  `transactionIpAddress` varchar(46) NOT NULL,
  `transactionSessionId` varchar(64) NOT NULL,
  PRIMARY KEY (`transactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AVG_ROW_LENGTH=88;

/*
STEP 5: Create the transaction details cold table
*/
CREATE TABLE `aggregator`.`transaction_details2_cold` (
  `transactionId` int(11) unsigned NOT NULL COMMENT 'FK to transactionId in header.',
  `verticalId` tinyint(3) unsigned NOT NULL COMMENT 'FK to vertical ID in vertical master, partitioned column.',
  `fieldId` smallint(5) unsigned NOT NULL COMMENT 'FK: to transaction fields, contains the numerical reference to the full xpath, field name.',
  `touchId` int(11) unsigned NOT NULL COMMENT 'FK: to the touches table, can be used to get the last touch and exact time.',
  `textValue` varchar(1020) NOT NULL COMMENT 'Full text representation of the form data. Has a smaller 256 index to cater for the email address.',
  PRIMARY KEY (`transactionId`,`verticalId`,`fieldId`),
  KEY `transaction_details_idx_fieldId` (`fieldId`),
  KEY `transaction_details_idx_textValue` (`textValue`(256))
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The storage table for transaction details that are no longer hot.'
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
 PARTITION pCarLMI VALUES IN (10) ENGINE = InnoDB,
 PARTITION pHomeLMI VALUES IN (11) ENGINE = InnoDB,
 PARTITION pCompetition VALUES IN (12) ENGINE = InnoDB,
 PARTITION pHomeloan VALUES IN (13) ENGINE = InnoDB,
 PARTITION pSimples VALUES IN (14) ENGINE = InnoDB,
 PARTITION pCreditCards VALUES IN (15) ENGINE = InnoDB) */;


/*
STEP 6: Create the transaction emails table
*/
CREATE TABLE `aggregator`.`transaction_emails` (
  `transactionId` INT(11) NOT NULL COMMENT 'FK to the transaction header table, however this can be \'split\' after archiving.',
  `emailId` INT(11) UNSIGNED NOT NULL COMMENT 'FK to the email master table.',
  `dataId` INT(11) UNSIGNED NULL DEFAULT 0 COMMENT 'FK to the data registry. Currently this will be a placeholder.',
  PRIMARY KEY (`transactionId`, `emailId`))
COMMENT = 'This may be a temporary table solution. The initial use is for a place to store the emaiAddress column that is in  transaction header, when archiving. this will help the retrieve quote process. However this does not look appealing as a long term solution.';


/*
STEP 7: add the sp transactions to warm cold
SEE RELATED FILE
*/

-- NOTE: ensure in Production that the first 'wave' is not 68 days but greater than 12 months

/*
STEP 8: add the loop sp transactions to warm cold
SEE RELEATED FILE
*/

-- NOTE: ensure in Production that the first 'wave' is not 68 days but greater than 12 months

/*
STEP 9: Run the loop at the correct time, e.g. early morning - late/night
*/
-- OPTIONAL and should be run after-hours only
CALL `aggregator`.`sp_loop_transactions_to_warm_cold`();

-- Testing after the loop has been finished
SELECT 'emails' AS title, COUNT(*) AS total FROM aggregator.transaction_emails
UNION ALL
SELECT 'headers_stored_away' AS title, COUNT(*) AS total FROM aggregator.transaction_header2_cold
UNION ALL
SELECT 'headers_remain' AS title, COUNT(*) AS total FROM aggregator.transaction_header
UNION ALL
SELECT 'details_stored_away' AS title, COUNT(*) AS total FROM aggregator.transaction_details2_cold
UNION ALL
SELECT 'details_remain' AS title, COUNT(*) AS total FROM aggregator.transaction_details
UNION ALL
SELECT 'current time' AS title, NOW() AS total;

/*
STEP 9b: clean-ups of old transactionIDs
*/

	-- TESTING THE DATA BEFORE PURGING
	SELECT xpath, textValue, count(transactionId) AS total, min(transactionId) AS firstSeen, max(transactionId) AS lastSeen
	,th.transactionId AS hotId, th2c.transactionId AS coldId
	FROM (SELECT * FROM aggregator.transaction_details
		WHERE  transactionID < (SELECT max(transactionId) FROM aggregator.transaction_header2_cold)
		-- AND xpath NOT IN (SELECT fieldCode FROM aggregator.transaction_fields)
		AND textValue != ''
		-- LIMIT 15000
		) AS r
	LEFT JOIN aggregator.transaction_header th USING(transactionId)
	LEFT JOIN aggregator.transaction_header2_cold th2c USING(transactionId)
		WHERE xpath NOT IN (SELECT fieldCode FROM aggregator.transaction_fields)
		GROUP BY xpath
		ORDER BY total DESC
		LIMIT 5000;	
		
		-- POSSIBLE FURTHER CLEAN-UPS
		SELECT * FROM aggregator.transaction_details
		-- DELETE FROM aggregator.transaction_details
		WHERE transactionId IN(
			SELECT transactionId FROM aggregator.transaction_header2_properties_cold
			WHERE transactionId NOT IN (SELECT transactionId FROM aggregator.transaction_header2_cold)
		);

		SELECT transactionId FROM aggregator.transaction_header2_properties_cold
		-- DELETE FROM aggregator.transaction_header2_properties_cold
		WHERE transactionId NOT IN (SELECT transactionId FROM aggregator.transaction_header2_cold);		

	-- NO TEXT VALUE in the left over batch.
	SELECT * FROM aggregator.transaction_details
	-- DELETE FROM aggregator.transaction_details
	WHERE transactionID < (SELECT max(transactionId) FROM aggregator.transaction_header2_cold)
	AND textValue = '';

	-- NO Field Value - check that we aren't losing important data - Note: there should be a report run on this after each day to ensure fields are correctly added.
	SELECT * FROM aggregator.transaction_details
	-- DELETE FROM aggregator.transaction_details
	WHERE transactionID < (SELECT max(transactionId) FROM aggregator.transaction_header2_cold)
	AND xpath NOT IN (SELECT `fieldCode` FROM `aggregator`.`transaction_fields`);
	
	-- No reference header in the table - though seems odd that these exist.
	-- NOTE: ensure the select is working properly as this may 'kill' everything.
	SELECT * FROM aggregator.transaction_details
	-- DELETE FROM aggregator.transaction_details
	WHERE transactionID < (SELECT max(transactionId) FROM aggregator.transaction_header2_cold)
	AND transactionID NOT IN (SELECT transactionID FROM aggregator.transaction_header2_cold);

/*
STEP 9: add the loop to the nightly events
*/

-- Made optional

/*
STEP 10: OTHER JOB LINKED BUT NOTING HERE: Convert retrieve quotes.
*/
