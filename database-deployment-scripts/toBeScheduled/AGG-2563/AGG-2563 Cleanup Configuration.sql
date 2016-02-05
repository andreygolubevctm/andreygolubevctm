-- CHECKER BEFORE: 14 on NXQ, 13 on PRELIVE and 13 on PRO
SELECT COUNT(*) FROM ctm.configuration WHERE configValue LIKE '%http://www.comparethemarket.com.au%';

-- UPDATER
UPDATE ctm.configuration SET configValue=REPLACE(configValue,'http://www.comparethemarket.com.au','https://www.comparethemarket.com.au') WHERE configValue LIKE '%http://www.comparethemarket.com.au%';

-- CHECKER AFTER: zero for all
SELECT COUNT(*) FROM ctm.configuration WHERE configValue LIKE '%http://www.comparethemarket.com.au%';

/* ROLLBACK
UPDATE ctm.configuration SET configValue=REPLACE(configValue,'https://www.comparethemarket.com.au','http://www.comparethemarket.com.au') WHERE configValue LIKE '%https://www.comparethemarket.com.au%';

-- CHECKER AFTER: 14 on NXQ, 13 on PRELIVE and 13 on PRO
SELECT COUNT(*) FROM ctm.configuration WHERE configValue LIKE '%http://www.comparethemarket.com.au%';
*/