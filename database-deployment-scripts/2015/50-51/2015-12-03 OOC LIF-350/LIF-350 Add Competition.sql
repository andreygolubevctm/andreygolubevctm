-- UPDATER
INSERT INTO ctm.competition (competitionId, competitionName, effectiveStart, effectiveEnd, styleCodeId) VALUES ('28', '$1000 Life/IP Promotion (Dec 2015)', '2015-12-03 09:00:00', '2016-03-03 08:59:59', '1');

-- CHECKER - 0 before 1 after
SELECT * FROM ctm.competition WHERE competitionId=28;

/* ROLLBACK
DELETE FROM ctm.competition WHERE competitionId=28;
 */