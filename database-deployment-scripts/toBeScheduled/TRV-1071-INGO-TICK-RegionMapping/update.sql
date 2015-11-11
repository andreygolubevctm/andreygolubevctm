SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'INGO');
SET @PVIDER2 = (select providerId from ctm.provider_master where providerCode = 'TICK');

-- updating INGO

update ctm.country_provider_mapping set  countryValue = 'ASIA'
   where providerId = @PVIDER and isoCode = 'IDN';

-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'IDN' and countryValue = 'ASIA' and providerId  = @PVIDER;

-- updating TICK

update ctm.country_provider_mapping set countryValue = 'ASIA'
   where providerId = @PVIDER2 and isoCode = 'IDN';



-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'IDN'  and countryValue = 'ASIA' and providerId  = @PVIDER2;


