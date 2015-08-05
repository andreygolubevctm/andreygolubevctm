SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=2 AND serviceCode='quoteServiceBER');

-- EASY
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='EASY' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'EASY-TRAVEL-22', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- I4LS
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='I4LS' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'I4LS-TRAVEL-90', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- INGO
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='INGO' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'INGO-TRAVEL-70', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- REAL
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='REAL' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'REAL-TRAVEL-211', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- SCTI
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='SCTI' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'SCTI-TRAVEL-193', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- STIN
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='STIN' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'STIN-TRAVEL-144', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- WLDC
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='WLDC' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'WLDC-TRAVEL-9', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- WOOL
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='WOOL' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'WOOL-TRAVEL-188', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- TSAV
SET @PROVIDER_ID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='TSAV' AND status<>'X');
INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, '0', 0, @PROVIDER_ID, 'errorProductCode', 'TSAV-TRAVEL-164', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
;

-- ROLLBACK
-- SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=2 AND serviceCode='quoteServiceBER');
--
-- DELETE FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'errorProductCode' and providerId in
-- (SELECT providerId FROM ctm.provider_master WHERE providerCode in ('EASY', 'I4LS', 'INGO', 'REAL', 'SCTI', 'STIN', 'WLDC', 'WOOL', 'TSAV'));