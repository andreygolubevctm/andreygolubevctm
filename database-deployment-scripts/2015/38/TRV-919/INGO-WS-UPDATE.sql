SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'INGO');
SET @TICK = (select providerId from ctm.provider_master where providerCode = 'TICK');
SET @BERServiceId = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

UPDATE ctm.service_properties SET servicePropertyValue='soap' WHERE providerId = @PVIDER AND servicePropertyKey='serviceType' limit 1;
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES (@BERServiceId, '0', '0', @PVIDER, 'trackCode', '22', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES (@BERServiceId, '0', '0', @PVIDER, 'inboundParams', 'defaultProductId=NODEFAULT,service=INGO,trackCode=22', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES (@BERServiceId, '0', '0', @PVIDER, 'outboundParams', 'SPName=au.com.Compare,clientID=500', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES (@BERServiceId, 'PRO', '0', @PVIDER, 'url', 'https://ctmservice.insureandgo.com.au/QuotesAPI', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES (@BERServiceId, '0', '0', @PVIDER, 'url', 'http://devausctmservice.insureandgo.com/QuotesAPI', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

INSERT INTO ctm.travel_product (providerId, productCode, baseProduct, effectiveStart, effectiveEnd) VALUES (@PVIDER, 'INGO-TRAVEL-', '1', '2011-03-01 00:00:00', '2040-12-31 00:00:00');

INSERT INTO ctm.travel_provider_benefit_mapping (benefitId, providerId, providerBenefitCode, effectiveStart, effectiveEnd) VALUES ('1', @PVIDER, 'cancellation_fee', '2011-03-01 00:00:00', '2040-12-31 00:00:00');
INSERT INTO ctm.travel_provider_benefit_mapping (benefitId, providerId, providerBenefitCode, effectiveStart, effectiveEnd) VALUES ('4', @PVIDER, 'medical', '2011-03-01 00:00:00', '2040-12-31 00:00:00');
INSERT INTO ctm.travel_provider_benefit_mapping (benefitId, providerId, providerBenefitCode, effectiveStart, effectiveEnd) VALUES ('6', @PVIDER, 'luggage', '2011-03-01 00:00:00', '2040-12-31 00:00:00');
INSERT INTO ctm.travel_provider_benefit_mapping (benefitId, providerId, providerBenefitCode, effectiveStart, effectiveEnd) VALUES ('2', @PVIDER, 'excess', '2011-03-01 00:00:00', '2040-12-31 00:00:00');

UPDATE ctm.country_provider_mapping INGO, (
		SELECT isoCode,regionValue, countryValue, handoverValue, priority FROM ctm.country_provider_mapping WHERE providerId = @TICK) TICK
	SET INGO.regionValue = TICK.regionValue,
	INGO.countryValue= TICK.countryValue,
	INGO.handoverValue= TICK.handoverValue,
	INGO.priority = TICK.priority
WHERE INGO.isoCode = TICK.isoCode AND providerId = @PVIDER limit 253;

UPDATE ctm.country_provider_mapping SET countryValue='Dom', priority='5' WHERE providerId = @PVIDER AND isoCode = 'AUS' limit 1;