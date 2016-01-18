-- TEST
SELECT * FROM ctm.content_control where contentKey = 'competitionPreCheckboxContainer' AND contentValue LIKE '%5000Offer%';

-- Turn off the image
UPDATE ctm.content_control SET effectiveEnd = '2015-09-25 00:00:00' where contentKey = 'competitionPreCheckboxContainer' AND contentValue LIKE '%5000Offer%';

-- TEST
SELECT * FROM ctm.content_control where contentKey = 'competitionPreCheckboxContainer' AND contentValue LIKE '%5000Offer%';