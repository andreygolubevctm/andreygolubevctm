-- [TEST] SELECT count(fieldId) AS total FROM `aggregator`.`transaction_fields` WHERE `fieldCode` = 'home/occupancy/coverTypeWarning/chosenOption' AND `verticalId` = 7;
-- BEFORE INSERT RESULT: 0

SET @newFieldId = (SELECT (MAX(fieldId) + 1) AS newId FROM `aggregator`.`transaction_fields`);

INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES (@newFieldId, '0', '11', 'home/occupancy/coverTypeWarning/chosenOption', '7', '1', '0', '0', '1', '0', '2040-12-31 00:00:00');

-- AFTER INSERT RESULT: 1

-- ======================================================================================
-- ================================== ROLLBACK ==========================================
-- ======================================================================================

-- [TEST] SELECT count(fieldId) AS total FROM `aggregator`.`transaction_fields` WHERE `fieldCode` = 'home/occupancy/coverTypeWarning/chosenOption';
-- BEFORE DELETE RESULT: 1

DELETE FROM `aggregator`.`transaction_fields` WHERE `fieldCode` = 'home/occupancy/coverTypeWarning/chosenOption' AND `verticalId` = 7 LIMIT 1;

-- AFTER DELETE RESULT: 0