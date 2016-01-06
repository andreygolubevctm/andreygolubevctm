-- UPDATER
INSERT INTO ctm.competition (competitionId, competitionName, effectiveStart, effectiveEnd, styleCodeId) VALUES ('29', '$5000 Life/IP Promotion (Dec 2015)', '2015-12-15 09:00:00', '2016-01-15 08:59:59', '1');

-- CHECKER - 0 before 1 after
SELECT * FROM ctm.competition WHERE competitionId=29;

/* ROLLBACK
DELETE FROM ctm.competition WHERE competitionId=29;
 */