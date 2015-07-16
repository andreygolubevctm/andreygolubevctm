SET @CAR_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'CAR');

INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES
(0, @CAR_VERTICAL_ID, 'CarQuoteFlag', 'makeCarQuoteMainJourney', '', '2015-06-01 00:00:00', '2015-12-31 00:00:00', 'false');

-- Rollback
-- SET @CAR_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'CAR');
--
-- DELETE FROM ctm.content_control WHERE verticalId = @CAR_VERTICAL_ID AND contentKey = 'makeCarQuoteMainJourney';