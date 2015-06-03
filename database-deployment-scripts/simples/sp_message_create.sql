USE `simples`;
DROP procedure IF EXISTS `message_create`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `message_create`(
	IN _tranId INT UNSIGNED,
	IN _sourceId INT,
	IN _contactName VARCHAR(255),
	IN _phoneNumber1 VARCHAR(15),
	IN _phoneNumber2 VARCHAR(15),
	IN _state VARCHAR(3),
	OUT _inserted INT
)
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------

	DECLARE _whenToAction DATETIME;
	DECLARE _messageDelay INT;
	DECLARE _tranIdExists INT;
	DECLARE _doNotContact INT;
	DECLARE _activeMessageId INT;
	DECLARE _activeMessageStatusId INT;
	DECLARE _activeMessageTranId  INT;
	DECLARE _dupeTranIdExists INT;
	DECLARE _hawkingOptin CHAR(1);

	--
	-- Calculate when this message should be actioned
	--
	SET _whenToAction = NOW();
	SELECT messageDelay INTO _messageDelay FROM simples.message_source WHERE id = _sourceId;
	-- Convert delay from minutes and add to current time
	SET _whenToAction = ADDTIME(NOW(), SEC_TO_TIME(_messageDelay*60));

	--
	-- Check conditions to avoid duplicates or unwanted messages
	--
	SELECT COUNT(transactionId)
	INTO _tranIdExists
	FROM simples.message msg
	WHERE transactionId = _tranId;

	-- Blacklist, Do not contact
	SELECT COUNT(mb.marketingBlacklistId) AS `count` 
	INTO _doNotContact
	FROM ctm.marketing_blacklist mb 
	INNER JOIN aggregator.transaction_header th ON th.styleCodeId = mb.styleCodeId
	WHERE th.TransactionId = _tranId
	AND mb.channel = 'phone'
	AND mb.`value` IN (_phoneNumber1, _phoneNumber2);
	
	-- This is a bit rubbish, but ignore the blacklist for the failed joins.
	IF _sourceId = 5 THEN
		SET _doNotContact = 0;
	END IF;

	--
	-- check if lead exsits with same phone number
	--
	SELECT id, transactionId, statusId
	INTO _activeMessageId, _activeMessageTranId, _activeMessageStatusId
	FROM simples.message
	WHERE
		( phoneNumber1 = _phoneNumber1 AND phoneNumber1 IS NOT NULL )
	OR
		( phoneNumber2 = _phoneNumber2 AND phoneNumber2 IS NOT NULL )
	ORDER BY id DESC
	LIMIT 1;

	--
	-- Check duplicates againest message_duplicates table
	--
	SELECT COUNT(transactionId)
	INTO _dupeTranIdExists
	FROM simples.message_duplicates
	WHERE transactionId = _tranId;

	--
	-- Add message to the queue
	--
	IF _tranIdExists = 0 AND _doNotContact = 0 AND _dupeTranIdExists = 0 THEN
		--
		-- EVERY MESSAGE IS HAWKING NOW 
		-- TODO: remove when tested in PROD
		--
		SET _hawkingOptin = 'Y';
		
		IF _activeMessageId IS NULL OR _activeMessageStatusId = 2 /* Completed */ OR _activeMessageStatusId = 33 /* Removed from PM */ THEN
			INSERT INTO message
			(transactionId, sourceId, statusId, created, whenToAction, contactName, phoneNumber1, phoneNumber2, state, hawkingOptin)
			VALUES
			(_tranId, _sourceId, 1/*New*/, NOW(), _whenToAction, _contactName, _phoneNumber1, _phoneNumber2, _state, _hawkingOptin);

			SET _inserted = 1;
		ELSE
			CALL simples.message_handle_duplicates (_activeMessageId, _activeMessageTranId, _activeMessageStatusId, _tranId, _whenToAction, _contactName, _phoneNumber1, _phoneNumber2, _state, _hawkingOptin);
			SET _inserted = 0;
		END IF;
	ELSE
		SET _inserted = 0;
	END IF;


END$$

DELIMITER ;