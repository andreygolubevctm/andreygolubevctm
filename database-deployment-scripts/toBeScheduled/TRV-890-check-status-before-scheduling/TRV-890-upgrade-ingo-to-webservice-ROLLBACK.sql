SET @BERServiceId := (SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode ='quoteServiceBER');

-- [TEST] SELECT count(servicePropertiesId) AS total FROM `ctm`.`service_properties` WHERE serviceMasterId = @BERServiceId AND providerId = 295 AND `servicePropertyKey` IN ('serviceType', 'inboundParams', 'outboundParams', 'url');
-- BEFORE UPDATE/INSERT TEST RESULT: 0

-- INGO
UPDATE `ctm`.`service_properties` SET `servicePropertyValue`='soap' WHERE providerId = 295 AND servicePropertyKey='serviceType';
DELETE * FROM  `ctm`.`service_properties` WHERE  providerId = 295 AND `servicePropertyKey` IN ('serviceType', 'inboundParams', 'outboundParams', 'url') LIMIT 5;

-- RESULT UPDATE/INSERT TEST AFTER: 1

-- ADD a generic product for INGO
-- [TEST] SELECT count(providerId) AS total FROM `ctm`.`travel_product` WHERE providerId = 295;
-- BEFORE INSERT TEST RESULT: 1
DELETE FROM `ctm`.`travel_product` WHERE `providerId` = '295' LIMIT 1;
-- AFTER INSERT TEST RESULT: 0

-- ADD Benefits for INGO
-- [TEST] SELECT count(providerId) AS total FROM `ctm`.`travel_provider_benefit_mapping` WHERE providerId = 295;
-- BEFORE INSERT TEST RESULT: 4
DELETE FROM `ctm`.`travel_provider_benefit_mapping` WHERE providerId = 295;
-- BEFORE INSERT TEST RESULT: 0