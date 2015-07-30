SET @TRAVEL_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'TRAVEL');
INSERT INTO ctm.service_master (verticalId, serviceCode, description) VALUES (@TRAVEL_VERTICAL_ID, 'travelQuoteService', '');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@TRAVEL_VERTICAL_ID AND serviceCode='travelQuoteService');

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, 0, '0', 0, 'serviceUrl','http://localhost:9080','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXI', 0, 'serviceUrl','http://127.0.0.1:8080/travel-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXS', 0, 'serviceUrl','http://127.0.0.1:8080/travel-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXQ', 0, 'serviceUrl','http://taws01_ass2:8080/travel-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'PRO', 0, 'serviceUrl','http://ecommerce.disconline.com.au:8080/travel-quote','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@SERVICE_MASTER_ID, 0, '0', 0, 'debugPath','travel/debug', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXI', 0, 'debugPath','travel/debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXS', 0, 'debugPath','travel/debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'NXQ', 0, 'debugPath','travel/debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'),
  (@SERVICE_MASTER_ID, 0, 'PRO', 0, 'debugPath','travel/app-logs-debug','2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');

SELECT * FROM service_properties where serviceMasterId = 151;
select * from ctm.service_master where serviceCode = 'travelQuoteService';