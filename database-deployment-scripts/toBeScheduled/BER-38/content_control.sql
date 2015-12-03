SET @ENERGY_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'UTILITIES');

INSERT INTO ctm.content_control (styleCodeId, verticalId, contentCode, contentKey, contentStatus, effectiveStart, effectiveEnd, contentValue) VALUES
(0, @ENERGY_VERTICAL_ID, 'EnergyQuoteFlag', 'makeEnergyQuoteMainJourney', '', '2015-06-01 00:00:00', '2015-12-31 00:00:00', 'false');
