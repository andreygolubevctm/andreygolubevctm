/** Updater **/
-- Adding limits to configuration settings
INSERT INTO ctm.configuration (configCode, environmentCode, styleCodeId, verticalId, configValue) VALUES ('blockUserAfterXRequestsFromIP', 'PRO', '1', '3', '10');
-- Adding extra "admin" roles
INSERT INTO aggregator.ip_address (ipStart, ipEnd, Date, Service, Role, Total, styleCodeId) VALUES ('0', '0', '2015-06-03', 'car', 'A', '0', '1');
INSERT INTO aggregator.ip_address (ipStart, ipEnd, Date, Service, Role, Total, styleCodeId) VALUES ('0', '1', '2015-06-03', 'car', 'A', '0', '1');
INSERT INTO aggregator.ip_address (ipStart, ipEnd, Date, Service, Role, Total, styleCodeId) VALUES ('2130706433', '2130706433', '2015-06-03', 'car', 'A', '0', '1');
INSERT INTO aggregator.ip_address (ipStart, ipEnd, Date, Service, Role, Total, styleCodeId) VALUES ('3232235520', '3232301055', '2015-06-03', 'car', 'A', '0', '1');

/** Checkers **/
-- Configuration setting - returns 1
SELECT * FROM ctm.configuration WHERE configCode='blockUserAfterXRequestsFromIP' AND environmentCode='PRO' AND styleCodeId='1' AND verticalId='3';
-- Admin roles - returns 4
SELECT * FROM aggregator.ip_address WHERE service = 'car';

/** Rollback **/
-- Remove configuration setting
-- DELETE FROM ctm.configuration WHERE configCode='blockUserAfterXRequestsFromIP' AND environmentCode='PRO' AND styleCodeId='1' AND verticalId='3';
-- Remove admin roles
-- DELETE FROM aggregator.ip_address WHERE service = 'car';