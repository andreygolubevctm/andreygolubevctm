-- Should return 1 result
SELECT * FROM ctm.product_master WHERE CURDATE() < EffectiveEnd AND productCode ='BNKW-FFP' and productCat = 'CREDITCARD';

UPDATE ctm.product_master SET effectiveEnd = '2015-09-24' where productCode= 'BNKW-FFP' LIMIT 1;

-- Should return 0 results
SELECT * FROM ctm.product_master WHERE CURDATE() < EffectiveEnd AND productCode ='BNKW-FFP' and productCat = 'CREDITCARD';
