UPDATE `ctm`.`product_master` SET `EffectiveEnd`='2040-12-31' WHERE `ProductId` IN (217, 216, 215, 214, 155, 154, 153, 152, 151, 150, 149, 148, 147);
-- Test. Should return 13 
-- SELECT count(ProductId) AS total FROM `ctm`.`product_master` WHERE `EffectiveEnd`='2040-12-31' AND `ProductId` IN (217, 216, 215, 214, 155, 154, 153, 152, 151, 150, 149, 148, 147);

DELETE * FROM `ctm`.`product_master` WHERE providerId = 299 AND `ProductId` IN (247, 248, 249, 250, 251, 252, 253, 254, 255);

-- Test. Should return 0
-- SELECT count(ProductId) AS total FROM `ctm`.`product_master` WHERE providerId = 299 AND `ProductId` IN (247, 248, 249, 250, 251, 252, 253, 254, 255);