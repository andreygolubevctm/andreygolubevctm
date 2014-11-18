/* ****************************
POPULATE: MARKETING OPT-IN (STORED PROCEDURE)
**************************** */
-- NOTE: you will need to be LOGGED IN AS THE CORRECT USER TYPE
-- Note this requires the stamping table with an archive feature

-- The below may work better as an INSERT VALUES type of table instead

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- Creates the latest OptIns based on the stamping table
-- --------------------------------------------------------------------------------
USE `ctm`;
DROP procedure IF EXISTS `processFromStampingToMarketingOptIn`;

DELIMITER $$
CREATE DEFINER=`server`@`%` PROCEDURE `ctm`.`processFromStampingToMarketingOptIn` ()
BEGIN

-- Declaring the variables for being used
DECLARE $done TINYINT DEFAULT 0;
DECLARE $FieldCategory TINYINT;
DECLARE $StyleCodeId TINYINT;
DECLARE $OptInTarget VARCHAR(256);
DECLARE $OptInStatus TINYINT;
DECLARE $StampId INT UNSIGNED;
DECLARE $Archive TINYINT;
DECLARE $counterOptIn SMALLINT DEFAULT 0;
DECLARE $counterStampArchive SMALLINT DEFAULT 0;

-- Create the Data
-- NOTE: Currently, we are only processing toggle marketing (as emails)
DECLARE $TcursorTable CURSOR FOR
SELECT
	CASE WHEN `action` = 'toggle_marketing' THEN 1 ELSE 0 END AS fieldCategory,
	styleCodeId,
	target as optInTarget,
	CASE WHEN `value` = 'on' or `value` = 'Yes' or `value` = 'y' or `value` = 'YY' or `value` = '[Y' THEN 1 ELSE 0 END AS optInStatus,
	stampId,
	(SELECT CASE WHEN fieldCategory = 0 THEN 2 ELSE 1 END ) AS archive
FROM ctm.stamping
WHERE archive = 0
LIMIT 1000;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET $done=1;

OPEN $TcursorTable;

read_loop: LOOP
 IF $done THEN
	LEAVE read_loop;
 END IF;
	FETCH $TcursorTable INTO $FieldCategory,$StyleCodeId,$OptInTarget,$OptInStatus,$StampId,$Archive;

	-- BUSINESS RULE: If an email category, than we really should have (some kind of) an email address
	IF $FieldCategory = 1 AND $OptInTarget LIKE '%@%' THEN
		-- UPDATE: the OptInList
		IF $FieldCategory IN(1,2,3) THEN
			INSERT INTO `ctm`.`marketingOptIn`
				(fieldCategory,styleCodeId,optInTarget,optInStatus,stampId)
				VALUES($FieldCategory,$StyleCodeId,$OptInTarget,$OptInStatus,$StampId)
			ON DUPLICATE KEY UPDATE `stampId`=VALUES(`stampId`), `optInStatus`=VALUES(`optInStatus`);

			SET $counterOptIn = $counterOptIn + 1;

		END IF;
	END IF;

	-- UPDATE: the stampID only when it's a 0
	UPDATE ctm.stamping
		SET archive = $Archive
		WHERE stampId = $StampId
		AND archive = 0;

		SET $counterStampArchive = $counterStampArchive + 1;

 END LOOP;

CLOSE $TcursorTable;

-- NOTE: TURN THIS ON AFTER THE MAIN BULK UPDATE
-- SELECT $counterOptIn AS OptinRowsAffected, $counterStampArchive AS stampArchiveRowsAffected;

END;
