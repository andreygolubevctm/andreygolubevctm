SET @WEBJET = (select providerId from ctm.provider_master where providerCode = 'WEBJ');
SET @TRAVELBER = (select serviceMasterId from ctm.service_master where serviceCode like 'quoteServiceBER');
SET @NEW_CLIENT_CODE_OUTPARAM = 'clientCode=WJPAU';
SET @OLD_CLIENT_CODE_OUTPARAM = 'clientCode=WEBJETAU';
SET @NEW_CLIENT_CODE='WJPAU';
SET @OLD_CLIENT_CODE='WEBJETAU';


update ctm.service_properties set servicePropertyValue = @NEW_CLIENT_CODE_OUTPARAM where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyValue = @OLD_CLIENT_CODE_OUTPARAM LIMIT 1;

-- test expect 1
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @NEW_CLIENT_CODE_OUTPARAM;

update ctm.service_properties set servicePropertyValue = @NEW_CLIENT_CODE where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyValue = @OLD_CLIENT_CODE LIMIT 1;

-- test expect 1
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @NEW_CLIENT_CODE;

update ctm.country_provider_mapping set countryValue = isoCode where providerId = @WEBJET LIMIT 253;
-- test expect 253
select count(countryValue) from ctm.country_provider_mapping where providerId = @WEBJET;


-- rollback
/*
update ctm.service_properties set servicePropertyValue = @OLD_CLIENT_CODE where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyValue = @NEW_CLIENT_CODE;

update ctm.service_properties set servicePropertyValue = @OLD_CLIENT_CODE_OUTPARAM where providerId = @WEBJET and
serviceMasterId = @TRAVELBER and servicePropertyValue = @NEW_CLIENT_CODE_OUTPARAM;

update ctm.country_provider_mapping set countryValue = '' where providerId = @WEBJET LIMIT 253;
*/
