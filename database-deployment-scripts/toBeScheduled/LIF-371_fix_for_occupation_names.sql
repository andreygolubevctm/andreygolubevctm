-- Should return ~70
SELECT COUNT(*) FROM ctm.lifebroker_occupations WHERE title LIKE ('% & %');

UPDATE ctm.lifebroker_occupations SET title=REPLACE(title,' & ',' &amp; ') WHERE 1;

-- Should return zero
SELECT COUNT(*) FROM ctm.lifebroker_occupations WHERE title LIKE ('% & %');
