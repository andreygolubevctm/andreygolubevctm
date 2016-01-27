-- CHECKER - zero records
SELECT * FROM ctm.content_control WHERE styleCodeId='0' AND verticalId='4' AND contentCode='SplitTest' AND contentKey='forceOptinOnSlide3';

-- UPDATE
INSERT INTO ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES ('0','4','SplitTest','forceOptinOnSlide3','','2016-01-27 00:00:00','2040-12-31 23:59:59','N');

-- CHECKER - 1 record
SELECT * FROM ctm.content_control WHERE styleCodeId='0' AND verticalId='4' AND contentCode='SplitTest' AND contentKey='forceOptinOnSlide3';

/* ROLLBACK
DELETE FROM ctm.content_control WHERE styleCodeId='0' AND verticalId='4' AND contentCode='SplitTest' AND contentKey='forceOptinOnSlide3';
-- CHECKER - zero records
SELECT * FROM ctm.content_control WHERE styleCodeId='0' AND verticalId='4' AND contentCode='SplitTest' AND contentKey='forceOptinOnSlide3';
*/