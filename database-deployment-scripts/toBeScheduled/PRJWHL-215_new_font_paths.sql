
-- No longer needed.
DELETE FROM `ctm`.`configuration` WHERE `configCode` = 'fontStylesheet';

-- Rollback
/*
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('fontStylesheet','0',1,0,'ctm/fonts.css');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('fontStylesheet','0',2,0,'meer/fonts.css');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('fontStylesheet','0',3,0,'cc/fonts.css');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('fontStylesheet','0',4,0,'yhoo/fonts.css');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('fontStylesheet','0',5,0,'amcl/fonts.css');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('fontStylesheet','0',6,0,'guar/fonts.css');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('fontStylesheet','0',7,0,'chem/fonts.css');
INSERT INTO `ctm`.`configuration` (`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`) VALUES ('fontStylesheet','0',8,0,'choo/fonts.css');
*/