SET @verticalId = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode='SIMPLES');

INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`)
VALUES ('DTMEnabled', '0', '0', @verticalId, 'N'),
       ('superTagEnabled', '0', '0', @verticalId, 'N');

/* TEST

SELECT * FROM ctm.configuration WHERE configCode IN ('DTMEnabled','superTagEnabled') AND verticalId=(SELECT verticalId FROM ctm.vertical_master WHERE verticalCode='SIMPLES');

*/