UPDATE ctm.content_control SET effectiveEnd = '2040-12-31 00:00:00' WHERE contentKey in ('makeTravelQuoteMainJourney', 'makeHomeQuoteMainJourney', 'makeCarQuoteMainJourney', 'makeHealthQuoteMainJourney', 'makeHealthApplyMainJourney');

SELECT * FROM ctm.content_control where contentKey in ('makeTravelQuoteMainJourney', 'makeHomeQuoteMainJourney', 'makeCarQuoteMainJourney', 'makeHealthQuoteMainJourney', 'makeHealthApplyMainJourney');

-- ROLLBACK
-- UPDATE ctm.content_control SET effectiveEnd = '2016-12-31 00:00:00' WHERE contentKey in ('makeTravelQuoteMainJourney', 'makeHomeQuoteMainJourney', 'makeCarQuoteMainJourney', 'makeHealthQuoteMainJourney', 'makeHealthApplyMainJourney');