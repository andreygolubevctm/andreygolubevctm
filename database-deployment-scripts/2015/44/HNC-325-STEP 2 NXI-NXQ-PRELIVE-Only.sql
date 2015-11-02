SET @HNCREALEssentialTest = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'REIN-02-01');
SET @HNCREALTopTest = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'REIN-02-02');
SET @HNCWOOLStandardTest = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'WOOL-02-01');
SET @HNCWOOLComprehensiveTest = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'WOOL-02-02');
SET @yesterday = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
SET @today = CURDATE();

UPDATE `ctm`.`home_product_content` SET EffectiveEnd = @yesterday WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = '2015-10-29' LIMIT 12;

-- SELECT count(*) FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday;
-- TEST AFTER UPDATE: 12

UPDATE `ctm`.`home_product_content` SET EffectiveStart = @today WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveStart = '2015-10-30' LIMIT 12;

-- SELECT * FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveStart = @today;
-- TEST AFTER UPDATE: 12

UPDATE `ctm`.`home_product_features` SET EffectiveEnd = @yesterday WHERE homeproductcontentid IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday)  AND EffectiveEnd = '2015-10-29' LIMIT 192;
 -- SELECT * FROM ctm.home_product_features WHERE homeproductcontentid IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday) AND EffectiveEnd = @yesterday;
-- TEST AFTER UPDATE: 192

UPDATE `ctm`.`home_product_features` SET EffectiveStart = @today WHERE homeproductcontentid IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveStart = @today) LIMIT 204;
-- SELECT * FROM ctm.home_product_features WHERE homeproductcontentid IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveStart = @today) AND EffectiveStart = @today;
-- TEST AFTER UPDATE: 204

UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveEnd`=@yesterday WHERE `homeProductContentId` IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday) AND `effectiveEnd`= '2015-10-29' LIMIT 24;
-- SELECT * FROM `ctm`.`home_product_disclosure_statements` WHERE `homeProductContentId` IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND EffectiveEnd = @yesterday) AND `effectiveEnd`=@yesterday;
-- TEST AFTER UPDATE: 24


UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveStart`=@today WHERE `homeProductContentId` IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND `effectiveStart`=@today) AND `effectiveStart`='2015-10-30' LIMIT 24;
 -- SELECT * FROM `ctm`.`home_product_disclosure_statements` WHERE `homeProductContentId` IN (SELECT homeproductcontentid FROM `ctm`.`home_product_content` WHERE homeProductId IN (@HNCREALEssentialTest, @HNCREALTopTest, @HNCWOOLStandardTest, @HNCWOOLComprehensiveTest) AND `effectiveStart`=@today) AND `effectiveStart`=@today;
-- TEST AFTER UPDATE: 24