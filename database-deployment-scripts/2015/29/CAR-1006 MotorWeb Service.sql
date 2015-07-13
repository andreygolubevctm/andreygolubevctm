-- Add new service master
INSERT INTO `ctm`.`service_master` (`verticalId`, `serviceCode`) VALUES ('0', 'motorwebRegoLookupService');
SET @SERVICE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` WHERE `verticalId` = '0' AND `serviceCode` = 'motorwebRegoLookupService');

INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES
  (@SERVICE_MASTER_ID, '0', 0, 0, "serviceUrl", "https://robot.motorweb.com.au/soap/autoid/1.0/", "2015-05-28 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@SERVICE_MASTER_ID, '0', 0, 0, "password", "swzxbue", "2015-05-28 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@SERVICE_MASTER_ID, '0', 0, 0, "certificate", "/motorweb-certificate.p12", "2015-05-28 00:00:00", "2040-12-12 11:59:59", "SERVICE");

/** Checker **/
SET @SERVICE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` WHERE `verticalId` = '0' AND `serviceCode` = 'motorwebRegoLookupService');
SELECT * FROM `ctm`.`service_properties` WHERE `serviceMasterId` = @SERVICE_MASTER_ID ORDER BY `styleCodeId` ASC, `ProviderId` ASC, `environmentCode` ASC;
SELECT * FROM `ctm`.`service_master` WHERE `serviceMasterId` = @SERVICE_MASTER_ID;

/** Rollback **/
-- SET @SERVICE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` WHERE `verticalId` = '0' AND `serviceCode` = 'motorwebRegoLookupService');
-- DELETE FROM `ctm`.`service_properties` WHERE `serviceMasterId` = @SERVICE_MASTER_ID;
-- DELETE FROM `ctm`.`service_master` WHERE `serviceMasterId` = @SERVICE_MASTER_ID;