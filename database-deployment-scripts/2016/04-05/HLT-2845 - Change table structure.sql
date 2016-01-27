ALTER TABLE `ctm`.`product_properties_search`
ADD COLUMN `situationFilter` VARCHAR(3) NULL DEFAULT NULL AFTER `monthlyLHC`,
ADD INDEX `SITUATION_FILTER` (`situationFilter` ASC);

ALTER TABLE `ctm`.`export_product_properties_search`
ADD COLUMN `situationFilter` VARCHAR(3) NULL DEFAULT NULL AFTER `monthlyLHC`;