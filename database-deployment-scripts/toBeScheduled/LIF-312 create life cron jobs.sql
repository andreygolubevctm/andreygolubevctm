-- Test (0 before, 2 after)
SELECT *
FROM ctm.cron_jobs
WHERE cronVerticalID = 6;

-- RUN
INSERT INTO `ctm`.`cron_jobs` (`cronStyleCodeID`, `cronVerticalID`, `cronFrequency`, `cronURL`, `cronEffectiveStart`, `cronEffectiveEnd`) VALUES ('0', '6', '1minute', '/cron/life/best_price_lead.jsp', '2015-05-06 00:00:00', '2040-12-31 23:59:59');
INSERT INTO `ctm`.`cron_jobs` (`cronStyleCodeID`, `cronVerticalID`, `cronFrequency`, `cronURL`, `cronEffectiveStart`, `cronEffectiveEnd`) VALUES ('0', '6', '15minutes', '/cron/life/dropout_lead.jsp', '2015-05-06 00:00:00', '2040-12-31 23:59:59');