/*
-- Query: SELECT * FROM aggregator.features_product_type where vertical='carlmi'
LIMIT 0, 1000

-- Date: 2015-07-08 16:50
*/
INSERT INTO `aggregator`.`features_product_type` (`id`,`name`,`code`,`Vertical`) VALUES (13,'Comprehensive','COMP','CARLMI');


-- ROLLBACK:
-- DELETE FROM aggregator.features_product_type WHERE vertical = 'CARLMI' LIMIT 1;