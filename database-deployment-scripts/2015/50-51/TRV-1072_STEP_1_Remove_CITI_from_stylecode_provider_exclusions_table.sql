SET @pid := (SELECT providerid FROM ctm.provider_master WHERE providerCode = 'ACET');
-- select count(*) from ctm.stylecode_provider_exclusions where providerId = @pid and verticalId = 2 and excludeDateTo = '2015-12-08';
-- TEST RESULT BEFORE UPDATE: 0
-- TEST RESULT AFTER UPDATE: 1


UPDATE ctm.stylecode_provider_exclusions SET excludeDateTo = '2015-12-08'  WHERE providerId = @pid and verticalId = 2 limit 1;


-- ====================== ROLLBACK
 -- UPDATE ctm.stylecode_provider_exclusions SET excludeDateTo = '2040-12-30'  WHERE providerId = @pid and verticalId = 2 limit 1;

-- select count(*) from ctm.stylecode_provider_exclusions where providerId = @pid and verticalId = 2 and excludeDateTo = '2015-12-08';
-- TEST RESULT BEFORE UPDATE: 1
-- TEST RESULT AFTER UPDATE: 0