SET @BERServiceId := (SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode ='quoteServiceBER');

-- [TEST] SELECT count(servicePropertiesId) AS total FROM `ctm`.`service_properties` WHERE serviceMasterId = @BERServiceId AND providerId = 295 AND `servicePropertyKey` IN ('serviceType', 'inboundParams', 'outboundParams', 'url');
-- BEFORE UPDATE/INSERT TEST RESULT: 0

-- INGO
UPDATE `ctm`.`service_properties` SET `servicePropertyValue`='soap' WHERE providerId = 295 AND servicePropertyKey='serviceType';
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@BERServiceId, '0', '0', '295', 'trackCode', '22', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@BERServiceId, '0', '0', '295', 'inboundParams', 'defaultProductId=NODEFAULT,service=INGO', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@BERServiceId, '0', '0', '295', 'outboundParams', 'SPName=au.com.Compare,clientID=500', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@BERServiceId, 'PRO', '0', '295', 'url', 'http://devausctmservice.insureandgo.com/QuotesAPI', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@BERServiceId, '0', '0', '295', 'url', 'https://ctmservice.insureandgo.com.au/QuotesAPI', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- RESULT UPDATE/INSERT TEST AFTER: 5

-- ===========================================================================================================================

-- [TEST] SELECT count(servicePropertiesId) AS total FROM `ctm`.`service_properties` WHERE serviceMasterId = @BERServiceId AND providerId = 323 AND `servicePropertyValue`='SPName=au.com.Compare,clientID=507';
-- BEFORE UPDATE TEST RESULT: 0
UPDATE `ctm`.`service_properties` SET `servicePropertyValue`='SPName=au.com.Compare,clientID=507' WHERE providerId = 323 AND servicePropertyKey='outboundParams';

-- AFTER UPDATE TEST RESULT: 1;

-- ADD a generic product for INGO
-- [TEST] SELECT count(providerId) AS total FROM `ctm`.`travel_product` WHERE providerId = 295;
-- BEFORE INSERT TEST RESULT: 0
INSERT INTO `ctm`.`travel_product` (`providerId`, `productCode`, `baseProduct`, `effectiveStart`, `effectiveEnd`) VALUES ('295', 'INGO-TRAVEL-', '1', '2011-03-01 00:00:00', '2040-12-31 00:00:00');
-- AFTER INSERT TEST RESULT: 1

-- ===========================================================================================================================

-- ADD Benefits for INGO
-- [TEST] SELECT count(providerId) AS total FROM `ctm`.`travel_provider_benefit_mapping` WHERE providerId = 295;
-- BEFORE INSERT TEST RESULT: 0
INSERT INTO `ctm`.`travel_provider_benefit_mapping` (`benefitId`, `providerId`, `providerBenefitCode`, `effectiveStart`, `effectiveEnd`) VALUES ('1', '295', 'cancellation_fee', '2011-03-01 00:00:00', '2040-12-31 00:00:00');
INSERT INTO `ctm`.`travel_provider_benefit_mapping` (`benefitId`, `providerId`, `providerBenefitCode`, `effectiveStart`, `effectiveEnd`) VALUES ('4', '295', 'medical', '2011-03-01 00:00:00', '2040-12-31 00:00:00');
INSERT INTO `ctm`.`travel_provider_benefit_mapping` (`benefitId`, `providerId`, `providerBenefitCode`, `effectiveStart`, `effectiveEnd`) VALUES ('6', '295', 'luggage', '2011-03-01 00:00:00', '2040-12-31 00:00:00');
INSERT INTO `ctm`.`travel_provider_benefit_mapping` (`benefitId`, `providerId`, `providerBenefitCode`, `effectiveStart`, `effectiveEnd`) VALUES ('2', '295', 'excess', '2011-03-01 00:00:00', '2040-12-31 00:00:00');
-- AFTER INSERT TEST RESULT: 4

-- ===========================================================================================================================

-- UPDATE InsureAndGo's country mapping to match TICK's
-- [TEST] SELECT count(mappingId) AS total FROM ctm.country_provider_mapping WHERE providerid = 295 AND regionvalue like 'R%';
-- BEFORE UPDATE TEST RESULT: 253
UPDATE ctm.country_provider_mapping INGO, (
		SELECT isoCode,regionValue, countryValue, handoverValue, priority FROM ctm.country_provider_mapping WHERE providerId = 323) TICK
	SET INGO.regionValue = TICK.regionValue,
	INGO.countryValue= TICK.countryValue,
	INGO.handoverValue= TICK.handoverValue,
	INGO.priority = TICK.priority
WHERE INGO.isoCode = TICK.isoCode AND providerId = 295;

-- AFTER UPDATE TEST RESULT: 0

-- ===========================================================================================================================

-- FINALLY update Domestic entry
-- [TEST] SELECT count(mappingId) AS total FROM `ctm`.`country_provider_mapping` WHERE isoCode = 'AUS' AND countryValue = 'Dom';

-- BEFORE UPDATE TEST RESULT: 0
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='Dom', `priority`='5' WHERE providerId = 295 AND isoCode = 'AUS';

-- AFTER UPDATE TEST RESULT: 1