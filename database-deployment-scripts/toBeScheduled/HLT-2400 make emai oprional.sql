set @maxFieldId = 2467 ;


INSERT INTO `aggregator`.`transaction_fields` 
(`fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`,`fieldId`) 
VALUES 
('0', '0', 'health/application/no/email', '4', '1', '0', '0', '0', '0', '2040-12-31 00:00:00', @maxFieldId);

/* TEST no of record =1*/
select     *
from    `aggregator`.`transaction_fields`
where    fieldId = @maxFieldId
        and fieldCode = 'health/application/no/email';
