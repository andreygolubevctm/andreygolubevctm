-- === ENABLE DTM FOR HEALTH.

-- TEST: Displays all DTMEnabled configs for health and simples
SELECT * FROM ctm.configuration WHERE configCode LIKE 'DTMEnabled' AND verticalId IN(4,14);
-- 8 Rows

-- TEST SELECT ONE:
SELECT * FROM ctm.configuration WHERE configCode LIKE 'DTMEnabled' AND verticalId = 4 AND styleCodeId = 1 AND environmentCode = 'PRO';
-- 1 row

-- ENABLE DTM FOR HEALTH ON CTM
UPDATE ctm.configuration SET configValue = 'Y' WHERE configCode LIKE 'DTMEnabled' AND verticalId = 4 AND styleCodeId = 1 AND environmentCode = 'PRO' LIMIT 1;
-- update 1 row

-- ======= DISABLE DTM FOR HEALTH BY UPDATE
UPDATE ctm.configuration SET configValue = 'N' WHERE configCode LIKE 'DTMEnabled' AND verticalId = 4 AND styleCodeId = 1 AND environmentCode = 'PRO' LIMIT 1;
-- 1 Row

-- DISABLE IN SIMPLES.
UPDATE ctm.configuration SET configValue = 'N' WHERE configCode LIKE 'DTMEnabled' AND verticalId = 14 AND styleCodeId = 1 AND environmentCode = 'PRO' LIMIT 1;
-- Shouldn't need to be run.

-- DISABLING DTM FROM 22/07/2015
-- WHAT WAS RUN BY LETO IN PROD
-- To disable DTM on Production, due to an internal network problem (see AGG-2490)
-- INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('DTMEnabled', 'PRO', '1', '4', 'N');
-- INSERT INTO `ctm`.`configuration` (`configCode`, `environmentCode`, `styleCodeId`, `verticalId`, `configValue`) VALUES ('DTMEnabled', 'PRO', '1', '14', 'N');


