-- SELECT count(*) FROM `ctm`.`content_control` WHERE contentCode = 'PHGTracking' AND contentKey = 'trackingURL' AND contentValue = 'http://creative.prf.hn/creative/' AND verticalId = 2;
-- RESULT BEFORE: 1
-- RESULT BEFORE: 0

UPDATE `ctm`.`content_control` SET contentValue = 'https://creative.prf.hn/creative/' WHERE contentCode = 'PHGTracking' AND contentKey = 'trackingURL' AND verticalId = 2 LIMIT 1;