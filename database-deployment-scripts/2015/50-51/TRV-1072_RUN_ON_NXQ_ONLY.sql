SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'ACET');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

update ctm.service_properties SET servicePropertyValue = '$craMBLeD@123!' where providerId = @PVIDER
and servicePropertyKey = 'password' and servicePropertyValue = 'password' limit 1;

update ctm.service_properties SET servicePropertyValue = 'citibankau_compare.svc' where providerId = @PVIDER
and servicePropertyKey = 'user' and servicePropertyValue = 'au.bk' limit 1;