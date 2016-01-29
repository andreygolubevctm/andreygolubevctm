-- SET @pid = SELECT providerid FROM ctm.provider_master WHERE providercode = 'SKII';

-- SELECT count(*) FROM `ctm`.`travel_product` where providerId = @pid AND baseProduct = 1;
-- RESULT BEFORE: 0
-- RESULT AFTER : 1

-- SKII
INSERT INTO `ctm`.`travel_product` (`providerId`, `productCode`, `baseProduct`, `effectiveStart`, `effectiveEnd`) VALUES (@pid, 'SKII-TRAVEL-', '1', '2016-01-01 00:00:00', '2040-12-31 00:00:00');

-- SKII New Product
INSERT INTO `ctm`.`travel_product` (`providerId`, `productCode`, `productName`, `baseProduct`, `providerProductCode`, `effectiveStart`, `effectiveEnd`) VALUES (@pid, 'SKI-TRAVEL-228', 'Ski Plus', '0', '21', '2016-01-01 00:00:00', '2040-12-31 00:00:00');


-- ROLLBACK

-- SELECT count(*) FROM `ctm`.`travel_product` where providerId = @pid AND baseProduct = 1;
-- RESULT BEFORE: 1
-- RESULT AFTER : 0

-- DELETE FROM `ctm`.`travel_product` WHERE providerId = @pid and baseProduct = 1 LIMIT 1;


-- SELECT count(*) FROM `ctm`.`travel_product` WHERE providerId = @pid and productCode = 'SKI-TRAVEL-228' and providerProductCode = 21;
-- RESULT BEFORE: 1
-- RESULT AFTER : 0

-- DELETE FROM `ctm`.`travel_product` WHERE providerId = @pid and productCode = 'SKI-TRAVEL-228' and providerProductCode = 21 LIMIT 1;