USE `simples`;
DROP procedure IF EXISTS `message_handle_duplicates`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `message_handle_duplicates`(
	IN _activeMessageId INT UNSIGNED,
	IN _activeMessageTranId INT UNSIGNED,
	IN _activeMessageStatusId INT,
	IN _tranId INT UNSIGNED,
	IN _whenToAction DATETIME,
	IN _contactName VARCHAR(255),
	IN _phoneNumber1 VARCHAR(15),
	IN _phoneNumber2 VARCHAR(15),
	IN _state VARCHAR(3)
)
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------
	
	DECLARE _maxDupeTranId INT;

	--
	-- If unassigned (new message/lead), bump up to the top of the queue
	--
	IF _activeMessageStatusId = 1 THEN
		UPDATE message
		SET created = NOW(), whenToAction = _whenToAction
		WHERE id = _activeMessageId;
	END IF;

	-- Get MAX duplicate transactionId for the active message
	SELECT MAX(transactionId)
	INTO _maxDupeTranId
	FROM message_duplicates
	WHERE messageId = _activeMessageId;

	--
	-- Update message to latest transaction: contactName, phone number alternatives and State
	--
	IF _tranId > _activeMessageTranId AND (_maxDupeTranId IS NULL OR _tranId > _maxDupeTranId ) THEN
		UPDATE message
		SET contactName = _contactName, 
			phoneNumber1 = _phoneNumber1,
			phoneNumber2 = _phoneNumber2,
			state = _state
		WHERE id = _activeMessageId;
	END IF;

	--
	-- Add transationId as duplicates against exsiting messageId
	--
	INSERT INTO message_duplicates
	(messageId, transactionId)
	VALUES
	(_activeMessageId, _tranId);

END$$

DELIMITER ;