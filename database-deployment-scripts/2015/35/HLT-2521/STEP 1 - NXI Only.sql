-- Warning this is a generated script and may not handle things such as status 'O' 
-- A developer should always review this before running 
-- STEP 1 extract from NXI 
SET @EffectiveStart = '2015-08-25';
SET @EffectiveEnd = '2016-03-31';
SET @providerID = 2;
-- TEST 
 SELECT count(productId) FROM `ctm`.`product_master` pm 
 WHERE Status != 'X' 
 AND providerID = @providerID 
 AND productId > 0 
 AND ProductCat = 'HEALTH' 
 AND EffectiveStart = @EffectiveStart 
 AND EffectiveEnd = @EffectiveEnd 
 AND pm.LongTitle in (
	'Silver Plus Extras',
	'Accident Only Hospital Cover and Silver Plus Extras',
	'Basic Hospital $250 Excess and Silver Plus Extras',
	'Basic Hospital $500 Excess and Silver Plus Extras',
	'Mid Hospital $250 Excess and Silver Plus Extras',
	'Mid Hospital $500 Excess and Silver Plus Extras',
	'Premium Hospital $250 Excess and Silver Plus Extras',
	'Premium Hospital $500 Excess and Silver Plus Extras',
	'Premium Hospital Nil Excess and Silver Plus Extras'
 );

/* Truncate the export tables */ 
TRUNCATE `ctm`.`export_product_master`; 
TRUNCATE `ctm`.`export_product_properties_ext`; 
TRUNCATE `ctm`.`export_product_properties`; 
TRUNCATE `ctm`.`export_product_properties_search`; 
TRUNCATE `ctm`.`export_product_capping_exclusions`; 
/* Run 4 insert/update queries to populate export tables */ 
/* 1. Copy product master  */ 
INSERT INTO `ctm`.`export_product_master` 
SELECT * FROM `ctm`.`product_master` pm 
WHERE Status != 'X' 
AND providerID = @providerID 
AND productId > 0 
AND ProductCat = 'HEALTH' 
AND EffectiveStart = @EffectiveStart 
AND EffectiveEnd = @EffectiveEnd
 AND pm.LongTitle in (
	'Silver Plus Extras',
	'Accident Only Hospital Cover and Silver Plus Extras',
	'Basic Hospital $250 Excess and Silver Plus Extras',
	'Basic Hospital $500 Excess and Silver Plus Extras',
	'Mid Hospital $250 Excess and Silver Plus Extras',
	'Mid Hospital $500 Excess and Silver Plus Extras',
	'Premium Hospital $250 Excess and Silver Plus Extras',
	'Premium Hospital $500 Excess and Silver Plus Extras',
	'Premium Hospital Nil Excess and Silver Plus Extras'
 );


/* 2. Copy product properties ext */ 
INSERT INTO `ctm`.`export_product_properties_ext` 
SELECT * FROM `ctm`.`product_properties_ext` original 
WHERE productId IN ( 
						SELECT productId FROM `ctm`.`product_master` pm 
						 WHERE Status != 'X' 
						 AND providerID = @providerID 
						 AND ProductCat = 'HEALTH' 
						 AND EffectiveStart = @EffectiveStart 
						 AND EffectiveEnd = @EffectiveEnd 
						 AND pm.LongTitle in (
							'Silver Plus Extras',
							'Accident Only Hospital Cover and Silver Plus Extras',
							'Basic Hospital $250 Excess and Silver Plus Extras',
							'Basic Hospital $500 Excess and Silver Plus Extras',
							'Mid Hospital $250 Excess and Silver Plus Extras',
							'Mid Hospital $500 Excess and Silver Plus Extras',
							'Premium Hospital $250 Excess and Silver Plus Extras',
							'Premium Hospital $500 Excess and Silver Plus Extras',
							'Premium Hospital Nil Excess and Silver Plus Extras'
						 )
					)
	 AND productId > 0;

/* 3. Copy product properties */ 
INSERT INTO `ctm`.`export_product_properties` 
SELECT * FROM `ctm`.`product_properties` original 
WHERE productId IN ( 
					 SELECT productId FROM `ctm`.`product_master` pm 
					 WHERE Status != 'X' 
					 AND providerID = @providerID 
					 AND ProductCat = 'HEALTH' 
					 AND EffectiveStart = @EffectiveStart 
					 AND EffectiveEnd = @EffectiveEnd 
					 AND pm.LongTitle in (
						'Silver Plus Extras',
						'Accident Only Hospital Cover and Silver Plus Extras',
						'Basic Hospital $250 Excess and Silver Plus Extras',
						'Basic Hospital $500 Excess and Silver Plus Extras',
						'Mid Hospital $250 Excess and Silver Plus Extras',
						'Mid Hospital $500 Excess and Silver Plus Extras',
						'Premium Hospital $250 Excess and Silver Plus Extras',
						'Premium Hospital $500 Excess and Silver Plus Extras',
						'Premium Hospital Nil Excess and Silver Plus Extras'
						)
				   )
	 AND productId > 0; 


/* 4. Copy product search (this is the main index) */ 
INSERT INTO `ctm`.`export_product_properties_search` 
SELECT * FROM `ctm`.`product_properties_search` original 
WHERE productId IN (  
					 SELECT productId FROM `ctm`.`product_master` pm 
					 WHERE Status != 'X' 
					 AND providerID = @providerID 
					 AND ProductCat = 'HEALTH' 
					 AND EffectiveStart = @EffectiveStart 
					 AND EffectiveEnd = @EffectiveEnd 
					 AND pm.LongTitle in (
						'Silver Plus Extras',
						'Accident Only Hospital Cover and Silver Plus Extras',
						'Basic Hospital $250 Excess and Silver Plus Extras',
						'Basic Hospital $500 Excess and Silver Plus Extras',
						'Mid Hospital $250 Excess and Silver Plus Extras',
						'Mid Hospital $500 Excess and Silver Plus Extras',
						'Premium Hospital $250 Excess and Silver Plus Extras',
						'Premium Hospital $500 Excess and Silver Plus Extras',
						'Premium Hospital Nil Excess and Silver Plus Extras'
						)
				   )
	 AND productId > 0;


/* 5. Copy product capping exclusion (this is the main index) */ 
INSERT INTO `ctm`.`export_product_capping_exclusions` 
SELECT * FROM `ctm`.`product_capping_exclusions` original 
WHERE productId IN (  
					 SELECT productId FROM `ctm`.`product_master` pm 
					 WHERE Status != 'X' 
					 AND providerID = @providerID 
					 AND ProductCat = 'HEALTH' 
					 AND EffectiveStart = @EffectiveStart 
					 AND EffectiveEnd = @EffectiveEnd 
					 AND pm.LongTitle in (
						'Silver Plus Extras',
						'Accident Only Hospital Cover and Silver Plus Extras',
						'Basic Hospital $250 Excess and Silver Plus Extras',
						'Basic Hospital $500 Excess and Silver Plus Extras',
						'Mid Hospital $250 Excess and Silver Plus Extras',
						'Mid Hospital $500 Excess and Silver Plus Extras',
						'Premium Hospital $250 Excess and Silver Plus Extras',
						'Premium Hospital $500 Excess and Silver Plus Extras',
						'Premium Hospital Nil Excess and Silver Plus Extras'
						)
				   )
	 AND productId > 0;
