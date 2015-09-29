-- UPDATER
SET @EXPIRES_OLD = '2015-09-25';
SET @EXPIRES_NEW = '2015-09-24';
SET @START_OLD = '2015-09-26';
SET @START_NEW = '2015-09-25';
SET @COMP = (SELECT carProductId FROM ctm.car_product WHERE code='REIN-01-02');
SET @COMP_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@COMP);
UPDATE ctm.car_product_features SET effectiveEnd=@EXPIRES_NEW WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND effectiveEnd=@EXPIRES_OLD AND carProductContentId=@COMP_CONT;
UPDATE ctm.car_product_features SET effectiveStart=@START_NEW WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND effectiveStart=@START_OLD AND carProductContentId=@COMP_CONT;

-- CHECKER - 4 Rows returned after update
SET @START = '2015-09-25';
SET @COMP = (SELECT carProductId FROM ctm.car_product WHERE code = 'REIN-01-02');
SET @COMP_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@COMP);
SELECT * FROM ctm.car_product_features WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND carProductContentId=@COMP_CONT AND effectiveStart = @START ORDER BY code ASC;

-- ROLLBACK
/*
SET @EXPIRES_OLD = '2015-09-25';
SET @EXPIRES_NEW = '2015-09-24';
SET @START_OLD = '2015-09-26';
SET @START_NEW = '2015-09-25';
SET @COMP = (SELECT carProductId FROM ctm.car_product WHERE code='REIN-01-02');
SET @COMP_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@COMP);
UPDATE ctm.car_product_features SET effectiveEnd=@EXPIRES_OLD WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND effectiveEnd=@EXPIRES_NEW AND carProductContentId=@COMP_CONT;
UPDATE ctm.car_product_features SET effectiveStart=@START_OLD WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND effectiveStart=@START_NEW AND carProductContentId=@COMP_CONT;
*/