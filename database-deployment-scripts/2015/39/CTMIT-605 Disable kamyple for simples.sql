-- DISABLE Kampyle for Simples
-- TEST: Return 0 rows:
SELECT * FROM ctm.configuration where configCode='kampyleFeedback' AND verticalId = 14;

INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('kampyleFeedback', '0', '1', '14', 'N');

-- TEST: Return 1 row:
SELECT * FROM ctm.configuration where configCode='kampyleFeedback' AND verticalId = 14;