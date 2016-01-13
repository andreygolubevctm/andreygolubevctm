-- SELECT count(*) AS total FROM `ctm`.`content_control` WHERE `contentCode` = 'PHGTracking' AND `verticalId` = 2;
-- TEST BEFORE: 0
-- TEST AFTER : 1

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '2', 'PHGTracking', 'trackingURL', '2016-01-01 00:00:00', '2040-12-31 23:59:59', 'http://creative.prf.hn/creative/');
SET @CCID := (SELECT LAST_INSERT_ID());

-- SELECT count(*) AS total FROM `ctm`.`content_supplementary` WHERE `contentControlId` = @CCID;
-- TEST BEFORE: 0
-- TEST AFTER : 28
INSERT INTO `ctm`.`content_supplementary` (`contentControlId`, `supplementaryKey`, `supplementaryValue`) VALUES (@CCID, '1COVPostImp', 'camref:1100l9pg/creativeref:1011l5893'),
(@CCID, '1FOW', 'camref:1100l9pi/creativeref:1101l5672'),
(@CCID, 'AMEX', 'camref:1101l9yn/creativeref:1100l5691'),
(@CCID, 'BUDD', 'camref:1101l9yp/creativeref:1011l5894'),
(@CCID, 'CITI', 'camref:1100l9pr/creativeref:1101l5675'),
(@CCID, 'CLBS', 'camref:1100l9ps/creativeref:1011l5905'),
(@CCID, 'DUIN', 'camref:1101l9yx/creativeref:1100l5693'),
(@CCID, 'EASY', 'camref:1101l9yy/creativeref:1100l5692'),
(@CCID, 'FAST', 'camref:1011l9tB/creativeref:1100l5688'),
(@CCID, 'GOIN', 'camref:1100l9pu/creativeref:1100l5690'),
(@CCID, 'I4LS', 'camref:1101l9yz/creativeref:1011l5898'),
(@CCID, 'INGO', 'camref:1100l9px/creativeref:1101l5673'),
(@CCID, 'KANG', 'camref:1101l9yB/creativeref:1101l5677'),
(@CCID, 'OTIS', 'camref:1011l9tE/creativeref:1011l5901'),
(@CCID, 'PPTI', 'camref:1011l9tF/creativeref:1101l5678'),
(@CCID, 'REAL', 'camref:1011l9tG/creativeref:1100l5687'),
(@CCID, 'STIN', 'camref:1100l9pH/creativeref:1011l5902'),
(@CCID, 'SKII', 'camref:1011l9tH/creativeref:1100l5689'),
(@CCID, 'SCTI', 'camref:1100l9pK/creativeref:1011l5900'),
(@CCID, 'TICK', 'camref:1100l9pL/creativeref:1101l5676'),
(@CCID, 'TSAV', 'camref:1101l9yG/creativeref:1011l5899'),
(@CCID, 'TINZ', 'camref:1011l9tI/creativeref:1100l5694'),
(@CCID, '30UN', 'camref:1100l9pN/creativeref:1011l5897'),
(@CCID, 'VIRG', 'camref:1100l9pP/creativeref:1011l5895'),
(@CCID, 'WEBJ', 'camref:1101l9yP/creativeref:1011l5903'),
(@CCID, 'WOOL', 'camref:1100l9pR/creativeref:1011l5904'),
(@CCID, 'WLDC', 'camref:1011l9tR/creativeref:1011l5896'),
(@CCID, 'ITRK', 'camref:1100l9py/creativeref:1101l5674');


-- ******************* ROLLBACK **************************************
-- SELECT count(*) AS total FROM `ctm`.`content_supplementary` WHERE `contentCode` = 'PHGTracking' AND `verticalId` = 2;
-- TEST BEFORE: 28
-- TEST AFTER : 0
-- DELETE FROM `ctm`.`content_supplementary` WHERE `contentControlId` = @CCID LIMIT 28;


-- SELECT count(*) AS total FROM `ctm`.`content_control` WHERE `contentCode` = 'PHGTracking' AND `verticalId` = 2;
-- TEST BEFORE: 1
-- TEST AFTER : 0

-- DELETE FROM `ctm`.`content_control` WHERE `contentCode` = 'PHGTracking' AND `verticalId` = 2 LIMIT 1;