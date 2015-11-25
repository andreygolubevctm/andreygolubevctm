-- UPDATER
SET @providerId = (SELECT ProviderId FROM ctm.provider_master WHERE Name='CUA');
UPDATE ctm.product_master SET Status='X' WHERE providerId=@providerId AND ProductCat='HEALTH' AND ShortTitle LIKE 'Private Hospital 65%' AND Status <> 'X';

-- CHECKER - 84 Before and 0 after
SET @providerId = (SELECT ProviderId FROM ctm.provider_master WHERE Name='CUA');
SELECT * FROM ctm.product_master WHERE providerId=@providerId AND ProductCat='HEALTH' AND ShortTitle LIKE 'Private Hospital 65%' AND Status <> 'X';