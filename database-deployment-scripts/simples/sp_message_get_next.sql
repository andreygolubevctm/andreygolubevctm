USE `simples`;
DROP procedure IF EXISTS `message_get_next`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `message_get_next`(
	IN _userId INT
)
BEGIN
	-- Pick a message for the user's queue or the open queue
	-- Reserve it by changing the userId to avoid concurrency issues.
	UPDATE simples.message
	SET userId = _userId
	WHERE id = (
		SELECT id FROM simples.message_queue_ordered WHERE userId IN (0, _userId)
		ORDER BY _rule ASC, whenToAction ASC
		LIMIT 1
	);

	SELECT id, transactionId, userId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction
	FROM simples.message_queue_ordered
	WHERE
		userId = _userId
	ORDER BY _rule ASC, whenToAction ASC
	LIMIT 1;

END$$

DELIMITER ;