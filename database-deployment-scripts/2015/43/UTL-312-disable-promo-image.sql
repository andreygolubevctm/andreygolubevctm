UPDATE `ctm`.`content_control` SET `effectiveEnd`='2015-10-14 08:59:59' WHERE contentKey = "competitionPromoImage" AND verticalId = 5 AND effectiveStart = '2015-08-27 09:00:00';

-- SELECT count(*) AS total FROM `ctm`.`content_control` WHERE contentKey = "competitionPromoImage" AND verticalId = 5 AND effectiveStart = '2015-08-27 09:00:00' AND `effectiveEnd`='2015-10-14 08:59:59';
--  RESULT: 1

-- ============================================================

-- ROLLBACK 
-- UPDATE `ctm`.`content_control` SET `effectiveEnd`='2015-11-30 08:59:59' WHERE contentKey = "competitionPromoImage" AND verticalId = 5 AND effectiveStart = '2015-08-27 09:00:00';

-- SELECT count(*) AS total FROM `ctm`.`content_control` WHERE contentKey = "competitionPromoImage" AND verticalId = 5 AND effectiveStart = '2015-08-27 09:00:00' AND `effectiveEnd`='2015-10-14 08:59:59';
--  RESULT: 0