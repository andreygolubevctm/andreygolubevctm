UPDATE `ctm`.`product_master` SET `EffectiveEnd`='2040-12-31' WHERE `ProductId` IN (68, 69);
-- Test. Should return 2 
-- SELECT count(ProductId) AS total FROM `ctm`.`product_master` WHERE `EffectiveEnd`='2040-12-31' AND `ProductId` IN (68,69);


DELETE * FROM `ctm`.`product_master` WHERE providerId = 294 AND `ProductId` IN (256);
-- Test. Should return 0
-- SELECT count(ProductId) AS total FROM `ctm`.`product_master` WHERE providerId = 294 AND `ProductId` IN (256);