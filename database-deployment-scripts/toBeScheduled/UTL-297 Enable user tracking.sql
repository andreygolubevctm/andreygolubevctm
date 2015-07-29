-- Test
SELECT *
FROM ctm.content_control
WHERE contentKey = "userTrackingEnabled"
AND verticalId = 5
AND styleCodeId = 1;

-- Run
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '5', 'User Tracking', 'userTrackingEnabled', '2015-07-27 00:00:00', '2015-09-15 00:00:00', 'Y');