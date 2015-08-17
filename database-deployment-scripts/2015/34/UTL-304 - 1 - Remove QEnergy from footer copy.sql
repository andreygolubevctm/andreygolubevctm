-- UPDATER
SET @ccID = (SELECT contentControlId FROM ctm.content_control WHERE verticalId=5 AND contentCode='Footer' AND contentKey='footerParticipatingSuppliers' AND effectiveEnd = '2038-01-19 03:14:07');
UPDATE ctm.content_control SET effectiveEnd = '2015-08-04 23:59:59' WHERE contentControlId=@ccID;
SET @ccID = (SELECT contentControlId FROM ctm.content_control WHERE verticalId=5 AND contentCode='Footer' AND contentKey='footerParticipatingSuppliers' AND effectiveEnd = '2038-01-19 00:00:00');
UPDATE ctm.content_control SET effectiveEnd = '2015-08-05 23:59:59' WHERE contentControlId=@ccID;
INSERT INTO ctm.content_control (styleCodeId,verticalId,contentCode,contentKey,contentStatus,effectiveStart,effectiveEnd,contentValue) VALUES ('1','5','Footer','footerParticipatingSuppliers','','2015-08-06 00:00:00','2040-12-31 23:59:59','Origin Energy, EnergyAustralia, Simply Energy, ActewAGL, Powershop, People Energy, Click, Online Power and Gas, Alinta Energy and SUMO Power');

-- CHECKER
SELECT * FROM ctm.content_control WHERE verticalId=5 AND contentCode='Footer' AND contentKey='footerParticipatingSuppliers';

-- ROLLBACK
/*
SET @ccID = (SELECT contentControlId FROM ctm.content_control WHERE verticalId=5 AND contentCode='Footer' AND contentKey='footerParticipatingSuppliers' AND effectiveEnd = '2015-08-04 23:59:59');
UPDATE ctm.content_control SET effectiveEnd = '2038-01-19 03:14:07' WHERE contentControlId=@ccID;
SET @ccID = (SELECT contentControlId FROM ctm.content_control WHERE verticalId=5 AND contentCode='Footer' AND contentKey='footerParticipatingSuppliers' AND effectiveEnd = '2015-08-05 23:59:59');
UPDATE ctm.content_control SET effectiveEnd = '2038-01-19 00:00:00' WHERE contentControlId=@ccID;
DELETE FROM ctm.content_control WHERE verticalId=5 AND contentCode='Footer' AND contentKey='footerParticipatingSuppliers' AND effectiveEnd = '2040-12-31 23:59:59';
*/