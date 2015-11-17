SET @pid:= (SELECT providerId FROM ctm.provider_master WHERE providerCode = 'WOOL');

DELETE FROM `ctm`.`car_product_features` WHERE `carProductContentId` IN (SELECT `carProductContentId` FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveStart = '2015-11-27' AND effectiveEnd = '2040-12-31');

-- SELECT count(*) FROM `ctm`.`car_product_features` WHERE `carProductContentId` IN (SELECT `carProductContentId` FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveStart = '2015-11-27' AND effectiveEnd = '2040-12-31');
-- TEST RESULT AFTER DELETE: 0

UPDATE `ctm`.`car_product_features`  SET effectiveEnd = '2040-12-31' WHERE carProductContentId IN ( SELECT `carProductContentId` FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveStart = '2011-03-01' AND effectiveEnd = '2015-11-26');


-- SELECT count(*) FROM `ctm`.`car_product_features` WHERE carProductContentId IN ( SELECT `carProductContentId` FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveStart = '2011-03-01' AND effectiveEnd = '2040-12-31');
-- TEST RESULT AFTER UPDATE: 32

DELETE FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveStart = '2015-11-27' AND effectiveEnd = '2040-12-31' LIMIT 2;

-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveStart = '2015-11-27' AND effectiveEnd = '2040-12-31';
-- TEST RESULT AFTER DELETE: 0

UPDATE `ctm`.`car_product_content` SET effectiveEnd = '2040-12-31' WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) 
AND effectiveStart = '2011-03-01' AND effectiveEnd = '2015-11-26';

-- SELECT * FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveStart = '2011-03-01' AND effectiveEnd = '2040-12-31';
-- TEST RESULT AFTER UPDATE: 2