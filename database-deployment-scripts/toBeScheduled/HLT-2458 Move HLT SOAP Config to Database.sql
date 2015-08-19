-- New master services.
-- Dont need to add a new service_master as 'appService' exists for HLT so we will use this
-- INSERT INTO `ctm`.`service_master` (`verticalId`, `serviceCode`) VALUES ('4', 'appService');
SELECT * FROM ctm.service_master where verticalid = 4;

-- TODO Need to remove all of these entries and work out where they are needing to be changed in VITORS code
SELECT * FROM ctm.service_properties where servicemasterid = 150;
SELECT * FROM `ctm`.`service_master` where servicecode = 'applicationService';

-- Need to add the ability to put in Gateway details
ALTER TABLE `ctm`.`service_properties`
CHANGE COLUMN `scope` `scope` ENUM('GLOBAL','SERVICE','GATEWAY') NOT NULL ;


-- ----------------------
-- QUOTE SERVICE --
-- ----------------------

-- Set master id's to use for later inserts.
SET @HEALTH_QUOTE_BASE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'quoteService' AND `verticalId` = '4');

-- Global
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'merge-root', 'soap-response', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'config-dir', 'aggregator/health', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'error-dir', '/usr/aih/app-logs/ctm/WEB-INF/aggregator/health/errors', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_QUOTE_BASE_MASTER_ID, 'LOCALHOST', 0, 0, 'error-dir', 'aggregator/health/app-logs-errors', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'debug-dir', 'health/debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_QUOTE_BASE_MASTER_ID, 'LOCALHOST', 0, 0, 'debug-dir', 'health/app-logs-debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'validation-file', 'WEB-INF/xsd/health/healthQuoteResult.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL')

;

-- Service
-- Global
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_QUOTE_BASE_MASTER_ID, 'LOCALHOST', 0, 0, 'soap-url', 'http://localhost:8080/ctm/rating/health_price_service_PHIO.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, 'NXI', 0, 0, 'soap-url', 'http://127.0.0.1:8080/ctm/rating/health_price_service_PHIO.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, 'NXQ', 0, 0, 'soap-url', 'http://192.168.149.45/ctm/rating/health_price_service_PHIO.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, 'PRO', 0, 0, 'soap-url', 'https://ecommerce.disconline.com.au/ctm/rating/health_price_service_PHIO.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'outbound-xsl', 'PHIO_outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'outbound-xsl-parms', 'partnerId=CC00000001,sourceId=TEST000001', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'inbound-xsl', 'PHIO_inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'inbound-xsl-parms', 'defaultProductId=NODEFAULT,service=PHIO', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'timeoutMillis', '20000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, 'PRO', 0, 0, 'timeoutMillis', '60000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'serviceType', 'url-encoded', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 0, 'serviceName', 'PHIO', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),

-- This is to enable all of the providers
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 1, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 2, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 3, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 5, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 6, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 7, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 8, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 9, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 10, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 11, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 12, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 13, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 14, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 15, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 16, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_QUOTE_BASE_MASTER_ID, '0', 0, 54, 'status', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;


-- ----------------------
-- APPLICATION SERVICE --
-- ----------------------

-- Set master id's to use for later inserts.
SET @HEALTH_APP_BASE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'appService' AND `verticalId` = '4');

-- Global
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, 0, 'merge-root', 'soap-response', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, 0, 'merge-xsl', 'merge-results.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, 0, 'config-dir', 'aggregator/health_application', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, 0, 'error-dir', '/usr/aih/app-logs/ctm/WEB-INF/aggregator/health_application/errors', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, 0, 'error-dir', 'aggregator/health_application/app-logs-errors', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, 0, 'debug-dir', 'health_application/debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, 0, 'debug-dir', 'app-logs-debug', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GLOBAL')

;
-- -----
-- AU --
-- -----
SET @PROVIDERID = 1;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/AUF/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://sit-sales.b2b.health-insurance.australianunity.com.au/CompareTheMarket.Soap11', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'NXQ', 0, @PROVIDERID, 'soap-url', 'https://stage-sales.b2b.health-insurance.australianunity.com.au/CompareTheMarket.Soap11', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://sales.b2b.health-insurance.australianunity.com.au/CompareTheMarket.Soap11', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://ws.australianunity.com.au/B2B/Broker/ProcessApplication', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-action', 'auHealthRetailTasksPci.ws_b2bSalesService_Binder_ProcessApplication', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'NXI', 0, @PROVIDERID, 'ssl-no-host-verify', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'NXQ', 0, @PROVIDERID, 'ssl-no-host-verify', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'ssl-no-host-verify', 'Y', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'auf/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'auf/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'auf/maskRequestOut.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRespIn-xsl', 'ahm/maskRespIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'AUF', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- ------
-- HCF --
-- ------
SET @PROVIDERID = 2;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/HCF/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://www.uat.hcf.com.au/EAPP/EAPPService.svc/EnrolNewMember', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://www.hcf.com.au/EAPP/EAPPService.svc/EnrolNewMember', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'https://www.uat.hcf.com.au/EAPP/EAPPService.svc/EnrolNewMember', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'hcf/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl-parms', 'keycode=P@$$w0rd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'outbound-xsl-parms', 'keycode=C@oDm*T7M*', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'hcf/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'hcf/maskRequestOut.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'extract-element', 'GetHCFSaleInfo', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'HCF', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- ------
-- NIB --
-- ------
SET @PROVIDERID = 3;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/NIB/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://services-review.nib.com.au/brokertest/joinservice.asmx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://services.nib.com.au/asmx/broker/joinService.asmx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://www.nib.com.au/Broker/Gateway/Enrol', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'nib/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'nib/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl-parms', 'brokerId=45211,password=AD12890C-2BB3-4499-85C6-2F2849D64439', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'inbound-xsl-parms', 'brokerId=45249,password=AD12890C-2BB3-4499-85C6-2F2849D64439', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'nib/maskRequestOut.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRespIn-xsl', 'nib/maskRespIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'NIB', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- ------------
-- Peoplecare --
-- ------- -----
-- THIS IS NOT USED...

-- --------
-- GMHBA --
-- -------
SET @PROVIDERID = 5;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/GMH/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://staging.api.gmhba.com.au/SOAP/Membership.svc/basic', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://api.gmhba.com.au/soap/membership.svc/basic', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-user', 'Comparethemarket', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-password', 'y$ha6ESw', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://tempuri.org/IMembership/SubmitMembershipTransactionUsingSTP', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'gmh/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'gmh/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'maskRequestOutHSL.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'GMHBA', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')

;

-- ------
-- GMF --
-- ------
SET @PROVIDERID = 6;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/GMF/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://testservices.gmfhealth.com.au/Service.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://online.gmfhealth.com.au/Service.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-user', 'Compare', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-password', 'Gmfcompare', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-password', 'Compare12', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://HSL.OMS.Public.API.Service/IService/SubmitMembership', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'gmf/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl-parms', 'keyname=Compare,keycode=Temp1234', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'outbound-xsl-parms', 'keyname=Compare,keycode=Compare12', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'gmf/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'maskRequestOutHSL.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'GMF', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')

;
-- GATEWAY
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'gatewayProvider', 'NAB', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'gatewayURL', 'https://testservices.gmfhealth.com.au/NAB/GMF_CTM_IFrame.aspx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'gatewayURL', 'https://members.hif.com.au/NAB/HIF_CTM_Prod_IFrame.aspx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'domain', 'https://online.gmfhealth.com.au/NAB/GMF_CTM_Prod_IFrame.aspx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'domain', 'https://online.gmfhealth.com.au', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY')
;
-- -----------
-- WestFund --
-- ------------
SET @PROVIDERID = 7;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/WFD/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'http://localhost:8080/ctm/rating/health/health_submit_to_file_or_sftp.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'NXI', 0, @PROVIDERID, 'soap-url', 'http://127.0.0.1:8080/ctm/rating/health/health_submit_to_file_or_sftp.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'NXQ', 0, @PROVIDERID, 'soap-url', 'http://192.168.149.45/ctm/rating/health/health_submit_to_file_or_sftp.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://ecommerce.disconline.com.au/ctm/rating/health/health_submit_to_file_or_sftp.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-password', '90F69E9900595D86626B916E7DB698E078EDCC390D20693B93A58B12F7CD180B', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'wfd/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'wfd/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'wfd/maskRequestOut.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'WFD', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;
-- --------
-- Frank --
-- --------
SET @PROVIDERID = 8;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/FRA/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://staging.api.gmhba.com.au/soap/membership.svc/basic', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://api.gmhba.com.au/soap/membership.svc/basic', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-user', 'comparethemarket', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-password', 'y$ha6ESw', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://tempuri.org/IMembership/SubmitMembershipTransactionUsingSTP', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'fra/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'fra/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'maskRequestOutHSL.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'FRA', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- ------
-- AHM --
-- ------
SET @PROVIDERID = 9;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/AHM/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://webagdev.ahm.com.au/WHICSServices/MembershipService.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://webag.ahm.com.au/WHICSServices/MembershipService.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'content-type', 'application/soap+xml; charset=utf-8', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'ahm/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'ahm/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'ahm/maskRequestOut.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRespIn-xsl', 'ahm/maskRespIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'AHM', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;
-- GATEWAY
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'gatewayProvider', 'Westpac', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'tokenUrl', 'https://quickstream.support.qvalent.com/CommunityTokenRequestServlet', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'tokenUrl', 'https://ws.qvalent.com/services/quickweb/CommunityTokenRequestServlet', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'username', 'AHMG', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'password', 'AHMG', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'password', 'K47731xVM', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'registerUrl', 'https://quickstream.support.qvalent.com/AccountRegistrationServlet', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'registerUrl', 'https://quickweb.westpac.com.au/AccountRegistrationServlet', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'cd_community', 'AHMG', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'cd_supplier_business', 'CTM', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'cd_supplier_business', 'AGG', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY')
;

-- -------
-- CBHS --
-- -------
SET @PROVIDERID = 10;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/CBBH/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://helper.cbhs.com.au/Test/CompareTheMarket/xmlapp.asp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://helper.cbhs.com.au/CompareTheMarket/xmlapp.asp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'cbh/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'cbh/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'cbh/maskRequestOut.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'CBH', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- ------
-- HIF --
-- ------
SET @PROVIDERID = 11;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/HIF/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://testservices.hif.com.au/Service.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://members.hif.com.au/Service.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://HSL.OMS.Public.API.Service/IService/SubmitMembership', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'hif/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl=parms', 'keyname=CompareTM,keycode=Compare', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'outbound-xsl=parms', 'keyname=CompareTM,keycode=Compare456', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'hif/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl-parms', 'bccEmail=ctm.test@hif.com.au', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'inbound-xsl-parms', 'bccEmail=ctm@hif.com.au', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'maskRequestOutHSL.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'content-type', 'application/soap+xml; charset=utf-8', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'HIF', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;
-- GATEWAY
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'gatewayProvider', 'NAB', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'gatewayURL', 'https://testservices.hif.com.au/NAB/HIF_CTM_IFrame.aspx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'gatewayURL', 'https://members.hif.com.au/NAB/HIF_CTM_Prod_IFrame.aspx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'domain', 'https://testservices.hif.com.au', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'domain', 'https://members.hif.com.au', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY')
;

-- ------
-- CUA --
-- ------
SET @PROVIDERID = 12;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/CUA/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://testservices.cuahealth.com.au/Service.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://onlineservices.cuahealth.com.au/Service.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://HSL.OMS.Public.API.Service/IService/SubmitMembership', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'cua/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl-parms', 'keyname=Choosi,keycode=Choosi17', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'NXS', 0, @PROVIDERID, 'outbound-xsl-parms', 'keyname=Choosi,keycode=CTM27ctm', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'outbound-xsl-parms', 'keyname=CTM,keycode=CTM27ctm', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'cua/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'maskRequestOutHSL.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'CUA', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;
-- GATEWAY
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'gatewayProvider', 'NAB', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'gatewayURL', 'https://testservices.cuahealth.com.au/NAB/CUA_CTM_IFrame.aspx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'gatewayURL', 'https://onlineservices.cuahealth.com.au/NAB/CUA_CTM_Prod_IFrame.aspx', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'domain', 'https://testservices.cuahealth.com.au', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'domain', 'https://onlineservices.cuahealth.com.au', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY')
;
-- ------
-- THF --
-- ------
SET @PROVIDERID = 13;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/THF/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://devservices.teachershealth.com.au/Service.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://online.teachershealth.com.au/Service.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://HSL.OMS.Public.API.Service/IService/SubmitMembershipSTP', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'thf/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl-parms', 'keyname=HFAPctm,keycode=Teachers1', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'outbound-xsl-parms', 'keyname=HFAPctm,keycode=wNxEdqyX', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'thf/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'maskRequestOutHSL.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'THF', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- ------
-- CtM --
-- ------
SET @PROVIDERID = 14;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/CTM/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'soap-url', 'http://localhost:8080/ctm/rating/health/health_submit_to_file_or_sftp.jsp', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'soap-password', 'test', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'outbound-xsl', 'ctm/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'inbound-xsl', 'ctm/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'maskRequestOut-xsl', 'ctm/maskRequestOut.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'serviceName', 'AUF', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;
-- GATEWAY
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'gatewayProvider', 'NAB', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'gatewayURL', 'external/hambs/mockPaymentGateway.html', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'NXI', 0, @PROVIDERID, 'gatewayURL', 'external/hambs/mockPaymentGateway.html', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'domain', 'http://localhost:8080', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY'),
(@HEALTH_APP_BASE_MASTER_ID, 'NXI', 0, @PROVIDERID, 'domain', 'http://nxi.secure.comparethemarket.com.au', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'GATEWAY')
;
-- -------
-- Bupa --
-- -------
SET @PROVIDERID = 15;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/BUP/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://ctmtest.bupa.com.au:446/CompareTheMarket.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://ctm.bupa.com.au:446/CompareTheMarket.svc', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'content-type', 'application/soap+xml; charset=utf-8', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'bup/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'bup/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'maskRequestOutHSL.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'BUP', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- -------
-- QCHF --
-- -------
SET @PROVIDERID = 16;


-- ---------
-- BUDGET --
-- ---------
SET @PROVIDERID = 54;
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'validation-file', 'WEB-INF/xsd/health/BUD/healthApplication.xsd', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-url', 'https://staging.api.gmhba.com.au/SOAP/Membership.svc/basic', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-url', 'https://api.gmhba.com.au/SOAP/membership.svc/basic', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-user', 'comparethemarket', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-password', 'y$ha6ESw', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'soap-action', 'http://tempuri.org/IMembership/SubmitMembershipTransactionUsingSTP', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'outbound-xsl', 'bud/outbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'inbound-xsl', 'bud/inbound.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestIn-xsl', 'maskRequestIn.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'maskRequestOut-xsl', 'maskRequestOutHSL.xsl', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'timeoutMillis', '240000', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceType', 'soap', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@HEALTH_APP_BASE_MASTER_ID, '0', 0, @PROVIDERID, 'serviceName', 'BUD', '2015-08-06 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;






-- Rollback
-- NOTES: Must run in this order (delete service properties before service master.), if you delete the master items first it will be harder to delete then service properties.
/*
SET @HEALTH_APP_BASE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` where `serviceCode` = 'appSerivce' AND `verticalId` = '4');

DELETE FROM `ctm`.`service_properties` WHERE `serviceMasterId` = @HEALTH_APP_BASE_MASTER_ID;

DELETE FROM `ctm`.`service_master` WHERE `verticalId` = '4' AND `serviceCode` IN ('appService');

*/