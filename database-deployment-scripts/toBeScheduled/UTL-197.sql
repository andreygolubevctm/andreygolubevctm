SELECT * FROM ctm.provider_properties WHERE providerId IN (SELECT providerId FROM product_master WHERE productCat='UTILITIES');
SELECT * FROM ctm.provider_master WHERE providerId IN (SELECT providerId FROM product_master WHERE productCat='UTILITIES');
SELECT * FROM ctm.product_properties WHERE productId IN (SELECT productId FROM product_master WHERE productCat='UTILITIES');
SELECT * FROM ctm.product_master where productCat='UTILITIES';
SELECT * FROM ctm.configuration WHERE configCode='emailCode';
SELECT * FROM ctm.configuration WHERE verticalId=5 AND configCode='switchwiseWebService';
SELECT * FROM ctm.configuration WHERE verticalId=5 AND configCode='useLocalDataSource';

DELETE FROM ctm.provider_properties WHERE providerId IN (SELECT providerId FROM product_master WHERE productCat='UTILITIES');

-- DELETE FROM ctm.provider_master WHERE providerId IN (SELECT providerId FROM product_master WHERE productCat='UTILITIES');
-- Only Integral Energy to delete from PROD
DELETE FROM ctm.provider_master WHERE providerId = 25;

DELETE FROM ctm.product_properties WHERE productId IN (SELECT productId FROM product_master WHERE productCat='UTILITIES');

DELETE FROM ctm.product_master where productCat='UTILITIES';

DELETE FROM ctm.configuration WHERE verticalId=5 AND configCode='emailCode';
DELETE FROM ctm.configuration WHERE verticalId=5 AND configCode='switchwiseWebService';
DELETE FROM ctm.configuration WHERE verticalId=5 AND configCode='useLocalDataSource';
