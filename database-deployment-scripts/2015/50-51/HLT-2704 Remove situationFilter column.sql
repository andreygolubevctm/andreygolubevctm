ALTER TABLE `ctm`.`product_properties_search` 
DROP COLUMN `situationFilter`,
DROP INDEX `SITUATION_FILTER` ;

ALTER TABLE `ctm`.`export_product_properties_search` 
DROP COLUMN `situationFilter`;