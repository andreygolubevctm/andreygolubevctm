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
	-- Add message to the queue
	--
	IF _tranIdExists = 0 AND _doNotContact = 0 THEN
		INSERT INTO message
		(transactionId, sourceId, statusId, created, whenToAction, contactName, phoneNumber1, phoneNumber2, state)
		VALUES
		(_tranId, _sourceId, 1/*New*/, NOW(), _whenToAction, _contactName, _phoneNumber1, _phoneNumber2, _state);

		SET _inserted = 1;
	ELSE
		SET _inserted = 0;
	END IF;


END$$

DELIMITER ;