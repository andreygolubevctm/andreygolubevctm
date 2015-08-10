-- UPDATER
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='DUIN');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','DUIN-TRAVEL-55',@PROV,'Comprehensive Snow Cover','Comprehensive Snow Cover','2015-08-10','2040-12-31','');
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='ACET');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','ACET-TRAVEL-8',@PROV,'Citibank Domestic-Annual Trip','Citibank Domestic-Annual Trip','2015-08-10','2040-12-31','');
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='PPTI');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','PPTI-TRAVEL-7',@PROV,'Priceline Protects Domestic Annual Trip','Priceline Protects Domestic Annual Trip','2015-08-10','2040-12-31','');
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='WEBJ');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','WEBJ-TRAVEL-51025',@PROV,'Webjet Multi Trip','Webjet Multi Trip','2015-08-10','2040-12-31','');

-- CHECKER - 4 products returned
SELECT * FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProductCode IN ('DUIN-TRAVEL-55','ACET-TRAVEL-8','PPTI-TRAVEL-7','WEBJ-TRAVEL-51025');

-- ROLLBACK
/*
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='DUIN');
DELETE FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProviderId=@PROV AND ProductCode IN ('DUIN-TRAVEL-55');
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='ACET');
DELETE FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProviderId=@PROV AND ProductCode IN ('ACET-TRAVEL-8');
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='PPTI');
DELETE FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProviderId=@PROV AND ProductCode IN ('PPTI-TRAVEL-7');
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='WEBJ');
DELETE FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProviderId=@PROV AND ProductCode IN ('WEBJ-TRAVEL-51025');
*/