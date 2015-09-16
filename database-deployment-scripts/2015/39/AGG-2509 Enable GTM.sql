SELECT * FROM ctm.configuration WHERE configCode = 'GTMEnabled';
-- Should return 0 rows;

INSERT INTO `configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMEnabled','0',0,0,'N');
INSERT INTO `configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMEnabled','LOCALHOST',0,0,'Y');
INSERT INTO `configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMEnabled','NXI',0,0,'Y');
INSERT INTO `configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMEnabled','PRO',1,14,'N');

SELECT * FROM ctm.configuration WHERE configCode = 'GTMEnabled';
-- Should return 4 rows;