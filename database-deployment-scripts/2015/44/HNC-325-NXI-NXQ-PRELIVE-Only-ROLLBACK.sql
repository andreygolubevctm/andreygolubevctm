SET @HNCREALEssentialTest = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'REIN-02-01');
SET @HNCREALTopTest = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'REIN-02-02');
SET @HNCWOOLStandardTest = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'WOOL-02-01');
SET @HNCWOOLComprehensiveTest = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'WOOL-02-02');
SET @yesterday = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
SET @today = CURDATE();

UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveEnd`='2015-10-29' WHERE `homeProductContentId` IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday) AND `effectiveEnd`= @yesterday LIMIT 6;
-- SELECT * FROM `ctm`.`home_product_disclosure_statements` WHERE `homeProductContentId` IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday) AND `effectiveEnd`=@yesterday;
-- TEST AFTER UPDATE: 6


UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveStart`='2015-10-30' WHERE `homeProductContentId` IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND `effectiveStart`=@today) AND `effectiveStart`=@today LIMIT 6;
 -- SELECT * FROM `ctm`.`home_product_disclosure_statements` WHERE `homeProductContentId` IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND `effectiveStart`=@today) AND `effectiveStart`=@today;
-- TEST AFTER UPDATE: 6

UPDATE `ctm`.`home_product_features` SET EffectiveEnd = '2015-10-29' WHERE homeproductcontentid IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday)  AND EffectiveEnd = @yesterday LIMIT 192;
 -- SELECT * FROM ctm.home_product_features WHERE homeproductcontentid IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday)  AND EffectiveEnd = @yesterday;
-- TEST AFTER UPDATE: 192

UPDATE `ctm`.`home_product_features` SET EffectiveStart = '2015-10-30' WHERE homeproductcontentid IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveStart = @today) AND EffectiveStart = @today LIMIT 204;
-- SELECT * FROM ctm.home_product_features WHERE homeproductcontentid IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveStart = @today) AND EffectiveStart = @today;
-- TEST AFTER UPDATE: 204

UPDATE `ctm`.`home_product_content` SET EffectiveEnd = '2015-10-29' WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday LIMIT 12;

-- SELECT * FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = '2015-10-29' AND EffectiveStart = '2011-03-01';
-- TEST AFTER UPDATE: 12

UPDATE `ctm`.`home_product_content` SET EffectiveStart = '2015-10-30' WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveStart = @today LIMIT 12;

-- SELECT * FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveStart = '2015-10-30';
-- TEST AFTER UPDATE: 12