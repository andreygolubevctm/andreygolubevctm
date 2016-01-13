-- SELECT count(*) AS total FROM `ctm`.`content_control` WHERE `contentCode` = 'PHGHandoverTracking' AND `verticalId` = 2;
-- TEST BEFORE: 0
-- TEST AFTER : 2

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '2', 'PHGHandoverTracking', 'handoverTrackingURL', '2016-01-01 00:00:00', '2040-12-31 23:59:59', 'http://prf.hn/click/camref:');
SET @CCID := (SELECT LAST_INSERT_ID());

-- SELECT count(*) AS total FROM `ctm`.`content_supplementary` WHERE `contentControlId` = @CCID;
-- TEST BEFORE: 0
-- TEST AFTER : 28
INSERT INTO `ctm`.`content_supplementary` (`contentControlId`, `supplementaryKey`, `supplementaryValue`) VALUES (@CCID, '1COVPostImp', '1100l9ph'),
(@CCID, '1FOW', '1011l9rM'),
(@CCID, 'AMEX', '1101l9yo'),
(@CCID, 'BUDD', '1100l9pj'),
(@CCID, 'ACET', '1011l9tz'),
(@CCID, 'CLBS', '1101l9yq'),
(@CCID, 'DUIN', '1011l9tA'),
(@CCID, 'EASY', '1100l9pt'),
(@CCID, 'FAST', '1011l9tC'),
(@CCID, 'GOIN', '1100l9pv'),
(@CCID, 'I4LS', '1100l9pw'),
(@CCID, 'INGO', '1011l9tD'),
(@CCID, 'KANG', '1101l9yC'),
(@CCID, 'OTIS', '1101l9yD'),
(@CCID, 'PPTI', '1100l9pz'),
(@CCID, 'REAL', '1100l9pA'),
(@CCID, 'STIN', '1100l9pI'),
(@CCID, 'SKII', '1100l9pJ'),
(@CCID, 'SCTI', '1101l9yE'),
(@CCID, 'TICK', '1101l9yF'),
(@CCID, 'TSAV', '1100l9pM'),
(@CCID, 'TINZ', '1011l9tQ'),
(@CCID, '30UN', '1101l9yN'),
(@CCID, 'VIRG', '1100l9pQ'),
(@CCID, 'WEBJ', '1101l9yQ'),
(@CCID, 'WOOL', '1100l9pY'),
(@CCID, 'WLDC', '1100l9pZ'),
(@CCID, 'ITRK', '1101l9yA');


-- ******************* ROLLBACK **************************************
-- SET @CCID = (SELECT contentControlId FROM `ctm`.`content_control` WHERE `contentKey` = 'PHGHandoverTracking' AND `verticalId` = 2);
-- SELECT count(*) AS total FROM `ctm`.`content_supplementary` WHERE `contentControlId` = @CCID;
-- TEST BEFORE: 28
-- TEST AFTER : 0
-- DELETE FROM `ctm`.`content_supplementary` WHERE `contentControlId` = @CCID LIMIT 28;


-- SELECT count(*) AS total FROM `ctm`.`content_control` WHERE `contentCode` = 'PHGHandoverTracking' AND `verticalId` = 2;
-- TEST BEFORE: 1
-- TEST AFTER : 0

-- DELETE FROM `ctm`.`content_control` WHERE `contentCode` = 'PHGHandoverTracking' AND `verticalId` = 2 LIMIT 2;