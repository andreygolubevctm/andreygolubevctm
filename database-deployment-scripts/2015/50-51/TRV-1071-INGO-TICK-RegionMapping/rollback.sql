SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'INGO');
SET @PVIDER2 = (select providerId from ctm.provider_master where providerCode = 'TICK');

-- updating INGO

update ctm.country_provider_mapping set  countryValue = 'PC', regionValue = '5', priority = 4
   where providerId = @PVIDER and isoCode = 'IDN';



-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'IDN'  and
 countryValue = 'PC' and providerId  = @PVIDER AND
 regionValue = '5' and  priority = 4;

-- updating TICK

update ctm.country_provider_mapping set  countryValue = 'PC', regionValue = '5', priority = 4
   where providerId = @PVIDER2 and isoCode = 'IDN';



-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'IDN'  and
 countryValue = 'PC' and providerId  = @PVIDER2 AND
 regionValue = '5' and  priority = 4;
