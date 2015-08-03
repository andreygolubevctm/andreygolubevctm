-- TEST
-- Should find the entries for AUF Smart Essentials

SELECT * FROM ctm.content_supplementary where supplementaryValue LIKE ('%/Smart_Essentials.pdf%');
-- and
SELECT * FROM ctm.content_control where contentcontrolid IN (SELECT contentcontrolid FROM ctm.content_supplementary where supplementaryValue LIKE ('%/Smart_Essentials.pdf%'));

-- NXQ ONLY
UPDATE ctm.contentcontrol SET effectiveEnd = '2015-07-27 00:00:00' WHERE contentcontrolId = '10600'

-- PROD ONLY
UPDATE ctm.contentcontrol SET effectiveEnd = '2015-07-27 00:00:00' WHERE contentcontrolId = '10597'

-- TEST
-- Should now see the one that is non 2015 as expired
SELECT * FROM ctm.content_supplementary where supplementaryValue LIKE ('%/Smart_Essentials.pdf%');
-- and
SELECT * FROM ctm.content_control where contentcontrolid IN (SELECT contentcontrolid FROM ctm.content_supplementary where supplementaryValue LIKE ('%/Smart_Essentials.pdf%'));
