-- Step 3. 
SET @EffectiveStart = '2015-04-01';
SET @EffectiveEnd = '2016-03-31';
SET @providerID = 2;

/* -- BEGIN TEST -- */

/* Test the products count matches expected */
SELECT 'Export', count(epm.productId) AS 'Total'
FROM `ctm`.`export_product_master` epm
WHERE epm.providerID = @providerID
UNION ALL
	SELECT 'Product', count(pm.productId) AS 'Total'
	FROM `ctm`.`product_master` pm
	INNER JOIN ctm.product_properties_search pps
	ON pps.ProductId = pm.ProductId
	WHERE pm.Status != 'X'
	AND pm.providerID = @providerID
	AND NOW() BETWEEN pm.EffectiveStart and pm.EffectiveEnd
	AND pm.ProductCat = 'HEALTH'
	AND pm.LongTitle IN (
		'Mid Plus Hospital $250 Excess and Gold Extras',
		'Mid Plus Hospital $250 Excess and Silver Extras',
		'Mid Plus Hospital $500 Excess and Gold Extras',
		'Mid Plus Hospital $500 Excess and Silver Extras',
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
LIMIT 9999;

/* -- END TEST -- */

/* **********
NOTE: this is run only ONCE to copy all the products over.
- 1. Check if products conflict (if so will need to delete the products before installing again)
- 2. Add product properties ext
- 3. Add product properties
- 4. Expire old product master
- 5. Add product search
- 6. Add product master
********** */

/* Disable current products product master */
UPDATE `ctm`.`product_master`
SET Status = 'X'
WHERE providerID = @providerID
AND Status != 'X'
AND NOW() BETWEEN EffectiveStart and EffectiveEnd
AND LongTitle IN (
	'Mid Plus Hospital $250 Excess and Gold Extras',
	'Mid Plus Hospital $250 Excess and Silver Extras',
	'Mid Plus Hospital $500 Excess and Gold Extras',
	'Mid Plus Hospital $500 Excess and Silver Extras',
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


/* TEST: if the data may have conflicts, should be zero, otherwise insert update statements are required */
SELECT * FROM `ctm`.`product_master`
WHERE productId IN
(SELECT product.productId FROM `ctm`.`export_product_master` product);

/* INSERT product properties */
INSERT INTO `ctm`.`product_properties`
SELECT * FROM `ctm`.`export_product_properties`;

/* INSERT product properties */
INSERT INTO `ctm`.`product_properties_ext`
SELECT * FROM `ctm`.`export_product_properties_ext`; 

/* INSERT product search (this is the main index) */
INSERT INTO `ctm`.`product_properties_search`
SELECT * FROM `ctm`.`export_product_properties_search`;

/* INSERT product capping exclusions */
INSERT INTO `ctm`.`product_capping_exclusions`
SELECT * FROM `ctm`.`export_product_capping_exclusions`;

/* INSERT product master (Add Product Master Last) */
INSERT INTO `ctm`.`product_master`
SELECT * FROM `ctm`.`export_product_master`;

/* Test import has worked there should be 280 products 

SELECT pm.* FROM `ctm`.`product_master` pm
INNER JOIN ctm.product_properties_search pps
ON pps.ProductId = pm.ProductId
WHERE pm.Status != 'X'
AND pm.providerID =  @providerID 
AND pm.EffectiveStart = @EffectiveStart
and pm.EffectiveEnd = @EffectiveEnd
AND pm.ProductCat = 'HEALTH'
AND pm.LongTitle IN (
	'Mid Plus Hospital $250 Excess and Gold Extras',
	'Mid Plus Hospital $250 Excess and Silver Extras',
	'Mid Plus Hospital $500 Excess and Gold Extras',
	'Mid Plus Hospital $500 Excess and Silver Extras',
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
limit 99999999;

*/