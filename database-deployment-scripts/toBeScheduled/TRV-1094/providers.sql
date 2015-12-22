-- Run
UPDATE ctm.content_control
SET effectiveEnd = '2016-01-07 23:59:59'
WHERE styleCodeId = '1'
AND verticalId = 2
AND contentCode = 'LogoGrid'
AND contentKey = 'underwriters'
ORDER BY contentControlId DESC
LIMIT 1;

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`)
VALUES ('1', '2', 'LogoGrid', 'underwriters', '2016-01-08 00:00:00', '2040-12-12 23:59:59', '<p>Downunder, OTI, Simply Travel, Fast Cover, Virgin Money, Worldcare, and Webjet are underwritten by Allianz Australia Insurance Limited.</p><p>1st for Women and Budget Direct Travel Insurance are underwritten by Auto & General Insurance Company Limited.</p><p>American Express, Citibank and Priceline Protects Travel Insurance are underwritten by ACE Insurance Limited. Real Insurance and Woolworths Travel insurance are underwritten by The Hollard Insurance Company Pty Ltd.</p><p>1Cover, Columbus Direct, Go Insurance, itrek, Insure4Less, Kango Cover, Ski Insurance, Travel Insuranz and Under 30&#39;s are underwritten by certain underwriters at Lloyd&#39;s of London. Easy Travel Insurance and Travel Insurance Saver are underwritten by QBE Insurance (Australia) Limited. InsureandGo and Tick Travel Insurance are underwritten by Mitsui Sumitomo Insurance Company Limited. Southern Cross Travel Insurance is underwritten by Southern Cross Benefits Ltd.</p>');

-- Rollback
/*
DELETE FROM ctm.content_control
WHERE styleCodeId = '1'
AND verticalId = 2
AND contentCode = 'LogoGrid'
AND contentKey = 'underwriters'
AND effectiveStart = DATE('2016-01-08 00:00:00');

UPDATE ctm.content_control
SET effectiveEnd = '2040-12-31 23:59:59'
WHERE styleCodeId = '1'
AND verticalId = 2
AND contentCode = 'LogoGrid'
AND contentKey = 'underwriters'
ORDER BY contentControlId DESC
LIMIT 1;
*/