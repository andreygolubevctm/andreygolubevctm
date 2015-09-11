SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'INGO');
SET @BERServiceId = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

--bringing NXQ to be inline with Prod
update ctm.service_properties set servicePropertyValue = 'db' where servicePropertyKey = 'serviceType'
   and providerId = @PVIDER and serviceMasterId = @BERServiceId limit 1;

delete from ctm.service_properties where providerId = @PVIDER and servicePropertyKey = 'trackCode' limit 1;

