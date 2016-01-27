-- TEST (0 before, 6 after)
SELECT *
FROM ctm.configuration
WHERE configCode LIKE 'splitTest_acciCover%';

-- TEST (0 before, 1 after)
SELECT *
FROM ctm.configuration
WHERE configCode = 'splitTest_current';

-- RUN
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('splitTest_acciCover_1_jVal', '0', '1', '4', '1');
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('splitTest_acciCover_1_range', '0', '1', '4', '0');
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('splitTest_acciCover_3_jVal', '0', '1', '4', '12');
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('splitTest_acciCover_3_range', '0', '1', '4', '100');
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('splitTest_acciCover_3_active', '0', '1', '4', 'Y');
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('splitTest_acciCover_3_count', '0', '1', '4', '2');
INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('splitTest_current', '0', '1', '4', 'acciCover');

-- ROLLBACK
/*
DELETE FROM ctm.configuration
WHERE (
  configCode LIKE 'splitTest_accidentalCover%'
  OR configCode = 'splitTest_current'
) AND environmentCode = 0
AND styleCodeId = 1
AND verticalId = 4;
 */