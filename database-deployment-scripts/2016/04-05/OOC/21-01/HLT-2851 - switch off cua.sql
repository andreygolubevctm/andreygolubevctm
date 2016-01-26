-- Expect 1 (for Yahoo)
SELECT * FROM ctm.stylecode_provider_exclusions
WHERE providerId = 12
AND NOW() BETWEEN excludeDateFrom and excludeDateTo;


INSERT INTO `ctm`.`stylecode_provider_exclusions`
(`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`)
VALUES ('0', '4', '12', NOW(), '2016-02-01 00:00:01');

-- Expect 2 for Yahoo and CtM

SELECT * FROM ctm.stylecode_provider_exclusions
WHERE providerId = 12
AND NOW() BETWEEN excludeDateFrom and excludeDateTo;