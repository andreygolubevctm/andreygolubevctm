-- ONLY TO BE RUN ON PROD ENVIRONMENTS
-- Run
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId, verticalId, providerId, excludeDateFrom, excludeDateTo)
VALUES (1, 2, 308, '2016-01-08 00:00:00', '2040-12-31 23:59:59');

-- Rollback
DELETE FROM ctm.stylecode_provider_exclusions
WHERE providerId = 308;