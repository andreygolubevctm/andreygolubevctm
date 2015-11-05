UPDATE `ctm`.`content_control`  SET `effectiveEnd`='2015-11-04 00:00:00' WHERE contentKey = 'footerParticipatingSuppliers' AND `verticalId` = 5 AND `effectiveStart` = '2015-09-10 07:00:00' AND `effectiveEnd` = '2038-01-19 00:00:00';

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '5', 'Footer', 'footerParticipatingSuppliers', '2015-11-05 00:00:00', '2040-12-31 00:00:00', 'Origin Energy, EnergyAustralia, Simply Energy, ActewAGL, Powershop, People Energy, Click, Online Power and Gas, Sumo Power, Alinta Energy and Red Energy');


-- SELECT count(*) FROM `ctm`.`content_control` WHERE `contentValue`='Origin Energy, EnergyAustralia, Simply Energy, ActewAGL, Powershop, People Energy, Click, Online Power and Gas, Sumo Power, Alinta Energy and Red Energy' AND  contentKey = 'footerParticipatingSuppliers' AND `verticalId` = 5 AND `effectiveStart` = '2015-11-05 00:00:00' AND `effectiveEnd` = '2040-12-31 00:00:00';
-- TEST AFTER UPDATE: 1


-- =======================================================
-- ===================== ROLLBACK ========================
-- =======================================================

-- DELETE FROM `ctm`.`content_control`  WHERE contentKey = 'footerParticipatingSuppliers' AND `verticalId` = 5 AND `effectiveStart` = '2015-11-05 00:00:00' AND `effectiveEnd` = '2040-12-31 00:00:00' LIMIT 1;

-- SELECT count(*) FROM `ctm`.`content_control` WHERE `contentValue`='Origin Energy, EnergyAustralia, Simply Energy, ActewAGL, Powershop, People Energy, Click, Online Power and Gas, Sumo Power, Alinta Energy and Red Energy' AND  contentKey = 'footerParticipatingSuppliers' AND `verticalId` = 5 AND `effectiveStart` = '2015-11-05 00:00:00' AND `effectiveEnd` = '2040-12-31 00:00:00';
-- TEST AFTER DELETE : 0

-- UPDATE `ctm`.`content_control`  SET `effectiveEnd`='2038-01-19 00:00:00' WHERE contentKey = 'footerParticipatingSuppliers' AND `verticalId` = 5 AND `effectiveStart` = '2015-09-10 07:00:00' AND `effectiveEnd` = '2015-11-04 00:00:00';