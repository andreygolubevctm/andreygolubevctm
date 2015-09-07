SET @ONECOV = (select providerId from ctm.provider_master where providerCode = '1COV');
SET @UNDER30 = (select providerId from ctm.provider_master where providerCode = '30UN');
SET @KANGO = (select providerId from ctm.provider_master where providerCode = 'KANG');
SET @SKI = (select providerId from ctm.provider_master where providerCode = 'SKII');
SET @TREK = (select providerId from ctm.provider_master where providerCode = 'ITRK');

-- Test expect 0
select count(countryValue) from ctm.country_provider_mapping where providerId  = @ONECOV;
update ctm.country_provider_mapping set countryValue = isoCode where providerId = @ONECOV LIMIT 257;
-- TEST expect 257
select count(countryValue) from ctm.country_provider_mapping where providerId  = @ONECOV;

-- Test expect 0
select count(countryValue) from ctm.country_provider_mapping where providerId  = @UNDER30;
update ctm.country_provider_mapping set countryValue = isoCode where providerId = @UNDER30 LIMIT 253;
-- Test expect 253
select count(countryValue) from ctm.country_provider_mapping where providerId  = @UNDER30;

-- Test expect 0
select count(countryValue) from ctm.country_provider_mapping where providerId  = @KANGO;
update ctm.country_provider_mapping set countryValue = isoCode where providerId = @KANGO LIMIT 253;
-- Test expect 253
select count(countryValue) from ctm.country_provider_mapping where providerId  = @KANGO;

-- Test expect 0
select count(countryValue) from ctm.country_provider_mapping where providerId  = @SKI;
update ctm.country_provider_mapping set countryValue = isoCode where providerId = @SKI LIMIT 253;
-- Test expect 253
select count(countryValue) from ctm.country_provider_mapping where providerId  = @SKI;

-- Test expect 0
select count(countryValue) from ctm.country_provider_mapping where providerId  = @TREK;
update ctm.country_provider_mapping set countryValue = isoCode where providerId = @TREK LIMIT 253;
-- Test expect 253
select count(countryValue) from ctm.country_provider_mapping where providerId  = @TREK;


-- ROLLBACK
/*
update ctm.country_provider_mapping set countryValue = '' where providerId = @TREK;
update ctm.country_provider_mapping set countryValue = '' where providerId = @ONECOV;
update ctm.country_provider_mapping set countryValue = '' where providerId = @UNDER30;
update ctm.country_provider_mapping set countryValue = '' where providerId = @KANGO;
update ctm.country_provider_mapping set countryValue = '' where providerId = @SKI;
update ctm.country_provider_mapping set countryValue = '' where providerId = @TREK;
*/