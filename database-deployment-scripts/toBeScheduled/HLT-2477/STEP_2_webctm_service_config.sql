SET @HEALTH_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HEALTH');
INSERT INTO ctm.service_master (verticalId, serviceCode) VALUES (@HEALTH_VERTICAL_ID, 'healthServiceBER');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@HEALTH_VERTICAL_ID AND serviceCode='healthServiceBER');

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, 0, '0', 0, 'serviceUrl','http://localhost:9083','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXI', 0, 'serviceUrl','http://127.0.0.1:8080/health-apply','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXS', 0, 'serviceUrl','http://127.0.0.1:8080/health-apply','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXQ', 0, 'serviceUrl','http://taws01_ass2:8080/health-apply','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'PRO', 0, 'serviceUrl','http://ecommerce.disconline.com.au:8080/health-apply','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, '0', 0, 'timeoutMillis','20000','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, '0', 0, 'debugPath','health/debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'PRO', 0, 'debugPath','health/app-logs-debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE')
  ;

-- Rollback
-- SET @HEALTH_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HEALTH');
-- SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@HEALTH_VERTICAL_ID AND serviceCode='healthQuoteServiceBER');
-- DELETE FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID;
--
-- DELETE FROM ctm.service_master WHERE verticalId=@HEALTH_VERTICAL_ID AND serviceCode='healthQuoteServiceBER';