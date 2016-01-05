-- UPDATER
UPDATE `ctm`.`configuration` SET `styleCodeId`='1' WHERE `configCode`='journeyOverride' and`styleCodeId`='0' and`verticalId`='4' and`environmentCode`='0';
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('journeyOverride', '0', '0', '4', 'N');

/* CHECKER
	* Before there should be 1 entry - where default is Y for all brands
	* After there should be 2 - where brand default is zero and only Y for CTM
*/
SELECT * FROM ctm.configuration WHERE configCode='journeyOverride';

/* ROLLBACK
DELETE FROM `ctm`.`configuration` WHERE `configCode`='journeyOverride' and`styleCodeId`='1' and`verticalId`='4' and`environmentCode`='0' and configValue='Y';
UPDATE `ctm`.`configuration` SET `configValue`='Y' WHERE `configCode`='journeyOverride' and`styleCodeId`='0' and`verticalId`='4' and`environmentCode`='0';
*/