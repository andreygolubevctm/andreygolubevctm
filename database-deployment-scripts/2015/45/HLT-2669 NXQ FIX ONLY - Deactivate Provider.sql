-- Updater
SET @HIF = (SELECT ProviderId FROM ctm.provider_master WHERE Name='HIF');
UPDATE ctm.provider_master SET EffectiveEnd='2015-11-02' WHERE ProviderId=@HIF;
UPDATE ctm.stylecode_provider_exclusions SET excludeDateFrom='2015-11-03 00:00:00' WHERE styleCodeId=0 AND verticalId=4 AND ProviderId=@HIF;
