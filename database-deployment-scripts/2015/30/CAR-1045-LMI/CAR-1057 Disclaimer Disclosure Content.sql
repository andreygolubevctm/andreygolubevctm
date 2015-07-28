-- [TEST] SELECT count(contentControlId) AS total FROM ctm.content_control WHERE contentCode like '%lmi%';
-- TEST RESULTS BEFORE UPDATE: 0

INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '10', 'LMIContent', 'lmiDisclaimer', '2014-06-01 00:00:00', '2040-06-30 23:59:59', '<p class="hidden-xs">Each product in this list may offer different features. This information has been supplied by an independent third party. Please always consider the policy wording and product disclosure statement for each product before making a decision to buy.  For more information about our features comparison tool, <a href="#footer">please see our disclaimer</a>.</p><p class="visible-xs">Information about our providers is supplied by an independent third party. For more information about the features comparison tool, please refer to our website.</p>');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '10', 'LMIContent', 'lmiCompareCopy', '2014-06-01 00:00:00', '2040-06-30 23:59:59', '<h4>Thank you for using our features comparison</h4><p>Now compare prices from our participating insurance providers</p>');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '10', 'LMIContent', 'lmiDisclosure', '2014-06-01 00:00:00', '2040-06-30 23:59:59', '<p><span class=\"icon-arrow-right\"></span> Click the arrows for more information about this feature</p>');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '11', 'LMIContent', 'lmiDisclaimer', '2014-06-01 00:00:00', '2040-06-30 23:59:59', '<p class="hidden-xs">Each product in this list may offer different features. This information has been supplied by an independent third party. Please always consider the policy wording and product disclosure statement for each product before making a decision to buy.  For more information about our features comparison tool, <a href="#footer">please see our disclaimer</a>.</p><p class="visible-xs">Information about our providers is supplied by an independent third party. For more information about the features comparison tool, please refer to our website.</p>');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '11', 'LMIContent', 'lmiCompareCopy', '2014-06-01 00:00:00', '2040-06-30 23:59:59', '<h4>Thank you for using our features comparison</h4><p>Now compare prices from our participating insurance providers</p>');
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('0', '11', 'LMIContent', 'lmiDisclosure', '2014-06-01 00:00:00', '2040-06-30 23:59:59', '<p><span class=\"icon-arrow-right\"></span> Click the arrows for more information about this feature</p>');

-- TEST RESULTS AFTER UPDATE: 6

-- ========================================================================================================
-- ROLLBACK
-- ========================================================================================================

-- [TEST] SELECT count(contentControlId) AS total FROM ctm.content_control WHERE contentCode like '%lmi%';
-- TEST RESULTS BEFORE DELETION: 6
-- DELETE FROM `ctm`.`content_control` WHERE contentCode = 'LMIContent' LIMIT 6;
-- TEST RESULTS AFTER  DELETION: 0