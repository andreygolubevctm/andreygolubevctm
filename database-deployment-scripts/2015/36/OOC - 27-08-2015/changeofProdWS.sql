SET @GOIN = (select providerId from ctm.provider_master where providerCode = 'GOIN');
update ctm.service_properties set servicePropertyValue = 'https://quote.goinsurance.com.au/ctm/xml_in' where providerId = @GOIN  and servicePropertyValue = 'http://quote.goinsurance.com.au/ctm/xml_in' LIMIT 1;
-- test -expect 1
select count(*) from ctm.service_properties where servicePropertyValue = 'https://quote.goinsurance.com.au/ctm/xml_in' and providerId = @GOIN;
