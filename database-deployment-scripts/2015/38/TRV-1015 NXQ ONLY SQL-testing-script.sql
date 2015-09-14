SET @pCode = (SELECT providerId FROM ctm.provider_master WHERE providerCode = 'WEBJ');
SET @serviceMasterId = (SELECT serviceMasterId FROM ctm.service_master WHERE servicecode = 'quoteServiceBER');

UPDATE ctm.service_properties SET servicePropertyValue = 'https://pricingapi.agaassistance.com.au/api/quickquote' WHERE providerId = @pCode AND serviceMasterId = @serviceMasterId AND environmentCode = '0' AND servicePropertyKey = 'url' LIMIT 1;

--  TEST
-- SELECT count(servicePropertiesId) AS total FROM ctm.service_properties WHERE providerId = @pCode AND serviceMasterId = @serviceMasterId AND servicePropertyKey = 'url' AND environmentCode = '0' AND servicePropertyValue = 'https://pricingapi.agaassistance.com.au/api/quickquote';

-- TEST RESULT: 1

--
-- ROLL BACK
-- UPDATE ctm.service_properties SET servicePropertyValue = 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote' WHERE providerId = @pCode AND serviceMasterId = @serviceMasterId AND environmentCode = '0' AND servicePropertyKey = 'url' LIMIT 1;*/

--  TEST
-- SELECT count(servicePropertiesId) AS total FROM ctm.service_properties WHERE providerId = @pCode AND serviceMasterId = @serviceMasterId AND servicePropertyKey = 'url' AND environmentCode = '0' AND servicePropertyValue = 'https://pricingapi.agaassistance.com.au/api/quickquote';

-- TEST RESULT: 0