-- Checker 1 record
SELECT * FROM ctm.content_control WHERE styleCodeId = '1' AND verticalId = 2 AND contentCode = 'LogoGrid' AND contentKey = 'briefInsurerCopyLink' AND effectiveEnd = '2040-12-12 23:59:59' ORDER BY contentControlId DESC LIMIT 1;

-- UPDATE
UPDATE ctm.content_control SET effectiveEnd = '2016-01-07 23:59:59' WHERE styleCodeId = '1' AND verticalId = 2 AND contentCode = 'LogoGrid' AND contentKey = 'briefInsurerCopyLink' ORDER BY contentControlId DESC LIMIT 1;

-- Checker 1 record
SELECT * FROM ctm.content_control WHERE styleCodeId = '1' AND verticalId = 2 AND contentCode = 'LogoGrid' AND contentKey = 'briefInsurerCopyLink' AND effectiveEnd = '2016-01-07 23:59:59' ORDER BY contentControlId DESC LIMIT 1;

-- UPDATE
INSERT INTO `ctm`.`content_control` (`styleCodeId`, `verticalId`, `contentCode`, `contentKey`, `effectiveStart`, `effectiveEnd`, `contentValue`) VALUES ('1', '2', 'LogoGrid', 'briefInsurerCopyLink', '2016-01-08 00:00:00', '2040-12-12 23:59:59', 'View all <strong>28 brands</strong> and their underwriters here');

-- Checker 1 record
SELECT * FROM ctm.content_control WHERE styleCodeId = '1' AND verticalId = 2 AND contentCode = 'LogoGrid' AND contentKey = 'briefInsurerCopyLink' AND effectiveEnd = '2040-12-12 23:59:59' ORDER BY contentControlId DESC LIMIT 1;
