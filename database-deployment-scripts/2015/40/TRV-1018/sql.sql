SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'ACET');
SET @PVIDER_AMEX = (select providerId  from ctm.provider_master where providerCode = 'AMEX');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

SET @NEW_PROPVALUE_NONPROD = 'defaultProductId=NODEFAULT,service=AMEX,rootURL=https://amex.atuat.acegroup.com/AU,trackCode=39';
SET @OLD_PROPVALUE_NONPROD = 'defaultProductId=NODEFAULT,service=AMEX,rootURL=https://amex.atuat.acegroup.com/AUResp/,trackCode=39';



update ctm.country_provider_mapping
 set regionValue = UPPER(regionValue)
where providerId = @PVIDER and isoCode = 'AUS' limit 1;

update ctm.service_properties set servicePropertyValue = @NEW_PROPVALUE_NONPROD
    where providerId = @PVIDER_AMEX and serviceMasterId = @SERVICE_MASTER_ID
    and servicePropertyValue = @OLD_PROPVALUE_NONPROD limit 1;

-- Test expect 1
select count(*) from ctm.service_properties where providerId = @PVIDER_AMEX and serviceMasterId = @SERVICE_MASTER_ID
    and servicePropertyValue = @NEW_PROPVALUE_NONPROD;

-- TEST expect 1

select count(*)  from ctm.country_provider_mapping where providerId = @PVIDER
and regionValue = '833B107A-9DC7-4D52-841D-6074884DCF50';

-- ROLLBACK
/*
SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'ACET');

update ctm.country_provider_mapping set regionValue = LOWER(revionValue)
 where providerId = @PVIDER and isoCode = 'AUS' limit 1;

-- expect 1
 select count(*)  from ctm.country_provider_mapping where providerId = @PVIDER
and regionValue = '833b107a-9dc7-4d52-841d-6074884dcf50';


SET @PVIDER_AMEX = (select providerId  from ctm.provider_master where providerCode = 'AMEX');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

SET @NEW_PROPVALUE_NONPROD = 'defaultProductId=NODEFAULT,service=AMEX,rootURL=https://amex.atuat.acegroup.com/AU,trackCode=39';
SET @OLD_PROPVALUE_NONPROD = 'defaultProductId=NODEFAULT,service=AMEX,rootURL=https://amex.atuat.acegroup.com/AUResp/,trackCode=39';


update ctm.service_properties set servicePropertyValue = @OLD_PROPVALUE_NONPROD
    where providerId = @PVIDER_AMEX and serviceMasterId = @SERVICE_MASTER_ID
    and servicePropertyValue = @NEW_PROPVALUE_NONPROD limit 1;

-- expect 1
select count(*) from ctm.service_properties where providerId = @PVIDER_AMEX and serviceMasterId = @SERVICE_MASTER_ID
    and servicePropertyValue = @OLD_PROPVALUE_NONPROD;

 */


