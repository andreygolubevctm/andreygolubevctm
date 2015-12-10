SET @HEALTH_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HEALTH');

INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES
(0, @HEALTH_VERTICAL_ID, 'HealthQuoteFlag', 'makeHealthQuoteMainJourney', '', '2015-06-01 00:00:00', '2015-12-31 00:00:00', 'false');

-- Rollback
-- SET @HEALTH_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HEALTH');
--
-- DELETE FROM ctm.content_control WHERE verticalId = @HEALTH_VERTICAL_ID AND contentKey = 'makeHealthQuoteMainJourney';