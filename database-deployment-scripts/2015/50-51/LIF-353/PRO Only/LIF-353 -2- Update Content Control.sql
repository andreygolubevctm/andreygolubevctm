-- -------------------
-- EXPIRE OLD COMP --
-- -------------------

-- UPDATER
UPDATE ctm.content_control SET effectiveEnd='2015-12-15 08:59:59' WHERE verticalId IN (6,8) AND contentCode='Competition' AND effectiveStart='2015-12-03 09:00:00' AND effectiveEnd='2016-03-03 08:59:59';

-- CHECKER 6 records before and zero after
SELECT * FROM ctm.content_control WHERE verticalId IN (6,8) AND contentCode='Competition' AND effectiveStart='2015-12-03 09:00:00' AND effectiveEnd='2016-03-03 08:59:59';

/* ROLLBACK
UPDATE ctm.content_control SET effectiveEnd='2016-03-03 08:59:59' WHERE verticalId IN (6,8) AND contentCode='Competition' AND effectiveStart='2015-12-03 09:00:00' AND effectiveEnd='2015-12-15 08:59:59';
*/

-- ----------------
-- ADD NEW COMP --
-- ----------------

-- UPDATER
INSERT INTO ctm.content_control (contentControlId,styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES (null,'1','6','Competition','competitionId','','2015-12-15 09:00:00','2016-01-15 08:59:59','29');
INSERT INTO ctm.content_control (contentControlId,styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES (null,'1','8','Competition','competitionId','','2015-12-15 09:00:00','2016-01-15 08:59:59','29');
INSERT INTO ctm.content_control (contentControlId,styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES (null,'1','6','Competition','competitionEnabled','','2015-12-15 09:00:00','2016-01-15 08:59:59','Y');
INSERT INTO ctm.content_control (contentControlId,styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES (null,'1','8','Competition','competitionEnabled','','2015-12-15 09:00:00','2016-01-15 08:59:59','Y');
INSERT INTO ctm.content_control (contentControlId,styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES (null,'1','6','Competition','competitionCheckboxText','','2015-12-15 09:00:00','2016-01-15 08:59:59','Yes, I agree to the <a target=\'_blank\'  href=\'/static/competitions/Life-IP - 5x$1000 trade promotion TCs.pdf\'>competition terms and conditions</a>.');
INSERT INTO ctm.content_control (contentControlId,styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES (null,'1','8','Competition','competitionCheckboxText','','2015-12-15 09:00:00','2016-01-15 08:59:59','Yes, I agree to the <a target=\'_blank\'  href=\'/static/competitions/Life-IP - 5x$1000 trade promotion TCs.pdf\'>competition terms and conditions</a>.');

-- CHECKER 0 before 6 after
SELECT * FROM ctm.content_control WHERE verticalId IN (6,8) AND contentCode='Competition' AND contentKey IN ('competitionId','competitionEnabled','competitionCheckboxText') AND effectiveStart='2015-12-15 09:00:00' AND effectiveEnd='2016-01-15 08:59:59' ORDER BY verticalId ASC;

/* ROLLBACK
DELETE FROM ctm.content_control WHERE verticalId IN (6,8) AND contentCode='Competition' AND contentKey IN ('competitionEnabled','competitionCheckboxText') AND effectiveStart='2015-12-15 09:00:00' AND effectiveEnd='2016-01-15 08:59:59';
*/