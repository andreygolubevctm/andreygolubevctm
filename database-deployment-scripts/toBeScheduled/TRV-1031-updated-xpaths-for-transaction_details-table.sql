-- SELECT * FROM aggregator.transaction_fields WHERE fieldCode IN ('travel/travellers/traveller1DOB', 'travel/travellers/traveller2DOB', 'travel/travellers/travellersDOB') AND verticalId = 2 and fieldCategory = 4;
-- TEST RESULT BEFORE INSERT: 0 
-- TEST RESULT AFTER INSERT: 3

INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2486', '0', '4', 'travel/travellers/traveller1DOB', '2', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');
INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2487', '0', '4', 'travel/travellers/traveller2DOB', '2', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');
INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2488', '0', '4', 'travel/travellers/travellersDOB', '2', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');

-- SELECT * FROM aggregator.transaction_fields WHERE fieldCode = 'travel/oldest' AND verticalId = 2 and fieldCategory = 4;
-- TEST RESULT BEFORE DELETE: 1 
-- TEST RESULT AFTER DELETE: 0

DELETE FROM `aggregator`.`transaction_fields` WHERE fieldCode = 'travel/oldest' AND verticalId = 2 and fieldCategory = 4 LIMIT 1;

-- ROLLBACK

/* 
-- SELECT * FROM aggregator.transaction_fields WHERE fieldCode = 'travel/oldest' AND verticalId = 2 and fieldCategory = 4;
-- TEST RESULT BEFORE INSERT: 0 
-- TEST RESULT AFTER INSERT: 1
INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('1590', '0', '4', 'travel/oldest', '2', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');

-- SELECT * FROM aggregator.transaction_fields WHERE fieldCode IN ('travel/travellers/traveller1DOB', 'travel/travellers/traveller2DOB') AND verticalId = 2 and fieldCategory = 4;
-- TEST RESULT BEFORE DELETE: 3
-- TEST RESULT AFTER DELETE: 0

DELETE FROM `aggregator`.`transaction_fields` WHERE fieldCode = 'travel/travellers/traveller1DOB' AND verticalId = 2 and fieldCategory = 4 LIMIT 1;
DELETE FROM `aggregator`.`transaction_fields` WHERE fieldCode = 'travel/travellers/traveller2DOB' AND verticalId = 2 and fieldCategory = 4 LIMIT 1;
DELETE FROM `aggregator`.`transaction_fields` WHERE fieldCode = 'travel/travellers/travellersDOB' AND verticalId = 2 and fieldCategory = 4 LIMIT 1;
*/