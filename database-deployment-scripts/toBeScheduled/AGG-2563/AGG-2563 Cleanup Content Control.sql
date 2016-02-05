-- CHECKER BEFORE: 14 on NXQ, 12 on PRELIVE and 14 on PRO
SELECT COUNT(*) FROM ctm.content_control WHERE contentValue LIKE '%http://www.comparethemarket.com.au%';

-- UPDATER
UPDATE ctm.content_control SET contentValue=REPLACE(contentValue,'http://www.comparethemarket.com.au','https://www.comparethemarket.com.au') WHERE contentValue LIKE '%http://www.comparethemarket.com.au%';

-- CHECKER AFTER: zero for all 
SELECT COUNT(*) FROM ctm.content_control WHERE contentValue LIKE '%http://www.comparethemarket.com.au%';

/* ROLLBACK
UPDATE ctm.content_control SET contentValue=REPLACE(contentValue,'https://www.comparethemarket.com.au','http://www.comparethemarket.com.au') WHERE contentValue LIKE '%https://www.comparethemarket.com.au%';

-- CHECKER AFTER: 14 on NXQ, 12 on PRELIVE and 14 on PRO
SELECT COUNT(*) FROM ctm.content_control WHERE contentValue LIKE '%http://www.comparethemarket.com.au%';
*/