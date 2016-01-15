-- This should show 2490 rows already
Select max(fieldid) from aggregator.transaction_fields;

-- Test - should = 0
SELECT * FROM aggregator.transaction_fields where fieldCode = 'utilities/application/details/mobile';

INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2491', '1786', '2', 'utilities/application/details/mobile', '5', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');
INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2492', '0', '2', 'utilities/application/details/mobileinput', '5', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');

-- Test - should = 2 (2 old and 2 new)
SELECT * FROM aggregator.transaction_fields where fieldCode LIKE 'utilities/application/details/mobile%';

-- Test - should = 0
SELECT * FROM aggregator.transaction_fields where fieldCode = 'utilities/application/details/other';

INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2493', '1786', '2', 'utilities/application/details/other', '5', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');
INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2494', '0', '2', 'utilities/application/details/otherinput', '5', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');

-- Test - should = 2 (2 old and 2 new)
SELECT * FROM aggregator.transaction_fields where fieldCode LIKE 'utilities/application/details/other%';