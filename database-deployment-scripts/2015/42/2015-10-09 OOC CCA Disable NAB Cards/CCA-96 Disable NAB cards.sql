-- Should return 9 results
SELECT * FROM ctm.product_master WHERE '2015-10-12' < EffectiveEnd AND productCode IN('NABA-LR', 'NABA-LF', 'NABA-P2', 'NABA-QR', 'NABA-QRP', 'NABA-VR', 'NABA-VRP', 'NABA-FR', 'NABA-P') and productCat = 'CREDITCARD';

UPDATE ctm.product_master SET effectiveEnd = '2015-10-11' where productCode IN('NABA-LR', 'NABA-LF', 'NABA-P2', 'NABA-QR', 'NABA-QRP', 'NABA-VR', 'NABA-VRP', 'NABA-FR', 'NABA-P') LIMIT 9;

-- Should return 0 results
SELECT * FROM ctm.product_master WHERE '2015-10-12' < EffectiveEnd AND productCode IN('NABA-LR', 'NABA-LF', 'NABA-P2', 'NABA-QR', 'NABA-QRP', 'NABA-VR', 'NABA-VRP', 'NABA-FR', 'NABA-P') and productCat = 'CREDITCARD';
