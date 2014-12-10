USE `simples`;
DROP procedure IF EXISTS `user_stats`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `simples`.`user_stats`(
	IN _userId INT,
	IN _date DATE
)
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------

-- SET _userId = 49;
-- SET _date = '2014-11-27';
IF _date IS NULL THEN SET _date = CURDATE(); END IF;
SET @completed = (SELECT COUNT(*) FROM simples.message_audit WHERE userId=_userId AND DATE(created)=_date AND statusId=2);
SET @postponed = (SELECT COUNT(*) FROM simples.message_audit WHERE userId=_userId AND DATE(created)=_date AND statusId=4);
SET @unsuccessful = (SELECT COUNT(*) FROM simples.message_audit WHERE userId=_userId AND DATE(created)=_date AND statusId=6);
SET @invalidLeads = (SELECT COUNT(*) FROM simples.message_audit WHERE userId=_userId AND DATE(created)=_date AND statusId=2 AND reasonStatusId IN (10,14,16,24,25));
SET @sales = (
	SELECT COUNT(*) FROM aggregator.transaction_header th
	INNER JOIN ctm.touches ON type='C' AND th.transactionId = touches.transaction_id AND date=_date
	WHERE StartDate=_date AND touches.operator_id=(SELECT ldapuid FROM simples.user WHERE id=_userId)
);
-- SET @sales = 4;
SET @conversion = (@sales / (@completed - @invalidLeads) * 100);

SELECT
	@completed AS `Completed`
	, @unsuccessful AS `Unsuccessful`
	, @postponed AS `Postponed`
	, ROUND((@completed - @invalidLeads) / (@completed - @invalidLeads + @postponed + @unsuccessful) * 100) AS `Contact`
	, @sales AS `Sales`
	, IFNULL(ROUND(@conversion,2), 0) AS `Conversion`
	, (SELECT COUNT(id) FROM simples.message_queue_available WHERE userId IN (0,_userId)) AS `Active`
	, (SELECT COUNT(id) FROM simples.message WHERE userId IN (0,_userId) AND whenToAction > NOW()) AS `Future`
;


END$$

DELIMITER ;
