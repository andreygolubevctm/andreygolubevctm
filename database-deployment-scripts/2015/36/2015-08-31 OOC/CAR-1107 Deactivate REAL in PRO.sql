-- Updater
SET @pID = (SELECT providerId FROM ctm.provider_master WHERE providerCode='REAL');
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES ('0','3',@pID,'2015-08-31 23:55:00','2015-09-01 08:00:00');

-- Checker
SET @pID = (SELECT providerId FROM ctm.provider_master WHERE providerCode='REAL');
SELECT * FROM ctm.stylecode_provider_exclusions WHERE styleCodeId='0' AND verticalId='3' AND providerId=@pID;

-- Rollback 
/*SET @pID = (SELECT providerId FROM ctm.provider_master WHERE providerCode='REAL');
DELETE FROM ctm.stylecode_provider_exclusions WHERE styleCodeId='0' AND verticalId='3' AND providerId=@pID;
*/