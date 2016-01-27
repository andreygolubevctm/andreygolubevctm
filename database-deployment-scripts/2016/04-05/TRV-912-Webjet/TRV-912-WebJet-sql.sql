SET @WEBJET = (select providerId from ctm.provider_master where providerCode = 'WEBJ');
SET @TRAVELBER = (select serviceMasterId from ctm.service_master where serviceCode like 'quoteServiceBER' and verticalId = '2');
SET @NEW_CLIENT_CODE_OUTPARAM = 'clientCode=WJPAU';
SET @OLD_CLIENT_CODE_OUTPARAM = 'clientCode=WEBJETAU';
SET @NEW_CLIENT_CODE='WJPAU';
SET @OLD_CLIENT_CODE='WEBJETAU';
SET @VIRG = (select providerId from ctm.provider_master where providercode = 'VIRG');
SET @INBOUNDPARAMUAT = 'defaultProductId=NODEFAULT,service=WEBJ,quoteUrl=https://uat-elevate.agaassistance.com.au/webjet/,trackCode=52';
SET @INBOUNDPARAMPRO = 'defaultProductId=NODEFAULT,service=WEBJ,quoteUrl=https://insurance.webjet.com.au/webjet/,trackCode=52';
SET @OLD_INBOUND_PARAMS = 'defaultProductId=NODEFAULT,service=WEBJ,quoteUrl=https://uat-webjetau.agaassistance.com.au,trackCode=52';


update ctm.service_properties set servicePropertyValue = 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote' where providerId = @WEBJET
and serviceMasterId = @TRAVELBER and environmentCode = '0' and servicePropertyKey = 'url' LIMIT 1;

-- test expect 1
select count(*) from ctm.service_properties where servicePropertyValue = 'https://uat-pricingapi.agaassistance.com.au/api/QuickQuote' and providerId = @WEBJET
and serviceMasterId = @TRAVELBER and environmentCode = '0' and servicePropertyKey = 'url';


-- UPDATE OUTBOUND PARAMS
update ctm.service_properties set servicePropertyValue = @NEW_CLIENT_CODE_OUTPARAM where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyValue = @OLD_CLIENT_CODE_OUTPARAM LIMIT 1;

-- test expect 1
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @NEW_CLIENT_CODE_OUTPARAM;


-- UPDATE INBOUND PARAMS
 update ctm.service_properties set servicePropertyValue = @INBOUNDPARAMUAT where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyKey = 'inboundParams' and environmentCode = '0';

  update ctm.service_properties set servicePropertyValue = @INBOUNDPARAMPRO where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyKey = 'inboundParams' and environmentCode = 'PRO';

-- test expect 1
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @INBOUNDPARAMUAT;
-- test expect 1
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @INBOUNDPARAMPRO;



update ctm.service_properties set servicePropertyValue = @NEW_CLIENT_CODE where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyValue = @OLD_CLIENT_CODE LIMIT 1;

-- test expect 1
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @NEW_CLIENT_CODE;


-- perform region transformation

delete from ctm.country_provider_mapping where providerId = @WEBJET limit 253;

insert into ctm.country_provider_mapping (providerId,productGroup,isoCode,regionValue,countryValue,priority,effectiveStart,effectiveEnd,status)
 select @WEBJET,0, ctm.country_provider_mapping.isoCode,ctm.country_provider_mapping.regionValue, ctm.country_provider_mapping.countryValue,1,'2015-08-05','2040-12-31',ctm.country_provider_mapping.status
  FROM ctm.country_provider_mapping
where providerId = @VIRG LIMIT 253;

-- expect 253
select count(*) from ctm.country_provider_mapping where providerId = @WEBJET;

-- add to product master

-- NEW SGL products WEB JET
INSERT INTO ctm.product_master (ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd)
 VALUES ('TRAVEL', 'WEBJ-TRAVEL-54158', @WEBJET, 'Basic', 'Basic', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd)
 VALUES ('TRAVEL', 'WEBJ-TRAVEL-54157', @WEBJET, 'Essentials', 'Essentials', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd)
 VALUES ('TRAVEL', 'WEBJ-TRAVEL-54156', @WEBJET, 'Comprehensive', 'Comprehensive', '2015-08-05', '2040-12-31');

 INSERT INTO ctm.product_master (ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd)
 VALUES ('TRAVEL', 'WEBJ-TRAVEL-54693', @WEBJET, 'Domestic', 'Domestic', '2015-08-05', '2040-12-31');

-- MULTI products new ones
INSERT INTO ctm.product_master (ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd)
 VALUES ('TRAVEL', 'WEBJ-TRAVEL-5415915', @WEBJET, 'Multi-Trip (15 Days)', 'Multi-Trip (15 Days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd)
 VALUES ('TRAVEL', 'WEBJ-TRAVEL-5415930', @WEBJET, 'Multi-Trip (30 Days)', 'Multi-Trip (30 Days)', '2015-08-05', '2040-12-31');

INSERT INTO ctm.product_master (ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd)
 VALUES ('TRAVEL', 'WEBJ-TRAVEL-5415945', @WEBJET, 'Multi-Trip (45 Days)', 'Multi-Trip (45 Days)', '2015-08-05', '2040-12-31');



-- test expect 7
select count(*) from ctm.product_master where productCode in ('WEBJ-TRAVEL-54693','WEBJ-TRAVEL-5415915','WEBJ-TRAVEL-5415930','WEBJ-TRAVEL-5415945','WEBJ-TRAVEL-54156','WEBJ-TRAVEL-54157','WEBJ-TRAVEL-54158') and providerId = @WEBJET;

 -- insert into travel_product
 INSERT INTO ctm.travel_product
(providerId, productCode, description, baseProduct, pdsUrl, effectiveStart, effectiveEnd)
VALUES (@WEBJET, 'WEBJ-TRAVEL-',
 'As Australia and New Zealand\'s leading online travel agency, Webjet leads the way in online travel tools and technology. Offering unparalleled choice in online travel bookings, Webjet offers a broad range of Travel Insurance products, with the opportunity to tailor your excess and control your premium to suit your needs. Backed by Allianz Global Assistance, we\'ve got you covered. Get a quote today and pack some peace of mind.', '1', 'https://api.agaassistance.com.au/content/webjet/attachments/ProductDisclosureStatement.pdf', '2015-08-04', '2040-12-31');

-- test expect 1
select count(*) from ctm.travel_product where productCode = 'WEBJ-TRAVEL-';

 -- ----------------------------------------------------------------------------------
-- adding product names to the ovveriding tables for the flexibility of quickly overwriting them
-- multi
 INSERT INTO ctm.travel_product
 (providerId, productCode, title, baseProduct, maxTripDuration,providerProductCode, effectiveStart, effectiveEnd,pdsUrl)
 VALUES (@WEBJET, 'WEBJ-TRAVEL-5415915','Multi-Trip','0',
     '15','5415915','2015-08-04', '2040-12-31','https://api.agaassistance.com.au/content/webjet/attachments/ProductDisclosureStatement.pdf');

INSERT INTO ctm.travel_product
 (providerId, productCode, title, baseProduct, maxTripDuration,providerProductCode, effectiveStart, effectiveEnd,pdsUrl)
 VALUES (@WEBJET, 'WEBJ-TRAVEL-5415930','Multi-Trip','0',
     '30','5415930','2015-08-04', '2040-12-31','https://api.agaassistance.com.au/content/webjet/attachments/ProductDisclosureStatement.pdf');

INSERT INTO ctm.travel_product
 (providerId, productCode, title, baseProduct, maxTripDuration,providerProductCode, effectiveStart, effectiveEnd,pdsUrl)
 VALUES (@WEBJET, 'WEBJ-TRAVEL-5415945','Multi-Trip','0',
     '45','5415945','2015-08-04', '2040-12-31','https://api.agaassistance.com.au/content/webjet/attachments/ProductDisclosureStatement.pdf');
-- single
INSERT INTO ctm.travel_product
 (providerId, productCode, title, baseProduct, maxTripDuration,providerProductCode, effectiveStart, effectiveEnd,pdsUrl)
 VALUES (@WEBJET, 'WEBJ-TRAVEL-54158','Basic','0','','54158','2015-08-04', '2040-12-31','https://insurance.webjet.com.au/webjet/File/Download?docType=PDS');
INSERT INTO ctm.travel_product
 (providerId, productCode, title, baseProduct, maxTripDuration,providerProductCode, effectiveStart, effectiveEnd,pdsUrl)
 VALUES (@WEBJET, 'WEBJ-TRAVEL-54157','Essentials','0','','54157','2015-08-04', '2040-12-31','https://insurance.webjet.com.au/webjet/File/Download?docType=PDS');
INSERT INTO ctm.travel_product
 (providerId, productCode, title, baseProduct, maxTripDuration,providerProductCode, effectiveStart, effectiveEnd,pdsUrl)
 VALUES (@WEBJET, 'WEBJ-TRAVEL-54156','Comprehensive','0','','54156','2015-08-04', '2040-12-31','https://insurance.webjet.com.au/webjet/File/Download?docType=PDS');

 INSERT INTO ctm.travel_product
 (providerId, productCode, title, baseProduct, maxTripDuration,providerProductCode, effectiveStart, effectiveEnd,pdsUrl)
 VALUES (@WEBJET, 'WEBJ-TRAVEL-54693','Domestic','0','','54693','2015-08-04', '2040-12-31','https://insurance.webjet.com.au/webjet/File/Download?docType=PDS');

-- TEST expect 7
select count(*) from ctm.travel_product where providerProductCode in ('54693','54156','54157','54158','5415915','5415930','5415945');

-- UPDATE PDS's
-- Test - Expect 10 (excludes new products)
SELECT * FROM ctm.travel_product where pdsUrl = 'https://api.agaassistance.com.au/content/webjet/attachments/ProductDisclosureStatement.pdf';


UPDATE ctm.travel_product SET pdsUrl = 'https://insurance.webjet.com.au/webjet/File/Download?docType=PDS' where pdsUrl = 'https://api.agaassistance.com.au/content/webjet/attachments/ProductDisclosureStatement.pdf';

-- TEST - Expect 18 including the new products
SELECT * FROM ctm.travel_product where pdsUrl = 'https://insurance.webjet.com.au/webjet/File/Download?docType=PDS';


