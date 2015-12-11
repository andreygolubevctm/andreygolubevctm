-- THIS NEEDS TO BE RUN ONLY ON NXQ AND NOTHING ELSE ANY OTHER ENVIRONMENT IGNORE
-- THIS NEEDS TO BE RUN ONLY ON NXQ AND NOTHING ELSE ANY OTHER ENVIRONMENT IGNORE
-- THIS NEEDS TO BE RUN ONLY ON NXQ AND NOTHING ELSE ANY OTHER ENVIRONMENT IGNORE
-- THIS NEEDS TO BE RUN ONLY ON NXQ AND NOTHING ELSE ANY OTHER ENVIRONMENT IGNORE
-- THIS NEEDS TO BE RUN ONLY ON NXQ AND NOTHING ELSE ANY OTHER ENVIRONMENT IGNORE

SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'DUIN');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

update ctm.service_properties set servicePropertyValue = 'http://www.duinsure.com.au/quoteEngineXML' where
  providerId = @PVIDER and serviceMasterId = @SERVICE_MASTER_ID and environmentCode = '0' and servicePropertyKey = 'url' limit 1;

-- text expect 1
select count(*) from ctm.service_properties where providerId = @PVIDER and serviceMasterId = @SERVICE_MASTER_ID
 and environmentCode = '0' and servicePropertyKey = 'url' and servicePropertyValue = 'http://www.duinsure.com.au/quoteEngineXML';

 -- rollback

 /*
update ctm.service_properties set servicePropertyValue = 'http://www.duinsure.com.au/sites/duinsureaus.nsf/quoteEngineXMLSnow' where
  providerId = @PVIDER and serviceMasterId = @SERVICE_MASTER_ID and environmentCode = '0' and servicePropertyKey = 'url' limit 1;

-- test expect 1
 select count(*) from ctm.service_properties where providerId = @PVIDER and serviceMasterId = @SERVICE_MASTER_ID
 and environmentCode = '0' and servicePropertyKey = 'url' and servicePropertyValue = 'http://www.duinsure.com.au/sites/duinsureaus.nsf/quoteEngineXMLSnow';

*/