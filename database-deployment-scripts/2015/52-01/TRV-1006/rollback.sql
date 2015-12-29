SET @PVIDER_WOM = (select providerId from ctm.provider_master where providerCode = '1FOW');
SET @PVIDER_BUDD = (select providerId from ctm.provider_master where providerCode = 'BUDD');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

SET @NEW_ENDPOINT_LOCAL = 'https://nxq.ecommerce.disconline.com.au/services/3.2/getTravelQuotes';
SET @OLD_ENDPOINT_LOCAL = 'https://nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes';

SET @NEW_ENDPOINT_NONPROD = 'https://services-nxq.ecommerce.disconline.com.au/services/3.2/getTravelQuotes';
SET @OLD_ENDPOINT_NONPROD = 'https://services-nxq.ecommerce.disconline.com.au/services/3.1/getTravelQuotes';

SET @NEW_ENDPOINT_PROD = 'https://services.ecommerce.disconline.com.au/services/3.2/getTravelQuotes';
SET @OLD_ENDPOINT_PROD = 'https://services.ecommerce.disconline.com.au/services/3.1/getTravelQuotes';

SET @NEW_OUTBOUND_PARAMS_BUDD = 'partnerId=CTM0000200,sourceId=0000000001,schemaVersion=3.2';
SET @OLD_OUTBOUND_PARAMS_BUDD = 'partnerId=CTM0000200,sourceId=0000000001,schemaVersion=3.1';

SET @NEW_OUTBOUND_PARAMS_WOM = 'partnerId=CTM0000200,sourceId=0000000002,schemaVersion=3.2';
SET @OLD_OUTBOUND_PARAMS_WOM = 'partnerId=CTM0000200,sourceId=0000000002,schemaVersion=3.1';
-- lets do all of Budget direct updates
update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_LOCAL where providerId = @PVIDER_BUDD
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = '0' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_NONPROD where providerId = @PVIDER_BUDD
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = 'NXS' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_NONPROD where providerId = @PVIDER_BUDD
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = 'NXI' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_NONPROD where providerId = @PVIDER_BUDD
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = 'NXQ' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_PROD where providerId = @PVIDER_BUDD
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = 'PRO' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_OUTBOUND_PARAMS_BUDD where providerId = @PVIDER_BUDD
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyValue = @NEW_OUTBOUND_PARAMS_BUDD limit 1;

-- TEST expect 3
select count(*) from ctm.service_properties where providerId = @PVIDER_BUDD and serviceMasterId = @SERVICE_MASTER_ID
 and servicePropertyValue = @OLD_ENDPOINT_NONPROD and servicePropertyKey = 'url';

 -- TEST expect 1
 select count(*) from ctm.service_properties where providerId = @PVIDER_BUDD and serviceMasterId = @SERVICE_MASTER_ID
 and servicePropertyValue = @OLD_ENDPOINT_PROD and servicePropertyKey = 'url';

 -- TEST expect 1
 select count(*) from ctm.service_properties where providerId = @PVIDER_BUDD and serviceMasterId = @SERVICE_MASTER_ID
 and servicePropertyValue = @OLD_ENDPOINT_LOCAL and servicePropertyKey = 'url';

-- Test expect 1
select count(*) from ctm.service_properties where providerId = @PVIDER_BUDD and serviceMasterId = @SERVICE_MASTER_ID
and servicePropertyValue = @OLD_OUTBOUND_PARAMS_BUDD;

-- lets do all of woman 1st updates

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_LOCAL where providerId = @PVIDER_WOM
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = '0' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_NONPROD where providerId = @PVIDER_WOM
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = 'NXS' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_NONPROD where providerId = @PVIDER_WOM
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = 'NXI' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_NONPROD where providerId = @PVIDER_WOM
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = 'NXQ' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_ENDPOINT_PROD where providerId = @PVIDER_WOM
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'url' and environmentCode = 'PRO' limit 1;

update ctm.service_properties set servicePropertyValue = @OLD_OUTBOUND_PARAMS_WOM where providerId = @PVIDER_WOM
   and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyValue = @NEW_OUTBOUND_PARAMS_WOM limit 1;



-- TEST expect 3
select count(*) from ctm.service_properties where providerId = @PVIDER_WOM and serviceMasterId = @SERVICE_MASTER_ID
 and servicePropertyValue = @OLD_ENDPOINT_NONPROD and servicePropertyKey = 'url';

 -- TEST expect 1
 select count(*) from ctm.service_properties where providerId = @PVIDER_WOM and serviceMasterId = @SERVICE_MASTER_ID
 and servicePropertyValue = @OLD_ENDPOINT_PROD and servicePropertyKey = 'url';

 -- TEST expect 1
 select count(*) from ctm.service_properties where providerId = @PVIDER_WOM and serviceMasterId = @SERVICE_MASTER_ID
 and servicePropertyValue = @OLD_ENDPOINT_LOCAL and servicePropertyKey = 'url';

-- Test Expect 1

select count(*) from ctm.service_properties where providerId = @PVIDER_WOM and serviceMasterId = @SERVICE_MASTER_ID
and servicePropertyValue = @OLD_OUTBOUND_PARAMS_WOM;



-- roll back

SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'BUDD');
SET @FOWPVIDER = (select providerId from ctm.provider_master where providerCode = '1FOW');


delete from ctm.travel_product where providerId = @PVIDER and productCode
in ('AGIS-TRAVEL-7-100-Domestic',
   'AGIS-TRAVEL-8-100-Essential',
   'AGIS-TRAVEL-9-100-Comprehensive',
   'AGIS-TRAVEL-10-100-LastMinute',
   'AGIS-TRAVEL-11-100-AnnualMultiTrip',
   'AGIS-TRAVEL-7-100-Ski',
   'AGIS-TRAVEL-8-100-Ski',
   'AGIS-TRAVEL-9-100-Ski',
   'AGIS-TRAVEL-10-100-Ski',
   'AGIS-TRAVEL-11-100-Ski',
   'AGIS-TRAVEL-7-200-Ski',
   'AGIS-TRAVEL-8-200-Ski',
   'AGIS-TRAVEL-9-200-Ski',
   'AGIS-TRAVEL-10-200-Ski',
   'AGIS-TRAVEL-11-200-Ski') limit 15;

-- Expect 0
select count(*) from ctm.travel_product where providerId = @PVIDER and productCode
in ('AGIS-TRAVEL-7-100-Domestic',
   'AGIS-TRAVEL-8-100-Essential',
   'AGIS-TRAVEL-9-100-Comprehensive',
   'AGIS-TRAVEL-10-100-LastMinute',
   'AGIS-TRAVEL-11-100-AnnualMultiTrip',
   'AGIS-TRAVEL-7-100-Ski',
   'AGIS-TRAVEL-8-100-Ski',
   'AGIS-TRAVEL-9-100-Ski',
   'AGIS-TRAVEL-10-100-Ski',
   'AGIS-TRAVEL-11-100-Ski',
   'AGIS-TRAVEL-7-200-Ski',
   'AGIS-TRAVEL-8-200-Ski',
   'AGIS-TRAVEL-9-200-Ski',
   'AGIS-TRAVEL-10-200-Ski',
   'AGIS-TRAVEL-11-200-Ski');

update ctm.travel_product set providerProductCode = 'J' where productCode = 'AGIS-TRAVEL-7' and providerId = @PVIDER limit 1;
update ctm.travel_product set providerProductCode = 'G' where productCode = 'AGIS-TRAVEL-8' and providerId = @PVIDER limit 1;
update ctm.travel_product set providerProductCode = 'H' where productCode = 'AGIS-TRAVEL-9' and providerId = @PVIDER limit 1;
update ctm.travel_product set providerProductCode = 'I' where productCode = 'AGIS-TRAVEL-10' and providerId = @PVIDER limit 1;
update ctm.travel_product set providerProductCode = 'K' where productCode = 'AGIS-TRAVEL-11' and providerId = @PVIDER limit 1;

update ctm.travel_product set providerProductCode = 'J' where productCode = '1FOW-TRAVEL-19' and providerId = @FOWPVIDER limit 1;
update ctm.travel_product set providerProductCode = 'G' where productCode = '1FOW-TRAVEL-20' and providerId = @FOWPVIDER limit 1;
update ctm.travel_product set providerProductCode = 'H' where productCode = '1FOW-TRAVEL-21' and providerId = @FOWPVIDER limit 1;
update ctm.travel_product set providerProductCode = 'I' where productCode = '1FOW-TRAVEL-22' and providerId = @FOWPVIDER limit 1;
update ctm.travel_product set providerProductCode = 'K' where productCode = '1FOW-TRAVEL-23' and providerId = @FOWPVIDER limit 1;

delete from ctm.travel_product where providerId = @FOWPVIDER and productCode
in ('1FOW-TRAVEL-19-100-Ski',
    '1FOW-TRAVEL-20-100-Ski',
    '1FOW-TRAVEL-21-100-Ski',
    '1FOW-TRAVEL-22-100-Ski',
    '1FOW-TRAVEL-23-100-Ski'
   ) limit 5;


update ctm.travel_product_benefits set productId = 'G' where productId = 'G-200-Essential' and providerId = @PVIDER limit 17;
-- expect 17
select count(*) from ctm.travel_product_benefits where providerId = @PVIDER and productId = 'G';


update ctm.travel_product_benefits set productId = 'H' where productId = 'H-200-Comprehensive' and providerId = @PVIDER limit 22;
-- expect 22
select count(*) from ctm.travel_product_benefits where providerId = @PVIDER and productId = 'H';

update ctm.travel_product_benefits set productId = 'I' where productId = 'I-200-LastMinute' and providerId = @PVIDER limit 7;
-- expect 7
select count(*) from ctm.travel_product_benefits where providerId = @PVIDER and productId = 'I';

update ctm.travel_product_benefits set productId = 'J' where productId = 'J-200-Domestic' and providerId = @PVIDER limit 13;
-- expect 13
select count(*) from ctm.travel_product_benefits where providerId = @PVIDER and productId = 'J';

update ctm.travel_product_benefits set productId = 'K' where productId = 'K-200-AnnualMultiTrip' and providerId = @PVIDER limit 23;
-- expect 23
select count(*) from ctm.travel_product_benefits where providerId = @PVIDER and productId = 'K';

delete from ctm.travel_product_benefits where providerId = @PVIDER and productId in (
'G-100-Essential',
'G-100-Ski',
'G-200-Ski',
'H-100-Comprehensive',
'H-100-Ski',
'H-200-Ski',
'I-100-LastMinute',
'I-100-Ski',
'I-200-Ski',
'J-100-Domestic',
'J-100-Ski',
'J-200-Ski',
'K-100-AnnualMultiTrip',
'K-100-Ski',
'K-200-Ski') limit 306;

-- expect 0
select count(*) from ctm.travel_product_benefits where providerId = @PVIDER and productId in (
'G-100-Essential',
'G-100-Ski',
'G-200-Ski',
'H-100-Comprehensive',
'H-100-Ski',
'H-200-Ski',
'I-100-LastMinute',
'I-100-Ski',
'I-200-Ski',
'J-100-Domestic',
'J-100-Ski',
'J-200-Ski',
'K-100-AnnualMultiTrip',
'K-100-Ski',
'K-200-Ski');


update ctm.travel_product_benefits set productId = 'G' where productId = 'G-100-Essential' and providerId = @FOWPVIDER limit 17;
-- expect 17
select count(*) from ctm.travel_product_benefits where productId = 'G' and providerId = @FOWPVIDER;

update ctm.travel_product_benefits set productId = 'H' where productId = 'H-100-Comprehensive' and providerId = @FOWPVIDER limit 22;
-- expect 22
select count(*) from ctm.travel_product_benefits where productId = 'H' and providerId = @FOWPVIDER;

update ctm.travel_product_benefits set productId = 'I' where productId = 'I-100-LastMinute' and providerId = @FOWPVIDER limit 7;
-- expect 7
select count(*) from ctm.travel_product_benefits where productId = 'I' and providerId = @FOWPVIDER;

update ctm.travel_product_benefits set productId = 'J' where productId = 'J-100-Domestic' and providerId = @FOWPVIDER limit 13;
-- expect 13
select count(*) from ctm.travel_product_benefits where productId = 'J' and providerId = @FOWPVIDER;

update ctm.travel_product_benefits set productId = 'K' where productId = 'K-100-AnnualMultiTrip' and providerId = @FOWPVIDER limit 22;
-- expect 22
select count(*) from ctm.travel_product_benefits where productId = 'K' and providerId = @FOWPVIDER;

delete from  ctm.travel_product_benefits where providerId = @FOWPVIDER and productId in (
'G-100-Ski',
'H-100-Ski',
'I-100-Ski',
'J-100-Ski',
'K-100-Ski') limit 111;

-- expect 0
select count(*) from ctm.travel_product_benefits where providerId = @FOWPVIDER and productId in (
'G-100-Ski',
'H-100-Ski',
'I-100-Ski',
'J-100-Ski',
'K-100-Ski'
);





delete from ctm.travel_benefit_master where benefitName = 'AVALANCHE_COVER' limit 1;
delete from ctm.travel_benefit_master where benefitName = 'LIFT_PASS' limit 1;
delete from ctm.travel_benefit_master where benefitName = 'SNOW_SPORTS_EQUIPMENT' limit 1;









