SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'I4LS');
SET @TIZ = (select providerId from ctm.provider_master where providerCode = 'TINZ');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');


/*
property changes
*/

UPDATE ctm.service_properties SET effectiveEnd='2015-08-31 00:00:00' WHERE providerId = @PVIDER
 and serviceMasterId = @SERVICE_MASTER_ID
 and servicePropertyKey = 'serviceType'
 and servicePropertyValue = 'db' limit 1;


INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PVIDER, 'serviceType', 'soap', '2015-09-01', '2040-12-31', 'SERVICE');


INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PVIDER, 'url', 'https://quote.insure4less.com.au/ctm/', '2015-09-01', '2040-12-31', 'SERVICE');

INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PVIDER, 'inboundParams', 'defaultProductId=NODEFAULT,service=I4LS,trackCode=24', '2015-09-01', '2040-12-31', 'SERVICE');

INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
VALUES (@SERVICE_MASTER_ID, 'PRO', '0', @PVIDER, 'url', 'https://quote.insure4less.com.au/ctm/', '2015-09-01', '2040-12-31', 'SERVICE');

INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PVIDER, 'trackCode', '24', '2015-09-01', '2040-12-31', 'SERVICE');

INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PVIDER, 'timeout', '20', '2015-09-01', '2040-12-31', 'SERVICE');

/*
TESTERS expect 7
*/
select count(*) from ctm.service_properties where providerId = @PVIDER and servicePropertyKey in
 ('serviceType','url','inboundParams','trackCode','timeout');

/*
Tester expect 1
*/
select count(*) from ctm.service_properties where providerId = @PVIDER and
   servicePropertyKey = 'serviceType' and effectiveEnd='2015-08-31 00:00:00';



SET @PVIDER = (select providerId from ctm.provider_master where providerCode = 'I4LS');
SET @TIZ = (select providerId from ctm.provider_master where providerCode = 'TINZ');
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');

-- create base and override AMT products names

INSERT INTO ctm.travel_product
(providerId, productCode, description,baseProduct, pdsUrl, effectiveStart, effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-',
        'insure4less policies are underwritten at Lloyd\'s of London, one of the world\'s largest insurance markets, to give complete peace of mind. insure4less holds an Australian Financial Services licence meaning that they are regulated and have to adhere to strict guidelines. insure4less is an Australian company and isn\'t owned by a foreign parent. All insure4less insurance policies are supported by a 15 day money back guarantee.', '1', 'http://quote.insure4less.com.au/pds/download/latest', '2015-08-04', '2040-12-31');

-- provider does not allow send a separate node for duration so overriting it here so that travelquote can populate duration otherwise it will be null


INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-5-31','insure4less Travel Insurance, AMT Essentials, Worldwide exc USA & Canada','0','31','2-3-5-31','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-6-31','insure4less Travel Insurance, AMT Excel, Worldwide exc USA & Canada','0','31','2-3-6-31','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-7-31','insure4less Travel Insurance, AMT Excel Plus, Worldwide exc USA & Canada','0','31','2-3-7-31','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-15-31','insure4less Travel Insurance, AMT Medical Only, Worldwide exc USA & Canada','0','31','2-3-15-31','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-5-45','insure4less Travel Insurance, AMT Essentials, Worldwide exc USA & Canada',
                  '0','45','2-3-5-45','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-6-45','insure4less Travel Insurance, AMT Excel, Worldwide exc USA & Canada',
                  '0','45','2-3-6-45','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-7-45','insure4less Travel Insurance, AMT Excel, Plus Worldwide exc USA & Canada',
                 '0','45','2-3-7-45','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-15-45','insure4less Travel Insurance, AMT Medical Only, Worldwide exc USA & Canada',
                 '0','45','2-3-15-45','2015-08-04', '2040-12-31');
--

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-5-62','insure4less Travel Insurance, AMT Essentials, Worldwide exc USA & Canada',
                  '0','62','2-3-5-62','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-6-62','insure4less Travel Insurance, AMT Excel, Worldwide exc USA & Canada',
                  '0','62','2-3-6-62','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-7-62','insure4less Travel Insurance, AMT Excel, Plus Worldwide exc USA & Canada',
                 '0','62','2-3-7-62','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-15-62','insure4less Travel Insurance, AMT Medical Only, Worldwide exc USA & Canada',
                 '0','62','2-3-15-62','2015-08-04', '2040-12-31');
--

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-5-93','insure4less Travel Insurance, AMT Essentials, Worldwide exc USA & Canada',
                  '0','93','2-3-5-93','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-6-93','insure4less Travel Insurance, AMT Excel, Worldwide exc USA & Canada',
                  '0','93','2-3-6-93','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-7-93','insure4less Travel Insurance, AMT Excel, Plus Worldwide exc USA & Canada',
                 '0','93','2-3-7-93','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-3-15-93','insure4less Travel Insurance, AMT Medical Only, Worldwide exc USA & Canada',
                 '0','93','2-3-15-93','2015-08-04', '2040-12-31');
--

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-5-31','insure4less Travel Insurance, AMT Essentials, Worldwide inc USA & Canada','0','31','2-4-5-31','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-6-31','insure4less Travel Insurance, AMT Excel, Worldwide inc USA & Canada','0','31','2-4-6-31','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-7-31','insure4less Travel Insurance, AMT Excel, Plus Worldwide inc USA & Canada','0','31','2-4-7-31','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-15-31','insure4less Travel Insurance, AMT Medical Only, Worldwide inc USA & Canada','0','31','2-4-15-31','2015-08-04', '2040-12-31');

--
INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-5-45','insure4less Travel Insurance, AMT Essentials, Worldwide inc USA & Canada',
                  '0','45','2-4-5-45','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-6-45','insure4less Travel Insurance, AMT Excel, Worldwide inc USA & Canada',
                  '0','45','2-4-6-45','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-7-45','insure4less Travel Insurance, AMT Excel, Plus Worldwide inc USA & Canada',
                 '0','45','2-4-7-45','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-15-45','insure4less Travel Insurance, AMT Medical Only, Worldwide inc USA & Canada',
                 '0','45','2-4-15-45','2015-08-04', '2040-12-31');
--

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-5-62','insure4less Travel Insurance, AMT Essentials, Worldwide inc USA & Canada',
                  '0','62','2-4-5-62','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-6-62','insure4less Travel Insurance, AMT Excel, Worldwide inc USA & Canada',
                  '0','62','2-4-6-62','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-7-62','insure4less Travel Insurance, AMT Excel, Plus Worldwide inc USA & Canada',
                 '0','62','2-4-7-62','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-15-62','insure4less Travel Insurance, AMT Medical Only, Worldwide inc USA & Canada',
                 '0','62','2-4-15-62','2015-08-04', '2040-12-31');
--

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-5-93','insure4less Travel Insurance, AMT Essentials, Worldwide inc USA & Canada',
                  '0','93','2-4-5-93','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-6-93','insure4less Travel Insurance, AMT Excel, Worldwide inc USA & Canada',
                  '0','93','2-4-6-93','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-7-93','insure4less Travel Insurance, AMT Excel, Plus Worldwide inc USA & Canada',
                 '0','93','2-4-7-93','2015-08-04', '2040-12-31');

INSERT INTO ctm.travel_product
(providerId,productCode, title,baseProduct,maxTripDuration,providerProductCode,effectiveStart,effectiveEnd)
VALUES (@PVIDER, 'I4LS-TRAVEL-2-4-15-93','insure4less Travel Insurance, AMT Medical Only, Worldwide inc USA & Canada',
                 '0','93','2-4-15-93','2015-08-04', '2040-12-31');
/*
TESTs

Expect 32
 */
 select count(*) from ctm.travel_product where providerId = @PVIDER and providerProductCode in
('2-3-5-31','2-3-6-31','2-3-7-31','2-3-15-31','2-3-5-45','2-3-6-45','2-3-7-45','2-3-15-45','2-3-5-62','2-3-6-62',
'2-3-7-62','2-3-15-62','2-3-5-93','2-3-6-93','2-3-7-93','2-3-15-93','2-4-5-31','2-4-6-31','2-4-7-31','2-4-15-31',
'2-4-5-45','2-4-6-45','2-4-7-45','2-4-15-45','2-4-5-62','2-4-6-62','2-4-7-62','2-4-15-62','2-4-5-93','2-4-6-93',
'2-4-7-93','2-4-15-93');

/*
Expect 1
 */
select count(*) from ctm.travel_product where providerId = @PVIDER and productCode = 'I4LS-TRAVEL-';



/*
* For reporting
 */

-- country products

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-1-3-5', @PVIDER, 'Insure4Less Essentials', 'Insure4Less Essentials', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-1-3-6', @PVIDER, 'Insure4Less Excel', 'Insure4Less Excel', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-1-3-7', @PVIDER, 'Insure4Less Excel Plus', 'Insure4Less Excel Plus', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-1-3-15', @PVIDER, 'Insure4Less Medical Only', 'Insure4Less Medical Only', '2015-08-05', '2040-12-31');

-- amt products

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-5-31', @PVIDER,
 'Insure4Less AMT Essentials exc USA Canada 31',
 'Insure4Less AMT Essentials Worldwide exc USA & Canada (31 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-6-31', @PVIDER,
 'Insure4Less AMT Excel exc USA Canada 31',
 'Insure4Less AMT Excel Worldwide exc USA & Canada (31 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-7-31', @PVIDER,
 'Insure4Less AMT Excel Plus exc USA Canada 31',
 'Insure4Less AMT Excel Plus Worldwide exc USA & Canada (31 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-15-31', @PVIDER,
 'Insure4Less AMT Medical Only exc USA Canada 31',
 'Insure4Less AMT Medical Only Worldwide exc USA & Canada (31 days)', '2015-08-05', '2040-12-31');

--
INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-5-45', @PVIDER,
 'Insure4Less AMT Essentials exc USA Canada 45',
 'Insure4Less AMT Essentials Worldwide exc USA & Canada (45 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-6-45', @PVIDER,
 'Insure4Less AMT Excel exc USA Canada 45',
 'Insure4Less AMT Excel Worldwide exc USA & Canada (45 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-7-45', @PVIDER,
 'Insure4Less AMT Excel Plus exc USA Canada 45',
 'Insure4Less AMT Excel Plus Worldwide exc USA & Canada (45 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-15-45', @PVIDER,
 'Insure4Less AMT Medical exc USA Canada 45',
 'Insure4Less AMT Medical Only Worldwide exc USA & Canada (45 days)', '2015-08-05', '2040-12-31');

--
INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-5-62', @PVIDER,
 'Insure4Less AMT Essentials exc USA Canada 62',
 'Insure4Less AMT Essentials Worldwide exc USA & Canada (62 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-6-62', @PVIDER,
 'Insure4Less AMT Excel exc USA Canada 62',
 'Insure4Less AMT Excel Worldwide exc USA & Canada (62 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-7-62', @PVIDER,
 'Insure4Less AMT Excel Plus exc USA Canada 62',
 'Insure4Less AMT Excel Plus Worldwide exc USA & Canada (62 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-15-62', @PVIDER,
 'Insure4Less AMT Medical Only exc USA Canada 62',
 'Insure4Less AMT Medical Only Worldwide exc USA & Canada (62 days)', '2015-08-05', '2040-12-31');

--
INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-5-93', @PVIDER,
 'Insure4Less AMT Essentials exc USA Canada 93',
 'Insure4Less AMT Essentials Worldwide exc USA & Canada (93 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-6-93', @PVIDER,
 'Insure4Less AMT Excel exc USA Canada 93',
 'Insure4Less AMT Excel Worldwide exc USA & Canada (93 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-7-93', @PVIDER,
 'Insure4Less AMT Excel Plus exc USA Canada 93',
 'Insure4Less AMT Excel Plus Worldwide exc USA & Canada (93 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-3-15-93', @PVIDER,
 'Insure4Less AMT Medical exc USA Canada 93',
 'Insure4Less AMT Medical Only Worldwide exc USA & Canada (93 days)', '2015-08-05', '2040-12-31');

--
INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-5-31', @PVIDER,
 'Insure4Less AMT Essentials inc USA Canada 31',
 'Insure4Less AMT Essentials Worldwide inc USA & Canada (31 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-6-31', @PVIDER,
 'Insure4Less AMT Excel inc USA Canada 31',
 'Insure4Less AMT Excel Worldwide inc USA & Canada (31 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-7-31', @PVIDER,
 'Insure4Less AMT Excel Plus inc USA Canada 31',
 'Insure4Less AMT Excel Plus Worldwide inc USA & Canada (31 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-15-31', @PVIDER,
 'Insure4Less AMT Medical inc USA Canada 31',
 'Insure4Less AMT Medical Only Worldwide inc USA & Canada (31 days)', '2015-08-05', '2040-12-31');

--
INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-5-45', @PVIDER,
 'Insure4Less AMT Essentials inc USA Canada 45',
 'Insure4Less AMT Essentials Worldwide inc USA & Canada (45 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-6-45', @PVIDER,
 'Insure4Less AMT Excel inc USA Canada 45',
 'Insure4Less AMT Excel Worldwide inc USA & Canada (45 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-7-45', @PVIDER,
 'Insure4Less AMT Excel Plus inc USA Canada 45',
 'Insure4Less AMT Excel Plus Worldwide inc USA & Canada (45 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-15-45', @PVIDER,
 'Insure4Less AMT Medical inc USA Canada 45',
 'Insure4Less AMT Medical Only Worldwide inc USA & Canada (45 days)', '2015-08-05', '2040-12-31');

--
INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-5-62', @PVIDER,
 'Insure4Less AMT Essentials inc USA Canada 62',
 'Insure4Less AMT Essentials Worldwide inc USA & Canada (62 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-6-62', @PVIDER,
 'Insure4Less AMT Excel inc USA Canada 62',
 'Insure4Less AMT Excel Worldwide inc USA & Canada (62 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-7-62', @PVIDER,
 'Insure4Less AMT Excel Plus inc USA Canada 62',
 'Insure4Less AMT Excel Plus Worldwide inc USA & Canada (62 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-15-62', @PVIDER,
 'Insure4Less AMT Medical inc USA Canada 62',
 'Insure4Less AMT Medical Only Worldwide inc USA & Canada (62 days)', '2015-08-05', '2040-12-31');

--
INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-5-93', @PVIDER,
 'Insure4Less AMT Essentials inc USA Canada 93',
 'Insure4Less AMT Essentials Worldwide inc USA & Canada (93 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-6-93', @PVIDER,
 'Insure4Less AMT Excel inc USA Canada 93',
 'Insure4Less AMT Excel Worldwide inc USA & Canada (93 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-7-93', @PVIDER,
 'Insure4Less AMT Excel Plus inc USA Canada 93',
 'Insure4Less AMT Excel Plus Worldwide inc USA & Canada (93 days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode,ProviderId,ShortTitle,LongTitle, EffectiveStart,EffectiveEnd)
VALUES ('TRAVEL', 'I4LS-TRAVEL-2-4-15-93', @PVIDER,
 'Insure4Less AMT Medical inc USA Canada 93',
 'Insure4Less AMT Medical Only Worldwide inc USA & Canada (93 days)', '2015-08-05', '2040-12-31');

/*
TEST expect 36
 */
select count(*) from ctm.product_master where providerId = @PVIDER and productCode in ('I4LS-TRAVEL-2-3-5-31','I4LS-TRAVEL-2-3-6-31','I4LS-TRAVEL-2-3-7-31','I4LS-TRAVEL-2-3-15-31','I4LS-TRAVEL-2-3-5-45','I4LS-TRAVEL-2-3-6-45',
'I4LS-TRAVEL-2-3-7-45','I4LS-TRAVEL-2-3-15-45','I4LS-TRAVEL-2-3-5-62','I4LS-TRAVEL-2-3-6-62',
'I4LS-TRAVEL-2-3-7-62','I4LS-TRAVEL-2-3-15-62','I4LS-TRAVEL-2-3-5-93','I4LS-TRAVEL-2-3-6-93','I4LS-TRAVEL-2-3-7-93',
'I4LS-TRAVEL-2-3-15-93','I4LS-TRAVEL-2-4-5-31','I4LS-TRAVEL-2-4-6-31','I4LS-TRAVEL-2-4-7-31','I4LS-TRAVEL-2-4-15-31',
'I4LS-TRAVEL-2-4-5-45','I4LS-TRAVEL-2-4-6-45','I4LS-TRAVEL-2-4-7-45','I4LS-TRAVEL-2-4-15-45',
'I4LS-TRAVEL-2-4-5-62','I4LS-TRAVEL-2-4-6-62','I4LS-TRAVEL-2-4-7-62','I4LS-TRAVEL-2-4-15-62','I4LS-TRAVEL-2-4-5-93','I4LS-TRAVEL-2-4-6-93',
'I4LS-TRAVEL-2-4-7-93','I4LS-TRAVEL-2-4-15-93','I4LS-TRAVEL-1-3-5','I4LS-TRAVEL-1-3-6','I4LS-TRAVEL-1-3-7','I4LS-TRAVEL-1-3-15');


-- travel benefit mapping

INSERT INTO ctm.travel_provider_benefit_mapping (benefitId,providerId,providerBenefitCode,effectiveStart,effectiveEnd)
 VALUES ('2', @PVIDER, '21', '2015-08-05', '2040-12-31');
INSERT INTO ctm.travel_provider_benefit_mapping (benefitId,providerId,providerBenefitCode,effectiveStart,effectiveEnd)
 VALUES ('4', @PVIDER, '3', '2015-08-05', '2040-12-31');
INSERT INTO ctm.travel_provider_benefit_mapping (benefitId,providerId,providerBenefitCode,effectiveStart,effectiveEnd)
 VALUES ('6', @PVIDER, '6', '2015-08-05', '2040-12-31');
INSERT INTO ctm.travel_provider_benefit_mapping (benefitId,providerId,providerBenefitCode,effectiveStart,effectiveEnd)
 VALUES ('1', @PVIDER, '1', '2015-08-05', '2040-12-31');

/*
TEST expect 4
 */

select count(*) from ctm.travel_provider_benefit_mapping where providerId = @PVIDER;


--country value to isocode

update ctm.country_provider_mapping set countryValue = isoCode where providerId = @PVIDER limit 253;

/*
TEST expect 253
 */
select count(countryValue) from ctm.country_provider_mapping where providerId = @PVIDER;

