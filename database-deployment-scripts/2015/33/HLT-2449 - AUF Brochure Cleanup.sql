-- TEST
-- Should be 88 entries
SELECT * FROM ctm.content_supplementary
where supplementaryValue LIKE ('%/2015/%');

UPDATE ctm.content_supplementary
SET supplementaryValue = REPLACE(supplementaryValue, '/2015', '')
where supplementaryValue LIKE ('%/2015/%');

-- TEST
-- Should be 0 entries
SELECT * FROM ctm.content_supplementary
where supplementaryValue LIKE ('%/2015/%');