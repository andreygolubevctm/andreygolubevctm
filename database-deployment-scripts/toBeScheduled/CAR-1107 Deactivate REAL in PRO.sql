-- Updater
SET @pID = (SELECT providerId FROM ctm.provider_master WHERE providerCode='WOOL');
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES (1,3,@pID,'2015-08-31 23:55:00','2015-09-01 08:00:00');

-- Checker
SET @pID = (SELECT providerId FROM ctm.provider_master WHERE providerCode='WOOL');
SELECT * FROM ctm.stylecode_provider_exclusions WHERE styleCodeId=1 AND verticalId=3 AND providerId=@pID;

-- Rollback 
/*SET @pID = (SELECT providerId FROM ctm.provider_master WHERE providerCode='WOOL');
DELETE FROM ctm.stylecode_provider_exclusions WHERE styleCodeId=1 AND verticalId=3 AND providerId=@pID;
*/