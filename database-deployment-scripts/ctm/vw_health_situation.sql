/* ****************************
VIEW: vw_health_situation
**************************** */
-- Used in reporting and data extracts

DROP VIEW IF EXISTS `test`.`heath_situation`;
DROP VIEW IF EXISTS `test`.`health_situation`;
DROP VIEW IF EXISTS `aggregator`.`health_situation`;
DROP VIEW IF EXISTS `aggregator`.`vw_health_situation`;


USE `aggregator`;
CREATE OR REPLACE ALGORITHM = UNDEFINED
	DEFINER = `server`@`%`
	SQL SECURITY DEFINER
VIEW `aggregator`.`vw_health_situation` AS
	SELECT
		`aggregator`.`general`.`code` AS `code`,
		`aggregator`.`general`.`description` AS `description`
	FROM
		`aggregator`.`general`
	WHERE
		((`aggregator`.`general`.`type` = 'healthSitu')
			AND (`aggregator`.`general`.`code` IN ('ATP' , 'CSF',
			'FK',
			'LBC',
			'LC',
			'M',
			'O',
			'YC',
			'YS')))
	ORDER BY `aggregator`.`general`.`orderSeq`;