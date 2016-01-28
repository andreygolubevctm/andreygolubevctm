SET @SERVICE_CODE = 'contactValidatorService';

-- should return 0 results
SELECT * FROM ctm.service_master WHERE serviceCode = @SERVICE_CODE;

INSERT INTO ctm.service_master (`verticalId`, `serviceCode`) VALUES (0, @SERVICE_CODE);

-- should return 1 results
SELECT * FROM ctm.service_master WHERE serviceCode = @SERVICE_CODE;

SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=0 AND serviceCode=@SERVICE_CODE);

-- should return 0 results
SELECT * FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID;

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
(@SERVICE_MASTER_ID, 0, '0', 0, 'serviceUrl','http://localhost:9087','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 0, 'NXI', 0, 'serviceUrl','http://127.0.0.1:8080/contact-validator','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 0, 'NXS', 0, 'serviceUrl','http://127.0.0.1:8080/contact-validator','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 0, 'NXQ', 0, 'serviceUrl','http://taws01_ass2:8080/contact-validator','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 0, 'PRO', 0, 'serviceUrl','http://ecommerce.disconline.com.au:8080/contact-validator','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 0, '0', 0, 'timeoutMillis','300000','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 0, '0', 0, 'debugPath','contactValidator/debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
(@SERVICE_MASTER_ID, 0, 'PRO', 0, 'debugPath','contactValidator/app-logs-debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

-- should return 8 results
SELECT * FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID;

-- ROLLBACK
-- SET @SERVICE_CODE = 'contactValidatorService';
-- SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=0 AND serviceCode=@SERVICE_CODE);
-- DELETE FROM ctm.service_properties WHERE serviceMasterId = @SERVICE_MASTER_ID;
-- DELETE FROM ctm.service_master WHERE serviceMasterId = @SERVICE_MASTER_ID;