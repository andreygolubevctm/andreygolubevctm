-- UPDATER
INSERT INTO ctm.content_control (contentControlId,styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES 
	(null,0,3,'Browsers','minimumSupportedBrowsers','','2015-08-03 00:00:00','2040-12-31 23:59:59','{"FIREFOX": 4,"SAFARI": 5,"IE": 9,"CHROME": 4,"OPERA": 12}'),
	(null,0,7,'Browsers','minimumSupportedBrowsers','','2015-08-03 00:00:00','2040-12-31 23:59:59','{"FIREFOX": 4,"SAFARI": 5,"IE": 9,"CHROME": 4,"OPERA": 12}');

-- CHECKER: 0 before update and 2 after
SELECT * FROM ctm.content_control WHERE verticalId IN (3,7) AND contentCode='Browsers' AND contentKey='minimumSupportedBrowsers';

-- ROLLBACK
-- DELETE FROM ctm.content_control WHERE verticalId IN (3,7) AND contentCode='Browsers' AND contentKey='minimumSupportedBrowsers';