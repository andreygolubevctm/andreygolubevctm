-- UPDATE
UPDATE ctm.content_control SET effectiveStart='2015-11-30 09:00:00' WHERE verticalId=5 AND contentCode='COMPETITION' AND contentKey='competitionEnabled' AND effectiveStart='2015-08-27 09:00:00' AND effectiveEnd='2038-01-19 03:14:07';

-- CHECKER
SELECT * FROM ctm.content_control WHERE verticalId=5 AND contentCode='COMPETITION' AND contentKey='competitionEnabled' AND effectiveStart='2015-11-30 09:00:00' AND effectiveEnd='2038-01-19 03:14:07';

-- ROLLBACK
-- UPDATE ctm.content_control SET effectiveStart='2015-08-27 09:00:00' WHERE verticalId=5 AND contentCode='COMPETITION' AND contentKey='competitionEnabled' AND effectiveStart='2015-11-30 09:00:00' AND effectiveEnd='2038-01-19 03:14:07';