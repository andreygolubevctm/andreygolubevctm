INSERT INTO ctm.competition (competitionId, competitionName, effectiveStart, effectiveEnd, styleCodeId) VALUES (27, '$5000 Life Promotion', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 1);

INSERT INTO ctm.content_control (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '6', 'Competition', 'competitionId', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 27);
INSERT INTO ctm.content_control (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '8', 'Competition', 'competitionId', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 27);
INSERT INTO ctm.content_control (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '6', 'Competition', 'competitionEnabled', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 'Y');
INSERT INTO ctm.content_control (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '8', 'Competition', 'competitionEnabled', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 'Y');
INSERT INTO ctm.content_control (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '6', 'Competition', 'competitionCheckboxText', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 'I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>terms and conditions</a>.');
INSERT INTO ctm.content_control (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '8', 'Competition', 'competitionCheckboxText', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 'I agree to the <a target=\'_blank\'  href=\'http://www.comparethemarket.com.au/competition/5000competition.pdf\'>terms and conditions</a>.');


-- CHECKERS --
SELECT * FROM ctm.competition WHERE competitionId=27;
SELECT * FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='6' AND contentCode='COMPETITION' AND effectiveEnd='2015-11-30 08:59:59';
SELECT * FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='8' AND contentCode='COMPETITION' AND effectiveEnd='2015-11-30 08:59:59';

-- ROLLBACK
-- DELETE FROM ctm.competition WHERE competitionId=27 LIMIT 1;
-- DELETE FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='6' AND contentCode='COMPETITION' AND effectiveEnd='2015-11-30 08:59:59';
-- DELETE FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='8' AND contentCode='COMPETITION' AND effectiveEnd='2015-11-30 08:59:59';