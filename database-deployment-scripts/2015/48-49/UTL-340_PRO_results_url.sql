-- UPDATER
SET @masterId = (SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode='resultsService');
DELETE FROM ctm.service_properties WHERE serviceMasterId=@masterId AND environmentCode='PRO' AND servicePropertyKey='serviceUrl';
INSERT INTO ctm.service_properties (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
  VALUES (@masterId, 'PRO', 0, 0, 'serviceUrl', 'https://www.utilityworld.com.au/comparethemarket/api/response/results_lookup_response_new.php', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE');


-- CHECKER - 0 before and 1 after update
SELECT * FROM ctm.service_properties WHERE serviceMasterId=@masterId AND environmentCode='PRO' AND servicePropertyKey='serviceUrl';

/* ROLLBACK
DELETE FROM ctm.service_properties WHERE serviceMasterId=@masterId AND environmentCode='PRO' AND servicePropertyKey='serviceUrl';
*/