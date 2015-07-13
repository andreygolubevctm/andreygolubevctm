SET @CAR_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'CAR');

INSERT INTO ctm.configuration (configCode, environmentCode, styleCodeId, verticalId, configValue) VALUES
	('quoteBackendUrl', '0', 0, @CAR_VERTICAL_ID, 'http://localhost:9081'),
	('quoteBackendUrl', 'NXI', 0, @CAR_VERTICAL_ID, 'http://127.0.0.1:8080/car-quote'),
	('quoteBackendUrl', 'NXS', 0, @CAR_VERTICAL_ID, 'http://127.0.0.1:8080/car-quote'),
	('quoteBackendUrl', 'NXQ', 0, @CAR_VERTICAL_ID, 'http://taws01_ass2:8080/car-quote'),
	('quoteBackendUrl', 'PRO', 0, @CAR_VERTICAL_ID, 'http://ecommerce.disconline.com.au:8080/car-quote');

-- Rollback
-- SET @CAR_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'CAR');
--
-- DELETE FROM ctm.configuration WHERE verticalId = @CAR_VERTICAL_ID AND configCode = 'quoteBackendUrl';