
SET @provider_id = (SELECT providerId FROM ctm.provider_master WHERE providerCode='PPTI');
SELECT @provider_id FROM ctm.provider_master

-- Basic
UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='8210a68c-bfec-4c40-b963-a1cf00388197' AND benefitId=2;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (@provider_id,'8210a68c-bfec-4c40-b963-a1cf00388197',2,'Excess on claims','Excess on claims',200,'$200',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

-- Essentials
UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='c9b94be1-99a7-4523-b682-a1cf00389c0c' AND benefitId=2;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (@provider_id,'c9b94be1-99a7-4523-b682-a1cf00389c0c',2,'Excess on claims','Excess on claims',200,'$200',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='c9b94be1-99a7-4523-b682-a1cf00389c0c' AND benefitId=6;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (@provider_id,'c9b94be1-99a7-4523-b682-a1cf00389c0c',6,'Luggage and Personal Effects','Luggage and Personal Effects',3000,'$3,000',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

-- Premium
UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f' AND benefitId=2;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (@provider_id,'0eb6cdfa-2e4e-4108-804a-a1cf0038b64f',2,'Excess on claims','Excess on claims',200,'$200',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f' AND benefitId=6;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (@provider_id,'0eb6cdfa-2e4e-4108-804a-a1cf0038b64f',6,'Luggage and Personal Effects','Luggage and Personal Effects',10000,'$10,000',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

-- Annual
UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='4f466c05-2738-4829-8412-a1cf0038d032' AND benefitId=2;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (@provider_id,'4f466c05-2738-4829-8412-a1cf0038d032',2,'Excess on claims','Excess on claims',200,'$200',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='4f466c05-2738-4829-8412-a1cf0038d032' AND benefitId=6;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (@provider_id,'4f466c05-2738-4829-8412-a1cf0038d032',6,'Luggage and Personal Effects','Luggage and Personal Effects',10000,'$10,000',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');


-- Rollback
-- DELETE ctm.travel_product_benefits WHERE productId='8210a68c-bfec-4c40-b963-a1cf00388197' AND benefitId=2 AND startDate='2016-01-21 00:00:00';
-- DELETE ctm.travel_product_benefits WHERE productId='c9b94be1-99a7-4523-b682-a1cf00389c0c' AND benefitId=2 AND startDate='2016-01-21 00:00:00';
-- DELETE ctm.travel_product_benefits WHERE productId='c9b94be1-99a7-4523-b682-a1cf00389c0c' AND benefitId=6 AND startDate='2016-01-21 00:00:00';
-- DELETE ctm.travel_product_benefits WHERE productId='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f' AND benefitId=2 AND startDate='2016-01-21 00:00:00';
-- DELETE ctm.travel_product_benefits WHERE productId='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f' AND benefitId=6 AND startDate='2016-01-21 00:00:00';
-- DELETE ctm.travel_product_benefits WHERE productId='4f466c05-2738-4829-8412-a1cf0038d032' AND benefitId=2 AND startDate='2016-01-21 00:00:00';
-- DELETE ctm.travel_product_benefits WHERE productId='4f466c05-2738-4829-8412-a1cf0038d032' AND benefitId=6 AND startDate='2016-01-21 00:00:00';

-- UPDATE ctm.travel_product_benefits SET endDate='2040-12-31 00:00:00' WHERE productId='8210a68c-bfec-4c40-b963-a1cf00388197' AND benefitId=2;
-- UPDATE ctm.travel_product_benefits SET endDate='2040-12-31 00:00:00' WHERE productId='c9b94be1-99a7-4523-b682-a1cf00389c0c' AND benefitId=2;
-- UPDATE ctm.travel_product_benefits SET endDate='2040-12-31 00:00:00' WHERE productId='c9b94be1-99a7-4523-b682-a1cf00389c0c' AND benefitId=6;
-- UPDATE ctm.travel_product_benefits SET endDate='2040-12-31 00:00:00' WHERE productId='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f' AND benefitId=2;
-- UPDATE ctm.travel_product_benefits SET endDate='2040-12-31 00:00:00' WHERE productId='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f' AND benefitId=6;
-- UPDATE ctm.travel_product_benefits SET endDate='2040-12-31 00:00:00' WHERE productId='4f466c05-2738-4829-8412-a1cf0038d032' AND benefitId=2;
-- UPDATE ctm.travel_product_benefits SET endDate='2040-12-31 00:00:00' WHERE productId='4f466c05-2738-4829-8412-a1cf0038d032' AND benefitId=6;
