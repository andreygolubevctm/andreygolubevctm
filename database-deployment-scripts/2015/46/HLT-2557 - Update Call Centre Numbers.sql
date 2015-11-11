-- Test 4 results
SELECT * FROM ctm.content_control
where contentCode = 'Phone'
AND stylecodeid IN (0,1)
and verticalId = 4
and contentKey IN ('callCentreNumber',
'callCentreHelpNumber',
'callCentreNumberApplication',
'callCentreHelpNumberApplication')
;
-- Test - 8 results for all stylecodes
SELECT * FROM ctm.content_control
where contentCode = 'Phone'
and verticalId = 4
and contentKey IN ('callCentreNumberApplication',
'callCentreHelpNumberApplication')
;

DELETE FROM ctm.content_control
where contentCode = 'Phone'
and verticalId = 4
and contentKey IN ('callCentreNumberApplication',
'callCentreHelpNumberApplication')
;

-- Should change 2 records
UPDATE `ctm`.`content_control` SET `contentValue`='13 32 32'
where contentCode = 'Phone'
AND stylecodeid IN (0,1)
and verticalId = 4
and contentKey IN ('callCentreNumber',
'callCentreHelpNumber')
;

