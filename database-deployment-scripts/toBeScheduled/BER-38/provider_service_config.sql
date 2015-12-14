SET @ENERGY_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'UTILITIES');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@ENERGY_VERTICAL_ID AND serviceCode='resultsService');

INSERT INTO ctm.provider_master (`providerCode`, `Name`, `EffectiveStart`, `EffectiveEnd`) VALUES ('TWLD', 'Thought World', '2015-01-01', '2040-12-31');
SET @PROVIDER_ID = (SELECT providerId FROM ctm.provider_master WHERE providerCode = 'TWLD');

INSERT INTO ctm.service_properties (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES
  (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'serviceName', 'TWLD', '2015-01-01', '2040-12-31', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'serviceType', 'soap', '2015-01-01', '2040-12-31', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'url', 'http://www.utilityworld.com.au/comparethemarket/response/results_lookup_response_new.php', '2015-01-01', '2040-12-31', 'SERVICE'),
  (@SERVICE_MASTER_ID, 'PRO', '0', @PROVIDER_ID, 'url', 'https://www.utilityworld.com.au/comparethemarket/api/response/results_lookup_response_new.php', '2015-01-01', '2040-12-31', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'timeout', '20', '2015-01-01', '2040-12-31', 'SERVICE'),
  (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'errorProductCode', 'TWLD-ERR', '2015-01-01', '2040-12-31', 'SERVICE');