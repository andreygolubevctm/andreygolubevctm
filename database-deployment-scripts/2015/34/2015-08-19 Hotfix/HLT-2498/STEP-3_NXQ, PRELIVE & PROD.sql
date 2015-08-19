 SET @EffectiveStart = '2015-04-01';
SET @EffectiveEnd = '2016-03-31';
SET @providerID = 1;

/* -- BEGIN TEST -- */

/* Test the products count matches expected Export = 1260 and Product = 1260*/
SELECT 'Export', count(epm.productId) AS 'Total'
FROM `ctm`.`export_product_master` epm
WHERE epm.providerID = @providerID
UNION ALL
	SELECT 'Product', count(pm.productId) AS 'Total'
	from ctm.product_master pm
		join ctm.product_properties_search pps  on pm.productId = pps.productId 
		where  pm.Status != 'X' 
		 AND pm.providerID = @providerID 
		 AND pm.productId > 0 
		 AND pm.ProductCat = 'HEALTH' 
		 AND curdate() between pm.EffectiveStart AND pm.EffectiveEnd 
		and pps.productType in ('GeneralHealth','Combined')
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


/* TEST: if the data may have conflicts, count = 0 , otherwise insert update statements are required */
SELECT count(*) FROM `ctm`.`product_master`
WHERE productId IN
(SELECT product.productId FROM `ctm`.`export_product_master` product);

/* Disable current products product master 1260 products will be changes*/
UPDATE `ctm`.`product_master` pm
join ctm.product_properties_search pps  on pm.productId = pps.productId 
 SET pm.STATUS = 'X'
 WHERE pm.Status != 'X' 
		 AND pm.providerID = @providerID 
		 AND pm.productId > 0 
		 AND pm.ProductCat = 'HEALTH' 
		 AND curdate() between pm.EffectiveStart AND pm.EffectiveEnd 
		and pps.productType in ('GeneralHealth','Combined');

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

/* Test import has worked there should be 1260 products */


select count(pm.productId) from ctm.product_master pm
join ctm.product_properties_search pps  on pm.productId = pps.productId 
where  pm.Status != 'X' 
AND pm.providerID = @providerID 
AND pm.productId > 0 
AND pm.ProductCat = 'HEALTH' 
AND pm.EffectiveStart = @EffectiveStart 
AND pm.EffectiveEnd = @EffectiveEnd 
and pps.productType in ('GeneralHealth','Combined')
limit  9999;

-- expire all super extras on 23:59:59 11/09/2015 
-- this job has been done under HLT-2386 and have to redo it again
-- that time below query run in the middle of the data migration process which was wrong now this job is gonna make all correct
-- TEST count 98
select count(*) from `ctm`.`product_master` pm
 WHERE curdate() between pm.EffectiveStart AND pm.EffectiveEnd 
	AND providerID = @providerID
	AND Status != 'X'
		 AND pm.ProductCat = 'HEALTH' 
	AND LongTitle like '%Super Extras%';

UPDATE `ctm`.`product_master` pm
 SET effectiveEnd='2015-09-11'
 WHERE curdate() between pm.EffectiveStart AND pm.EffectiveEnd 
	AND providerID = @providerID
	AND Status != 'X'
		 AND pm.ProductCat = 'HEALTH' 
	AND LongTitle like '%Super Extras%';