-- ===================================================
-- BEFORE Test
-- SELECT count(providerId) AS total FROM `ctm`.`country_provider_mapping` WHERE ((`isoCode` = 'AFG' AND `countryValue` = 'AF') OR (`isoCode` = 'ATA' AND `countryValue` = 'AQ') OR (`isoCode` = 'CUW' AND `countryValue` = 'XC') OR (`isoCode` = 'COD' AND `countryValue` = 'CD') OR (`isoCode` = 'IMN' AND `countryValue` = 'XM') OR (`isoCode` = 'PCN' AND `countryValue` = 'PN') OR (`isoCode` = 'ROU' AND `countryValue` = 'ROM') OR (`isoCode` = 'BLM' AND `countryValue` = 'XA') OR (`isoCode` = 'TLS' AND `countryValue` = 'TP') OR (`isoCode` = 'WLF' AND `countryValue` = 'WF') OR (`isoCode` = 'ESH' AND `countryValue` = 'EH') OR (`isoCode` = 'CAI' AND `countryValue` = 'CAI')) AND providerId = 78;
-- RESULT: 0
-- ===================================================

-- update the isoCodes for Virgin
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='AF' WHERE providerId = 78 AND isoCode = 'AFG';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='AQ' WHERE providerId = 78 AND isoCode = 'ATA';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='XC' WHERE providerId = 78 AND isoCode = 'CUW';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='CD' WHERE providerId = 78 AND isoCode = 'COD';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='XM' WHERE providerId = 78 AND isoCode = 'IMN';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='PN' WHERE providerId = 78 AND isoCode = 'PCN';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='ROM' WHERE providerId = 78 AND isoCode = 'ROU';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='XA' WHERE providerId = 78 AND isoCode = 'BLM';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='TP' WHERE providerId = 78 AND isoCode = 'TLS';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='WF' WHERE providerId = 78 AND isoCode = 'WLF';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='EH' WHERE providerId = 78 AND isoCode = 'ESH';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='CAI' WHERE providerId = 78 AND isoCode = 'CAI ';

-- ===================================================
-- BEFORE Test
-- SELECT count(providerId) AS total FROM `ctm`.`country_provider_mapping` WHERE ((`isoCode` = 'AFG' AND `countryValue` = 'AF') OR (`isoCode` = 'ATA' AND `countryValue` = 'AQ') OR (`isoCode` = 'CUW' AND `countryValue` = 'XC') OR (`isoCode` = 'COD' AND `countryValue` = 'CD') OR (`isoCode` = 'IMN' AND `countryValue` = 'XM') OR (`isoCode` = 'PCN' AND `countryValue` = 'PN') OR (`isoCode` = 'ROU' AND `countryValue` = 'ROM') OR (`isoCode` = 'BLM' AND `countryValue` = 'XA') OR (`isoCode` = 'TLS' AND `countryValue` = 'TP') OR (`isoCode` = 'WLF' AND `countryValue` = 'WF') OR (`isoCode` = 'ESH' AND `countryValue` = 'EH') OR (`isoCode` = 'CAI' AND `countryValue` = 'CAI')) AND providerId = 78;
-- RESULT: 12
-- ===================================================