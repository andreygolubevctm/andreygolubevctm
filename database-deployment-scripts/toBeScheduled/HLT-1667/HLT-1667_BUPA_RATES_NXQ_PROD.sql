/* -- EXPORT AND THEN IMPORT THE 4 TABLES FROM NXI TO NXQ
 * HLT-1667 ctm_export_product_master.sql
 * HLT-1667 ctm_export_product_properties_ext.sql
 * HLT-1667 ctm_export_product_properties_search.sql
 * HLT-1667 ctm_export_product_properties.sql
 *
 * -- */

/* -- BEGIN TEST -- */

/* Test the products count matches expected - total should match the test above */
SELECT 'Export', count(epm.productId) AS 'Total'
FROM `ctm`.`export_product_master` epm
WHERE epm.providerID = 15
UNION ALL
	SELECT 'Product', count(pm.productId) AS 'Total'
	FROM `ctm`.`product_master` pm
	WHERE pm.providerID = 15
	AND pm.EffectiveEnd >= NOW()
	AND pm.Longtitle like '%Young Singles Saver%'
	AND pm.Status NOT IN ('N', 'X')
LIMIT 9999;

/* -- END TEST -- */


/*

SELECT * FROM `ctm`.`product_master`
WHERE `providerid` = 15
AND `productID` > 0
AND Status <> 'X'
AND EffectiveEnd >= Now()
AND Longtitle like '%Young Singles Saver%'
LIMIT 9999;

*/
/* 'EXPIRE' BY STATUS OLDER PRODUCTS */
UPDATE `ctm`.`product_master`
SET `Status`='X'
WHERE `providerid` = 15
AND `productID` > 0
AND Longtitle like '%Young Singles Saver%'
AND EffectiveEnd >= Now();



/* **********
NOTE: this is run only ONCE to copy all the products over.
- 1. Check if products conflict (if so will need to delete the products before installing again)
- 2. Add product properties ext
- 3. Add product properties
- 4. Expire old product master
- 5. Add product search
- 6. Add product master
********** */

/* TEST: if the data may have conflicts, should be zero, otherwise insert update statements are required */
SELECT * FROM `ctm`.`product_master`
WHERE productId IN
(SELECT product.productId FROM `ctm`.`export_product_master` product);

/* INSERT product properties ext */
INSERT INTO `ctm`.`product_properties_ext`
SELECT * FROM `ctm`.`export_product_properties_ext`;

/* INSERT product properties */
INSERT INTO `ctm`.`product_properties`
SELECT * FROM `ctm`.`export_product_properties`;

/* INSERT product search (this is the main index) */
INSERT INTO `ctm`.`product_properties_search`
SELECT * FROM `ctm`.`export_product_properties_search`;

/* INSERT product master (Add Product Master Last) */
INSERT INTO `ctm`.`product_master`
SELECT * FROM `ctm`.`export_product_master`;