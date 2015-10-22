INSERT INTO `aggregator`.`general` (`type`, `code`, `description`, `orderSeq`) VALUES ('healthCvrType', 'c', 'Combined', '1');
INSERT INTO `aggregator`.`general` (`type`, `code`, `description`, `orderSeq`) VALUES ('healthCvrType', 'e', 'Extras', '3');
INSERT INTO `aggregator`.`general` (`type`, `code`, `description`, `orderSeq`) VALUES ('healthCvrType', 'h', 'Hospital', '2');

INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2489', '0', '6', 'health/situation/coverType', '4', '1', '0', '0', '0', '0', '2040-12-31 00:00:00');

-- Test - Should be 3 records
SELECT * FROM aggregator.general where type = 'healthCvrType';

-- Test - Should be 1 record
SELECT * FROM aggregator.transaction_fields where fieldcode = 'health/situation/coverType';