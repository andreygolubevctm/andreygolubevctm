SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'I4LS');
update ctm.country_provider_mapping set countryValue = isoCode where providerId = @PVIDER limit 253;

-- test
select count(*) from ctm.country_provider_mapping where providerId = @PVIDER and countryValue in (isocode);
-- expect 253


