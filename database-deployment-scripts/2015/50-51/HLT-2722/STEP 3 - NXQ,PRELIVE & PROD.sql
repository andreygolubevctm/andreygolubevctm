SET @EffectiveStart = '2015-04-01';
SET @EffectiveEnd = '2016-03-31';
SET @providerID = 16;

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
	AND LongTitle IN (
		'Top Hospital',
		'Top Hospital 250',
		'Top Hospital 500',
		'Top Hospital with Essential Extras',
		'Top Hospital 250 with Essential Extras',
		'Top Hospital 500 with Essential Extras',
		'Top Hospital 250 with Premium Extras',
		'Top Hospital 250 with Premium Extras ',
		'Top Hospital with Young Extras',
		'Top Hospital 250 with Young Extras',
		'Top Hospital 500 with Young Extras',
		'Top Hospital 500 with Premium Extras',
		'Top Hospital 500 with Premium Extras ',
		'Top Hospital with Premium Extras'
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

/* Disable current products product master */
UPDATE `ctm`.`product_master` pm
 SET STATUS = 'X'
 WHERE pm.EffectiveStart = @EffectiveStart
AND pm.EffectiveEnd = @EffectiveEnd
AND providerID = @providerID
 AND Status != 'X'
 AND LongTitle IN (
		'Top Hospital',
		'Top Hospital 250',
		'Top Hospital 500',
		'Top Hospital with Essential Extras',
		'Top Hospital 250 with Essential Extras',
		'Top Hospital 500 with Essential Extras',
		'Top Hospital 250 with Premium Extras',
		'Top Hospital 250 with Premium Extras ',
		'Top Hospital with Young Extras',
		'Top Hospital 250 with Young Extras',
		'Top Hospital 500 with Young Extras',
		'Top Hospital 500 with Premium Extras',
		'Top Hospital 500 with Premium Extras ',
		'Top Hospital with Premium Extras'
	);

/* Disable current products product master */
/*UPDATE `ctm`.`product_master` pm
 SET pm.EffectiveEnd = STR_TO_DATE(@EffectiveStart, '%Y-%m-%d') - INTERVAL 1 DAY 
  WHERE(pm.EffectiveStart != @EffectiveStart AND pm.EffectiveEnd != @EffectiveEnd)
AND @EffectiveStart between EffectiveStart AND EffectiveEnd 
AND providerID = @providerID 
 AND Status != 'X'; */


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

/* Test import has worked there should be 48 products

SELECT pm.* FROM `ctm`.`product_master` pm
INNER JOIN ctm.product_properties_search pps
ON pps.ProductId = pm.ProductId
WHERE pm.Status != 'X'
AND pm.providerID =  @providerID 
AND pm.EffectiveStart = @EffectiveStart
and pm.EffectiveEnd = @EffectiveEnd
AND pm.ProductCat = 'HEALTH'
AND LongTitle IN (
	'Top Hospital',
	'Top Hospital 250',
	'Top Hospital 500',
	'Top Hospital with Essential Extras',
	'Top Hospital 250 with Essential Extras',
	'Top Hospital 500 with Essential Extras',
	'Top Hospital 250 with Premium Extras',
	'Top Hospital 250 with Premium Extras ',
	'Top Hospital with Young Extras',
	'Top Hospital 250 with Young Extras',
	'Top Hospital 500 with Young Extras',
	'Top Hospital 500 with Premium Extras',
	'Top Hospital 500 with Premium Extras ',
	'Top Hospital with Premium Extras'
)
limit 99999999;

*/