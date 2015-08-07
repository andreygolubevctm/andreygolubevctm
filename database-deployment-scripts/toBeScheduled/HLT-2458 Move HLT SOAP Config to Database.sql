-- New master services.
-- Dont need to add a new service_master as 'appService' exists for HLT so we will use this
-- INSERT INTO `ctm`.`service_master` (`verticalId`, `serviceCode`) VALUES ('4', 'appService');
SELECT * FROM ctm.service_master where verticalid = 4

-- Set master id's to use for later inserts.
SET @HOME_BASE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'appService' AND `verticalId` = '4');

-- Global
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'merge-root', 'soap-response', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'merge-xsl', 'merge-results.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'config-dir', 'aggregator/health_application', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'errorDir', '/usr/aih/app-logs/ctm/WEB-INF/aggregator/health_application/errors', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, 'LOCALHOST', 0, 0, 'error-dir', 'aggregator/health_application/app-logs-errors', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'debug-dir', 'health_application/debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, 'LOCALHOST', 0, 0, 'debug-dir', 'app-logs-debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL')
-- ,
-- (@HOME_BASE_MASTER_ID, '0', 0, 0, 'validationFile', 'WEB-INF/xsd/home/homeQuoteResults.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
;
--------
-- AU --
--------
SET @PROVIDERID = 1;


---------
-- HCF --
---------
SET @PROVIDERID = 2;

---------
-- NIB --
---------
SET @PROVIDERID = 3;

---------------
-- Peoplecare --
----------------
SET @PROVIDERID = 4;

-----------
-- GMHBA --
----------
SET @PROVIDERID = 5;

---------
-- GMF --
---------
SET @PROVIDERID = 6;

--------------
-- WestFund --
---------------
SET @PROVIDERID = 7;

-----------
-- Frank --
-----------
SET @PROVIDERID = 8;

---------
-- AHM --
---------
SET @PROVIDERID = 9;

----------
-- CBHS --
----------
SET @PROVIDERID = 10;

---------
-- HIF --
---------
SET @PROVIDERID = 11;

---------
-- CUA --
---------
SET @PROVIDERID = 12;

---------
-- THF --
---------
SET @PROVIDERID = 13;

---------
-- CtM --
---------
SET @PROVIDERID = 14;

----------
-- Bupa --
----------
SET @PROVIDERID = 15;

----------
-- QCHF --
----------
SET @PROVIDERID = 16;



-- Global
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'mergeRoot', 'soap-response', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'mergeXsl', 'merge-results.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'configDir', 'aggregator/home', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'errorDir', '/usr/aih/app-logs/ctm/WEB-INF/aggregator/home/errors', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, 'LOCALHOST', 0, 0, 'errorDir', 'aggregator/home/app-logs-errors', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'debugDir', 'home/app-logs-debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, 'NXI', 0, 0, 'debugDir', 'home/debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, 'NXS', 0, 0, 'debugDir', 'home/debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HOME_BASE_MASTER_ID, '0', 0, 0, 'validationFile', 'WEB-INF/xsd/home/homeQuoteResults.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
;


-- Budget
SET @BUDD_PROVIDER_ID = (SELECT `providerId `FROM `ctm`.`provider_master` WHERE `name` = 'Budget Direct' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOME_BASE_MASTER_ID, '0', 0, @BUDD_PROVIDER_ID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @BUDD_PROVIDER_ID, 'serviceName', 'AGIS_BUDD', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, 'LOCALHOST', 0, @BUDD_PROVIDER_ID, 'soapUrl' ,'https://nxq.ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXI', 0, @BUDD_PROVIDER_ID, 'soapUrl' ,'http://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXS', 0, @BUDD_PROVIDER_ID, 'soapUrl' ,'http://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXQ', 0, @BUDD_PROVIDER_ID, 'soapUrl' ,'https://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'PRO', 0, @BUDD_PROVIDER_ID, 'soapUrl' ,'https://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @BUDD_PROVIDER_ID, 'soapAction', 'gethomeQuotes', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @BUDD_PROVIDER_ID, 'outboundXsl' ,'AGIS/outbound_results.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @BUDD_PROVIDER_ID, 'outboundXslParms' ,'partnerId=CTM0000100,sourceId=0000000001,schemaVersion=3.1','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @BUDD_PROVIDER_ID, 'inboundXsl' ,'AGIS/inbound_results.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @BUDD_PROVIDER_ID, 'inboundXslParms' ,'defaultProductId=BUDD-05-29,service=AGIS_BUDD','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @BUDD_PROVIDER_ID, 'timeoutMillis' ,'40000','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE');


-- Virgin
SET @VIRG_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Virgin Money' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOME_BASE_MASTER_ID, '0', 0, @VIRG_PROVIDER_ID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @VIRG_PROVIDER_ID, 'serviceName', 'AGIS_VIRG', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, 'LOCALHOST', 0, @VIRG_PROVIDER_ID, 'soapUrl' ,'https://nxq.ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXI', 0, @VIRG_PROVIDER_ID, 'soapUrl' ,'http://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXS', 0, @VIRG_PROVIDER_ID, 'soapUrl' ,'http://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXQ', 0, @VIRG_PROVIDER_ID, 'soapUrl' ,'https://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'PRO', 0, @VIRG_PROVIDER_ID, 'soapUrl' ,'https://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @VIRG_PROVIDER_ID, 'soapAction', 'gethomeQuotes', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @VIRG_PROVIDER_ID, 'outboundXsl' ,'AGIS/outbound_results.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @VIRG_PROVIDER_ID, 'outboundXslParms' ,'partnerId=CTM0000100,sourceId=0000000002,schemaVersion=3.1','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @VIRG_PROVIDER_ID, 'inboundXsl' ,'AGIS/inbound_results.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @VIRG_PROVIDER_ID, 'inboundXslParms' ,'defaultProductId=VIRG-05-26,service=AGIS_VIRG','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @VIRG_PROVIDER_ID, 'timeoutMillis' ,'40000','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE');


-- Dodo
SET @EXDD_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Dodo Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOME_BASE_MASTER_ID, '0', 0, @EXDD_PROVIDER_ID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @EXDD_PROVIDER_ID, 'serviceName', 'AGIS_EXDD', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, 'LOCALHOST', 0, @EXDD_PROVIDER_ID, 'soapUrl' ,'https://nxq.ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXI', 0, @EXDD_PROVIDER_ID, 'soapUrl' ,'http://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXS', 0, @EXDD_PROVIDER_ID, 'soapUrl' ,'http://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXQ', 0, @EXDD_PROVIDER_ID, 'soapUrl' ,'https://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'PRO', 0, @EXDD_PROVIDER_ID, 'soapUrl' ,'https://ecommerce.disconline.com.au/services/3.1/gethomeQuotes','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @EXDD_PROVIDER_ID, 'soapAction', 'gethomeQuotes', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @EXDD_PROVIDER_ID, 'outboundXsl' ,'AGIS/outbound_results.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @EXDD_PROVIDER_ID, 'outboundXslParms' ,'partnerId=CTM0000100,sourceId=0000000003,schemaVersion=3.1','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @EXDD_PROVIDER_ID, 'inboundXsl' ,'AGIS/inbound_results.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @EXDD_PROVIDER_ID, 'inboundXslParms' ,'defaultProductId=EXDD-05-21,service=AGIS_EXDD','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @EXDD_PROVIDER_ID, 'timeoutMillis' ,'40000','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE');


-- Real
SET @REIN_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Real Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOME_BASE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'serviceName', 'REIN', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, 'LOCALHOST', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'http://localhost:8080/ctm/rating/home/home_price_service.jsp?service=WOOL','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXI', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'http://192.168.149.65/ctm/rating/home/home_price_service.jsp?service=WOOL','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXS', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'http://192.168.149.233/ctm/rating/home/home_price_service.jsp?service=WOOL','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXQ', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'http://192.168.149.45/ctm/rating/home/home_price_service.jsp?service=WOOL','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'PRO', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://ecommerce.disconline.com.au/ctm/rating/home/home_price_service.jsp?service=WOOL','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'outboundXsl' ,'Hollard/copy_nodes_outbound.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundXsl' ,'Hollard/copy_nodes_inbound.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundXslParms' ,'productId=REIN-02-01','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'timeoutMillis' ,'25000','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE');

-- Real init
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'serviceName', 'REININIT', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyonesit.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_INIT_MASTER_ID, 'NXQ', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyonepp.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_INIT_MASTER_ID, 'PRO', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyone.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'soapAction', 'http://tempuri.org/IAggregatorService/Initialize', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'outboundXsl', 'Hollard/init_outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'outboundXslParms', 'keyname=ctmpp01,keypass=14lC(MWg,siteKey=RealHomeBaseCTM', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_INIT_MASTER_ID, 'PRO', 0, @REIN_PROVIDER_ID, 'outboundXslParms', 'keyname=ctmprod01,keypass=%^56tgBy,siteKey=RealHomeBaseCTM', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundXsl', 'Hollard/init_inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundXslParms', 'productId=REIN-02-01', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_INIT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundtimeoutMillisXslParms', '20000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- Real quote
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'serviceName', 'REINIQUOTE', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyonesit.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, 'NXQ', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyonepp.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, 'PRO', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyone.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'soapAction', 'http://tempuri.org/IAggregatorService/GetHomeQuote', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'outboundXsl', 'Hollard/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'outboundXslParms', 'partnerId=CTM0000001,sourceId=TEST000001', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundXsl', 'Hollard/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundXslParms', 'productId=REIN-02-01,service=REIN', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_QUOTE_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundtimeoutMillisXslParms', '35000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- Real content
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'serviceName', 'REINCONTENT', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyonesit.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, 'NXQ', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyonepp.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, 'PRO', 0, @REIN_PROVIDER_ID, 'soapUrl' ,'https://everyone.realinsurance.com.au/v2/AggregatorService.svc','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'soapAction', 'http://tempuri.org/IAggregatorService/GetContentForToken', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'outboundXsl', 'Hollard/content_outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'outboundXslParms', 'partnerId=CTM0000001,sourceId=TEST000001', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundXsl', 'Hollard/content_inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundXslParms', 'productId=REIN-02-01,service=REIN', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOLLARD_CONTENT_MASTER_ID, '0', 0, @REIN_PROVIDER_ID, 'inboundtimeoutMillisXslParms', '35000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE');


-- Woolworths
SET @WOOL_PROVIDER_ID = (SELECT `providerId` FROM `ctm`.`provider_master` WHERE `name` = 'Woolworths Insurance' AND `status` <> 'X');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HOME_BASE_MASTER_ID, '0', 0, @WOOL_PROVIDER_ID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @WOOL_PROVIDER_ID, 'serviceName', 'WOOL', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HOME_BASE_MASTER_ID, 'LOCALHOST', 0, @WOOL_PROVIDER_ID, 'soapUrl' ,'http://localhost:8080/ctm/rating/home/home_price_service.jsp?service=REIN','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXI', 0, @WOOL_PROVIDER_ID, 'soapUrl' ,'http://192.168.149.65/ctm/rating/home/home_price_service.jsp?service=REIN','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXS', 0, @WOOL_PROVIDER_ID, 'soapUrl' ,'http://192.168.149.233/ctm/rating/home/home_price_service.jsp?service=REIN','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'NXQ', 0, @WOOL_PROVIDER_ID, 'soapUrl' ,'http://192.168.149.45/ctm/rating/home/home_price_service.jsp?service=REIN','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, 'PRO', 0, @WOOL_PROVIDER_ID, 'soapUrl' ,'https://ecommerce.disconline.com.au/ctm/rating/home/home_price_service.jsp?service=REIN','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @WOOL_PROVIDER_ID, 'outboundXsl' ,'Hollard/copy_nodes_outbound.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @WOOL_PROVIDER_ID, 'inboundXsl' ,'Hollard/copy_nodes_inbound.xsl','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @WOOL_PROVIDER_ID, 'inboundXslParms' ,'productId=WOOL-02-01','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE'),
(@HOME_BASE_MASTER_ID, '0', 0, @WOOL_PROVIDER_ID, 'timeoutMillis' ,'25000','2015-08-06 00:00:00','2038-01-19 00:00:00','SERVICE');


-- Rollback
-- NOTES: Must run in this order (delete service properties before service master.), if you delete the master items first it will be harder to delete then service properties.
/*
SET @HOME_BASE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'homeQuoteService' AND `verticalId` = '7');
SET @HOLLARD_INIT_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'homeQuoteService_hollard_init' AND `verticalId` = '7');
SET @HOLLARD_QUOTE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'homeQuoteService_hollard_quote' AND `verticalId` = '7');
SET @HOLLARD_CONTENT_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'homeQuoteService_hollard_content' AND `verticalId` = '7');

DELETE FROM `ctm`.`service_properties` WHERE `serviceMasterId` IN (@HOME_BASE_MASTER_ID, @HOLLARD_INIT_MASTER_ID, @HOLLARD_QUOTE_MASTER_ID, @HOLLARD_CONTENT_MASTER_ID);

DELETE FROM `ctm`.`service_master` WHERE `verticalId` = '7' AND `erviceCode` IN ('homeQuoteService', 'homeQuoteService_hollard_init', 'homeQuoteService_hollard_quote', 'homeQuoteService_hollard_content');

*/