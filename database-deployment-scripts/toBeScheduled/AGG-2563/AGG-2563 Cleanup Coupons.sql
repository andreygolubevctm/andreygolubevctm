-- CHECKER BEFORE: 29 records
SELECT COUNT(*) FROM ctm.coupons WHERE contentBanner LIKE '%http://www.comparethemarket.com.au%' OR contentSuccess LIKE '%http://www.comparethemarket.com.au%' OR contentConfirmation LIKE '%http://www.comparethemarket.com.au%';

-- UPDATER
UPDATE ctm.coupons SET contentBanner=REPLACE(contentBanner,'http://www.comparethemarket.com.au','https://www.comparethemarket.com.au') WHERE contentBanner LIKE '%http://www.comparethemarket.com.au%';
UPDATE ctm.coupons SET contentSuccess=REPLACE(contentSuccess,'http://www.comparethemarket.com.au','https://www.comparethemarket.com.au') WHERE contentSuccess LIKE '%http://www.comparethemarket.com.au%';
UPDATE ctm.coupons SET contentConfirmation=REPLACE(contentConfirmation,'http://www.comparethemarket.com.au','https://www.comparethemarket.com.au') WHERE contentConfirmation LIKE '%http://www.comparethemarket.com.au%';

-- CHECKER AFTER: zero for all 
SELECT COUNT(*) FROM ctm.coupons WHERE contentBanner LIKE '%http://www.comparethemarket.com.au%' OR contentSuccess LIKE '%http://www.comparethemarket.com.au%' OR contentConfirmation LIKE '%http://www.comparethemarket.com.au%';

/* ROLLBACK

UPDATE ctm.coupons SET contentBanner=REPLACE(contentBanner,'https://www.comparethemarket.com.au','http://www.comparethemarket.com.au') WHERE contentBanner LIKE '%https://www.comparethemarket.com.au%';
UPDATE ctm.coupons SET contentSuccess=REPLACE(contentSuccess,'https://www.comparethemarket.com.au','http://www.comparethemarket.com.au') WHERE contentSuccess LIKE '%https://www.comparethemarket.com.au%';
UPDATE ctm.coupons SET contentConfirmation=REPLACE(contentConfirmation,'https://www.comparethemarket.com.au','http://www.comparethemarket.com.au') WHERE contentConfirmation LIKE '%https://www.comparethemarket.com.au%';

-- CHECKER AFTER: 14 on NXQ, 12 on PRELIVE and 14 on PRO
SELECT COUNT(*) FROM ctm.coupons WHERE contentBanner LIKE '%http://www.comparethemarket.com.au%' OR contentSuccess LIKE '%http://www.comparethemarket.com.au%' OR contentConfirmation LIKE '%http://www.comparethemarket.com.au%';
*/