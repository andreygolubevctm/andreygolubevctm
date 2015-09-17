
-- Step 3. 
SET @EffectiveStart = '2015-05-25';
SET @EffectiveEnd = '2016-03-31';
SET @providerID = 3;

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
  AND (pm.LongTitle LIKE 'Advantage Hospital%'
 		OR pm.LongTitle LIKE 'Standard Hospital%')
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

/* Disable current products product master update count = 70*/
UPDATE `ctm`.`product_master` pm
 SET STATUS = 'X'
 WHERE now() between pm.EffectiveStart AND pm.EffectiveEnd 
 AND providerID = @providerID
 AND Status != 'X'
 AND pm.ProductCat = 'HEALTH'
 AND (pm.LongTitle LIKE 'Advantage Hospital%'
 	 OR pm.LongTitle LIKE 'Standard Hospital%');

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

/* Test import has worked there should be 1344 products */

SELECT pm.* FROM `ctm`.`product_master` pm
INNER JOIN ctm.product_properties_search pps
ON pps.ProductId = pm.ProductId
WHERE pm.Status != 'X'
AND pm.providerID =  @providerID 
AND now() between pm.EffectiveStart AND pm.EffectiveEnd 
AND pm.ProductCat = 'HEALTH'
AND (pm.LongTitle LIKE 'Advantage Hospital%'
 	OR pm.LongTitle LIKE 'Standard Hospital%')
limit 99999999;

