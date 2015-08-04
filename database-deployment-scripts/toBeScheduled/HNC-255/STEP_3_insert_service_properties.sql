SET @HOME_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HOME');
INSERT INTO ctm.service_master (verticalId, serviceCode) VALUES (@HOME_VERTICAL_ID, 'homeServiceBER');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@HOME_VERTICAL_ID AND serviceCode='homeServiceBER');

SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='BUDD' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_BUDD','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'outboundParams','partnerId=CTM0000100,sourceId=0000000001,schemaVersion=3.2','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'outboundParams','partnerId=CHI0000100,sourceId=0000000001,schemaVersion=3.2','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','BUDD-05-29','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://services.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE');

SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='VIRG' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_VIRG','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'outboundParams','partnerId=CTM0000100,sourceId=0000000002,schemaVersion=3.2','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','VIRG-05-26','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://services.ecommerce.disconline.com.au/services/3.2/gethomeQuotes','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE');

SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='REAL' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','REIN','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'outboundParams','keyname=ctmpp01,keypass=14lC(MWg,siteKey=RealHomeBaseCTM','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'outboundParams','keyname=srvchoopp01,keypass=emkBjY+M,siteKey=RealBaseHomeChoosi','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','REIN-02-01','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://everyonesit.realinsurance.com.au/v2/AggregatorService.svc','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://everyone.realinsurance.com.au/v2/AggregatorService.svc','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'outboundParams','keyname=ctmprod01,keypass=%^56tgBy,siteKey=RealHomeBaseCTM','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',8,'outboundParams','keyname=srvchooprd01,keypass=2fWCd@jz,siteKey=RealBaseHomeChoosi','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE');

SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='WOOL' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','WOOL','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'outboundParams','keyname=ctmpp01,keypass=14lC(MWg,siteKey=WoolworthsHomeBaseCTM','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','WOOL-02-01','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://everyonesit.realinsurance.com.au/v2/AggregatorService.svc','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://everyone.realinsurance.com.au/v2/AggregatorService.svc','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'outboundParams','keyname=ctmprod01,keypass=%^56tgBy,siteKey=WoolworthsHomeBaseCTM','2014-01-01 00:00:00','2038-01-19 00:00:00', 'SERVICE');

-- ServiceUrl for web_ctm

SET @HOME_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HOME');
INSERT INTO ctm.service_master (verticalId, serviceCode) VALUES (@HOME_VERTICAL_ID, 'homeQuoteServiceBER');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@HOME_VERTICAL_ID AND serviceCode='homeQuoteServiceBER');

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, 0, '0', 0, 'serviceUrl','http://localhost:9082','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXI', 0, 'serviceUrl','http://127.0.0.1:8080/home-contents-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXS', 0, 'serviceUrl','http://127.0.0.1:8080/home-contents-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXQ', 0, 'serviceUrl','http://taws01_ass2:8080/home-contents-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'PRO', 0, 'serviceUrl','http://ecommerce.disconline.com.au:8080/home-contents-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, '0', 0, 'timeoutMillis','40000','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, '0', 0, 'debugPath','home/debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'PRO', 0, 'debugPath','home/app-logs-debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
  ;

-- Rollback
-- SET @HOME_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HOME');
-- SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@HOME_VERTICAL_ID AND serviceCode='homeQuoteServiceBER');
-- DELETE FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID;
--
-- DELETE FROM ctm.service_master WHERE verticalId=@HOME_VERTICAL_ID AND serviceCode='homeQuoteServiceBER';
--
-- SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@HOME_VERTICAL_ID AND serviceCode='homeServiceBER');
-- DELETE FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID;
--
-- DELETE FROM ctm.service_master WHERE verticalId=@HOME_VERTICAL_ID AND serviceCode='homeServiceBER';