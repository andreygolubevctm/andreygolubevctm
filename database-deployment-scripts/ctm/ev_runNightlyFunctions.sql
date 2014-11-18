/* *******************************
CREATE: The CtM application daily activities, runNightlyFunctions
******************************** */

USE `ctm`;
DROP event IF EXISTS `ctm`.`runNightlyFunctions`;

DELIMITER $$

CREATE
	DEFINER='server'@'%'
EVENT `ctm`.`runNightlyFunctions`
	ON SCHEDULE EVERY '1' DAY
	STARTS '2014-11-11 01:00:00'
	COMMENT 'This is the daily housekeeing that should be run by the CtM application.'
	DO
		BEGIN
		CALL `ctm`.`loopProcessFromStampingToMarketingOptIn`();
		CALL `ctm`.`populateMarketingSegments`();
END $$

DELIMITER ;

ALTER EVENT `ctm`.`runNightlyFunctions`
	ENABLE
;