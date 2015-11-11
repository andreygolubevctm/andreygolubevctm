SET @pID = (SELECT providerId FROM ctm.provider_master WHERE providerCode='ACET');
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES ('0','2',@pID,'2015-11-11 00:00:00','2040-11-11 00:00:00');

-- SELECT * FROM ctm.stylecode_provider_exclusions WHERE styleCodeId='0' AND verticalId='2' AND providerId=@pID;
-- RESULT BEFORE INSERT: 0
-- RESULT AFTER INSERT: 1

-- Rollback
-- DELETE FROM ctm.stylecode_provider_exclusions WHERE styleCodeId='0' AND verticalId='2' AND providerId=@pID;

-- SELECT * FROM ctm.stylecode_provider_exclusions WHERE styleCodeId='0' AND verticalId='2' AND providerId=@pID;
-- RESULT BEFORE INSERT: 1
-- RESULT AFTER INSERT: 0