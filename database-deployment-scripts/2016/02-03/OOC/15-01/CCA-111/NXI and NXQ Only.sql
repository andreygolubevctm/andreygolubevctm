SET @pId = (SELECT ProviderId FROM ctm.provider_master WHERE Name='Bankwest');

-- Check - 3 products with effective end date of 2040-12-31 and Status of ''
SELECT * FROM ctm.product_master WHERE ProviderId=@pId AND ProductCat='CREDITCARD' AND productCode IN ('BNKW-BLR','BNKW-BLRG','BNKW-BLRP');

-- Update
UPDATE ctm.product_master SET EffectiveEnd='2016-01-13', Status='X' WHERE ProviderId=@pId AND ProductCat='CREDITCARD' AND productCode IN ('BNKW-BLR','BNKW-BLRG','BNKW-BLRP');

-- Check - 3 products with effective end date of 2016-01-13 and Status of 'X'
SELECT * FROM ctm.product_master WHERE ProviderId=@pId AND ProductCat='CREDITCARD' AND productCode IN ('BNKW-BLR','BNKW-BLRG','BNKW-BLRP');

/* Rollback
UPDATE ctm.product_master SET EffectiveEnd='2040-12-31', Status='' WHERE ProviderId=@pId AND ProductCat='CREDITCARD' AND productCode IN ('BNKW-BLR','BNKW-BLRG','BNKW-BLRP');
-- Check - 3 products with effective end date of 2040-12-31 and Status of ''
SELECT * FROM ctm.product_master WHERE ProviderId=@pId AND ProductCat='CREDITCARD' AND productCode IN ('BNKW-BLR','BNKW-BLRG','BNKW-BLRP');
*/