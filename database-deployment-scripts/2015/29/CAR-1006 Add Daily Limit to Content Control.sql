/** Updater **/
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '3', 'RegoLookup', 'regoLookupDailyLimit', '2014-06-22 00:00:00', '2040-12-31 23:59:59', '10000');

/** Checker - One record exists after update **/
SELECT * FROM ctm.content_control WHERE styleCodeId=1 AND verticalId=3 AND contentCode='RegoLookup' AND contentKey='regoLookupDailyLimit';

/** Rollback **/
-- DELETE FROM ctm.content_control WHERE styleCodeId=1 AND verticalId=3 AND contentCode='RegoLookup' AND contentKey='regoLookupDailyLimit';