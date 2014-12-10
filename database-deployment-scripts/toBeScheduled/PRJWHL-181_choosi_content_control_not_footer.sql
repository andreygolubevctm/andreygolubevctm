-- Generic
-- minimumSupportedBrowsers should be default across everything.
DELETE FROM `ctm`.`content_control` WHERE `contentKey` = 'minimumSupportedBrowsers';
INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,0,'Browsers','minimumSupportedBrowsers','','2014-01-01 00:00:00','2038-01-19 00:00:00','{\"FIREFOX\": 4,\"SAFARI\": 5,\"IE\": 8,\"CHROME\": 4,\"OPERA\": 12}');
INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (8,0,'Global','brandDisplayName','','2014-01-01 00:00:00','2038-01-19 00:00:00','Choosi');

-- Rollback
/*
DELETE FROM `ctm`.`content_control` WHERE `styleCodeId` = 0 AND `verticalId` = 0 AND `contentCode` = 'Browsers' AND `contentKey` = 'minimumSupportedBrowsers';
DELETE FROM `ctm`.`content_control` WHERE `styleCodeId` = 8 AND `verticalId` = 0 AND `contentCode` = 'Global' AND `contentKey` = 'brandDisplayName';

INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (10080,1,0,'Browsers','minimumSupportedBrowsers','','2014-08-01 00:00:00','2038-01-01 00:00:00','{\"FIREFOX\": 4,\"SAFARI\": 5,\"IE\": 8,\"CHROME\": 4,\"OPERA\": 12}');
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (10284,1,13,'Browsers','minimumSupportedBrowsers','','2014-08-01 00:00:00','2038-01-01 00:00:00','{\"FIREFOX\": 4,\"SAFARI\": 5,\"IE\": 9,\"CHROME\": 4,\"OPERA\": 12}');
*/