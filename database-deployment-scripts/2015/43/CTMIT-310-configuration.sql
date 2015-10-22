INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES
('jwtEnabled','0','0','0','false');

-- health
set @vertical = '4';
INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES('jwtSecondsUntilNextTokenN','0','0',@vertical,'20');

INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES('jwtSecondsUntilNextTokenR','0','0',@vertical,'4');

INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES('jwtSecondsUntilNextTokenA','0','0',@vertical,'4');

INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES
('jwtEnabled','0','0',@vertical,'true');

INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES
('jwtSecretKey','0','0',@vertical,'-G0l8eq3AFgfwU6LilF6sY-ssap5mM3Ue5ED2tYs');

-- fuel
set @vertical = '9';
INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES('jwtSecondsUntilNextTokenN','0','0',@vertical,'0');
INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES('jwtSecondsUntilNextTokenR','0','0',@vertical,'5');

INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES
('jwtEnabled','0','0',@vertical,'true');

INSERT INTO `ctm`.`configuration`
(`configCode`,`environmentCode`,`styleCodeId`,`verticalId`,`configValue`)
VALUES
('jwtSecretKey','0','0',@vertical,'SFrE6xJ9kYusG2Pl7z-I8IiVPjHZfo-EGcWNOXSG');

/*

-- rollback
DELETE from `ctm`.`configuration`
WHERE configCode IN('jwtSecretKey','jwtEnabled','jwtSecondsUntilNextTokenR','jwtSecondsUntilNextTokenN', 'jwtSecondsUntilNextTokenA');

*/