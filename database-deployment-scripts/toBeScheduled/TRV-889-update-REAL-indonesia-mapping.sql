-- [TEST] SELECT count(mappingId) as TOTAL FROM `ctm`.`country_provider_mapping` WHERE providerId = 71 AND isoCode = 'IDN' AND `regionValue`='R5' AND `priority`='5';
-- BEFORE RESULT: 0

UPDATE `ctm`.`country_provider_mapping` SET `regionValue`='R5', `priority`='5' WHERE providerId = 71 AND isoCode = 'IDN';

-- AFTER RESULT: 1