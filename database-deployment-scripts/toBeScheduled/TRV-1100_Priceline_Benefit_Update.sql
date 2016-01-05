-- Basic
UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='8210a68c-bfec-4c40-b963-a1cf00388197' AND benefitId=2;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (309,'8210a68c-bfec-4c40-b963-a1cf00388197',2,'Excess on claims','Excess on claims',200,'$200',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

-- Essentials
UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='c9b94be1-99a7-4523-b682-a1cf00389c0c' AND benefitId=2;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (309,'c9b94be1-99a7-4523-b682-a1cf00389c0c',2,'Excess on claims','Excess on claims',200,'$200',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='c9b94be1-99a7-4523-b682-a1cf00389c0c' AND benefitId=6;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (309,'c9b94be1-99a7-4523-b682-a1cf00389c0c',6,'Luggage and Personal Effects','Luggage and Personal Effects',3000,'$3,000',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

-- Premium
UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f' AND benefitId=2;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (309,'0eb6cdfa-2e4e-4108-804a-a1cf0038b64f',2,'Excess on claims','Excess on claims',200,'$200',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');

UPDATE ctm.travel_product_benefits SET endDate='2016-01-20 23:59:59' WHERE productId='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f' AND benefitId=6;
INSERT INTO ctm.travel_product_benefits (providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate)
    VALUES (309,'0eb6cdfa-2e4e-4108-804a-a1cf0038b64f',6,'Luggage and Personal Effects','Luggage and Personal Effects',10000,'$10,000',0,'2016-01-21 00:00:00','2040-12-31 00:00:00');