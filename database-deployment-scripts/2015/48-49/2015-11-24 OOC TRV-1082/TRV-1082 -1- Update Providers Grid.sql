-- UPDATER
SET @exCC = (SELECT contentControlId FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='2' AND contentCode='LogoGrid' AND contentKey='underwriters' AND CURRENT_DATE BETWEEN effectiveStart AND effectiveEnd);
UPDATE ctm.content_control SET effectiveEnd='2015-11-23 23:59:59' WHERE contentControlId=@exCC;
INSERT INTO ctm.content_control (contentControlId,styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES (null,1,2,'LogoGrid','underwriters','','2015-11-24 00:00:00','2040-12-31 23:59:59','<p>Downunder, OTI, Simply Travel, Fast Cover, Virgin Money, Worldcare, Webjet, and Zuji travel insurance are underwritten by Allianz Australia Insurance Limited.</p><p>1st for Women and Budget Direct Travel Insurance are underwritten by Auto & General Insurance Company Limited.</p><p>American Express, Citibank and Priceline Protects Travel Insurance are underwritten by ACE Insurance Limited. Real Insurance and Woolworths Travel insurance are underwritten by The Hollard Insurance Company Pty Ltd.</p><p>1Cover, Columbus Direct, Go Insurance, itrek, Insure4Less, Kango Cover, Ski Insurance, Travel Insuranz and Under 30&#39;s are underwritten by certain underwriters at Lloyd&#39;s of London. Easy Travel Insurance and Travel Insurance Saver are underwritten by QBE Insurance (Australia) Limited. InsureandGo and Tick Travel Insurance are underwritten by Mitsui Sumitomo Insurance Company Limited. Southern Cross Travel Insurance is underwritten by Southern Cross Benefits Ltd.</p>');

-- CHECKER - 2 before update and 3 after and 2 after rollback yo
SELECT * FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='2' AND contentCode='LogoGrid' AND contentKey='underwriters';

/* ROLLBACK
DELETE FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='2' AND contentCode='LogoGrid' AND contentKey='underwriters' AND effectiveStart='2015-11-24 00:00:00' AND effectiveEnd='2040-12-31 23:59:59';
UPDATE ctm.content_control SET effectiveEnd='2038-01-19 00:00:00' WHERE styleCodeId='1' AND verticalId='2' AND contentCode='LogoGrid' AND contentKey='underwriters' AND effectiveEnd='2015-11-23 23:59:59';
*/