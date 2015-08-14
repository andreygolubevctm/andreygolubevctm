-- UPDATER
INSERT INTO ctm.competition (competitionId, competitionName, effectiveStart, effectiveEnd, styleCodeId) VALUES ('25', '$5000 Utilities Promotion', '2015-08-27 09:00:00', '2015-11-30 08:59:59', '1');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '5', 'Competition', 'competitionId', '', '2015-08-27 09:00:00', '2015-11-30 08:59:59', '25');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '5', 'Competition', 'competitionEnabled', '', '2015-08-27 09:00:00', '2015-11-30 08:59:59', 'Y');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '5', 'Competition', 'competitionCheckboxText', '', '2015-08-27 09:00:00', '2015-11-30 08:59:59', 'I agree to the <a target="_blank"  href="http://comparethemarket.com.au/competition/termsandconditionsenergy.pdf">competition terms and conditions</a>.');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '5', 'Competition', 'competitionPromoImage', '', '2015-08-27 09:00:00', '2015-11-30 08:59:59', '<div class="promotion-201508-container"><div class="promo-image utilities}"></div></div>');

-- CHECKERS --
SELECT * FROM ctm.competition WHERE competitionId=25;
SELECT * FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='5' AND contentCode='COMPETITION' AND effectiveEnd='2015-11-30 08:59:59';

-- ROLLBACK
-- DELETE FROM ctm.competition WHERE competitionId=25 LIMIT 1;
-- DELETE FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='5' AND contentCode='COMPETITION' AND effectiveEnd='2015-11-30 08:59:59';