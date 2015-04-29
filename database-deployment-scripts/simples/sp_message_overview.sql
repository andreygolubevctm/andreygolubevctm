USE `simples`;
DROP procedure IF EXISTS `message_overview`;

DELIMITER $$
USE `simples`$$
CREATE PROCEDURE `simples`.`message_overview` ()
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------

	SELECT COUNT(id) AS `current`
		, (SELECT COUNT(id) FROM simples.message_queue_available WHERE statusId = 1) AS `pending`
		, (SELECT COUNT(id) FROM simples.message WHERE statusId = 1 AND whenToAction > NOW()) AS `future`
		, (SELECT COUNT(id) FROM simples.message WHERE statusId = 4) AS `postponed`
		, (SELECT COUNT(id) FROM simples.message WHERE statusId = 2) AS `completed`
		, (
					 SELECT COUNT(msg.id) FROM simples.message msg
					 	 INNER JOIN simples.message_source src ON src.id = msg.sourceId
					 WHERE msg.statusId NOT IN (2, 7)
								 AND NOW() >=  DATE_ADD(msg.created,INTERVAL src.messageExpiry DAY)
				 ) AS `expired`
	FROM simples.message_queue_available;

END$$

DELIMITER ;