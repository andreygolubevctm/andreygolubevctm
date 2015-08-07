SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM  ctm.service_master WHERE verticalId = 2 AND serviceCode = 'quoteServiceBER');
SET @OTIS_PROVIDER_ID = (select providerId from ctm.provider_master where providerCode = 'OTIS');

-- ======== PROVIDER_MASTER ======
INSERT INTO `ctm`.`provider_master`
(`ProviderId`, `providerCode`, `Name`, `EffectiveStart`, `EffectiveEnd`) VALUES ('', 'GOIN', 'Go Travel Insurance', '2015-08-04', '2040-12-31');
SET @PROVIDER_ID = (select providerId from ctm.provider_master where providerCode = 'GOIN');
/*===== TEST Expect ==== 1*/
select count(*) from ctm.provider_master where providerCode = 'GOIN';


-- ===== TRAVEL_PRODUCT ===== --

INSERT INTO `ctm`.`travel_product`
(`providerId`, `productCode`, `description`, `baseProduct`, `pdsUrl`, `effectiveStart`, `effectiveEnd`)
VALUES (@PROVIDER_ID, 'GOIN-TRAVEL-',
        'Owned and operated in Australia, Go Insurance is backed by Lloyd\'s of London, the world\'s specialist insurance market. With over 30 years\' experience, they have a great understanding of what travellers need - flexible travel insurance that is tailored to your itinerary and budget. Great cover, unrivalled flexibility, competitive prices and a team of specialists looking out for you, Go Insurance is a great choice.', '1', 'http://quote.goinsurance.com.au/assets/Go_PDS_V2.0_0315.pdf', '2015-08-04', '2040-12-31');
/* TEST expect 1 */
select count(*) from ctm.travel_product where productCode = 'GOIN-TRAVEL-';


-- ========= PRODUCT_MASTER ======--

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-S01', @PROVIDER_ID, 'Go Insurance - Go Base', 'Go Insurance - Go Base', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-S02', @PROVIDER_ID, 'Go Insurance - Go Base', 'Go Insurance - Go Base', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-S03', @PROVIDER_ID, 'Go Insurance - Go Basic', 'Go Insurance - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-S04', @PROVIDER_ID, 'Go Insurance - Go Basic', 'Go Insurance - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-S05', @PROVIDER_ID, 'Go Insurance - Go Plus', 'Go Insurance - Go Plus', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-S06', @PROVIDER_ID, 'Go Insurance - Go Plus', 'Go Insurance - Go Plus', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A01', @PROVIDER_ID, 'Go Insurance - AMT 200 31 days Excl - Go Basic', 'Go Insurance AMT Worldwide (Excess 200) Excl North America, Canada and Antarctica (31 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A02', @PROVIDER_ID, 'Go Insurance - AMT 200 50 days Excl - Go Basic', 'Go Insurance AMT Worldwide (Excess 200) Excl North America, Canada and Antarctica (50 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A03', @PROVIDER_ID, 'Go Insurance - AMT 200 60 days Excl - Go Basic', 'Go Insurance AMT Worldwide (Excess 200) Excl North America, Canada and Antarctica (60 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A04', @PROVIDER_ID, 'Go Insurance - AMT 100 31 days Excl - Go Basic', 'Go Insurance AMT Worldwide (Excess 100) Excl North America, Canada and Antarctica (31 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A05', @PROVIDER_ID, 'Go Insurance - AMT 100 50 days Excl - Go Basic', 'Go Insurance AMT Worldwide (Excess 100) Excl North America, Canada and Antarctica (50 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A06', @PROVIDER_ID, 'Go Insurance - AMT 100 60 days Excl - Go Basic', 'Go Insurance AMT Worldwide (Excess 100) Excl North America, Canada and Antarctica (60 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A07', @PROVIDER_ID, 'Go Insurance - AMT 200 31 days - Go Basic', 'Go Insurance AMT Worldwide (Excess 200) (31 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A08', @PROVIDER_ID, 'Go Insurance - AMT 200 50 days - Go Basic', 'Go Insurance AMT Worldwide (Excess 200) (50 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A09', @PROVIDER_ID, 'Go Insurance - AMT 200 60 days - Go Basic', 'Go Insurance AMT Worldwide (Excess 200) (60 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A10', @PROVIDER_ID, 'Go Insurance - AMT 100 31 days - Go Basic', 'Go Insurance AMT Worldwide (Excess 100) (31 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A11', @PROVIDER_ID, 'Go Insurance - AMT 100 50 days - Go Basic', 'Go Insurance AMT Worldwide (Excess 100) (50 days) - Go Basic', '2015-08-05', '2040-12-31');

INSERT INTO `ctm`.`product_master` (`ProductCat`, `ProductCode`, `ProviderId`, `ShortTitle`, `LongTitle`, `EffectiveStart`, `EffectiveEnd`)
VALUES ('TRAVEL', 'GOIN-TRAVEL-A12', @PROVIDER_ID, 'Go Insurance - AMT 100 60 days - Go Basic', 'Go Insurance AMT Worldwide (Excess 100) (60 days) - Go Basic', '2015-08-05', '2040-12-31');

/*Test expect 18*/
select COUNT(*) from ctm.product_master where productcat = 'TRAVEL' and providerId = @PROVIDER_ID;


-- ==== SERVICE_PROPERTIES SQL

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'serviceName', 'GOIN', '2015-08-05', '2040-12-31', 'SERVICE');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'serviceType', 'soap', '2015-08-05', '2040-12-31', 'SERVICE');


INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'url', 'http://quote-test.goinsurance.com.au/ctm/xml_in', '2015-08-05', '2040-12-31', 'SERVICE');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, 'PRO', '0', @PROVIDER_ID, 'url', 'http://quote.goinsurance.com.au/ctm/xml_in', '2015-08-05', '2040-12-31', 'SERVICE');


INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'soapAction', 'http://quote-test.goinsurance.com.au/ctm/xml_in', '2015-08-05', '2040-12-31', 'SERVICE');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'errorProductCode', 'GOIN-TRAVEL-12', '2015-08-05', '2040-12-31', 'SERVICE');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'trackCode', '53', '2015-08-05', '2040-12-31', 'SERVICE');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'outboundParams', 'SPName=au.com.Compare', '2015-08-05', '2040-12-31', 'SERVICE');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES (@SERVICE_MASTER_ID, '0', '0', @PROVIDER_ID, 'inboundParams', 'defaultProductId=NODEFAULT,service=GOIN,trackCode=53', '2015-08-05', '2040-12-31', 'SERVICE');

/* TEST: expect 9 */
select count(*) from ctm.service_properties where providerId = @PROVIDER_ID;

-- ============ COUNTRY_PROVIDER_MAPPING ====

insert into ctm.country_provider_mapping (providerId,productGroup,isoCode,countryValue,priority,effectiveStart,effectiveEnd,status)
  SELECT @PROVIDER_ID, 0, ctm.country_provider_mapping.isoCode, ctm.country_provider_mapping.countryValue,1,'2015-08-05','2040-12-31',ctm.country_provider_mapping.status
  FROM ctm.country_provider_mapping
  where providerId = @OTIS_PROVIDER_ID;

/* TEST: expect 253 */
select count(*) from ctm.country_provider_mapping where providerId = @PROVIDER_ID;


/*

-- ROLLBACK --
 -- uncomment for rollback
 SET @PROVIDER_ID_FOR_ROLLBACK = (select providerId from ctm.provider_master where providerCode = 'GOIN');
 SET @GOINTRAVEL = 'GOIN-TRAVEL-';
 SET @PROVIDER_CODE = 'GOIN';
*/
 delete from ctm.country_provider_mapping where providerId = @PROVIDER_ID_FOR_ROLLBACK;
 select count(*) from ctm.country_provider_mapping where providerId = @PROVIDER_ID_FOR_ROLLBACK;
 -- expect 0

 delete from ctm.service_properties where providerId = @PROVIDER_ID_FOR_ROLLBACK;
 select count(*) from ctm.service_properties where providerId = @PROVIDER_ID_FOR_ROLLBACK;
 -- expect 0

 delete from ctm.product_master where productcat = 'TRAVEL' and providerId = @PROVIDER_ID_FOR_ROLLBACK;
 select count(*) from ctm.product_master where productcat = 'TRAVEL' and providerId = @PROVIDER_ID_FOR_ROLLBACK;
 -- expect 0

 delete from ctm.travel_product where productCode = @GOINTRAVEL;
 select count(*) from ctm.travel_product where productCode = @GOINTRAVEL;
 -- expect 0

 delete from ctm.provider_master where providerCode = @PROVIDER_CODE;
 select count(*) from ctm.provider_master where providerCode = @PROVIDER_CODE;
 -- expect 0













