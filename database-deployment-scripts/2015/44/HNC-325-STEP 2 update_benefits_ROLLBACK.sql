SET @HNCREALEssential = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'REIN-02-01');
SET @HNCREALTop = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'REIN-02-02');
SET @HNCWOOLStandard = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'WOOL-02-01');
SET @HNCWOOLComprehensive = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'WOOL-02-02');



-- ==========================================
-- Restore the old pds'
UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveEnd`='2040-12-31' WHERE `effectiveEnd`='2015-10-29' AND `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId IN(@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive)) LIMIT 24;

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveEnd`='2040-12-31' AND `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId IN(@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive));
-- TEST RESULT: 24

-- ==========================================
-- Delete the new pds'

DELETE FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveStart` = '2015-10-30' AND `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId IN(@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive)) LIMIT 24;


-- SELECT * FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveStart` = '2015-10-30' AND `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId IN(@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive));
-- TEST RESULT: 0


-- ==========================================
-- Restore old features

UPDATE `ctm`.`home_product_features` SET `effectiveEnd`='2040-12-31' WHERE `effectiveEnd`='2015-10-29' AND homeProductContentId IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId IN(@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive)) LIMIT 192;

-- SELECT count(*) FROM `ctm`.`home_product_features` WHERE effectiveEnd = '2040-12-31' AND homeProductContentId IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId IN(@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive)) ;
-- TEST RESULT: 192

-- ==========================================
-- Delete new features
DELETE FROM `ctm`.`home_product_features` WHERE `effectiveStart` = '2015-10-30' AND homeProductContentId IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId IN(@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive)) LIMIT 192;

-- SELECT count(*) FROM `ctm`.`home_product_features` WHERE `effectiveStart` = '2015-10-30' AND homeProductContentId IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId IN(@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive));
-- TEST RESULT: 0


-- ==========================================
-- Restore old content
UPDATE `ctm`.`home_product_content` SET `effectiveEnd`='2040-12-31' WHERE `effectiveEnd`='2015-10-29' AND homeProductId IN (@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive) LIMIT 12;

-- SELECT count(*) FROM `ctm`.`home_product_content` WHERE `effectiveEnd`='2040-12-31' AND `effectiveStart` = '2011-03-01' AND homeProductId IN (@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive);
-- TEST RESULT: 12

-- ==========================================
-- Delete new content
DELETE FROM `ctm`.`home_product_content` WHERE `effectiveStart` = '2015-10-30' AND homeProductId IN (@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive) LIMIT 12;

-- SELECT count(*) FROM `ctm`.`home_product_content` WHERE `effectiveStart` = '2015-10-30' AND homeProductId IN (@HNCREALEssential, @HNCREALTop, @HNCWOOLStandard, @HNCWOOLComprehensive);
-- TEST RESULT: 0