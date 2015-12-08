SET @pid := (SELECT providerid FROM ctm.provider_master WHERE providerCode = 'ACET');
-- ASIA
-- SELECT * FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = 'eac89a74-662c-4e36-a0b6-9ff60113602a' AND priority = 3;
-- TEST RESULT BEFORE UPDATE: 26
-- TEST RESULT AFTER UPDATE: 0

UPDATE ctm.country_provider_mapping SET regionValue = '957CF9D5-9374-442B-9890-9FF601247DE7' WHERE providerid = @pid AND priority = 3 and regionValue = 'eac89a74-662c-4e36-a0b6-9ff60113602a' LIMIT 26;

-- PACIFIC ISLANDS
-- SELECT * FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = '8ecf958d-8708-4b22-8e96-9ff601136a2c' AND priority = 4;
-- TEST RESULT BEFORE UPDATE: 30
-- TEST RESULT AFTER UPDATE: 0

UPDATE ctm.country_provider_mapping SET regionValue = '05BF92F8-8D20-423D-B3BA-9FF601248691' WHERE providerid = @pid AND priority = 4 and regionValue = '8ecf958d-8708-4b22-8e96-9ff601136a2c' LIMIT 30;

-- WORLDWIDE
-- ==== Just for reference Start ====
-- AFRICAS = 'DZA','AGO','BEN','BWA','BFA','BDI','CMR','CAI ','CPV','CAF','TCD','COM','COG','COD','DJI','EGY','GNQ','ERI','ETH','GAB','GMB','GHA','GIN','GNB','CIV','KEN','LSO','LBR','LBY','MDG','MWI','MLI','MRT','MUS','MYT','MAR','MOZ','NAM','NER','NGA','REU','RWA','SHN','STP','SEN','SYC','SLE','SOM','ZAF','SSD','SDN','SWZ','TZA','TGO','TUN','UGA','ESH','ZMB','ZWE';
-- AMERICAS = "'ATA','ATG','ARG','ABW','BHS','BRB','BLZ','BMU','BOL','BES','BVT','BRA','IOT','VGB','CAN','CYM','CHL','COL','CRI','CUB','CUW','DMA','DOM','ECU','SLV','FLK','GUF','GAL','GRD','GLP','GTM','GUY','HTI','HND','JAM','MTQ','MEX','MSR','NIC','PAN','PRY','PER','PRI','BLM','KNA','LCA','MAF','SPM','VCT','SXM','SA','SGS','SUR','TCA','UMI','USA','URY','VEN','VIR'";
-- ==== Just for reference End====

-- SELECT * FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = '37c47d9d-cc54-4543-a9f1-9ff6011349b2' AND priority = 1 AND isoCode IN ('DZA','AGO','BEN','BWA','BFA','BDI','CMR','CAI ','CPV','CAF','TCD','COM','COG','COD','DJI','EGY','GNQ','ERI','ETH','GAB','GMB','GHA','GIN','GNB','CIV','KEN','LSO','LBR','LBY','MDG','MWI','MLI','MRT','MUS','MYT','MAR','MOZ','NAM','NER','NGA','REU','RWA','SHN','STP','SEN','SYC','SLE','SOM','ZAF','SSD','SDN','SWZ','TZA','TGO','TUN','UGA','ESH','ZMB','ZWE', 'ATA','ATG','ARG','ABW','BHS','BRB','BLZ','BMU','BOL','BES','BVT','BRA','IOT','VGB','CAN','CYM','CHL','COL','CRI','CUB','CUW','DMA','DOM','ECU','SLV','FLK','GUF','GAL','GRD','GLP','GTM','GUY','HTI','HND','JAM','MTQ','MEX','MSR','NIC','PAN','PRY','PER','PRI','BLM','KNA','LCA','MAF','SPM','VCT','SXM','SA','SGS','SUR','TCA','UMI','USA','URY','VEN','VIR');
-- TEST RESULT BEFORE UPDATE: 118
-- TEST RESULT AFTER UPDATE: 0

UPDATE ctm.country_provider_mapping cpm SET regionValue = '840CBA6B-4907-457B-A04C-9FF60124639D' WHERE providerid = @pid AND priority = 1 AND mappingId IN (SELECT * FROM (SELECT mappingId FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = '37c47d9d-cc54-4543-a9f1-9ff6011349b2' AND priority = 1 AND isoCode IN ('DZA','AGO','BEN','BWA','BFA','BDI','CMR','CAI ','CPV','CAF','TCD','COM','COG','COD','DJI','EGY','GNQ','ERI','ETH','GAB','GMB','GHA','GIN','GNB','CIV','KEN','LSO','LBR','LBY','MDG','MWI','MLI','MRT','MUS','MYT','MAR','MOZ','NAM','NER','NGA','REU','RWA','SHN','STP','SEN','SYC','SLE','SOM','ZAF','SSD','SDN','SWZ','TZA','TGO','TUN','UGA','ESH','ZMB','ZWE', 'ATA','ATG','ARG','ABW','BHS','BRB','BLZ','BMU','BOL','BES','BVT','BRA','IOT','VGB','CAN','CYM','CHL','COL','CRI','CUB','CUW','DMA','DOM','ECU','SLV','FLK','GUF','GAL','GRD','GLP','GTM','GUY','HTI','HND','JAM','MTQ','MEX','MSR','NIC','PAN','PRY','PER','PRI','BLM','KNA','LCA','MAF','SPM','VCT','SXM','SA','SGS','SUR','TCA','UMI','USA','URY','VEN','VIR')) AS mappingIds) LIMIT 118;

-- WORLDWIDE Excluding Americas & Africa
-- SELECT * FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = 'b054b9d7-41d9-470f-a487-9ff60113539c';
-- TEST RESULT BEFORE UPDATE: 73
-- TEST RESULT AFTER UPDATE: 0

UPDATE ctm.country_provider_mapping SET regionValue = 'C92301A0-B25E-4247-AD6F-9FF6012471AE' WHERE providerid = @pid  and regionValue = 'b054b9d7-41d9-470f-a487-9ff60113539c' LIMIT 78;


-- ====================== ROLLBACK ===================
-- ASIA
-- UPDATE ctm.country_provider_mapping SET regionValue = 'eac89a74-662c-4e36-a0b6-9ff60113602a' WHERE providerid = @pid AND priority = 3 and regionValue = '957CF9D5-9374-442B-9890-9FF601247DE7';
-- SELECT * FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = '957CF9D5-9374-442B-9890-9FF601247DE7' AND priority = 3;
-- TEST RESULT BEFORE ROLLBACK: 26
-- TEST RESULT AFTER ROLLBACK: 0

-- PACIFIC ISLANDS
-- UPDATE ctm.country_provider_mapping SET regionValue = '8ecf958d-8708-4b22-8e96-9ff601136a2c' WHERE providerid = @pid AND priority = 4 and regionValue = '05BF92F8-8D20-423D-B3BA-9FF601248691';
-- SELECT * FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = '05BF92F8-8D20-423D-B3BA-9FF601248691' AND priority = 4;
-- TEST RESULT BEFORE ROLLBACK: 30
-- TEST RESULT AFTER ROLLBACK: 0

-- WORLDWIDE
-- UPDATE ctm.country_provider_mapping SET regionValue = '05BF92F8-8D20-423D-B3BA-9FF601248691' WHERE providerid = @pid AND priority = 1 and regionValue = '8ecf958d-8708-4b22-8e96-9ff601136a2c';
-- SELECT * FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = '840CBA6B-4907-457B-A04C-9FF60124639D' AND priority = 1 AND isoCode IN ('DZA','AGO','BEN','BWA','BFA','BDI','CMR','CAI ','CPV','CAF','TCD','COM','COG','COD','DJI','EGY','GNQ','ERI','ETH','GAB','GMB','GHA','GIN','GNB','CIV','KEN','LSO','LBR','LBY','MDG','MWI','MLI','MRT','MUS','MYT','MAR','MOZ','NAM','NER','NGA','REU','RWA','SHN','STP','SEN','SYC','SLE','SOM','ZAF','SSD','SDN','SWZ','TZA','TGO','TUN','UGA','ESH','ZMB','ZWE', 'ATA','ATG','ARG','ABW','BHS','BRB','BLZ','BMU','BOL','BES','BVT','BRA','IOT','VGB','CAN','CYM','CHL','COL','CRI','CUB','CUW','DMA','DOM','ECU','SLV','FLK','GUF','GAL','GRD','GLP','GTM','GUY','HTI','HND','JAM','MTQ','MEX','MSR','NIC','PAN','PRY','PER','PRI','BLM','KNA','LCA','MAF','SPM','VCT','SXM','SA','SGS','SUR','TCA','UMI','USA','URY','VEN','VIR');
-- TEST RESULT BEFORE ROLLBACK: 118
-- TEST RESULT AFTER ROLLBACK: 0

-- WORLDWIDE Excluding Americas & Africa
-- UPDATE ctm.country_provider_mapping SET regionValue = 'b054b9d7-41d9-470f-a487-9ff60113539c' WHERE providerid = @pid AND priority = 2 and regionValue = 'C92301A0-B25E-4247-AD6F-9FF6012471AE';
-- SELECT * FROM ctm.country_provider_mapping WHERE providerid = @pid AND regionValue = 'C92301A0-B25E-4247-AD6F-9FF6012471AE' AND priority = 2;
-- TEST RESULT BEFORE ROLLBACK: 73
-- TEST RESULT AFTER ROLLBACK: 0


UPDATE ctm.travel_product SET providerProductCode = 'International-Frequent Traveller'  WHERE providerId = @pid
        AND providerProductCode = 'International-Annual Trip' and productCode = 'ACET-TRAVEL-7' limit 1;

UPDATE ctm.travel_product SET productName = 'International Frequent Traveller'  WHERE providerId = @pid
        AND productName = 'International Annual Trip' and productCode = 'ACET-TRAVEL-7' limit 1;

-- test expect 1
select count(*) from ctm.travel_product where providerId = @pid and
      providerProductCode = 'International-Frequent Traveller' and productCode = 'ACET-TRAVEL-7';

-- rollback

-- UPDATE ctm.travel_product SET providerProductCode = 'International-Annual Trip'  WHERE providerId = @pid
--        AND providerProductCode = 'International-Frequent Traveller' and productCode = 'ACET-TRAVEL-7' limit 1;

--UPDATE ctm.travel_product SET productName = 'International Annual Trip'  WHERE providerId = @pid
--        AND productName = 'International Frequent Traveller' and productCode = 'ACET-TRAVEL-7' limit 1;

-- test expect 1
--select count(*) from ctm.travel_product where providerId = @pid and
--      providerProductCode = 'International-Annual Trip' and productCode = 'ACET-TRAVEL-7';

update ctm.travel_product_benefits set productId = 'International-Frequent Traveller' where providerId = @pid
 and productId = 'International-Annual Trip' limit 15;

 -- test expect 15
 select count(*) from ctm.travel_product_benefits where providerId = @pid and productId = 'International-Frequent Traveller';

 -- rollback

 -- update ctm.travel_product_benefits set productId = 'International-Annual Trip' where providerId = @pid
-- and productId = 'International-Frequent Traveller' limit 15;

 -- test expect 15
-- select count(*) from ctm.travel_product_benefits where providerId = @pid and productId = 'International-Annual Trip';






