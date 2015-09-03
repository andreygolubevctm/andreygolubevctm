-- UPDATER
INSERT INTO ctm.competition (competitionId, competitionName, effectiveStart, effectiveEnd, styleCodeId) VALUES ('26', '$5000 Health Promotion', '2015-09-03 09:00:00', '2015-11-30 08:59:59', '1');

INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '4', 'Competition', 'competitionEnabled', '', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 'Y');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '4', 'Competition', 'competitionSecret', '', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 'vU9CD4NjT3S6p7a83a4t');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '4', 'Competition', 'competitionCheckboxText', '', '2015-09-03 09:00:00', '2015-11-30 08:59:59', 'I agree to the <a target="_blank"  href="http://www.comparethemarket.com.au/competition/5000competition.pdf">competition terms and conditions</a>.');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '4', 'Competition', 'competitionPromoImage', '', '2015-09-03 09:00:00', '2015-11-30 08:59:59', '<div class="promotion-container-201508-5000Offer"><div class="promo-image health"></div></div>');
INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES ('1', '4', 'Competition', 'competitionPreCheckboxContainer', '', '2015-09-03 09:00:00', '2015-11-30 08:59:59', '<div class="promotion-container-201508-5000Offer"><div class="promo-image health}"></div></div>');


-- CHECKERS --
SELECT * FROM ctm.competition WHERE competitionId=26;
SELECT * FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='4' AND contentCode='COMPETITION' AND effectiveEnd='2015-11-30 08:59:59';

-- ROLLBACK
-- DELETE FROM ctm.competition WHERE competitionId=26 LIMIT 1;
-- DELETE FROM ctm.content_control WHERE styleCodeId='1' AND verticalId='4' AND contentCode='COMPETITION' AND effectiveEnd='2015-11-30 08:59:59';