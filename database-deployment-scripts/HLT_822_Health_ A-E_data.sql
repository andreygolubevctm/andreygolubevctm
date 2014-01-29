-- Test Script
SELECT count(productId) FROM ctm.product_properties_ext
WHERE `Type` = 'A' OR `Type` = 'E';


-- Deletion
DELETE FROM ctm.product_properties_ext
WHERE productId <= 150000
AND `Type` = 'A';

DELETE FROM ctm.product_properties_ext
WHERE productId <= 150000
AND `Type` = 'E';


DELETE FROM ctm.product_properties_ext
WHERE productId BETWEEN 150000 AND 175000
AND `Type` = 'A';

DELETE FROM ctm.product_properties_ext
WHERE productId BETWEEN 150000 AND 175000
AND `Type` = 'E';


DELETE FROM ctm.product_properties_ext
WHERE productId >= 175000
AND `Type` = 'A';

DELETE FROM ctm.product_properties_ext
WHERE productId >= 175000
AND `Type` = 'E';