-- [TEST] SELECT count(mappingId) AS total FROM `ctm`.`country_provider_mapping` WHERE providerId IN (323, 295) AND isoCode = 'IDN' AND regionValue IN ('R4', '5'); 
-- BEFORE UPDATING RESULT: 0


UPDATE `ctm`.`country_provider_mapping` SET `regionValue`='5', `countryValue`='PC', `priority`='4' WHERE  providerId = 323 AND isoCode = 'IDN';
UPDATE `ctm`.`country_provider_mapping` SET `regionValue`='R4', `handoverValue`='5', `priority`='4' WHERE  providerId = 295 AND isoCode = 'IDN';

-- AFTER UPDATING RESULT: 2

-- ===================================================================================================

-- ROLLBACK
-- [TEST] SELECT count(mappingId) AS total FROM ctm.country_provider_mapping WHERE providerId IN (323, 295) AND isoCode IN ('IDN') AND regionValue IN ('R3', '9');

-- BEFORE UPDATING RESULT: 0
-- UPDATE `ctm`.`country_provider_mapping` SET `regionValue`='9', `countryValue`='ASIA', `priority`='3' WHERE  providerId = 323 AND isoCode = 'IDN';
--UPDATE `ctm`.`country_provider_mapping` SET `regionValue`='R3', `handoverValue`='9', `priority`='3' WHERE  providerId = 295 AND isoCode = 'IDN';

-- AFTER UPDATING RESULT: 2