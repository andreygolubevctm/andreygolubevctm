-- UPDATER
SET @ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=6 AND serviceCode='bestPriceLeadFeedService');
UPDATE ctm.service_properties SET servicePropertyValue='https://services.ecommerce.disconline.com.au/services/3.1/messageCentreCreateMessage' WHERE serviceMasterId=@ID AND environmentCode='PRO' AND servicePropertyKey='serviceUrl';
SET @ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=6 AND serviceCode='getACallLeadFeedService');
UPDATE ctm.service_properties SET servicePropertyValue='https://services.ecommerce.disconline.com.au/services/3.1/messageCentreCreateMessage' WHERE serviceMasterId=@ID AND environmentCode='PRO' AND servicePropertyKey='serviceUrl';

-- CHECKER: URLS should be http://ecommerce... before and http://services.ecommerce... after
SET @BP = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=6 AND serviceCode='bestPriceLeadFeedService');
SET @CB = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=6 AND serviceCode='getACallLeadFeedService');
SELECT * FROM ctm.service_properties WHERE serviceMasterId IN (@BP,@CB) AND environmentCode='PRO' AND servicePropertyKey='serviceUrl';

-- ROLLBACK
/*
SET @ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=6 AND serviceCode='bestPriceLeadFeedService');
UPDATE ctm.service_properties SET servicePropertyValue='https://ecommerce.disconline.com.au/services/3.1/messageCentreCreateMessage' WHERE serviceMasterId=@ID AND environmentCode='PRO' AND servicePropertyKey='serviceUrl';
SET @ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=6 AND serviceCode='getACallLeadFeedService');
UPDATE ctm.service_properties SET servicePropertyValue='https://ecommerce.disconline.com.au/services/3.1/messageCentreCreateMessage' WHERE serviceMasterId=@ID AND environmentCode='PRO' AND servicePropertyKey='serviceUrl';
*/