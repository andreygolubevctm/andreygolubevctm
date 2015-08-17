-- UPDATER
SET @pID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='TICK');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@pID,'providerKey','tick_t1T0O45sli','2015-08-06 00:00:00','2040-12-31 23:59:59','');

-- CHECKER: empty before and 1 row after
SET @pID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='TICK');
SELECT * FROM ctm.provider_properties WHERE ProviderId=@pID AND PropertyId='providerKey';

-- ROLLBACK
-- SET @pID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='TICK');
-- DELETE FROM ctm.provider_properties WHERE ProviderId=@pID AND PropertyId='providerKey';