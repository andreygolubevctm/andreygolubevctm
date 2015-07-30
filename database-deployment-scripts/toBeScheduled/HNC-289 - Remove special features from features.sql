-- UPDATE - Remove special feature entries for selected Budget, Virgin and (historical Dodo) products
UPDATE aggregator.features SET description='** from service **' WHERE (productId LIKE 'BUDD-05-29%' OR productId LIKE 'VIRG-05-26%' OR productId LIKE 'EXDD-05-21%') AND code='speFea' AND field_value = 'S';

-- CHECKER - Should be 9 rows with the new copy above (or old copy below if an uhoh occured)
SELECT * FROM aggregator.features WHERE (productId LIKE 'BUDD-05-29%' OR productId LIKE 'VIRG-05-26%' OR productId LIKE 'EXDD-05-21%') AND field_value = 'S';

-- ROLLBACK
-- UPDATE aggregator.features SET description='Save 20% when you buy Home online*' WHERE productId='BUDD-05-29-HHB' AND code='speFea' AND field_value='S';
-- UPDATE aggregator.features SET description='Save 20% when you buy Contents online*' WHERE productId='BUDD-05-29-HHC' AND code='speFea' AND field_value='S';
-- UPDATE aggregator.features SET description='Save 35% when you buy Home & Contents online*' WHERE productId='BUDD-05-29-HHZ' AND code='speFea' AND field_value='S';
-- UPDATE aggregator.features SET description='Home=10% discount*' WHERE productId='EXDD-05-21-HHB' AND code='speFea' AND field_value='S';
-- UPDATE aggregator.features SET description='Contents=10% discount*' WHERE productId='EXDD-05-21-HHC' AND code='speFea' AND field_value='S';
-- UPDATE aggregator.features SET description='Receive a FREE wireless alarm and phone system.' WHERE productId='EXDD-05-21-HHZ' AND code='speFea' AND field_value='S';
-- UPDATE aggregator.features SET description='Home = 10% discount*' WHERE productId='VIRG-05-26-HHB' AND code='speFea' AND field_value='S';
-- UPDATE aggregator.features SET description='Contents = 10% discount*' WHERE productId='VIRG-05-26-HHC' AND code='speFea' AND field_value='S';
-- UPDATE aggregator.features SET description='Home + Contents = 25% discount*' WHERE productId='VIRG-05-26-HHZ' AND code='speFea' AND field_value='S';