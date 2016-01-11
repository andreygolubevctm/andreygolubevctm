-- ONLY TO BE RUN ON TEST ENVIRONMENTS (NXI, NXQ, NXS)
-- Run
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId, verticalId, providerId, excludeDateFrom, excludeDateTo)
VALUES (1, 2, 308, '2015-12-21 00:00:00', '2040-12-31 23:59:59');

-- Rollback
/*
DELETE FROM ctm.stylecode_provider_exclusions
WHERE providerId = 308;
*/