-- UPDATER
SET @pID = (SELECT ProviderId FROM ctm.provider_master WHERE Name='Bupa');
UPDATE ctm.product_master SET Status='X' WHERE ProviderId=@pId AND Status != 'X' AND EffectiveStart='2015-04-01' AND EffectiveEnd='2016-03-31';

-- CHECKER - 693 Before and Zero After
SET @pID = (SELECT ProviderId FROM ctm.provider_master WHERE Name='Bupa');
SELECT * FROM ctm.product_master WHERE ProviderId=@pId AND Status != 'X' AND EffectiveStart='2015-04-01' AND EffectiveEnd='2016-03-31';