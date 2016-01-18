-- UPDATER 
SET @EXPIRES = '2015-09-25';
SET @START = '2015-09-26';
SET @FINISH = '2040-12-31';
SET @PAYD = (SELECT carProductId FROM ctm.car_product WHERE code='REIN-01-01');
SET @PAYD_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@PAYD);
UPDATE ctm.car_product_features SET effectiveEnd=@EXPIRES WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND carProductContentId=@PAYD_CONT;
INSERT INTO ctm.car_product_features (featureId,carProductContentId,code,name,value,description,effectiveStart,effectiveEnd) VALUES (null,@PAYD_CONT,'windscreen','Windscreen excess reduction','O','Optional cover available for the repair or replacement of the front windscreen of your car if it is accidentally broken during the insurance period. No excess will apply for the first windscreen claim made in any one period of insurance.',@START,@FINISH);
INSERT INTO ctm.car_product_features (featureId,carProductContentId,code,name,value,description,effectiveStart,effectiveEnd) VALUES (null,@PAYD_CONT,'personalEf','','Y','Covers up to $500 for loss or damage to personal items which are designed to be worn or carried.',@START,@FINISH);
INSERT INTO ctm.car_product_features (featureId,carProductContentId,code,name,value,description,effectiveStart,effectiveEnd) VALUES (null,@PAYD_CONT,'newRep','New for new replacement','2 Years','',@START,@FINISH);
INSERT INTO ctm.car_product_features (featureId,carProductContentId,code,name,value,description,effectiveStart,effectiveEnd) VALUES (null,@PAYD_CONT,'lifRep','Lifetime repair guarantee','Y','Guaranteed repairs by repairer appointed by Real Insurance.',@START,@FINISH);

-- CHECKER
SET @EXPIRES = '2015-09-25';
SET @PAYD = (SELECT carProductId FROM ctm.car_product WHERE code = 'REIN-01-01');
SET @PAYD_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@PAYD);
SELECT * FROM ctm.car_product_features WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND carProductContentId=@PAYD_CONT AND effectiveStart > @EXPIRES ORDER BY code ASC;

-- ROLLBACK
/*
SET @EXPIRES = '2015-09-25';
SET @START = '2015-09-26';
SET @FINISH = '2040-12-31';
SET @PAYD = (SELECT carProductId FROM ctm.car_product WHERE code = 'REIN-01-01');
SET @PAYD_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@PAYD);
DELETE FROM ctm.car_product_features WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND carProductContentId=@PAYD_CONT AND effectiveStart=@START AND effectiveEnd=@FINISH ORDER BY code ASC;
UPDATE ctm.car_product_features SET effectiveEnd=@FINISH WHERE code IN ('windscreen','personalEf','newRep','lifRep') AND carProductContentId=@PAYD_CONT AND effectiveEnd=@EXPIRES;
*/