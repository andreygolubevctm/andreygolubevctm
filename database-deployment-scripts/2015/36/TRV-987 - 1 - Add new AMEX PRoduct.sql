-- UDPATER
SET @providerID = (SELECT providerId FROM ctm.provider_master WHERE ProviderCode='AMEX');
SET @productID = (SELECT productId FROM ctm.travel_product WHERE providerId=@providerId AND productCode='AMEX-TRAVEL-25');
SET @pName = (SELECT productName FROM ctm.travel_product WHERE productId=@productID);
SET @pDesc = (SELECT description FROM ctm.travel_product WHERE productId=@productID);
SET @pdsUrl = (SELECT pdsUrl FROM ctm.travel_product WHERE productId=@productID);
SET @pStart = (SELECT effectiveStart FROM ctm.travel_product WHERE productId=@productID);
SET @pEnd = (SELECT effectiveEnd FROM ctm.travel_product WHERE productId=@productID);
INSERT INTO ctm.travel_product (providerId,productCode,productName,title,description,baseProduct,pdsUrl,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd) VALUES (@providerID,'AMEX-TRAVEL-27',@pName,null,@pDesc,'0',@pdsUrl,45,'363cba19-28af-4f38-b987-a2e4003f3463-DOMESTIC',@pStart,@pEnd);

-- CHECKER
SET @providerID = (SELECT providerId FROM ctm.provider_master WHERE ProviderCode='AMEX');
SELECT * FROM ctm.travel_product WHERE productCode='AMEX-TRAVEL-27';

-- ROLLBACK
-- SET @providerID = (SELECT providerId FROM ctm.provider_master WHERE ProviderCode='AMEX');
-- DELETE FROM ctm.travel_product WHERE providerId=@providerId AND productCode='AMEX-TRAVEL-27';