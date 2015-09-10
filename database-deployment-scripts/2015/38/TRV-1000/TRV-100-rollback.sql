SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'I4LS');
SET @TIZ = (select providerId from ctm.provider_master where providerCode = 'TINZ');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

/*
rollback property changes
 */
 UPDATE ctm.service_properties SET effectiveEnd='2040-12-31 00:00:00' WHERE providerId = @PVIDER
 and serviceMasterId = @SERVICE_MASTER_ID
 and servicePropertyKey = 'serviceType'
 and servicePropertyValue = 'db' limit 1;

 delete from ctm.service_properties where providerId = @PVIDER and servicePropertyKey = 'soap' limit 1;
 delete from ctm.service_properties where providerId = @PVIDER and servicePropertyKey = 'url' limit 2;
 delete from ctm.service_properties where providerId = @PVIDER and servicePropertyKey = 'inboundParams' limit 1;
 delete from ctm.service_properties where providerId = @PVIDER and servicePropertyKey = 'trackCode' limit 1;
 delete from ctm.service_properties where providerId = @PVIDER and servicePropertyKey = 'timeout' limit 1;

/*
TESTERS expect 0
*/
select count(*) from ctm.service_properties where providerId = @PVIDER and servicePropertyKey in
 ('serviceType','url','inboundParams','trackCode','timeout');


 /*
 rollback product names
  */
delete from ctm.travel_product where productCode = 'I4LS-TRAVEL-' and providerId = @PVIDER limit 1;

delete from ctm.travel_product where providerId = @PVIDER and providerProductCode in ('2-3-5-31','2-3-6-31','2-3-7-31','2-3-15-31','2-3-5-45','2-3-6-45','2-3-7-45','2-3-15-45','2-3-5-62','2-3-6-62',
'2-3-7-62','2-3-15-62','2-3-5-93','2-3-6-93','2-3-7-93','2-3-15-93','2-4-5-31','2-4-6-31','2-4-7-31','2-4-15-31',
'2-4-5-45','2-4-6-45','2-4-7-45','2-4-15-45','2-4-5-62','2-4-6-62','2-4-7-62','2-4-15-62','2-4-5-93','2-4-6-93',
'2-4-7-93','2-4-15-93') limit 32;

/*
TEST
Expect 0
 */
 select count(*) from ctm.travel_product where providerId = @PVIDER and providerProductCode in
('2-3-5-31','2-3-6-31','2-3-7-31','2-3-15-31','2-3-5-45','2-3-6-45','2-3-7-45','2-3-15-45','2-3-5-62','2-3-6-62',
'2-3-7-62','2-3-15-62','2-3-5-93','2-3-6-93','2-3-7-93','2-3-15-93','2-4-5-31','2-4-6-31','2-4-7-31','2-4-15-31',
'2-4-5-45','2-4-6-45','2-4-7-45','2-4-15-45','2-4-5-62','2-4-6-62','2-4-7-62','2-4-15-62','2-4-5-93','2-4-6-93',
'2-4-7-93','2-4-15-93');



/*
Rollback for reporting
 */
 delete from ctm.product_master where providerId = @PVIDER and ProductCode in ('I4LS-TRAVEL-2-3-5-31','I4LS-TRAVEL-2-3-6-31','I4LS-TRAVEL-2-3-7-31','I4LS-TRAVEL-2-3-15-31','I4LS-TRAVEL-2-3-5-45','I4LS-TRAVEL-2-3-6-45',
'I4LS-TRAVEL-2-3-7-45','I4LS-TRAVEL-2-3-15-45','I4LS-TRAVEL-2-3-5-62','I4LS-TRAVEL-2-3-6-62',
'I4LS-TRAVEL-2-3-7-62','I4LS-TRAVEL-2-3-15-62','I4LS-TRAVEL-2-3-5-93','I4LS-TRAVEL-2-3-6-93','I4LS-TRAVEL-2-3-7-93',
'I4LS-TRAVEL-2-3-15-93','I4LS-TRAVEL-2-4-5-31','I4LS-TRAVEL-2-4-6-31','I4LS-TRAVEL-2-4-7-31','I4LS-TRAVEL-2-4-15-31',
'I4LS-TRAVEL-2-4-5-45','I4LS-TRAVEL-2-4-6-45','I4LS-TRAVEL-2-4-7-45','I4LS-TRAVEL-2-4-15-45',
'I4LS-TRAVEL-2-4-5-62','I4LS-TRAVEL-2-4-6-62','I4LS-TRAVEL-2-4-7-62','I4LS-TRAVEL-2-4-15-62','I4LS-TRAVEL-2-4-5-93','I4LS-TRAVEL-2-4-6-93',
'I4LS-TRAVEL-2-4-7-93','I4LS-TRAVEL-2-4-15-93','I4LS-TRAVEL-1-3-5','I4LS-TRAVEL-1-3-6','I4LS-TRAVEL-1-3-7','I4LS-TRAVEL-1-3-15');

/*
Test expect 0
 */
 select count(*) from ctm.product_master where providerId = @PVIDER and productCode in ('I4LS-TRAVEL-2-3-5-31','I4LS-TRAVEL-2-3-6-31','I4LS-TRAVEL-2-3-7-31','I4LS-TRAVEL-2-3-15-31','I4LS-TRAVEL-2-3-5-45','I4LS-TRAVEL-2-3-6-45',
'I4LS-TRAVEL-2-3-7-45','I4LS-TRAVEL-2-3-15-45','I4LS-TRAVEL-2-3-5-62','I4LS-TRAVEL-2-3-6-62',
'I4LS-TRAVEL-2-3-7-62','I4LS-TRAVEL-2-3-15-62','I4LS-TRAVEL-2-3-5-93','I4LS-TRAVEL-2-3-6-93','I4LS-TRAVEL-2-3-7-93',
'I4LS-TRAVEL-2-3-15-93','I4LS-TRAVEL-2-4-5-31','I4LS-TRAVEL-2-4-6-31','I4LS-TRAVEL-2-4-7-31','I4LS-TRAVEL-2-4-15-31',
'I4LS-TRAVEL-2-4-5-45','I4LS-TRAVEL-2-4-6-45','I4LS-TRAVEL-2-4-7-45','I4LS-TRAVEL-2-4-15-45',
'I4LS-TRAVEL-2-4-5-62','I4LS-TRAVEL-2-4-6-62','I4LS-TRAVEL-2-4-7-62','I4LS-TRAVEL-2-4-15-62','I4LS-TRAVEL-2-4-5-93','I4LS-TRAVEL-2-4-6-93',
'I4LS-TRAVEL-2-4-7-93','I4LS-TRAVEL-2-4-15-93','I4LS-TRAVEL-1-3-5','I4LS-TRAVEL-1-3-6','I4LS-TRAVEL-1-3-7','I4LS-TRAVEL-1-3-15');

/*
Rollback travel benefit mapping
 */
delete from ctm.travel_provider_benefit_mapping where providerId = @PVIDER limit 4;

 /* Test expect 0
  */
select count(*) from ctm.travel_provider_benefit_mapping where providerId = @PVIDER;

/*
Rollback for country
 */
 update ctm.country_provider_mapping set countryValue = '' where providerId = @PVIDER limit 253;

/*
Test expect 0
 */
 select count(*) from ctm.country_provider_mapping where providerId = @PVIDER and countryValue <> '';












