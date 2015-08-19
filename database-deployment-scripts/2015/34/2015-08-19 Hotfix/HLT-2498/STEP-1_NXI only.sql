-- Warning this is a generated script and may not handle things such as status 'O' 
-- A developer should always review this before running 
-- STEP 1 extract from NXI 
SET @EffectiveStart = '2015-04-01';
SET @EffectiveEnd = '2016-03-31';
SET @providerID = 1;

-- TEST  count= 1260
select count(pm.productId) from ctm.product_properties_search pps 
join ctm.product_master pm on pm.productId = pps.productId 
where  pm.Status != 'X' 
 AND pm.providerID = @providerID 
 AND pm.productId > 0 
 AND pm.ProductCat = 'HEALTH' 
 AND pm.EffectiveStart = @EffectiveStart 
 AND pm.EffectiveEnd = @EffectiveEnd 
and pps.productType in ('GeneralHealth','Combined')
limit  9999;

 /* Truncate the export tables */ 
TRUNCATE `ctm`.`export_product_master`; 
TRUNCATE `ctm`.`export_product_properties_ext`; 
TRUNCATE `ctm`.`export_product_properties`; 
TRUNCATE `ctm`.`export_product_properties_search`; 
TRUNCATE `ctm`.`export_product_capping_exclusions`; 


/* Run 4 insert/update queries to populate export tables */ 
/* 1. Copy product master  */ 
INSERT INTO `ctm`.`export_product_master` 
select pm.* from ctm.product_master pm
join ctm.product_properties_search pps  on pm.productId = pps.productId 
where  pm.Status != 'X' 
 AND pm.providerID = @providerID 
 AND pm.productId > 0 
 AND pm.ProductCat = 'HEALTH' 
 AND pm.EffectiveStart = @EffectiveStart 
 AND pm.EffectiveEnd = @EffectiveEnd 
and pps.productType in ('GeneralHealth','Combined')
limit  9999;


/* 2. Copy product properties ext */ 
INSERT INTO `ctm`.`export_product_properties_ext` 
SELECT * FROM `ctm`.`product_properties_ext` original 
WHERE productId IN ( 
		select pm.productId from ctm.product_master pm
		join ctm.product_properties_search pps  on pm.productId = pps.productId 
		where  pm.Status != 'X' 
		 AND pm.providerID = @providerID 
		 AND pm.productId > 0 
		 AND pm.ProductCat = 'HEALTH' 
		 AND pm.EffectiveStart = @EffectiveStart 
		 AND pm.EffectiveEnd = @EffectiveEnd 
		and pps.productType in ('GeneralHealth','Combined')
		)
 AND productId > 0;


/* 3. Copy product properties */ 
INSERT INTO `ctm`.`export_product_properties` 
SELECT * FROM `ctm`.`product_properties` original 
WHERE productId IN ( 
		select pm.productId from ctm.product_master pm
		join ctm.product_properties_search pps  on pm.productId = pps.productId 
		where  pm.Status != 'X' 
		 AND pm.providerID = @providerID 
		 AND pm.productId > 0 
		 AND pm.ProductCat = 'HEALTH' 
		 AND pm.EffectiveStart = @EffectiveStart 
		 AND pm.EffectiveEnd = @EffectiveEnd 
		and pps.productType in ('GeneralHealth','Combined')
		)
 AND productId > 0; 


/* 4. Copy product search (this is the main index) */ 
INSERT INTO `ctm`.`export_product_properties_search` 
SELECT * FROM `ctm`.`product_properties_search` original 
WHERE productId IN ( 
		select pm.productId from ctm.product_master pm
		join ctm.product_properties_search pps  on pm.productId = pps.productId 
		where  pm.Status != 'X' 
		 AND pm.providerID = @providerID 
		 AND pm.productId > 0 
		 AND pm.ProductCat = 'HEALTH' 
		 AND pm.EffectiveStart = @EffectiveStart 
		 AND pm.EffectiveEnd = @EffectiveEnd 
		and pps.productType in ('GeneralHealth','Combined')
		)
 AND productId > 0;


/* 5. Copy product capping exclusion (this is the main index) */ 
INSERT INTO `ctm`.`export_product_capping_exclusions` 
SELECT * FROM `ctm`.`product_capping_exclusions` original 
WHERE productId IN ( 
		select pm.productId from ctm.product_master pm
		join ctm.product_properties_search pps  on pm.productId = pps.productId 
		where  pm.Status != 'X' 
		 AND pm.providerID = @providerID 
		 AND pm.productId > 0 
		 AND pm.ProductCat = 'HEALTH' 
		 AND pm.EffectiveStart = @EffectiveStart 
		 AND pm.EffectiveEnd = @EffectiveEnd 
		and pps.productType in ('GeneralHealth','Combined')
		)
 AND productId > 0;

