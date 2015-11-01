-- Should return 2 results
SELECT * FROM ctm.product_master WHERE '2015-10-18' < EffectiveEnd AND productCode IN('ANZ-RP', 'ANZ-FFP') and productCat = 'CREDITCARD';

UPDATE ctm.product_master SET effectiveEnd = '2015-10-18' where productCode IN('ANZ-RP', 'ANZ-FFP') LIMIT 2;

-- Should return 0 results
SELECT * FROM ctm.product_master WHERE '2015-10-18' < EffectiveEnd AND productCode IN('ANZ-RP', 'ANZ-FFP') and productCat = 'CREDITCARD';
