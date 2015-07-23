UPDATE ctm.provider_master SET providerCode = 'AGCH' WHERE name = 'Auto and General Car Choosi';

SET @CAR_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'CAR');
INSERT INTO ctm.service_master (verticalId, serviceCode) VALUES (@CAR_VERTICAL_ID, 'carServiceBER');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@CAR_VERTICAL_ID AND serviceCode='carServiceBER');

-- First for Women
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='1FOW' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_1FOW','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','1FOW-05-02','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',1,'outboundParams','partnerId=CTM0000003,sourceId=0000000003','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','partnerId=CC00000001,sourceId=0000000003','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'outboundParams','partnerId=CHI0000001,sourceId=0000000003','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- AI
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='AI' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'outboundParams','quoteType=GetMultiPremium,subPartnerCode=CTM,agentCode=CTM,productQuoted=ELEGANT;CLASSICSB;ELEGANTPL;TRADIESURE;TRADIESUREPL','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'inboundParams','quoteURL=https://dev.aiinsurance.com.au/buy/disclosure/','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','AI-01-01','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AI','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'sslNoHostVerify','Y','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','http://support.aiinsurance.com.au/SSGatewayTest/SSGateway.asmx','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'user','AUTOANDGEN','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'password','Aut0andG3n','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'LOCALHOST',0,'sslNoHostVerify','N','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://b2b.aiinsurance.com.au/SSGateway/SSGateway.asmx','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'inboundParams','defaultProductId=AI-01-01,quoteURL=https://secure.aiinsurance.com.au/buy/disclosure/','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','quoteType=GetMultiPremium,subPartnerCode=AUTOANDGENWEB,agentCode=AUTOANDGENWEB,productQuoted=ELEGANT;TRADIESURE;TRADIESUREPL','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'outboundParams','quoteType=GetMultiPremium,subPartnerCode=CTM,agentCode=CTM,productQuoted=ELEGANT;CLASSICSB;ELEGANTPL;TRADIESURE;TRADIESUREPL','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'user','CHOOSI','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'password','Ch0o51','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- EXPO
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='EXPO' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_EXPO','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','EXPO-05-16','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',1,'outboundParams','partnerId=CTM0000003,sourceId=0000000008','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','partnerId=CC00000001,sourceId=0000000008','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- Budget direct
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='BUDD' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_BUDD','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','BUDD-05-04','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',1,'outboundParams','partnerId=CTM0000003,sourceId=0000000001','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','partnerId=CC00000001,sourceId=0000000001','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'outboundParams','partnerId=CHI0000001,sourceId=0000000001','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- CBCK
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='CBCK' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_CBCK','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','CBCK-05-08','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',1,'outboundParams','partnerId=CTM0000003,sourceId=0000000006','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','partnerId=CC00000001,sourceId=0000000006','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- IECO
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='IECO' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_IECO','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','IECO-05-09','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',1,'outboundParams','partnerId=CTM0000003,sourceId=0000000002','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','partnerId=CC00000001,sourceId=0000000002','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- OZIC
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='OZIC' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_OZIC','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','OZIC-05-01','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',1,'outboundParams','partnerId=CTM0000003,sourceId=0000000007','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','partnerId=CC00000001,sourceId=0000000007','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'outboundParams','partnerId=CHI0000001,sourceId=0000000007','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- REAL
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='REAL' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://everyonesit.realinsurance.com.au/v2/AggregatorService.svc','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','REIN','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','REIN-01-02','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'outboundParams','keyname=ctmpp01,keypass=14lC(MWg,siteKey=CompareTheMarketBaseAgg','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://everyone.realinsurance.com.au/v2/AggregatorService.svc','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'outboundParams','keyname=ctmprod01,keypass=%^56tgBy,siteKey=CompareTheMarketBaseAgg','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','keyname=srvcapcpp01,keypass=Sf072ry!,siteKey=RealBaseCaptainCompare','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',3,'outboundParams','keyname=srvcapcprd01,keypass=bSVAx.He,siteKey=RealBaseCaptainCompare','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'outboundParams','keyname=srvchoopp01,keypass=emkBjY+M,siteKey=RealBaseChoosi','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',8,'outboundParams','keyname=srvchooprd01,keypass=2fWCd@jz,siteKey=RealBaseChoosi','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- RETI
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='RETI' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_RETI','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','RETI-05-03','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',1,'outboundParams','partnerId=CTM0000003,sourceId=0000000005','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','partnerId=CC00000001,sourceId=0000000005','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- VIRG
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='VIRG' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_VIRG','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','VIRG-05-17','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',1,'outboundParams','partnerId=CTM0000003,sourceId=0000000004','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',3,'outboundParams','partnerId=CC00000001,sourceId=0000000004','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- WOOL
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='WOOL' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','WOOL-01-02','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://everyonesit.realinsurance.com.au/v2/AggregatorService.svc','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','WOOL','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'outboundParams','keyname=ctmpp01,keypass=14lC(MWg,siteKey=WoolworthsBaseCTM','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'outboundParams','keyname=ctmprod01,keypass=%^56tgBy,siteKey=WoolworthsBaseCTM','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://everyone.realinsurance.com.au/v2/AggregatorService.svc','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- EXDD
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='EXDD' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceName','AGIS_EXDD','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'outboundParams','partnerId=CTM0000003,sourceId=0000000009','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'errorProductCode','EXDD-05-04','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',0,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',0,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',0,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- CHOOSI
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='AGCH' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'serviceName','AGIS_CHOO','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'outboundParams','partnerId=CHI0000002,sourceId=0000000001','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'serviceType','soap','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'errorProductCode','BUDD-05-04','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'soapUrl','https://nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, '0',8,'inboundParams','defaultProductList=BUDD@BUDD-05-04|1FOW@1FOW-05-02|OZIC@OZIC-05-01','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXI',8,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXS',8,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'NXQ',8,'soapUrl','https://services-nxq.ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, @PROVIDER_ID, 'PRO',8,'soapUrl','https://ecommerce.disconline.com.au/services/3.2/getCarQuotes','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- ServiceUrl for web_ctm

SET @CAR_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'CAR');
INSERT INTO ctm.service_master (verticalId, serviceCode) VALUES (@CAR_VERTICAL_ID, 'carQuoteServiceBER');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@CAR_VERTICAL_ID AND serviceCode='carQuoteServiceBER');

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, 0, '0', 0, 'serviceUrl','http://localhost:9081','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXI', 0, 'serviceUrl','http://127.0.0.1:8080/car-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXS', 0, 'serviceUrl','http://127.0.0.1:8080/car-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXQ', 0, 'serviceUrl','http://taws01_ass2:8080/car-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'PRO', 0, 'serviceUrl','http://ecommerce.disconline.com.au:8080/car-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, '0', 0, 'timeoutMillis','40000','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
  ;

-- Rollback
-- SET @CAR_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'CAR');
-- SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@CAR_VERTICAL_ID AND serviceCode='carQuoteServiceBER');
-- DELETE FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID;
--
-- DELETE FROM ctm.service_master WHERE verticalId=@CAR_VERTICAL_ID AND serviceCode='carQuoteServiceBER';
--
-- SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@CAR_VERTICAL_ID AND serviceCode='carServiceBER');
-- DELETE FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID;
--
-- DELETE FROM ctm.service_master WHERE verticalId=@CAR_VERTICAL_ID AND serviceCode='carServiceBER';
--
-- UPDATE ctm.provider_master SET providerCode = null WHERE name = 'Auto and General Car Choosi';


