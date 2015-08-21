-- New entry in competiton table --
INSERT INTO `ctm`.`competition` (`competitionId`, `competitionName`, `effectiveStart`, `effectiveEnd`, `styleCodeId`) VALUES ('24', '$1000 Health Results Promotion (August 2015)', '2015-08-14 09:00:00', '2015-09-03 08:59:59', '1');

-- Content Control Table --
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `contentStatus`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '4', 'Competition', 'competitionEnabled', '', '2015-08-14 09:00:00', '2015-09-03 08:59:59', 'Y');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `contentStatus`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '4', 'Competition', 'competitionSecret', '', '2015-08-14 09:00:00', '2015-09-03 08:59:59', 'kSdRdpu5bdM5UkKQ8gsK');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `contentStatus`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '4', 'Competition', 'competitionPreCheckboxContainer', '', '2015-08-14 09:00:00', '2015-09-03 08:59:59', '<div id=\"promoPreCheckboxContainer\" class=\"promotion\"><div class=\"health1000promoImage\"></div></div>');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `contentStatus`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '4', 'Competition', 'competitionPromoImage', '', '2015-08-14 09:00:00', '2015-09-03 08:59:59', '<div id=\"promoImageContainer\" class=\"promotion\"><div class=\"health1000promoImage\"></div></div>');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `contentStatus`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '4', 'Competition', 'competitionCheckboxText', '', '2015-08-14 09:00:00', '2015-09-03 08:59:59', 'I agree to the <a href=\"http://www.comparethemarket.com.au/competition/termsandconditionshealth.pdf\" target=\"_blank\">terms &amp; conditions</a> of the promotion.');

-- Test --
SELECT * FROM ctm.content_control
where verticalId = 4
and contentKey Like 'competition%'
and '2015-08-14 09:00:00' between effectiveStart and effectiveEnd;