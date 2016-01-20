-- Checker - zero records
SELECT * FROM ctm.content_control WHERE styleCodeId='0' AND verticalId='4' AND contentCode='SplitTest' AND contentKey='blockFrontendChanges';

-- Update
INSERT INTO ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES ('0','4','SplitTest','blockFrontendChanges','','2016-01-18 00:00:00','2040-12-31 23:59:59','Y');

-- Checker - 1 record
SELECT * FROM ctm.content_control WHERE styleCodeId='0' AND verticalId='4' AND contentCode='SplitTest' AND contentKey='blockFrontendChanges';

/* Rollback
DELETE FROM ctm.content_control WHERE styleCodeId='0' AND verticalId='4' AND contentCode='SplitTest' AND contentKey='blockFrontendChanges';
-- Checker - zero records
SELECT * FROM ctm.content_control WHERE styleCodeId='0' AND verticalId='4' AND contentCode='SplitTest' AND contentKey='blockFrontendChanges';
*/