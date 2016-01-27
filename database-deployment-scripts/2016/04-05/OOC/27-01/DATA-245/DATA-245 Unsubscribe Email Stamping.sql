-- UPDATE
INSERT INTO ctm.stamping (`styleCodeId`,`action`,`brand`,`vertical`,`target`,`value`,`comment`,`operatorId`,`datetime`,`IpAddress`,`archive`) VALUES ('1', 'toggle_marketing', 'ctm', 'car', 'rossdavidson@bigpond.com', 'off', 'QUOTE', 'ONLINE', '2016-01-27 13:15:00', '127.0.0.1', '1');
INSERT INTO ctm.stamping (`styleCodeId`,`action`,`brand`,`vertical`,`target`,`value`,`comment`,`operatorId`,`datetime`,`IpAddress`,`archive`) VALUES ('1', 'toggle_marketing', 'ctm', 'home', 'rossdavidson@bigpond.com', 'off', 'QUOTE', 'ONLINE', '2016-01-27 13:15:00', '127.0.0.1', '1');

-- CHECKER: 2 records
SELECT * FROM ctm.stamping WHERE `styleCodeiD`='1' AND `action`='toggle_marketing' AND `brand`='ctm' AND `vertical` IN ('car','home') AND `target`='rossdavidson@bigpond.com' AND `value`='off' AND `comment`='QUOTE' AND `operatorId`='ONLINE' AND `datetime`='2016-01-27 13:15:00' AND `IpAddress`='127.0.0.1' AND `archive`='1';

/** ROLLBACK
DELETE FROM ctm.stamping WHERE `styleCodeiD`='1' AND `action`='toggle_marketing' AND `brand`='ctm' AND `vertical` IN ('car','home') AND `target`='rossdavidson@bigpond.com' AND `value`='off' AND `comment`='QUOTE' AND `operatorId`='ONLINE' AND `datetime`='2016-01-27 13:15:00' AND `IpAddress`='127.0.0.1' AND `archive`='1';
-- CHECKER: 0 records
SELECT * FROM ctm.stamping WHERE `styleCodeiD`='1' AND `action`='toggle_marketing' AND `brand`='ctm' AND `vertical` IN ('car','home') AND `target`='rossdavidson@bigpond.com' AND `value`='off' AND `comment`='QUOTE' AND `operatorId`='ONLINE' AND `datetime`='2016-01-27 13:15:00' AND `IpAddress`='127.0.0.1' AND `archive`='1';
*/