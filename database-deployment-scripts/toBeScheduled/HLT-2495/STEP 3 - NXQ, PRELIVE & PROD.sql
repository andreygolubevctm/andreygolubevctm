SET @EffectiveStart = '2015-08-25';
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
	AND pm.LongTitle in (	
						'Accident Only Hospital Cover and Gold Extras',
						'Accident Only Hospital Cover and Platinum Extras',
						'Basic Hospital $250 Excess and Gold Extras',
						'Basic Hospital $250 Excess and Platinum Extras',
						'Basic Hospital $500 Excess and Gold Extras',
						'Basic Hospital $500 Excess and Platinum Extras',
						'Gold Extras',
						'Mid Hospital $250 Excess and Gold Extras',
						'Mid Hospital $250 Excess and Platinum Extras',
						'Mid Hospital $500 Excess and Gold Extras',
						'Mid Hospital $500 Excess and Platinum Extras',
						'Mid Plus Hospital $250 Excess and Gold Extras',
						'Mid Plus Hospital $500 Excess and Gold Extras',
						'Platinum Extras',
						'Premium Hospital $250 Excess and Gold Extras',
						'Premium Hospital $250 Excess and Platinum Extras',
						'Premium Hospital $500 Excess and Gold Extras',
						'Premium Hospital $500 Excess and Platinum Extras',
						'Premium Hospital Nil Excess and Gold Extras',
						'Premium Hospital Nil Excess and Platinum Extras',
						'Accident Only Hospital Cover and Silver Plus Extras'
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

/* Disable current products product master 588 records tobe updated*/
UPDATE `ctm`.`product_master` pm
SET STATUS = 'X'
WHERE pm.EffectiveStart = @EffectiveStart
	AND NOW() BETWEEN pm.EffectiveStart and pm.EffectiveEnd
	AND Status != 'X' 
	AND pm.LongTitle in (	
						'Accident Only Hospital Cover and Gold Extras',
						'Accident Only Hospital Cover and Platinum Extras',
						'Basic Hospital $250 Excess and Gold Extras',
						'Basic Hospital $250 Excess and Platinum Extras',
						'Basic Hospital $500 Excess and Gold Extras',
						'Basic Hospital $500 Excess and Platinum Extras',
						'Gold Extras',
						'Mid Hospital $250 Excess and Gold Extras',
						'Mid Hospital $250 Excess and Platinum Extras',
						'Mid Hospital $500 Excess and Gold Extras',
						'Mid Hospital $500 Excess and Platinum Extras',
						'Mid Plus Hospital $250 Excess and Gold Extras',
						'Mid Plus Hospital $500 Excess and Gold Extras',
						'Platinum Extras',
						'Premium Hospital $250 Excess and Gold Extras',
						'Premium Hospital $250 Excess and Platinum Extras',
						'Premium Hospital $500 Excess and Gold Extras',
						'Premium Hospital $500 Excess and Platinum Extras',
						'Premium Hospital Nil Excess and Gold Extras',
						'Premium Hospital Nil Excess and Platinum Extras',
						'Accident Only Hospital Cover and Silver Plus Extras'
					 );



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

/* Test import has worked there should be 588 products */

SELECT count(*) FROM `ctm`.`product_master` pm
INNER JOIN ctm.product_properties_search pps
ON pps.ProductId = pm.ProductId
WHERE pm.Status != 'X'
AND pm.providerID =  @providerID 
AND NOW() BETWEEN pm.EffectiveStart and pm.EffectiveEnd
AND pm.ProductCat = 'HEALTH' 
	AND pm.LongTitle in (	
						'Accident Only Hospital Cover and Gold Extras',
						'Accident Only Hospital Cover and Platinum Extras',
						'Basic Hospital $250 Excess and Gold Extras',
						'Basic Hospital $250 Excess and Platinum Extras',
						'Basic Hospital $500 Excess and Gold Extras',
						'Basic Hospital $500 Excess and Platinum Extras',
						'Gold Extras',
						'Mid Hospital $250 Excess and Gold Extras',
						'Mid Hospital $250 Excess and Platinum Extras',
						'Mid Hospital $500 Excess and Gold Extras',
						'Mid Hospital $500 Excess and Platinum Extras',
						'Mid Plus Hospital $250 Excess and Gold Extras',
						'Mid Plus Hospital $500 Excess and Gold Extras',
						'Platinum Extras',
						'Premium Hospital $250 Excess and Gold Extras',
						'Premium Hospital $250 Excess and Platinum Extras',
						'Premium Hospital $500 Excess and Gold Extras',
						'Premium Hospital $500 Excess and Platinum Extras',
						'Premium Hospital Nil Excess and Gold Extras',
						'Premium Hospital Nil Excess and Platinum Extras',
						'Accident Only Hospital Cover and Silver Plus Extras'
					 )
limit 99999999;
