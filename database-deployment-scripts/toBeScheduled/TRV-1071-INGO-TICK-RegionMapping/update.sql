SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'INGO');
SET @PVIDER2 = (select providerId from ctm.provider_master where providerCode = 'TICK');

-- updating INGO

update ctm.country_provider_mapping set regionValue = '3', countryValue = 'ASIA'
   where providerId = @PVIDER and isoCode = 'IDN';
update ctm.country_provider_mapping set regionValue = '4', countryValue = 'PC'
   where providerId = @PVIDER and isoCode = 'BAL';


-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'BAL' and regionValue = '4' and countryValue = 'PC' and providerId  = @PVIDER;

-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'IDN' and regionValue = '3' and countryValue = 'ASIA' and providerId  = @PVIDER;

-- updating TICK

update ctm.country_provider_mapping set regionValue = '3', countryValue = 'ASIA'
   where providerId = @PVIDER2 and isoCode = 'IDN';

   update ctm.country_provider_mapping set regionValue = '4', countryValue = 'PC'
  where providerId = @PVIDER2 and isoCode = 'BAL';


  -- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'BAL' and regionValue = '4' and countryValue = 'PC' and providerId  = @PVIDER2;

-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'IDN' and regionValue = '3' and countryValue = 'ASIA' and providerId  = @PVIDER2;


