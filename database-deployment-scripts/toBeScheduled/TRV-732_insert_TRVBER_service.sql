
INSERT INTO ctm.service_master (verticalId, serviceCode) VALUES ('2', 'quoteServiceBER');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=2 AND serviceCode='quoteServiceBER');

-- 1FOW
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='1FOW' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', '1FOW', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'soap', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'url', 'https://nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'soapAction', 'https://nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'outboundParams', 'partnerId=CTM0000200,sourceId=0000000002,schemaVersion=3.1', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'inboundParams', 'defaultProductId=NODEFAULT,service=1FOW', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'NXI', 0, @PROVIDER_ID, 'url', 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'NXI', 0, @PROVIDER_ID, 'soapAction', 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'NXS', 0, @PROVIDER_ID, 'url', 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'NXS', 0, @PROVIDER_ID, 'soapAction', 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'NXQ', 0, @PROVIDER_ID, 'url', 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'NXQ', 0, @PROVIDER_ID, 'soapAction', 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'url', 'https://ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'soapAction', 'https://ecommerce.disconline.com.au/services/3.1/getTravelQuotes', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- ZUJI
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='ZUJI' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'ZUJI', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'soap', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'outboundParams', '', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'inboundParams', 'defaultProductId=NODEFAULT,service=ZUJI,quoteUrl=https://uat-zuji.agaassistance.com.au', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'password', 'F7AT8v57udgE5rx', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'user', 'CtM', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'clientCode', 'ZUJIAU', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXI', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXS', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXQ', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'inboundParams', 'defaultProductId=NODEFAULT,service=ZUJI,quoteUrl=https://www.zuji.com.au/insurance', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'url', 'https://pricingapi.agaassistance.com.au/api/quickquote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- WEBJET webservice
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='WEBJ' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'WEBJ', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'soap', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'outboundParams', '', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'inboundParams', 'defaultProductId=NODEFAULT,service=WEBJ,quoteUrl=https://uat-webjetau.agaassistance.com.au', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'password', 'F7AT8v57udgE5rx', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'user', 'CtM', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'clientCode', 'WEBJAU', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXI', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXS', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXQ', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'inboundParams', 'defaultProductId=NODEFAULT,service=WEBJ,quoteUrl=https://www.webjet.com.au/insurance', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'url', 'https://pricingapi.agaassistance.com.au/api/quickquote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- VIRGIN Webservice
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='VIRG' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'VIRG', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'soap', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'outboundParams', '', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'inboundParams', 'defaultProductId=NODEFAULT,service=VIRJ,quoteUrl=https://uat-aspire.agaassistance.com.au/virginmoney/', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'password', 'F7AT8v57udgE5rx', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'user', 'CtM', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'clientCode', 'VMON', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXI', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXS', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'NXQ', 0, @PROVIDER_ID, 'url', 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'inboundParams', 'defaultProductId=NODEFAULT,service=VIRG,quoteUrl=https://www.virginmoney.com.au', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'url', 'https://pricingapi.agaassistance.com.au/api/quickquote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- EASY
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='EASY' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'EASY', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- FAST
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='FAST' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'FAST', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- I4LS
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='I4LS' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'I4LS', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- INGO
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='INGO' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'INGO', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- REAL
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='REAL' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'REAL', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- SCTI
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='SCTI' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'SCTI', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'url', 'http://pp1.scti.com.au/979230', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'NXI', 0, @PROVIDER_ID, 'url', 'http://pp3.scti.com.au/quote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'NXQ', 0, @PROVIDER_ID, 'url', 'http://pp3.scti.com.au/quote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'url', 'http://www.scti.com.au/quote', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- STIN
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='STIN' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'STIN', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'url', 'uat.simplytravelinsurance.com.au', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 'PRO', 0, @PROVIDER_ID, 'url', 'www.simplytravelinsurance.com.au', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- TINZ
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='TINZ' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'TINZ', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- WLDC
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='WLDC' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'WLDC', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- WOOL
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='WOOL' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceName', 'WOOL', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'serviceType', 'db', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

/* ROLLBACK

SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=2 AND serviceCode='quoteServiceBER');

DELETE FROM ctm.service_properties WHERE serviceMasterId=@SERVICE_MASTER_ID;
DELETE FROM ctm.service_master WHERE serviceMasterId=@SERVICE_MASTER_ID;

*/