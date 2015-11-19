SET @ENERGY_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'UTILITIES');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@ENERGY_VERTICAL_ID AND serviceCode='resultsService');

INSERT INTO ctm.provider_master (`providerCode`, `Name`, `EffectiveStart`, `EffectiveEnd`) VALUES ('TWLD', 'Thought World', '2015-01-01', '2040-12-31');
SET @PROVIDER_ID = (SELECT providerId FROM ctm.provider_master WHERE providerCode = 'TWLD');
SET @RESULTS_SERVICE_URL = (SELECT servicePropertyValue FROM ctm.service_properties WHERE serviceMasterId=@SERVICE_MASTER_ID AND servicePropertyKey = 'serviceUrl');

INSERT INTO ctm.service_properties (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
  (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'serviceName', 'TWLD', '2015-01-01', '2040-12-31', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'serviceType', 'soap', '2015-01-01', '2040-12-31', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'url', @RESULTS_SERVICE_URL, '2015-01-01', '2040-12-31', 'SERVICE');