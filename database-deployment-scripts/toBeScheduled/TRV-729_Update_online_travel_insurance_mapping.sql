-- ===================================================
-- BEFORE Test
-- SELECT count(providerId) AS total FROM `ctm`.`country_provider_mapping` WHERE ((`isoCode` = 'AFG' AND `countryValue` = 'AF') OR (`isoCode` = 'ATA' AND `countryValue` = 'AQ') OR (`isoCode` = 'CUW' AND `countryValue` = 'XC') OR (`isoCode` = 'COD' AND `countryValue` = 'CD') OR (`isoCode` = 'IMN' AND `countryValue` = 'XM') OR (`isoCode` = 'PCN' AND `countryValue` = 'PN') OR (`isoCode` = 'ROU' AND `countryValue` = 'ROM') OR (`isoCode` = 'BLM' AND `countryValue` = 'XA') OR (`isoCode` = 'TLS' AND `countryValue` = 'TP') OR (`isoCode` = 'WLF' AND `countryValue` = 'WF') OR (`isoCode` = 'ESH' AND `countryValue` = 'EH') OR (`isoCode` = 'CAI' AND `countryValue` = 'CAI')) AND providerId = 282;
-- RESULT: 0
-- ===================================================

-- update the isoCodes for Online Travel Insurance
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='AF' WHERE providerId = 282 AND isoCode = 'AFG';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='AQ' WHERE providerId = 282 AND isoCode = 'ATA';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='XC' WHERE providerId = 282 AND isoCode = 'CUW';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='CD' WHERE providerId = 282 AND isoCode = 'COD';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='XM' WHERE providerId = 282 AND isoCode = 'IMN';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='PN' WHERE providerId = 282 AND isoCode = 'PCN';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='ROM' WHERE providerId = 282 AND isoCode = 'ROU';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='XA' WHERE providerId = 282 AND isoCode = 'BLM';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='TP' WHERE providerId = 282 AND isoCode = 'TLS';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='WF' WHERE providerId = 282 AND isoCode = 'WLF';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='EH' WHERE providerId = 282 AND isoCode = 'ESH';
UPDATE `ctm`.`country_provider_mapping` SET `countryValue`='CAI' WHERE providerId = 282 AND isoCode = 'CAI ';

-- ===================================================
-- BEFORE Test
-- SELECT count(providerId) AS total FROM `ctm`.`country_provider_mapping` WHERE ((`isoCode` = 'AFG' AND `countryValue` = 'AF') OR (`isoCode` = 'ATA' AND `countryValue` = 'AQ') OR (`isoCode` = 'CUW' AND `countryValue` = 'XC') OR (`isoCode` = 'COD' AND `countryValue` = 'CD') OR (`isoCode` = 'IMN' AND `countryValue` = 'XM') OR (`isoCode` = 'PCN' AND `countryValue` = 'PN') OR (`isoCode` = 'ROU' AND `countryValue` = 'ROM') OR (`isoCode` = 'BLM' AND `countryValue` = 'XA') OR (`isoCode` = 'TLS' AND `countryValue` = 'TP') OR (`isoCode` = 'WLF' AND `countryValue` = 'WF') OR (`isoCode` = 'ESH' AND `countryValue` = 'EH') OR (`isoCode` = 'CAI' AND `countryValue` = 'CAI')) AND providerId = 282;
-- RESULT: 12
-- ===================================================