-- [TEST] SELECT count('contentControlId') AS total FROM `ctm`.`content_control` WHERE contentKey = 'coverTypeWarningCopy';
-- RESULT BEFORE UPDATE: 0

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '7', 'Ownership', 'coverTypeWarningCopy', '2015-04-22 00:00:00', '2040-12-31 23:59:59', '<p><strong>Home insurance</strong> can only be used if you own or are paying off the home. If you are renting, you can get <strong>contents only insurance</strong> to cover your belongings.</p><p>Would you like to switch from <strong>placeholder</strong> insurance to Contents insurance?</p>');

-- RESULT AFTER UPDATE: 1

-- ===============================================================
-- ========================== ROLLBACK ===========================
-- ===============================================================

-- [TEST] SELECT count('contentControlId') AS total FROM `ctm`.`content_control` WHERE contentKey = 'coverTypeWarningCopy';
-- RESULT BEFORE DELETE: 1

DELETE FROM `ctm`.`content_control` WHERE contentKey = 'coverTypeWarningCopy' LIMIT 1;

-- RESULT AFTER DELETE: 0