/*
-- Query: SELECT * FROM aggregator.features_product_type where vertical='homelmi'
LIMIT 0, 1000

-- Date: 2015-07-09 13:09
*/
INSERT INTO aggregator.`features_product_type` (`id`,`name`,`code`,`Vertical`) VALUES (14,'Home','HOME','HOMELMI');
INSERT INTO aggregator.`features_product_type` (`id`,`name`,`code`,`Vertical`) VALUES (15,'Home & Contents','H&C','HOMELMI');
-- ROLLBACK:
-- DELETE FROM aggregator.features_product_type WHERE vertical = 'HOMELMI' LIMIT 2;