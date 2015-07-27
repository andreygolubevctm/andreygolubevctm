UPDATE ctm.country_provider_mapping SET countryValue='PYF' WHERE providerId=78 AND countryValue='TAH';
UPDATE ctm.country_provider_mapping SET countryValue='PYF' WHERE providerId=282 AND countryValue='TAH';

-- Rollback
--UPDATE ctm.country_provider_mapping SET countryValue='TAH' WHERE providerId=78 AND countryValue='TAH';
--UPDATE ctm.country_provider_mapping SET countryValue='TAH' WHERE providerId=282 AND countryValue='TAH';
