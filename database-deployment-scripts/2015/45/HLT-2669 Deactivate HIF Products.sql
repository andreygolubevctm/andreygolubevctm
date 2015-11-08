-- Updater
UPDATE `ctm`.`product_master` SET `Status`='X' WHERE ProductCat='HEALTH' AND ProviderId=(SELECT providerId FROM ctm.provider_master WHERE Name='HIF') AND NOW() BETWEEN EffectiveStart and EffectiveEnd AND Status NOT IN ('X','N');

-- Checker - 77 before and 0 after
SELECT * FROM ctm.product_master WHERE ProductCat='HEALTH' AND ProviderId=(SELECT providerId FROM ctm.provider_master WHERE Name='HIF') AND NOW() BETWEEN EffectiveStart and EffectiveEnd AND Status NOT IN ('X','N');
