SET @HOME_QUOTE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'homeQuoteService');

-- AGIS_BUDD Budget Direct
SET @BUDD_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Budget Direct' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@HOME_QUOTE_MASTER_ID, '0', 8, @BUDD_PROVIDER_ID, 'outboundXslParms', 'partnerId=CHI0000100,sourceId=0000000001,schemaVersion=3.1', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- AGIS_VIRG Virgin
SET @VIRG_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Virgin Money' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@HOME_QUOTE_MASTER_ID, '0', 8, @VIRG_PROVIDER_ID, 'outboundXslParms', 'partnerId=CHI0000100,sourceId=0000000002,schemaVersion=3.1', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- Exclusions
SET @EXDD_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Dodo Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 7, @EXDD_PROVIDER_ID, '2014-01-01', '2020-01-01');

SET @REAL_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Real Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 7, @REAL_PROVIDER_ID, '2014-01-01', '2020-01-01');

SET @WOOL_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Woolworths Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 7, @WOOL_PROVIDER_ID, '2014-01-01', '2020-01-01');

-- Rollback
/*
SET @HOME_QUOTE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'homeQuoteService');
DELETE FROM `ctm`.`service_properties` WHERE `styleCodeId` = 8 AND `servicePropertyValue` LIKE '%partnerId=CHI0000100%' AND `serviceMasterId` = @HOME_QUOTE_MASTER_ID;

DELETE FROM `ctm`.`stylecode_provider_exclusions` WHERE `styleCodeId` = 8 AND `verticalId` = 7;
*/