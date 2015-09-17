SELECT * FROM ctm.configuration WHERE configCode = 'GTMEnabled';
-- Should return 0 rows;

INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMEnabled','0',0,0,'N');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMEnabled','LOCALHOST',0,0,'Y');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMEnabled','NXI',0,0,'Y');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMEnabled','PRO',1,14,'N');

SELECT * FROM ctm.configuration WHERE configCode = 'GTMEnabled';
-- Should return 4 rows;

SELECT * FROM ctm.configuration WHERE configCode = 'GTMPropertyId';
-- Should return 0 rows;

INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMPropertyId','0',0,0,'');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMPropertyId','LOCALHOST',0,0,'GTM-N4S6QQ');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMPropertyId','NXI',0,0,'GTM-N4S6QQ');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMPropertyId','NXQ',0,0,'GTM-W9GR9M');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMPropertyId','NXS',0,0,'GTM-W9GR9M');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('GTMPropertyId','PRO',1,0,'GTM-W9GR9M');

SELECT * FROM ctm.configuration WHERE configCode = 'GTMPropertyId';
-- Should return 6 rows;
