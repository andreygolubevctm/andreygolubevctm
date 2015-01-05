SET @CAR_QUOTE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'carQuoteService');

-- AGIS_BUDD Budget Direct
SET @BUDD_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Budget Direct' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@CAR_QUOTE_MASTER_ID, '0', 8, @BUDD_PROVIDER_ID, 'outboundXslParms', 'partnerId=CHI0000001,sourceId=0000000001', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- AGIS_1FOW 1st for Women
SET @1FOW_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = '1st For Women' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@CAR_QUOTE_MASTER_ID, '0', 8, @1FOW_PROVIDER_ID, 'outboundXslParms', 'partnerId=CHI0000001,sourceId=0000000003', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- AGIS_VIRG Virgin
SET @VIRG_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Virgin Money' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@CAR_QUOTE_MASTER_ID, '0', 8, @VIRG_PROVIDER_ID, 'outboundXslParms', 'partnerId=CHI0000001,sourceId=0000000004', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- AGIS_OZIC Ozicare
SET @OZIC_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Ozicare' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@CAR_QUOTE_MASTER_ID, '0', 8, @OZIC_PROVIDER_ID, 'outboundXslParms', 'partnerId=CHI0000001,sourceId=0000000007', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- AGIS_EXDD Dodo
SET @EXDD_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Dodo Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES (@CAR_QUOTE_MASTER_ID, '0', 8, @EXDD_PROVIDER_ID, 'outboundXslParms', 'partnerId=CHI0000001,sourceId=0000000009', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');


-- Exclusions
SET @REAL_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Real Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 3, @REAL_PROVIDER_ID, '2014-01-01', '2020-01-01');

SET @WOOL_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Woolworths Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 3, @WOOL_PROVIDER_ID, '2014-01-01', '2020-01-01');

SET @AI_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'AI Insurance Holdings Pty Ltd' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 3, @AI_PROVIDER_ID, '2014-01-01', '2020-01-01');

SET @IECO_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'ibuyeco' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 3, @IECO_PROVIDER_ID, '2014-01-01', '2020-01-01');

SET @CBCK_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Cashback' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 3, @CBCK_PROVIDER_ID, '2014-01-01', '2020-01-01');

SET @RETI_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Retirease' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 3, @RETI_PROVIDER_ID, '2014-01-01', '2020-01-01');

SET @EXPO_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Australia Post' AND `status` <> 'X');
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES (8, 3, @EXPO_PROVIDER_ID, '2014-01-01', '2020-01-01');

-- Rollback
/*
SET @CAR_QUOTE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'carQuoteService');
DELETE FROM `ctm`.`service_properties` WHERE `styleCodeId` = 8 AND `servicePropertyValue` LIKE '%partnerId=CHI0000001%' AND `serviceMasterId` = @CAR_QUOTE_MASTER_ID;

DELETE FROM `ctm`.`stylecode_provider_exclusions` WHERE `styleCodeId` = 8 AND `verticalId` = 3;
*/