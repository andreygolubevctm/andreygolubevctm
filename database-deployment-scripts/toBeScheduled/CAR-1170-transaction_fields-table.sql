-- TEST: 0 before and 2 after
-- SELECT count(*) AS total FROM `aggregator`.`transaction_fields` WHERE fieldId IN (2505, 2506);

INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2505', '0', '12', 'quote/vehicle/passengerForPayment', '3', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');
INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2506', '0', '12', 'quote/vehicle/goodsForPayment', '3', '1', '0', '0', '0', '0', '2014-12-31 00:00:00');

-- ROLLBACK
-- DELETE FROM `aggregator`.`transaction_fields` WHERE fieldId IN (2505, 2506);