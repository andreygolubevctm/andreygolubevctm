SET @providerid =  (SELECT providerid FROM ctm.provider_master WHERE providercode='WLDC');

UPDATE `ctm`.`country_provider_mapping` SET `handoverValue`='asia', `priority`='3', `regionValue`='R3' WHERE providerID = @providerid AND isoCode='BAL' LIMIT 1;

-- TEST RESULT: 1
-- SELECT count(mappingId) AS total FROM `ctm`.`country_provider_mapping` WHERE `handoverValue`='asia' AND `priority`='3' AND `regionValue`='R3' AND providerID = @providerid AND isoCode='BAL';


-- ============================================================

-- ROLLBACK
-- UPDATE `ctm`.`country_provider_mapping` SET `handoverValue`='pacific', `priority`='4', `regionValue`='R4' WHERE providerID = @providerid AND isoCode='BAL' LIMIT 1;

-- TEST RESULT: 0
-- SELECT count(mappingId) AS total FROM `ctm`.`country_provider_mapping` WHERE `handoverValue`='asia' AND `priority`='3' AND `regionValue`='R3' AND providerID = @providerid AND isoCode='BAL';