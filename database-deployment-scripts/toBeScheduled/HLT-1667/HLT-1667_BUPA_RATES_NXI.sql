/* -- START POPULATING EXPORT TABLES (for importing into NXQ) -- */

/* Truncate the export tables */
TRUNCATE `ctm`.`export_product_master`;
TRUNCATE `ctm`.`export_product_properties_ext`;
TRUNCATE `ctm`.`export_product_properties`;
TRUNCATE `ctm`.`export_product_properties_search`;

/* Run 4 insert/update queries to populate export tables */

/* 1. Copy product master  */
INSERT INTO `ctm`.`export_product_master`
SELECT * FROM `ctm`.`product_master` product
WHERE Status != 'X'
AND providerID = 15
AND now() BETWEEN EffectiveStart and EffectiveEnd
AND Longtitle like '%Young Singles Saver%'
AND productId > 0
AND ProductCat = 'HEALTH';


/* 2. Copy product properties ext */
INSERT INTO `ctm`.`export_product_properties_ext`
SELECT * FROM `ctm`.`product_properties_ext` original
WHERE productId IN
(SELECT product.productId FROM `ctm`.`export_product_master` product);


/* 3. Copy product properties */
INSERT INTO `ctm`.`export_product_properties`
SELECT * FROM `ctm`.`product_properties` original
WHERE productId IN
(SELECT product.productId FROM `ctm`.`export_product_master` product);

/* 4. Copy product search (this is the main index) */
INSERT INTO `ctm`.`export_product_properties_search`
SELECT * FROM `ctm`.`product_properties_search` original
WHERE productId IN
(SELECT product.productId FROM `ctm`.`export_product_master` product);

/* 5. Setting status to 'N' has been omitted as product available determined by start date */

/* -- END NXI STEPS-- */