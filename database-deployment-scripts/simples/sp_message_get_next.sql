USE `simples`;
DROP procedure IF EXISTS `message_get_next`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `message_get_next`(
	IN _userId INT
)
BEGIN

	SELECT id, transactionId, userId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone
	FROM simples.message_queue_ordered

	WHERE

		(userId = _userId OR userId = 0)

	LIMIT 1;

END$$

DELIMITER ;