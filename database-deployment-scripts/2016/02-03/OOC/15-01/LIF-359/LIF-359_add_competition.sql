-- UPDATER
INSERT INTO ctm.competition (competitionId, competitionName, effectiveStart, effectiveEnd, styleCodeId) VALUES ('30', '$5000 Life/IP Promotion (Jan 2015)', '2015-01-15 09:00:00', '2016-02-15 08:59:59', '1');

-- CHECKER - 0 before 1 after
SELECT * FROM ctm.competition WHERE competitionId=30;

/* ROLLBACK
DELETE FROM ctm.competition WHERE competitionId=30;
 */