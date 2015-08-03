-- Test 3 after, 0 before
SELECT *
FROM ctm.content_control
WHERE contentKey LIKE "userTracking%"
AND verticalId = 3
AND effectiveEnd > CURDATE()
AND styleCodeId = 1;

-- Run
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '3', 'User Tracking', 'userTrackingEnabled', '2015-07-30 00:00:00', '2015-09-30 00:00:00', 'Y');
INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES ('1','3','User Tracking','userTrackingBrowserRules','','2015-07-30 00:00:00','2038-01-01 00:00:00','{\"FIREFOX\": 33,\"SAFARI\": 8,\"IE\": 11,\"CHROME\": 37}');
INSERT INTO `ctm`.`content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES ('1','3','User Tracking','userTrackingDeviceRules','','2015-07-30 00:00:00','2038-01-01 00:00:00','{\"COMPUTER\": true,\"TABLET\": true,\"MOBILE\": false}');