INSERT INTO
`ctm`.`provider_properties` (`ProviderId`, `PropertyId`, `SequenceNo`, `Text`, `EffectiveStart`, `EffectiveEnd`, `Status`)
SELECT 12, 'DailyLimit', MAX(SequenceNo)+1, '1', '2014-11-01', '2014-12-31', 1
FROM ctm.provider_properties
WHERE ProviderId = 12
AND PropertyId = 'DailyLimit';