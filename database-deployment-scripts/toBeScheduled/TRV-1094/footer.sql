-- Run
UPDATE ctm.content_control
SET effectiveEnd = '2016-01-07 23:59:59'
WHERE styleCodeId = 1
AND verticalId = 2
AND contentCode = 'Footer'
AND contentKey = 'footerParticipatingSuppliers';

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '2', 'Footer', 'footerParticipatingSuppliers', '2016-01-08 00:00:00', '2040-12-12 23:59:59', 'Online Travel Insurance, Worldcare Travel Insurance, Simply Travel Insurance, Insure4less, Travel Insuranz, InsureandGo, DUinsure, Fastcover, American Express, Easy Travel Insurance, Columbus Direct, Virgin Money, 1st for Women, Budget Direct, Under 30, Kango Cover, Ski Insurance, 1Cover, iTrek, Citibank Travel Insurance, Travel Insurance Saver, Woolworths Travel Insurance, Southern Cross Travel Insurance, Webjet Travel Insurance,  Priceline Protects, Real Travel Insurance, Tick Travel Insurance, and Go Insurance');

-- Rollback
DELETE FROM ctm.content_control
WHERE styleCodeId = '1'
AND verticalId = 2
AND contentCode = 'Footer'
AND contentKey = 'footerParticipatingSuppliers'
AND effectiveStart = DATE('2016-01-08 00:00:00');

UPDATE ctm.content_control
SET effectiveEnd = '2040-12-31 23:59:59'
WHERE styleCodeId = '1'
AND verticalId = 2
AND contentCode = 'Footer'
AND contentKey = 'footerParticipatingSuppliers'
ORDER BY contentControlId DESC
LIMIT 1;