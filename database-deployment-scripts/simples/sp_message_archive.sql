USE `simples`;
DROP procedure IF EXISTS `message_archive`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `message_archive`()
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------

	DECLARE aDone INT;
	DECLARE bDone INT;
	DECLARE totalArchiveCount INT;
	DECLARE totalFailedJoinsCount INT;
	DECLARE totalFailedJoinsCreatedCount INT;
	DECLARE totalFailedJoinsUpdatedCount INT;
	DECLARE totalUnassginedCount INT;

	DECLARE _failedJoinExists BOOLEAN;
	DECLARE _isInvalidFailedJoin BOOLEAN;
	DECLARE _canArchive BOOLEAN;
	DECLARE _messageId INT UNSIGNED;
	DECLARE _tranId INT UNSIGNED;
	DECLARE _sourceId INT;
	DECLARE _userId INT;
	DECLARE _statusId INT;
	DECLARE _created DATETIME;
	DECLARE _phoneNumber1 VARCHAR(15);
	DECLARE _phoneNumber2 VARCHAR(15);

	DECLARE MessageCursor CURSOR FOR
			SELECT id, transactionId, sourceId, userId, statusId, created, phoneNumber1, phoneNumber2
			FROM simples.message
			ORDER BY id ASC;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET aDone = 1;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		CALL logging.doLog('sp_message_archive: exception occurred', 'MK-20004');
		CALL logging.saveLog();
		SELECT 'An error has occurred in: sp_message_archive, operation rollbacked and the stored procedure was terminated' AS errorMessage;
		RESIGNAL;
	END;

	OPEN MessageCursor;

		SET aDone = 0;
		SET totalArchiveCount = 0;
		SET totalFailedJoinsCount = 0;
		SET totalFailedJoinsCreatedCount = 0;
		SET totalFailedJoinsUpdatedCount = 0;
		SET totalUnassginedCount = 0;

		check_message: LOOP
			-- Fetch the row's columns into variables
			FETCH MessageCursor INTO _messageId, _tranId, _sourceId, _userId, _statusId, _created, _phoneNumber1, _phoneNumber2;

			IF aDone = 1 THEN 
				LEAVE check_message;
			END IF;

			SET _failedJoinExists = FALSE;
			SET _isInvalidFailedJoin = FALSE;
			SET _canArchive = FALSE;

			BEGIN

				DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

				/* Check failed joins and get latest phone details for original rootId == */
				SELECT TRUE, phoneNumber1, phoneNumber2
				INTO _failedJoinExists, _phoneNumber1, _phoneNumber2
				FROM (
					SELECT 
						MAX(th.TransactionId) AS transactionId, 
						MAX(detailsPhoneMobile.textValue) AS phoneNumber1, 
						MAX(detailsPhoneOther.textValue) AS phoneNumber2,
						COUNT(touchInclude.id) AS touchIncludeCount,
						COUNT(touchExclude.id) AS touchEncludeCount
					FROM aggregator.transaction_header AS th
					LEFT JOIN ctm.touches AS touchInclude 
						ON touchInclude.transaction_id = th.TransactionId
						AND touchInclude.type IN ('F')
						AND touchInclude.operator_id = 'ONLINE'
					LEFT JOIN ctm.touches AS touchExclude 
						ON touchExclude.transaction_id = th.TransactionId
						AND touchExclude.type IN ('C')
					LEFT JOIN aggregator.transaction_details detailsPhoneMobile
						ON th.transactionId = detailsPhoneMobile.transactionid
						AND detailsPhoneMobile.xpath = 'health/application/mobile'
					LEFT JOIN aggregator.transaction_details detailsPhoneOther
						ON th.transactionId = detailsPhoneOther.transactionid
						AND detailsPhoneOther.xpath = 'health/application/other'
					WHERE th.rootId = _tranId
					UNION ALL
					SELECT 
						MAX(th.TransactionId) AS transactionId, 
						MAX(detailsPhoneMobile.textValue) AS phoneNumber1, 
						MAX(detailsPhoneOther.textValue) AS phoneNumber2,
						COUNT(touchInclude.id) AS touchIncludeCount,
						COUNT(touchExclude.id) AS touchEncludeCount
					FROM aggregator.transaction_header2_cold AS th
					LEFT JOIN ctm.touches AS touchInclude 
						ON touchInclude.transaction_id = th.TransactionId
						AND touchInclude.type IN ('F')
						AND touchInclude.operator_id = 'ONLINE'
					LEFT JOIN ctm.touches AS touchExclude 
						ON touchExclude.transaction_id = th.TransactionId
						AND touchExclude.type IN ('C')
					LEFT JOIN aggregator.transaction_details2_cold detailsPhoneMobile
						ON th.transactionId = detailsPhoneMobile.transactionid
						AND detailsPhoneMobile.fieldId = 249
					LEFT JOIN aggregator.transaction_details2_cold detailsPhoneOther
						ON th.transactionId = detailsPhoneOther.transactionid
						AND detailsPhoneOther.fieldId = 252
					WHERE th.rootId = _tranId
				) AS t
				HAVING SUM(touchIncludeCount) > 0 AND SUM(touchEncludeCount) = 0
				ORDER BY transactionId DESC
				LIMIT 1;

				/*  Check failed joins and get latest phone details for duplicated rootId == */
				IF NOT _failedJoinExists THEN
					SELECT TRUE, phoneNumber1, phoneNumber2
					INTO _failedJoinExists, _phoneNumber1, _phoneNumber2
					FROM (
						SELECT 
						MAX(th.TransactionId) AS transactionId, 
						MAX(detailsPhoneMobile.textValue) AS phoneNumber1, 
						MAX(detailsPhoneOther.textValue) AS phoneNumber2,
						COUNT(touchInclude.id) AS touchIncludeCount,
						COUNT(touchExclude.id) AS touchEncludeCount
						FROM aggregator.transaction_header AS th
						LEFT JOIN ctm.touches AS touchInclude 
							ON touchInclude.transaction_id = th.TransactionId
							AND touchInclude.type IN ('F')
							AND touchInclude.operator_id = 'ONLINE'
						LEFT JOIN ctm.touches AS touchExclude 
							ON touchExclude.transaction_id = th.TransactionId
							AND touchExclude.type IN ('C')
						LEFT JOIN aggregator.transaction_details detailsPhoneMobile
							ON th.transactionId = detailsPhoneMobile.transactionid
							AND detailsPhoneMobile.xpath = 'health/application/mobile'
						LEFT JOIN aggregator.transaction_details detailsPhoneOther
							ON th.transactionId = detailsPhoneOther.transactionid
							AND detailsPhoneOther.xpath = 'health/application/other'
						WHERE th.rootId IN (
							SELECT transactionId
							FROM simples.message_duplicates
							WHERE messageId = _messageId
						)
						UNION ALL
						SELECT 
						MAX(th.TransactionId) AS transactionId, 
						MAX(detailsPhoneMobile.textValue) AS phoneNumber1, 
						MAX(detailsPhoneOther.textValue) AS phoneNumber2,
						COUNT(touchInclude.id) AS touchIncludeCount,
						COUNT(touchExclude.id) AS touchEncludeCount
						FROM aggregator.transaction_header2_cold AS th
						LEFT JOIN ctm.touches AS touchInclude 
							ON touchInclude.transaction_id = th.TransactionId
							AND touchInclude.type IN ('F')
							AND touchInclude.operator_id = 'ONLINE'
						LEFT JOIN ctm.touches AS touchExclude 
							ON touchExclude.transaction_id = th.TransactionId
							AND touchExclude.type IN ('C')
						LEFT JOIN aggregator.transaction_details2_cold detailsPhoneMobile
							ON th.transactionId = detailsPhoneMobile.transactionid
							AND detailsPhoneMobile.fieldId = 249
						LEFT JOIN aggregator.transaction_details2_cold detailsPhoneOther
							ON th.transactionId = detailsPhoneOther.transactionid
							AND detailsPhoneOther.fieldId = 252
						WHERE th.rootId IN (
							SELECT transactionId
							FROM simples.message_duplicates
							WHERE messageId = _messageId
						)
					) AS t
					HAVING SUM(touchIncludeCount) > 0 AND SUM(touchEncludeCount) = 0
					ORDER BY transactionId DESC
					LIMIT 1;
					
				END IF;

			END;

			/* If found failed join and not a YHOO failed join (sourceId = 8), set sourceId to 5  */
			IF _failedJoinExists AND _sourceId <> 8 THEN
				SET _sourceId = 5;
			END IF;

			/* If message is Completed(2), Abandoned(7), removedFromPM(33), then archive*/
			IF _statusId IN (2, 7, 33) THEN
				SET _canArchive = TRUE;
				SET _statusId = 1;
				SET _userId = 0;
			END IF;

			START TRANSACTION;

				IF _canArchive THEN

					SET totalArchiveCount = totalArchiveCount + 1;

					INSERT INTO simples.message_archived 
					SELECT * FROM simples.message
					WHERE id = _messageId;

					DELETE FROM simples.message
					WHERE id = _messageId;

					IF _failedJoinExists THEN

						SET totalFailedJoinsCount = totalFailedJoinsCount + 1;

						SELECT IF(COUNT(id) > 0, TRUE, FALSE)
						INTO _isInvalidFailedJoin
						FROM simples.message_audit
						WHERE messageId = _messageId
						AND reasonStatusId = 34; /* invalid failed join sub status */

						IF NOT _isInvalidFailedJoin THEN
							SET totalFailedJoinsCreatedCount = totalFailedJoinsCreatedCount + 1;

							INSERT INTO simples.message
							(transactionId, sourceId, userId, statusId, created, whenToAction, contactName, phoneNumber1, phoneNumber2, state)
							SELECT _tranId, _sourceId, _userId, _statusId, NOW(), NOW(), contactName, _phoneNumber1, _phoneNumber2, state
							FROM simples.message_archived
							WHERE id = _messageId;
						ELSE
							DELETE FROM simples.message_duplicates
							WHERE messageId = _messageId;
						END IF;

					ELSE

						DELETE FROM simples.message_duplicates
						WHERE messageId = _messageId;

					END IF;

				ELSEIF _failedJoinExists THEN

					SET totalFailedJoinsCount = totalFailedJoinsCount + 1;
					SET totalFailedJoinsUpdatedCount = totalFailedJoinsUpdatedCount + 1;

					UPDATE simples.message
					SET sourceId = _sourceId, phoneNumber1 = _phoneNumber1, phoneNumber2 = _phoneNumber2
					WHERE id = _messageId;

				END IF;

			COMMIT;

		END LOOP check_message;

	CLOSE MessageCursor;

	/* UNASSIGN MESSAGES THAT HAVE BEEN RESERVED OVERNIGHT */
	UPDATE simples.message
	SET userId = 0
	WHERE userId > 0
	AND statusId IN (1, 3, 4, 5, 6);

	SET totalUnassginedCount = ROW_COUNT();

	-- Create the statistics
	CALL logging.doLog(CONCAT('sp_message_archive: ', totalArchiveCount, ' messages archived ::: ', totalFailedJoinsCount,' failed joins found ::: ', totalFailedJoinsCreatedCount,' messages created for failed joins ::: ', totalFailedJoinsUpdatedCount,' messages updated for failed joins ::: ', totalUnassginedCount,' messages unassigned.'), 'MK-20002');
	CALL logging.saveLog();

END$$

DELIMITER ;