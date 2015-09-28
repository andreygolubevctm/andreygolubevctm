SET @HEALTH_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HEALTH');

INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES
(0, @HEALTH_VERTICAL_ID, 'HealthApplicationProviders', 'healthApplicationExcludeProvidersMainJourney', '', '2015-06-01 00:00:00', '2015-12-31 00:00:00', 'BUD,BUP,CBH,CTM,CUA,FRA,GMH,HCF,HIF,NIB,QCF');

-- Rollback
-- SET @HEALTH_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HEALTH');
--
-- DELETE FROM ctm.content_control WHERE verticalId = @HEALTH_VERTICAL_ID AND contentKey = 'healthApplicationExcludeProvidersMainJourney';