-- UPDATER
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='VIRG');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','VIRG-TRAVEL-53799',@PROV,'VMONEY - COMPREHENSIVE - FAMILY (XX/XX/14)','VMONEY - COMPREHENSIVE - FAMILY (XX/XX/14)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','VIRG-TRAVEL-53800',@PROV,'VMONEY - COMPREHENSIVE - DUO (XX/XX/14)','VMONEY - COMPREHENSIVE - DUO (XX/XX/14)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','VIRG-TRAVEL-53802',@PROV,'VMONEY - DOMESTIC - FAMILY (XX/XX/14)','VMONEY - DOMESTIC - FAMILY (XX/XX/14)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','VIRG-TRAVEL-53803',@PROV,'VMONEY - DOMESTIC - DUO (XX/XX/14)','VMONEY - DOMESTIC - DUO (XX/XX/14)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','VIRG-TRAVEL-53805',@PROV,'VMONEY - ESSENTIALS - FAM (XX/XX/2014)','VMONEY - ESSENTIALS - FAM (XX/XX/2014)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','VIRG-TRAVEL-53806',@PROV,'VMONEY - ESSENTIALS - DUO (XX/XX/2014)','VMONEY - ESSENTIALS - DUO (XX/XX/2014)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','VIRG-TRAVEL-53808',@PROV,'VMONEY - BASIC - FAM (XX/XX/2014)','VMONEY - BASIC - FAM (XX/XX/2014)','2015-09-04','2040-12-31','');
INSERT INTO ctm.product_master (productId,ProductCat,ProductCode,ProviderId,ShortTitle,LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES (null,'TRAVEL','VIRG-TRAVEL-53810',@PROV,'VMONEY - BASIC - SGL (XX/XX/2014)','VMONEY - BASIC - SGL (XX/XX/2014)','2015-09-04','2040-12-31','');

-- CHECKER - 36 products returned
SELECT * FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProductCode IN ('VIRG-TRAVEL-53799','VIRG-TRAVEL-53800','VIRG-TRAVEL-53802','VIRG-TRAVEL-53803','VIRG-TRAVEL-53805','VIRG-TRAVEL-53806','VIRG-TRAVEL-53808','VIRG-TRAVEL-53810');

-- ROLLBACK
/*
SET @PROV = (SELECT providerId FROM ctm.provider_master WHERE providerCode='VIRG');
DELETE FROM ctm.product_master WHERE ProductCat='TRAVEL' AND ProviderId=@PROV AND ProductCode IN ('VIRG-TRAVEL-53799','VIRG-TRAVEL-53800','VIRG-TRAVEL-53802','VIRG-TRAVEL-53803','VIRG-TRAVEL-53805','VIRG-TRAVEL-53806','VIRG-TRAVEL-53808','VIRG-TRAVEL-53810');
*/