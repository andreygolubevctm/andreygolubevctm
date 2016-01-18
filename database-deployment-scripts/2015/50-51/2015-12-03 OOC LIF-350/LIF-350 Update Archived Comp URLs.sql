-- UPDATER
-- 12 Updated
UPDATE ctm.content_control SET contentValue=REPLACE(contentValue,'http://www.comparethemarket.com.au/competition/','https://www.comparethemarket.com.au/static/competitions/') WHERE contentCode='Competition' AND contentKey='competitionCheckboxText' AND contentValue LIKE '%comparethemarket.com.au/competition/%';
-- 9 Updated
UPDATE ctm.content_control SET contentValue=REPLACE(contentValue,'http://comparethemarket.com.au/competition/','https://www.comparethemarket.com.au/static/competitions/') WHERE contentCode='Competition' AND contentKey='competitionCheckboxText' AND contentValue LIKE '%comparethemarket.com.au/competition/%';

-- CHECKER 21 Rows before and zero after
SELECT * FROM ctm.content_control WHERE contentCode='Competition' AND contentKey='competitionCheckboxText' AND contentValue LIKE '%comparethemarket.com.au/competition/%';

/* ROLLBACK
UPDATE ctm.content_control SET contentValue=REPLACE(contentValue,'https://www.comparethemarket.com.au/static/competitions/','http://www.comparethemarket.com.au/competition/') WHERE contentCode='Competition' AND contentKey='competitionCheckboxText' AND contentValue LIKE '%comparethemarket.com.au/static/competitions/%';
*/