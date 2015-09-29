-- UPDATER 
SET @COMP = (SELECT carProductId FROM ctm.car_product WHERE code='REIN-01-02');
SET @COMP_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@COMP);
UPDATE ctm.car_product_features SET description='Optional cover available for the repair or replacement of the front windscreen of your car if it is accidentally broken or damaged during the insurance period. No excess will apply for the first windscreen claim made in any one period of insurance.' WHERE code='windscreen' AND carProductContentId=@COMP_CONT AND effectiveEnd='2040-12-31';

-- CHECKER
SET @COMP = (SELECT carProductId FROM ctm.car_product WHERE code = 'REIN-01-02');
SET @COMP_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@COMP);
SELECT * FROM ctm.car_product_features WHERE code='windscreen' AND carProductContentId=@COMP_CONT AND effectiveEnd='2040-12-31' ORDER BY code ASC;

-- ROLLBACK
/*
SET @COMP = (SELECT carProductId FROM ctm.car_product WHERE code='REIN-01-02');
SET @COMP_CONT = (SELECT MAX(carProductContentId) FROM ctm.car_product_content WHERE carProductId=@COMP);
UPDATE ctm.car_product_features SET description='Optional cover available for the repair or replacement of the front windscreen of your car if it is accidentally broken during the insurance period. No excess will apply for the first windscreen claim made in any one period of insurance.' WHERE code='windscreen' AND carProductContentId=@COMP_CONT AND effectiveEnd='2040-12-31';
*/