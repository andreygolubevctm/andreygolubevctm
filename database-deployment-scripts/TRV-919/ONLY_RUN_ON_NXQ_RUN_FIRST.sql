SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'INGO');
SET @BERServiceId = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

-- bringing NXQ to be inline with Prod
INSERT INTO ctm.service_properties
  (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
     VALUES (@BERServiceId, '0', '0', @PVIDER, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');


delete from ctm.service_properties where providerId = @PVIDER and servicePropertyKey = 'trackCode' limit 1;

