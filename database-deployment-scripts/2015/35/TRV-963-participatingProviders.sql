SET @CONTENTCONTROLID = (select contentControlId from ctm.content_control cc where
     cc.contentKey = 'footerParticipatingSuppliers' and styleCodeId = 1 AND verticalId = 2 and CURDATE() between
     cc.effectiveStart AND cc.effectiveEnd ORDER BY styleCodeId desc, verticalId desc LIMIT 1);

SET @NEWCONTENTVALUE = 'Online Travel Insurance, Worldcare Travel Insurance, Simply Travel Insurance, Insure4less, Travel Insuranz, InsureandGo, DUinsure, Fastcover, American Express, Easy Travel Insurance, Columbus Direct, Virgin Money, 1st for Women, Budget Direct, Under 30, Kango Cover, Ski Insurance, 1Cover, iTrek, Citibank Travel Insurance, Travel Insurance Saver, Woolworths Travel Insurance, Southern Cross Travel Insurance, Webjet Travel Insurance,  Priceline Protects, Real Travel Insurance, Tick Travel Insurance, Go Insurance and Zuji';
SET @OLDCONTENTVALUE = 'Online Travel Insurance, Worldcare Travel Insurance, Simply Travel Insurance, Insure4less, Travel Insuranz, InsureandGo, DUinsure, Fastcover, American Express, Easy Travel Insurance, Columbus Direct, Virgin Money, 1st for Women, Budget Direct, Under 30, Kango Cover, Ski Insurance, 1Cover, iTrek, Citibank Travel Insurance, Travel Insurance Saver, Woolworths Travel Insurance, Southern Cross Travel Insurance, Webjet Travel Insurance,  Priceline Protects, Real Travel Insurance, Tick Travel Insurance and Zuji';

update ctm.content_control set contentValue = @NEWCONTENTVALUE
 where contentControlId = @CONTENTCONTROLID LIMIT 1;

--test expect 1;
 select count(*) from ctm.content_control where contentValue = @NEWCONTENTVALUE;

 --ROLLBACK
 -- uncomment below for rollback
 -- SET @OLDCONTENTVALUE = 'Online Travel Insurance, Worldcare Travel Insurance, Simply Travel Insurance, Insure4less, Travel Insuranz, InsureandGo, DUinsure, Fastcover, American Express, Easy Travel Insurance, Columbus Direct, Virgin Money, 1st for Women, Budget Direct, Under 30, Kango Cover, Ski Insurance, 1Cover, iTrek, Citibank Travel Insurance, Travel Insurance Saver, Woolworths Travel Insurance, Southern Cross Travel Insurance, Webjet Travel Insurance,  Priceline Protects, Real Travel Insurance, Tick Travel Insurance and Zuji';

 update ctm.content_control set contentValue = @OLDCONTENTVALUE
 where contentControlId = @CONTENTCONTROLID LIMIT 1;


