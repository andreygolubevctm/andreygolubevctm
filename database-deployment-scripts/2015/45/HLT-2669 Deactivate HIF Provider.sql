-- Updater
SET @HIF = (SELECT ProviderId FROM ctm.provider_master WHERE Name='HIF');
UPDATE ctm.provider_master SET EffectiveEnd='2015-11-04' WHERE ProviderId=@HIF;
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES (0,4,@HIF,'2015-11-05 00:00:00','2040-12-31 23:59:59');

-- Rollback
/*SET @HIF = (SELECT ProviderId FROM ctm.provider_master WHERE Name='HIF');
UPDATE ctm.provider_master SET EffectiveEnd='2040-12-31' WHERE ProviderId=@HIF;
DELETE FROM ctm.stylecode_provider_exclusions WHERE styleCodeId='0' AND verticalId='4' AND providerId=@HIF;
*/