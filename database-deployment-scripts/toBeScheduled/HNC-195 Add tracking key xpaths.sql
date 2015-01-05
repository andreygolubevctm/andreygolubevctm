/** Add tracking key xpaths **/
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `contentStatus`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '7', 'Tracking', 'trackingKeyXpaths', '', '2014-12-01 00:00:00', '2040-12-31 23:59:59', 'home/coverType,home/policyHolder/firstName,home/policyHolder/lastName,home/policyHolder/email,home/property/address/fullAddress');

/** TEST 
SELECT * FROM `ctm`.`content_control` WHERE `styleCodeId` = '0' AND `verticalId` = '7' AND `contentCode` = 'Tracking' AND `contentKey` = 'trackingKeyXpaths';
**/
/** ROLLBACK 
DELETE FROM `ctm`.`content_control` WHERE `styleCodeId` = '0' AND `verticalId` = '7' AND `contentCode` = 'Tracking' AND `contentKey` = 'trackingKeyXpaths';
**/