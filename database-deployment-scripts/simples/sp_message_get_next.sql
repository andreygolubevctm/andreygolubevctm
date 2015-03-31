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

	/*
		Individual Order by in {simples.message_queue_ordered} only works with the use LIMIT. 
		Ref: http://dev.mysql.com/doc/refman/5.0/en/union.html
		so in this sp, secondary order by whenToAction only works with Rule 0 and 3 to make sure when it comes to assigned message, it is first in first out so that you have to deal you current message before moving to next one.

		**{simples.message_queue_ordered} will contain duplicates since we added _rule as a new coloumn but limit 1 and order by _rule should give us what we want
	*/
	UPDATE simples.message
	SET userId = _userId
	WHERE id = (
		SELECT id FROM simples.message_queue_ordered WHERE userId IN (0, _userId)
		ORDER BY _rule ASC, whenToAction ASC
		LIMIT 1
	);

	SELECT id, transactionId, userId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created
	FROM simples.message_queue_ordered
	WHERE
		userId = _userId
	ORDER BY _rule ASC, whenToAction ASC
	LIMIT 1;

END$$

DELIMITER ;