-- RUN
INSERT INTO `ctm`.`service_master` (`verticalId`, `serviceCode`) VALUES ('4', 'leadService');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES ('211', '0', '0', '0', 'enabled', 'true', '2014-01-01 00:00:00', '2040-01-01 00:00:00', 'SERVICE');
INSERT INTO `ctm`.`service_properties` (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`) VALUES ('211', '0', '0', '0', 'url', 'http://nxs-vm-ken01-ctm-app-x1:8080/ctm-leads/lead/', '2014-01-01 00:00:00', '2040-01-01 00:00:00', 'SERVICE');

-- ROLLBACK
/*

*/