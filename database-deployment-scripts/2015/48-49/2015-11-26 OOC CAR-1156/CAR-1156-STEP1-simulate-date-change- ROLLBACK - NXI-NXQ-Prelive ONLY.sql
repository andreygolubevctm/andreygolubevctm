SET @pid:= (SELECT providerId FROM ctm.provider_master WHERE providerCode = 'WOOL');

UPDATE `ctm`.`car_product_features` SET effectiveStart = '2015-11-27' WHERE `carProductContentId` IN (SELECT `carProductContentId` FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid)) AND effectiveEnd = '2040-12-31' LIMIT 32;
UPDATE `ctm`.`car_product_features` SET effectiveEnd = '2015-11-26' WHERE `carProductContentId` IN (SELECT `carProductContentId` FROM `ctm`.`car_product_content` WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid)) AND effectiveStart = '2011-03-01' LIMIT 32;

UPDATE `ctm`.`car_product_content` SET effectiveEnd = '2015-11-26' WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveStart = '2011-03-01'LIMIT 2;
UPDATE`ctm`.`car_product_content` SET effectiveStart = '2015-11-27' WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveEnd = '2040-12-31'  LIMIT 2;