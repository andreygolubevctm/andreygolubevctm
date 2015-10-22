SET @PVIDER_WOM = (select providerId from ctm.provider_master where providerCode = '1FOW');

-- updating override for excess from being $200 to $100
update ctm.travel_product_benefits set benefitValue = 100, benefitValueText = '$100' where providerId = @PVIDER_WOM
 and label = 'Excess on claims' limit 5;

-- Test Expect 5
 select count(*) from ctm.travel_product_benefits where benefitValue = 100 and providerId = @PVIDER_WOM;


-- Rollback
--update ctm.travel_product_benefits set benefitValue = 200, benefitValueText = '$200' where providerId = @PVIDER_WOM
-- and label = 'Excess on claims' limit 5;

-- Test Expect 5
-- select count(*) from ctm.travel_product_benefits where benefitValue = 200 and providerId = @PVIDER_WOM;