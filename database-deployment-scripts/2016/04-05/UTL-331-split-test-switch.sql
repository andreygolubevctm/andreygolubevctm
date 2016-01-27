-- SELECT count(*) AS total FROM `ctm`.`content_control` WHERE `contentCode` = 'SplitTest' AND contentKey='utilitiesRedesign';
-- RESULT BEFORE: 0
-- RESULT BEFORE: 1

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '5', 'SplitTest', 'utilitiesRedesign', '2016-01-01 00:00:00', '2040-12-31 00:00:00', 'Y');

-- ========================= ROLLBACK
-- SELECT `contentControlId` FROM `ctm`.`content_control` WHERE contentCode='SplitTest' AND contentKey = 'utilitiesRedesign';
-- RESULT BEFORE: 1
-- RESULT BEFORE: 0

-- DELETE FROM `ctm`.`content_control` WHERE contentCode='SplitTest' AND contentKey = 'utilitiesRedesign' LIMIT 1;