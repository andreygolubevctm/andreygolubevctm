-- UPDATER
SET @CONTENTCONTROLID = (SELECT contentControlId FROM ctm.content_control WHERE contentCode='LeadFeed' AND contentKey='ignoreMatchingFormField');
UPDATE ctm.content_supplementary SET supplementaryValue='0411111111,0755254545,0712345678,0400123123,0733452635' WHERE contentControlId = @CONTENTCONTROLID;

-- CHECKER - value should contain 5 phone numbers after update (3 before)
SET @CONTENTCONTROLID = (SELECT contentControlId FROM ctm.content_control WHERE contentCode='LeadFeed' AND contentKey='ignoreMatchingFormField');
SELECT * FROM ctm.content_supplementary WHERE contentControlId = @CONTENTCONTROLID;

-- ROLLBACK
-- SET @CONTENTCONTROLID = (SELECT contentControlId FROM ctm.content_control WHERE contentCode='LeadFeed' AND contentKey='ignoreMatchingFormField');
-- UPDATE ctm.content_supplementary SET supplementaryValue='0411111111,0755254545,0712345678' WHERE contentControlId = @CONTENTCONTROLID;