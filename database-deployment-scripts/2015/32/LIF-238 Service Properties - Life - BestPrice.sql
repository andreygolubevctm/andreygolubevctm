-- Add new service master
INSERT INTO `ctm`.`service_master` (`verticalId`, `serviceCode`) VALUES ('6', 'bestPriceLeadFeedService');
SET @BESTPRICE_LEAD_FEED_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` WHERE `verticalId` = '6' AND `serviceCode` = 'bestPriceLeadFeedService');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES
  -- CTM - OZICARE
  (@BESTPRICE_LEAD_FEED_MASTER_ID, '0', 1, 63, "serviceUrl", "https://services-nxq.ecommerce.disconline.com.au/services/3.1/messageCentreCreateMessage", "2015-07-07 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@BESTPRICE_LEAD_FEED_MASTER_ID, 'LOCALHOST', 1, 63, "serviceUrl", "https://nxq.ecommerce.disconline.com.au/services/3.1/messageCentreCreateMessage", "2015-07-07 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@BESTPRICE_LEAD_FEED_MASTER_ID, 'PRO', 1, 63, "serviceUrl", "https://ecommerce.disconline.com.au/services/3.1/messageCentreCreateMessage", "2015-07-07 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@BESTPRICE_LEAD_FEED_MASTER_ID, '0', 1, 63, "messageSource", "LICTBESTPR", "2015-07-07 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@BESTPRICE_LEAD_FEED_MASTER_ID, '0', 1, 63, "messageText", "CTM - Life Vertical - BestPrice Lead", "2015-07-07 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@BESTPRICE_LEAD_FEED_MASTER_ID, '0', 1, 63, "partnerId", "CTM0000300", "2015-07-07 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@BESTPRICE_LEAD_FEED_MASTER_ID, '0', 1, 63, "sourceId", "0000000002", "2015-07-07 00:00:00", "2040-12-12 11:59:59", "SERVICE");

/** Checker **/
SET @BESTPRICE_LEAD_FEED_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` WHERE `verticalId` = '6' AND `serviceCode` = 'bestPriceLeadFeedService');
SELECT * FROM `ctm`.`service_properties` WHERE `serviceMasterId` = @BESTPRICE_LEAD_FEED_MASTER_ID ORDER BY `styleCodeId` ASC, `ProviderId` ASC, `environmentCode` ASC;
SELECT * FROM `ctm`.`service_master` WHERE `serviceMasterId` = @BESTPRICE_LEAD_FEED_MASTER_ID;

/** Rollback **/
-- SET @BESTPRICE_LEAD_FEED_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` WHERE `verticalId` = '6' AND `serviceCode` = 'bestPriceLeadFeedService');
-- DELETE FROM `ctm`.`service_properties` WHERE `serviceMasterId` = @BESTPRICE_LEAD_FEED_MASTER_ID;
-- DELETE FROM `ctm`.`service_master` WHERE `serviceMasterId` = @BESTPRICE_LEAD_FEED_MASTER_ID;