SET @pid := (SELECT providerid FROM ctm.provider_master WHERE providerCode = 'ACET');
-- SELECT * FROM ctm.stylecode_provider_exclusions WHERE providerid = @pid AND verticalId = 2;
-- TEST RESULT BEFORE DELETE: 1
-- TEST RESULT AFTER DELETE: 0

DELETE FROM ctm.stylecode_provider_exclusions WHERE providerid = @pid AND verticalId = 2  LIMIT 1;

-- ====================== ROLLBACK
-- INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES ('0','2',@pID,'2015-11-13 00:00:00','2040-11-13 00:00:00');
-- SELECT * FROM ctm.stylecode_provider_exclusions WHERE providerid = @pid AND verticalId = 2;
-- TEST RESULT BEFORE ROLLBACK: 0
-- TEST RESULT AFTER ROLLBACK: 1