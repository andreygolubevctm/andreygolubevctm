-- TEST
select * from ctm.product_master where productCat = 'UTILITIES';
select * from ctm.product_master where productCat = 'empty';

DELETE FROM ctm.product_master where productCat = 'UTILITIES';
DELETE FROM  ctm.product_master where productCat = 'empty';