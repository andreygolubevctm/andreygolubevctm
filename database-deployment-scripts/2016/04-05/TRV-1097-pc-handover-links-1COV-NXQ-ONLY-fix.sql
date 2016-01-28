SET @CCID = (SELECT contentControlId FROM `ctm`.`content_control` WHERE `contentKey` = 'handoverTrackingURL' AND `verticalId` = 2);
-- SELECT count(*) FROM `ctm`.`content_supplementary` WHERE `contentControlId` = @CCID AND `supplementaryKey` = '1COVPostImp';
-- TEST RESULT BEFORE: 1
-- TEST RESULT AFTER: 0

UPDATE `ctm`.`content_supplementary` SET `supplementaryKey` = '1COV' WHERE `supplementaryKey` = '1COVPostImp' AND `contentControlId` = @CCID LIMIT 1;