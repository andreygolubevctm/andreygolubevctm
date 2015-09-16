-- UPDATER
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='OTIS');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','OTIS-TRAVEL-53155',@PROV,'OTI - COMPREHENSIVE - DUO (01/05/2014)','OTI - COMPREHENSIVE - DUO (01/05/2014)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','OTIS-TRAVEL-53156',@PROV,'OTI - DOMESTIC - DUO (01/05/2014)','OTI - DOMESTIC - DUO (01/05/2014)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','OTIS-TRAVEL-53157',@PROV,'OTI - BASIC - DUO (01/05/2014)','OTI - BASIC - DUO (01/05/2014)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','OTIS-TRAVEL-53158',@PROV,'OTI - COMPREHENSIVE - FAMILY (01/05/2014)','OTI - COMPREHENSIVE - FAMILY (01/05/2014)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','OTIS-TRAVEL-53159',@PROV,'OTI - DOMESTIC - FAMILY (01/05/2014)','OTI - DOMESTIC - FAMILY (01/05/2014)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','OTIS-TRAVEL-53160',@PROV,'OTI - BASIC - FAMILY (01/05/2014)','OTI - BASIC - FAMILY (01/05/2014)','2015-09-04','2040-12-31','');

-- CHECKER - 36 products returned
SELECT * FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProductCode IN ('OTIS-TRAVEL-53155','OTIS-TRAVEL-53156','OTIS-TRAVEL-53157','OTIS-TRAVEL-53158','OTIS-TRAVEL-53159','OTIS-TRAVEL-53160');

-- ROLLBACK
/*
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='OTIS');
DELETE FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProviderId=@PROV AND ProductCode IN ('OTIS-TRAVEL-53155','OTIS-TRAVEL-53156','OTIS-TRAVEL-53157','OTIS-TRAVEL-53158','OTIS-TRAVEL-53159','OTIS-TRAVEL-53160');
*/