/* Vars */
SET @SERVICE_MASTER_ID = (SELECT `serviceMasterId` FROM `ctm`.`service_master` WHERE `verticalId` = '0' AND `serviceCode` = 'motorwebRegoLookupService');

/* Update Dev certificate location */
UPDATE `ctm`.`service_properties` SET `servicePropertyValue` = 'WEB-INF/classes/motorweb-certificate-testEnv.p12'
  WHERE `serviceMasterId` = @SERVICE_MASTER_ID AND servicePropertyKey = 'certificate' AND `environmentCode` = '0';

/* Insert prod certificate location */
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
VALUES
  (@SERVICE_MASTER_ID, 'PRO', 0, 0, "password", "jvgfhsn", "2015-05-28 00:00:00", "2040-12-12 11:59:59", "SERVICE"),
  (@SERVICE_MASTER_ID, 'PRO', 0, 0, "certificate", "WEB-INF/classes/motorweb-certificate-prodEnv.p12", "2015-05-28 00:00:00", "2040-12-12 11:59:59", "SERVICE");

/* Test */
SELECT * FROM `ctm`.`service_properties` WHERE `serviceMasterId` = @SERVICE_MASTER_ID and `servicePropertyKey` = 'certificate';

/* Update flag to enable motorweb */
UPDATE `ctm`.`content_control` SET `contentValue` = 'Y' WHERE contentKey = 'regoLookupIsAvailable';
select * from ctm.content_control where contentKey = 'regoLookupIsAvailable';