SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'INGO');
SET @PVIDER2 = (select providerId from ctm.provider_master where providerCode = 'TICK');

-- updating INGO

update ctm.country_provider_mapping set  countryValue = 'ASIA', regionValue = '9', priority = 3
   where providerId = @PVIDER and isoCode = 'IDN';

-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'IDN' and
      countryValue = 'ASIA' and
      providerId  = @PVIDER AND
       regionValue = '9' and priority = 3;

-- updating TICK

uupdate ctm.country_provider_mapping set countryValue = 'ASIA',regionValue = '9', priority = 3
   where providerId = @PVIDER2 and isoCode = 'IDN';



-- test expect 1
select count(*) from ctm.country_provider_mapping where isoCode = 'IDN' and
      countryValue = 'ASIA' and
      providerId  = @PVIDER2 AND
       regionValue = '9' and priority = 3;


