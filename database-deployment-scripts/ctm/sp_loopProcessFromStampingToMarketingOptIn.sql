/* ****************************
POPULATE: MARKETING OPT-IN (STORED PROCEDURE LOOPED TILL NO MORE EXIST)
**************************** */
USE `ctm`;
DROP procedure IF EXISTS `loopProcessFromStampingToMarketingOptIn`;

DELIMITER $$
USE `ctm`$$
CREATE DEFINER=`server`@`%` PROCEDURE `ctm`.`loopProcessFromStampingToMarketingOptIn` ()
BEGIN

DECLARE $counter INT DEFAULT 1;

-- Work out the maximum times it should repeat as a safeguard for an ever-running loop
SELECT CEIL(count(*) / 1000) INTO @repetitions
FROM ctm.stamping
WHERE archive = 0;


WHILE @repetitions >= $counter DO

	CALL `ctm`.`processFromStampingToMarketingOptIn`();
	SET $counter = $counter + 1;

END WHILE;


END$$

DELIMITER ;
