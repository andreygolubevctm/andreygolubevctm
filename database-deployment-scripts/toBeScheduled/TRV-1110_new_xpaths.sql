SET @field_id = (SELECT MAX(fieldId) + 1 FROM aggregator.transaction_fields);
INSERT INTO aggregator.transaction_fields (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES (@field_id, 0, 13, 'travel/party', 2, 1, 0, 0, 0, 0, '2014-12-31 00:00:00');

SET @field_id = (SELECT MAX(fieldId) + 1 FROM aggregator.transaction_fields);
INSERT INTO aggregator.transaction_fields (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES (@field_id, 0, 13, 'travel/childrenSelect', 2, 1, 0, 0, 0, 0, '2014-12-31 00:00:00');
