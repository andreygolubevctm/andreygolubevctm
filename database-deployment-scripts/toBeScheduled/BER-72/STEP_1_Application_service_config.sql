-- All in ctm
USE ctm;


-- New master services.
SET @APPLY_SERVICE = 'applyService';
SET @VERTICAL_ID = (SELECT verticalId FROM vertical_master WHERE verticalCode = 'UTILITIES');

-- Set master id's to use for later inserts.
SET @STARTDATE = '2015-09-09';
SET @ENDDATE = '2038-01-19';
SET @SERVICE_NAME = 'TWLD';
SET @PROVIDERID = (SELECT providerId FROM ctm.provider_master WHERE providerCode = @SERVICE_NAME  LIMIT 1);
WHERE providerCode = 'TWLD';

INSERT INTO `ctm`.`provider_properties` (`ProviderId`, `PropertyId`, `Text`, `EffectiveStart`, `EffectiveEnd`) VALUES ( @PROVIDERID, 'FundCode', @SERVICE_NAME, '2011-03-01', '2040-12-31');
INSERT INTO service_master (verticalId, serviceCode) VALUES (@VERTICAL_ID, @APPLY_SERVICE);
SET @APP_BASE_MASTER_ID = (SELECT serviceMasterId FROM service_master where serviceCode = @APPLY_SERVICE AND verticalId = @VERTICAL_ID);
-- ----------------------
-- APPLICATION SERVICE --
-- ----------------------

-- -----
-- TWLD --
-- -----
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'http://www.utilityworld.com.au/comparethemarket/response/application_response.php', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://www.utilityworld.com.au/comparethemarket/api/response/application_response.php', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'TWLD-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '20000', @STARTDATE, @ENDDATE, 'SERVICE')
;
-- ------------------------------------------
-- Rollback --
/*
USE ctm;
SET @APPLY_SERVICE = 'applyService';
SET @VERTICAL_ID = (SELECT verticalId FROM vertical_master WHERE verticalCode = 'UTILITIES');
SET @APP_BASE_MASTER_ID = (SELECT serviceMasterId FROM service_master where serviceCode = @APPLY_SERVICE AND verticalId = @VERTICAL_ID);

DELETE FROM service_properties WHERE serviceMasterId = @APP_BASE_MASTER_ID;

DELETE FROM service_master WHERE verticalId = @VERTICAL_ID AND serviceCode = @APPLY_SERVICE;

 */


-- Rollback
-- NOTES: Must run in this order (delete service properties before service master.), if you delete the master items first it
--  will be harder to delete then service properties.
/*
SET @APP_BASE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master where serviceCode = 'appService' AND verticalId = @VERTICAL_ID);

DELETE FROM ctm.service_properties WHERE serviceMasterId = @APP_BASE_MASTER_ID;

DELETE FROM ctm.service_master WHERE verticalId = @VERTICAL_ID AND serviceCode IN (@APPLY_SERVICE);

*/