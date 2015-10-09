-- TEST: Return 1 row
SET @ID = (SELECT productId FROM ctm.product_master WHERE productCode = 'BNKW-FFP' and productCat = 'CREDITCARD');
SELECT * FROM ctm.product_properties_text WHERE productId = @ID AND propertyId = 'rewards-desc';

-- Just resetting to same ID so you can highlight this section. Should affect 1 row.
SET @ID = (SELECT productId FROM ctm.product_master WHERE productCode = 'BNKW-FFP' and productCat = 'CREDITCARD');
UPDATE ctm.product_properties_text SET `Text` = "-Earn 0.75 Qantas Points^ for every $1 you spend on eligible purchases
 -Receive 50,000 introductory bonus Qantas Points*" WHERE productId = @ID AND propertyId = 'rewards-desc' LIMIT 1;

-- Can't do a post test because of new lines
