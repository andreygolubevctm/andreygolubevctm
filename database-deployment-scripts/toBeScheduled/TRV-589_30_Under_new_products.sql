-- Test. Should return 2 
-- SELECT count(ProductId) AS total FROM `ctm`.`product_master` WHERE `EffectiveEnd`='2015-01-27' AND `ProductId` IN (68,69);
UPDATE `ctm`.`product_master` SET `EffectiveEnd`='2015-01-27' WHERE `ProductId` IN (68, 69);

-- Test. Should return 1
-- SELECT count(ProductId) AS total FROM `ctm`.`product_master` WHERE providerId = 294 AND `ProductId` IN (256);
INSERT INTO `ctm`.`product_master` (`ProductId`, `ProductCat`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`) VALUES ('256', 'TRAVEL', '294', 'Under30s Insurance U30 Single Trip', 'Under30s Insurance U30 Single Trip', '2015-01-28', '2040-12-31');