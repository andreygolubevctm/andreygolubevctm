-- SELECT count(*) AS total FROM `ctm`.`content_control` WHERE contentKey = 'snapshot';
-- RESULT BEFORE: 0
-- RESULT AFTER: 1

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`) VALUES ('0', '5', 'Snapshot', 'snapshot', '2016-01-01 00:00:00', '2040-12-31 23:59:59');
SET @CCID = (SELECT LAST_INSERT_ID());

-- SELECT count(*) AS total FROM `ctm`.`content_supplementary` WHERE contentControlId = @CCID;
-- RESULT BEFORE: 0
-- RESULT AFTER: 6

INSERT INTO `ctm`.`content_supplementary` (`contentControlId`, `supplementaryKey`, `supplementaryValue`) VALUES (@CCID, 'freeServiceTitle', 'Free service');
INSERT INTO `ctm`.`content_supplementary` (`contentControlId`, `supplementaryKey`, `supplementaryValue`) VALUES (@CCID, 'freeServiceContent', 'Our service is 100% free and we don\'t markup plans with any additional fees or charges');

INSERT INTO `ctm`.`content_supplementary` (`contentControlId`, `supplementaryKey`, `supplementaryValue`) VALUES (@CCID, 'switchingProvidersTitle', 'Switching providers');
INSERT INTO `ctm`.`content_supplementary` (`contentControlId`, `supplementaryKey`, `supplementaryValue`) VALUES (@CCID, 'switchingProvidersContent', 'If you stay in the same property and switch providers, your new provider will handle everything for you, even cancellation of your contract with your current provider (based on the State you live in)');

INSERT INTO `ctm`.`content_supplementary` (`contentControlId`, `supplementaryKey`, `supplementaryValue`) VALUES (@CCID, 'movingPropertyTitle', 'Moving property?');
INSERT INTO `ctm`.`content_supplementary` (`contentControlId`, `supplementaryKey`, `supplementaryValue`) VALUES (@CCID, 'movingPropertyContent', 'If you are moving property and need energy connected urgently, call us to prioritise your application');


-- ========================= ROLLBACK
-- SET @CCID = (SELECT `contentControlId` FROM `ctm`.`content_control` WHERE contentKey = 'snapshot');

-- SELECT count(*) AS total FROM `ctm`.`content_supplementary` WHERE contentControlId = @CCID;
-- RESULT BEFORE: 6
-- RESULT AFTER: 0
-- DELETE FROM `ctm`.`content_supplementary` WHERE `contentControlId` = @CCID LIMIT 6;

-- SELECT count(*) AS total FROM `ctm`.`content_supplementary` WHERE contentControlId = @CCID;
-- RESULT BEFORE: 1
-- RESULT AFTER: 0
-- DELETE FROM `ctm`.`content_control` WHERE `contentControlId` = @CCID LIMIT 1;