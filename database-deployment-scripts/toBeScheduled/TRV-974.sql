--SELECT * FROM country_provider_mapping WHERE providerid=301 AND isocode='CAN';
UPDATE ctm.country_provider_mapping SET regionValue='R1' WHERE providerid=301 AND isocode='CAN';
