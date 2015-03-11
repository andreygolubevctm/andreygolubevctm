/* ****************************
VIEW: vw_health_cover
**************************** */
-- Used in reporting and data extracts

DROP VIEW IF EXISTS `test`.`health_cover`;
DROP VIEW IF EXISTS `aggregator`.`health_cover`;
DROP VIEW IF EXISTS `aggregator`.`vw_health_cover`;


USE `aggregator`;
CREATE OR REPLACE ALGORITHM = UNDEFINED
	DEFINER = `server`@`%`
	SQL SECURITY DEFINER
VIEW `aggregator`.`vw_health_cover` AS
	SELECT
		`aggregator`.`general`.`code` AS `code`,
		`aggregator`.`general`.`description` AS `description`
	FROM
		`aggregator`.`general`
	WHERE
		((`aggregator`.`general`.`type` = 'healthCvr')
			AND (`aggregator`.`general`.`code` IN ('C' , 'F', 'S', 'SPF')))
	ORDER BY `aggregator`.`general`.`orderSeq`;