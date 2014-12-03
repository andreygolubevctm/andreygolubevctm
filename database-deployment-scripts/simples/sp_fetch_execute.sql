USE `simples`;
DROP procedure IF EXISTS `fetch_execute`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `fetch_execute`()
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------

	DECLARE bDone INT;
	DECLARE count INT;
	DECLARE insertedCount INT;

	DECLARE _tranId INT UNSIGNED;
	DECLARE _sourceId INT;
	DECLARE _sourceName VARCHAR(45);
	DECLARE _phoneNumber1 VARCHAR(15);
	DECLARE _phoneNumber2 VARCHAR(15);
	DECLARE _contactName VARCHAR(255);
	DECLARE _state VARCHAR(3);

	DECLARE SourcesCursor CURSOR FOR
		SELECT id, `name` FROM simples.message_source
		WHERE active = 1
		ORDER BY priority ASC;

	DECLARE TransactionsCursor CURSOR FOR
	SELECT MAX(transactionId) AS transactionId, sourceId, phoneNumber1, phoneNumber2, contactName, state
	FROM (
		-- Put any filtering rules here
		SELECT
			transactionId,
			sourceId,
			CASE
				WHEN
					phoneNumber1 NOT LIKE '%345678%'
					AND phoneNumber1 NOT LIKE '%00000%'
					AND phoneNumber1 NOT LIKE '%11111%'
					AND phoneNumber1 NOT LIKE '%22222%'
					AND phoneNumber1 NOT LIKE '%33333%'
					AND phoneNumber1 NOT LIKE '%44444%'
					AND phoneNumber1 NOT LIKE '%55555%'
					AND phoneNumber1 NOT LIKE '%66666%'
					AND phoneNumber1 NOT LIKE '%77777%'
					AND phoneNumber1 NOT LIKE '%88888%'
					AND phoneNumber1 NOT LIKE '%99999%'
					THEN phoneNumber1
				ELSE NULL
			END AS phoneNumber1,
			CASE
				WHEN
					phoneNumber2 NOT LIKE '%345678%'
					AND phoneNumber2 NOT LIKE '%00000%'
					AND phoneNumber2 NOT LIKE '%11111%'
					AND phoneNumber2 NOT LIKE '%22222%'
					AND phoneNumber2 NOT LIKE '%33333%'
					AND phoneNumber2 NOT LIKE '%44444%'
					AND phoneNumber2 NOT LIKE '%55555%'
					AND phoneNumber2 NOT LIKE '%66666%'
					AND phoneNumber2 NOT LIKE '%77777%'
					AND phoneNumber2 NOT LIKE '%88888%'
					AND phoneNumber2 NOT LIKE '%99999%'
					THEN phoneNumber2
				ELSE NULL
			END AS phoneNumber2,
			contactName,
			state
		FROM `temp_simples_fetches`
		WHERE
			state IS NOT NULL AND state != ''

			AND contactName != 'Guybrush'
			AND contactName NOT LIKE 'Test%'
			AND contactName NOT LIKE '% test%'
	)
	AS `filtered`
	WHERE phoneNumber1 IS NOT NULL OR phoneNumber2 IS NOT NULL

	-- Grouping will de-duplicate same details that are on different root IDs
	GROUP BY sourceId, phoneNumber1, phoneNumber2, contactName, state
	;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

-- -----------------------------
-- Populate a temp table using any active sources.
-- -----------------------------

	OPEN SourcesCursor;
	SET bDone = 0;
	REPEAT
		-- Fetch the row's columns into variables
		FETCH SourcesCursor INTO _sourceId, _sourceName;

		IF bDone = 0 THEN
			-- Execute the source's stored procedure
			SET @sql := concat('CALL simples.', _sourceName, '(', _sourceId, ');');
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		END IF;
	UNTIL bDone
	END REPEAT;
	CLOSE SourcesCursor;

-- -----------------------------
-- Iterate the temp table and create messages.
-- -----------------------------

	OPEN TransactionsCursor;
	SET bDone = 0;
	SET count = 0;
	SET insertedCount = 0;

	REPEAT
		-- Fetch the row's columns into variables
		FETCH TransactionsCursor INTO _tranId, _sourceId, _phoneNumber1, _phoneNumber2, _contactName, _state;

		IF bDone = 0 THEN
			-- Create a new message
			CALL simples.message_create (_tranId, _sourceId, _contactName, _phoneNumber1, _phoneNumber2, _state, @inserted);

			SET count = count + 1;
			SET insertedCount = insertedCount + @inserted;
		END IF;
	UNTIL bDone
	END REPEAT;

	CLOSE TransactionsCursor;

	-- Don't drop because the temp table will be cleaned up once the session/connection has ended and avoid any concurrency issues.
	-- DROP TABLE `temp_simples_fetches`;

	-- Return some stats
	SELECT count AS `count`, insertedCount AS `insertedCount`;

END$$

DELIMITER ;