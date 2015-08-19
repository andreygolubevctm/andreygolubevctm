-- Step 3. 
 SET @EffectiveStart = '2015-04-01';
SET @EffectiveEnd = '2016-03-31';
SET @providerID = 1;

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
	AND pm.LongTitle in( 'Gold Hospital - $250 Excess',
						'Gold Hospital - $250 Excess AND Basic Extras',
						'Gold Hospital - $250 Excess AND Comprehensive Extras',
						'Gold Hospital - $250 Excess AND Super Extras',
						'Gold Hospital - $250 Excess plus Starter 60%',
						'Gold Hospital - $250 Excess plus Starter 60% with Health Boost',
						'Gold Hospital - $250 Excess plus Starter 60% with Repair',
						'Gold Hospital - $250 Excess plus Starter 60% with Repair and Health Boost',
						'Gold Hospital - $250 Excess plus Starter 60% with Smile',
						'Gold Hospital - $250 Excess plus Starter 60% with Smile and Health Boost',
						'Gold Hospital - $250 Excess plus Starter 60% with Smile and Repair',
						'Gold Hospital - $250 Excess plus Starter 60% with Smile, Repair and Health Boost',
						'Gold Hospital - $500 Excess',
						'Gold Hospital - $500 Excess AND Basic Extras',
						'Gold Hospital - $500 Excess AND Comprehensive Extras',
						'Gold Hospital - $500 Excess AND Super Extras',
						'Gold Hospital - $500 Excess plus Starter 60%',
						'Gold Hospital - $500 Excess plus Starter 60% with Health Boost',
						'Gold Hospital - $500 Excess plus Starter 60% with Repair',
						'Gold Hospital - $500 Excess plus Starter 60% with Repair and Health Boost',
						'Gold Hospital - $500 Excess plus Starter 60% with Smile',
						'Gold Hospital - $500 Excess plus Starter 60% with Smile and Health Boost',
						'Gold Hospital - $500 Excess plus Starter 60% with Smile and Repair',
						'Gold Hospital - $500 Excess plus Starter 60% with Smile, Repair and Health Boost',
						'Smart Combination - $500 Excess',
						'Basic Hospital and Comprehensive Extras',
						'Comprehensive Extras',
						'Mid Hospital - $500 Excess and Comprehensive Extras'
		)
LIMIT 9999;

/* -- END TEST -- */

/* **********
NOTE: this is run only ONCE to copy all the products over.
- 1. Check if products conflict (if so will need to delete the products before installing again)
- 2. Expire old product master
- 3. Add product properties ext
- 4. Add product properties
- 5. Add product search
- 6. Add product master
********** */


/* TEST: if the data may have conflicts, should be zero, otherwise insert update statements are required */
SELECT * FROM `ctm`.`product_master`
WHERE productId IN
(SELECT product.productId FROM `ctm`.`export_product_master` product);

/* Disable current products product master 714 records */
UPDATE `ctm`.`product_master` pm
 SET STATUS = 'X'
WHERE pm.EffectiveStart = @EffectiveStart
	AND pm.EffectiveEnd = @EffectiveEnd
	AND providerID = @providerID
	AND Status != 'X'
	AND LongTitle in( 'Gold Hospital - $250 Excess',
					'Gold Hospital - $250 Excess AND Basic Extras',
					'Gold Hospital - $250 Excess AND Comprehensive Extras',
					'Gold Hospital - $250 Excess AND Super Extras',
					'Gold Hospital - $250 Excess plus Starter 60%',
					'Gold Hospital - $250 Excess plus Starter 60% with Health Boost',
					'Gold Hospital - $250 Excess plus Starter 60% with Repair',
					'Gold Hospital - $250 Excess plus Starter 60% with Repair and Health Boost',
					'Gold Hospital - $250 Excess plus Starter 60% with Smile',
					'Gold Hospital - $250 Excess plus Starter 60% with Smile and Health Boost',
					'Gold Hospital - $250 Excess plus Starter 60% with Smile and Repair',
					'Gold Hospital - $250 Excess plus Starter 60% with Smile, Repair and Health Boost',
					'Gold Hospital - $500 Excess',
					'Gold Hospital - $500 Excess AND Basic Extras',
					'Gold Hospital - $500 Excess AND Comprehensive Extras',
					'Gold Hospital - $500 Excess AND Super Extras',
					'Gold Hospital - $500 Excess plus Starter 60%',
					'Gold Hospital - $500 Excess plus Starter 60% with Health Boost',
					'Gold Hospital - $500 Excess plus Starter 60% with Repair',
					'Gold Hospital - $500 Excess plus Starter 60% with Repair and Health Boost',
					'Gold Hospital - $500 Excess plus Starter 60% with Smile',
					'Gold Hospital - $500 Excess plus Starter 60% with Smile and Health Boost',
					'Gold Hospital - $500 Excess plus Starter 60% with Smile and Repair',
					'Gold Hospital - $500 Excess plus Starter 60% with Smile, Repair and Health Boost',
					'Smart Combination - $500 Excess',
					'Basic Hospital and Comprehensive Extras',
					'Comprehensive Extras',
					'Mid Hospital - $500 Excess and Comprehensive Extras'
	);

-- expire all super extras on 23:59:59 11/09/2015
-- TEST count 98
select count(*) from `ctm`.`product_master` pm
 WHERE pm.EffectiveStart = @EffectiveStart
	AND pm.EffectiveEnd = @EffectiveEnd
	AND providerID = @providerID
	AND Status != 'X'
	AND LongTitle like '%Super Extras%';

UPDATE `ctm`.`product_master` pm
 SET effectiveEnd='2015-09-11'
 WHERE pm.EffectiveStart = @EffectiveStart
	AND pm.EffectiveEnd = @EffectiveEnd
	AND providerID = @providerID
	AND Status != 'X'
	AND LongTitle like '%Super Extras%';


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

-- Test import has worked there should be 714 products 

SELECT count(*) FROM `ctm`.`product_master` pm
INNER JOIN ctm.product_properties_search pps
ON pps.ProductId = pm.ProductId
WHERE pm.Status != 'X'
AND pm.providerID =  @providerID 
AND pm.EffectiveStart = @EffectiveStart
and pm.EffectiveEnd = @EffectiveEnd
AND pm.ProductCat = 'HEALTH'
AND LongTitle in( 'Gold Hospital - $250 Excess',
					'Gold Hospital - $250 Excess AND Basic Extras',
					'Gold Hospital - $250 Excess AND Comprehensive Extras',
					'Gold Hospital - $250 Excess AND Super Extras',
					'Gold Hospital - $250 Excess plus Starter 60%',
					'Gold Hospital - $250 Excess plus Starter 60% with Health Boost',
					'Gold Hospital - $250 Excess plus Starter 60% with Repair',
					'Gold Hospital - $250 Excess plus Starter 60% with Repair and Health Boost',
					'Gold Hospital - $250 Excess plus Starter 60% with Smile',
					'Gold Hospital - $250 Excess plus Starter 60% with Smile and Health Boost',
					'Gold Hospital - $250 Excess plus Starter 60% with Smile and Repair',
					'Gold Hospital - $250 Excess plus Starter 60% with Smile, Repair and Health Boost',
					'Gold Hospital - $500 Excess',
					'Gold Hospital - $500 Excess AND Basic Extras',
					'Gold Hospital - $500 Excess AND Comprehensive Extras',
					'Gold Hospital - $500 Excess AND Super Extras',
					'Gold Hospital - $500 Excess plus Starter 60%',
					'Gold Hospital - $500 Excess plus Starter 60% with Health Boost',
					'Gold Hospital - $500 Excess plus Starter 60% with Repair',
					'Gold Hospital - $500 Excess plus Starter 60% with Repair and Health Boost',
					'Gold Hospital - $500 Excess plus Starter 60% with Smile',
					'Gold Hospital - $500 Excess plus Starter 60% with Smile and Health Boost',
					'Gold Hospital - $500 Excess plus Starter 60% with Smile and Repair',
					'Gold Hospital - $500 Excess plus Starter 60% with Smile, Repair and Health Boost',
					'Smart Combination - $500 Excess',
					'Basic Hospital and Comprehensive Extras',
					'Comprehensive Extras',
					'Mid Hospital - $500 Excess and Comprehensive Extras'
	);

