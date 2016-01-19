SET @WEBJET = (select providerId from ctm.provider_master where providerCode = 'WEBJ');
SET @TRAVELBER = (select serviceMasterId from ctm.service_master where serviceCode like 'quoteServiceBER' and verticalId = '2');
SET @NEW_CLIENT_CODE_OUTPARAM = 'clientCode=WJPAU';
SET @OLD_CLIENT_CODE_OUTPARAM = 'clientCode=WEBJETAU';
SET @NEW_CLIENT_CODE='WJPAU';
SET @OLD_CLIENT_CODE='WEBJETAU';
SET @VIRG = (select providerId from ctm.provider_master where providercode = 'VIRG');
SET @INBOUNDPARAM = 'defaultProductId=NODEFAULT,service=WEBJ,quoteUrl=https://uat-elevate.agaassistance.com.au/webjet/,trackCode=52';
SET @OLD_INBOUND_PARAMS = 'defaultProductId=NODEFAULT,service=WEBJ,quoteUrl=https://uat-webjetau.agaassistance.com.au,trackCode=52';



update ctm.service_properties set servicePropertyValue = @OLD_CLIENT_CODE_OUTPARAM where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyValue = @NEW_CLIENT_CODE_OUTPARAM LIMIT 1;
-- test expect 0
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @NEW_CLIENT_CODE_OUTPARAM;
 -- test expect 1
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @OLD_CLIENT_CODE_OUTPARAM;


update ctm.service_properties set servicePropertyValue = @OLD_CLIENT_CODE where providerId = @WEBJET and
 serviceMasterId = @TRAVELBER and servicePropertyValue = @NEW_CLIENT_CODE LIMIT 1;
-- test expect 0
select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @NEW_CLIENT_CODE;
 -- test expect 1
 select count(*) from ctm.service_properties where providerId = @WEBJET and serviceMasterId = @TRAVELBER and
 servicePropertyValue = @OLD_CLIENT_CODE;


-- perform region transformation

delete from ctm.country_provider_mapping where providerId = @WEBJET limit 253;

INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'AFG','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ALA','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ALB','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'DZA','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ASM','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'AND','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'AGO','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'AIA','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ATA','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ATG','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ARG','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ARM','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ABW','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'AUS','AUS','',NULL,6,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'AUT','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'AZE','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BHS','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BHR','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BAL','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BGD','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BRB','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BLR','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BEL','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BLZ','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BEN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BMU','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BTN','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BOL','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BES','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BIH','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BWA','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BVT','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BRA','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'IOT','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BRN','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BGR','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BFA','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BDI','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'KHM','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CMR','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CAN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CAI','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CPV','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CYM','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CAF','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TCD','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CHL','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CHN','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CXR','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CCK','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'COL','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'COM','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'COD','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'COG','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'COK','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CRI','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CIV','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'HRV','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CUB','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CUW','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CYP','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CZE','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'DNK','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'DJI','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'DMA','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'DOM','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ECU','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'EGY','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SLV','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GNQ','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ERI','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'EST','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ETH','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'FLK','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'FRO','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'FJI','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'FIN','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'FRA','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GUF','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PYF','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ATF','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GAB','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GAL','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GMB','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GEO','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'DEU','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GHA','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GIB','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GRC','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GRL','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GRD','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GLP','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GUM','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GTM','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GGY','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GIN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GNB','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GUY','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'HTI','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'HMD','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'HND','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'HKG','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'HUN','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ISL','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'IND','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'IDN','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'IRN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'IRQ','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'IRL','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'IMN','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ISR','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ITA','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'JAM','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'JPN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'JEY','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'JOR','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'KAZ','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'KEN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'KIR','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PRK','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'KOR','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'KWT','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'KGZ','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LAO','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LVA','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LBN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LSO','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LBR','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LBY','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LIE','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LTU','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LUX','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MAC','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MKD','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MDG','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MWI','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MYS','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MDV','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MLI','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MLT','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MHL','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MTQ','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MRT','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MUS','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MYT','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MEX','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'FSM','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MDA','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MCO','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MNG','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MNE','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MSR','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MAR','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MOZ','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MMR','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NAM','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NRU','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NPL','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NLD','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NCL','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NZL','PACBL','',NULL,5,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NIC','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NER','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NGA','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NIU','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NFK','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MNP','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'NOR','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'OMN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PAK','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PLW','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PSE','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PAN','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PNG','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PRY','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PER','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PHL','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PCN','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'POL','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PRT','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'PRI','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'QAT','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'REU','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ROU','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'RUS','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'RWA','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'BLM','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SHN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'KNA','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LCA','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'MAF','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SPM','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'VCT','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'WSM','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SMR','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'STP','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SAU','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SEN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SRB','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SYC','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SLE','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SGP','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SXM','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SVK','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SVN','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SLB','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SOM','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ZAF','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SA','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SGS','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SSD','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ESP','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'LKA','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SDN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SUR','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SJM','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SWZ','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SWE','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'CHE','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'SYR','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TAH','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TWN','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TJK','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TZA','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'THA','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TLS','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TGO','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TKL','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TON','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TTO','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TUN','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TUR','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TKM','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TCA','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'TUV','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'UGA','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'UKR','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ARE','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'GBR','EURUK','',NULL,2,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'UMI','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'USA','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'URY','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'UZB','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'VUT','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'VEN','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'VNM','ASNJP','',NULL,3,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'VGB','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'VIR','USASC','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'WLF','PACBL','',NULL,4,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ESH','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'YEM','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ZMB','WORLD','',NULL,1,'2015-01-01','2040-12-12','');
INSERT INTO ctm.country_provider_mapping  (providerId,productGroup,isoCode,regionValue,countryValue,handoverValue,priority,effectiveStart,effectiveEnd,status) VALUES (@WEBJET,0,'ZWE','WORLD','',NULL,1,'2015-01-01','2040-12-12','');

-- expect 253
select count(*) from ctm.country_provider_mapping where providerId = @WEBJET;

-- add to product master

 delete from ctm.product_master where providerId = @WEBJET and productCat = 'TRAVEL' and
  productCode in ('WEBJ-TRAVEL-54693','WEBJ-TRAVEL-5415915','WEBJ-TRAVEL-5415930','WEBJ-TRAVEL-5415945','WEBJ-TRAVEL-54156','WEBJ-TRAVEL-54157','WEBJ-TRAVEL-54158') limit 7;

-- test expect 0
select count(*) from ctm.product_master where productCode in ('WEBJ-TRAVEL-54693','WEBJ-TRAVEL-5415915','WEBJ-TRAVEL-5415930','WEBJ-TRAVEL-5415945','WEBJ-TRAVEL-54156','WEBJ-TRAVEL-54157','WEBJ-TRAVEL-54158') and providerId = @WEBJET;

 -- insert into travel_product
 INSERT INTO ctm.travel_product
(providerId, productCode, description, baseProduct, pdsUrl, effectiveStart, effectiveEnd)
VALUES (@WEBJET, 'WEBJ-TRAVEL-',
 'As Australia and New Zealand\'s leading online travel agency, Webjet leads the way in online travel tools and technology. Offering unparalleled choice in online travel bookings, Webjet offers a broad range of Travel Insurance products, with the opportunity to tailor your excess and control your premium to suit your needs. Backed by Allianz Global Assistance, we\'ve got you covered. Get a quote today and pack some peace of mind.', '1', 'https://api.agaassistance.com.au/content/webjet/attachments/ProductDisclosureStatement.pdf', '2015-08-04', '2040-12-31') LIMIT 1;

delete from ctm.travel_product where providerId = @WEBJET and productCode = 'WEBJ-TRAVEL-' limit 1;

-- test expect 0
select count(*) from ctm.travel_product where productCode = 'WEBJ-TRAVEL-';


delete from ctm.travel_product where providerId = @WEBJET and providerProductCode in ('54693','54156','54157','54158','5415915','5415930','5415945');

-- TEST expect 0
select count(*) from ctm.travel_product where providerProductCode in ('54693','54156','54157','54158','5415915','5415930','5415945');








