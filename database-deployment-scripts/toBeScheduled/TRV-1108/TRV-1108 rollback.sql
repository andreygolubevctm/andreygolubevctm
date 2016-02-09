SET @ONECOVER = (select providerId from ctm.provider_master where providerCode = '1COV');
SET @TUNDER = (select providerId from ctm.provider_master where providerCode = '30UN');
SET @SKI = (select providerId from ctm.provider_master where providerCode = 'SKII');
SET @KANG = (select providerId from ctm.provider_master where providerCode = 'KANG');




delete from ctm.travel_product where providerId = @ONECOVER and providerProductCode in ('16','17','18','19AU') limit 4;


-- test onecover update and changes expect 0
select count(*) from ctm.travel_product where providerId = @ONECOVER and providerProductCode in ('16','17','18','19AU');


delete from ctm.travel_product where providerId = @TUNDER and providerProductCode = '20' limit 1;

 -- test 30un expect 0
select count(*) from ctm.travel_product where providerId = @TUNDER and providerProductCode = '20';



UPDATE ctm.travel_product SET providerProductCode = '6' where providerId = @SKI and providerProductCode = '23'
  and productCode = 'SKII-TRAVEL-225' limit 1;

delete from ctm.travel_product where providerId = @SKI and providerProductCode in ('22','24') limit 2;

-- test ski expect 1
select count(*) from ctm.travel_product where providerId = @SKI and providerProductCode in ('23','22','24','6');


UPDATE ctm.travel_product SET providerProductCode = '1035WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-252' and providerProductCode = '13WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1060WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-254' and providerProductCode = '14WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1135WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-253' and providerProductCode = '15WW' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1160WW'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-255' and providerProductCode = '16WW' limit 1;

-- test KANG expect 4
 select count(*) from ctm.travel_product where providerId = @KANG and providerProductCode in ('1035WW','1060WW','1135WW','1160WW');


UPDATE ctm.travel_product SET providerProductCode = '1035WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-256' and providerProductCode = '13WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1160WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-259' and providerProductCode = '14WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1135WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-257' and providerProductCode = '15WE' limit 1;

UPDATE ctm.travel_product SET providerProductCode = '1060WE'  WHERE providerId = @KANG
        AND productCode = 'KANG-TRAVEL-258' and providerProductCode = '16WE' limit 1;

-- test KANG expect 4
 select count(*) from ctm.travel_product where providerId = @KANG and providerProductCode in ('1035WE','1160WE','1135WE','1060WE');

