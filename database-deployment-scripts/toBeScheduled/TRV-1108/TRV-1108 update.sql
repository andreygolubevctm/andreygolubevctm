SET @ONECOVER = (select providerId from ctm.provider_master where providerCode = '1COV');
SET @TUNDER = (select providerId from ctm.provider_master where providerCode = '30UN');
SET @SKI = (select providerId from ctm.provider_master where providerCode = 'SKII');
SET @KANG = (select providerId from ctm.provider_master where providerCode = 'KANG');


-- onecover update and changes

 insert into ctm.travel_product (providerId,productCode,productName,providerProductCode,baseProduct,effectiveStart,effectiveEnd)
 values (@ONECOVER,'1COV-TRAVEL-608187','Comprehensive Domestic','16','0','2016-01-12','2040-12-31');


 insert into ctm.travel_product (providerId,productCode,productName,providerProductCode,baseProduct,effectiveStart,effectiveEnd)
 values (@ONECOVER,'1COV-TRAVEL-608188','Frequent Traveller Domestic','17','0','2016-01-12','2040-12-31');

insert into ctm.travel_product (providerId,productCode,productName,providerProductCode,baseProduct,effectiveStart,effectiveEnd)
 values (@ONECOVER,'1COV-TRAVEL-608189','Ski Plus Domestic','18','0','2016-01-12','2040-12-31');

insert into ctm.travel_product (providerId,productCode,productName,providerProductCode,baseProduct,effectiveStart,effectiveEnd)
 values (@ONECOVER,'1COV-TRAVEL-608190','Annual Ski Plus Domestic','19AU','0','2016-01-12','2040-12-31');

 -- test onecover update and changes expect 4
 select count(*) from ctm.travel_product where providerId = @ONECOVER and providerProductCode in ('16','17','18','19AU');


 -- 30un
 insert into ctm.travel_product (providerId,productCode,productName,providerProductCode,baseProduct,effectiveStart,effectiveEnd)
 values (@TUNDER,'30UN-TRAVEL-257','U30 Single Trip Domestic','20','0','2016-01-12','2040-12-31');

 -- test 30un expect 1
 select count(*) from ctm.travel_product where providerId = @TUNDER and providerProductCode = '20';

 -- SKI

UPDATE ctm.travel_product SET providerProductCode = '23' where providerId = @SKI and providerProductCode = '6'
  and productCode = 'SKII-TRAVEL-225' limit 1;

insert into ctm.travel_product (providerId,productCode,productName,providerProductCode,baseProduct,effectiveStart,effectiveEnd)
 values (@SKI,'SKII-TRAVEL-226','Ski Plus Domestic','22','0','2016-01-12','2040-12-31');

 insert into ctm.travel_product (providerId,productCode,productName,providerProductCode,baseProduct,effectiveStart,effectiveEnd)
 values (@SKI,'SKII-TRAVEL-227','Annual Ski Plus Domestic','24','0','2016-01-12','2040-12-31');

 -- test ski expect 3
 select count(*) from ctm.travel_product where providerId = @SKI and providerProductCode in ('23','22','24');

-- KANGO

UPDATE ctm.travel_product SET providerProductCode = '13WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-252' and providerProductCode = '1035WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '14WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-254' and providerProductCode = '1060WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '15WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-253' and providerProductCode = '1135WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '16WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-255' and providerProductCode = '1160WW' limit 1;

-- test KANG expect 4
 select count(*) from ctm.travel_product where providerId = @KANG and providerProductCode in ('13WW','14WW','15WW','16WW');


-- roll back

/*
UPDATE ctm.travel_product SET providerProductCode = '1035WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-252' and providerProductCode = '13WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1060WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-254' and providerProductCode = '14WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1135WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-253' and providerProductCode = '15WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1160WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-255' and providerProductCode = '16WW' limit 1;
*/
-- done


UPDATE ctm.travel_product SET providerProductCode = '13WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-256' and providerProductCode = '1035WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '14WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-259' and providerProductCode = '1160WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '15WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-257' and providerProductCode = '1135WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '16WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-258' and providerProductCode = '1060WE' limit 1;

-- test KANG expect 4
 select count(*) from ctm.travel_product where providerId = @KANG and providerProductCode in ('13WE','14WE','15WE','16WE');

-- rollback
/*
UPDATE ctm.travel_product SET providerProductCode = '1035WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-256' and providerProductCode = '13WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1160WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-259' and providerProductCode = '14WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1135WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-257' and providerProductCode = '15WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1060WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-258' and providerProductCode = '16WE' limit 1;
*/



select * from ctm.travel_product where providerId = @PVIDER;


-- was 2ww
-- UPDATE ctm.travel_product SET providerProductCode = '2' where providerId = @PVIDER and providerProductCode = '2WW'
--  and productCode = '1COV-TRAVEL-605074' limit 1;


SELECT p.providerCode, t.productCode, t.productName, t.title, t.description, t.effectiveStart,t.effectiveEnd,
                                t.pdsUrl, t.maxTripDuration, t.providerProductCode, t.baseProduct
                        FROM ctm.travel_product t
                                JOIN ctm.provider_master p
                                ON t.providerId = p.providerId
                        WHERE curdate() BETWEEN t.effectiveStart AND t.effectiveEnd
                                AND curdate() BETWEEN p.effectiveStart AND t.effectiveEnd order by  p.providerCode asc;