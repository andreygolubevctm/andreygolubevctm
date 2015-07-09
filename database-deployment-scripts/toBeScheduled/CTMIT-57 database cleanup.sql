-- Test

SELECT *  FROM aggregator.email_properties
WHERE emailAddress NOT LIKE '%@%._%';


-- Update

DELETE FROM aggregator.email_properties
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and propertyId >= ''
and brand >= ''
and vertical >= ''
AND emailId < 250000;

DELETE FROM aggregator.email_master
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and vertical >= ''
AND emailId < 250000;

SELECT *  FROM aggregator.email_properties
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and propertyId >= ''
and brand >= ''
and vertical >= ''
AND emailId >= 250000
AND emailId < 350000;

SELECT * FROM aggregator.email_master
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and vertical >= ''
AND emailId >= 250000
AND emailId < 350000;

SELECT *  FROM aggregator.email_properties
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and propertyId >= ''
and brand >= ''
and vertical >= ''
AND emailId >= 350000
AND emailId < 450000;

SELECT * FROM aggregator.email_master
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and vertical >= ''
AND emailId >= 350000
AND emailId < 450000;


DELETE FROM aggregator.email_properties
WHERE emailId IN (
  SELECT emailId FROM aggregator.email_master
  WHERE emailAddress NOT LIKE '%@%._%'
  and emailAddress >= ''
  and vertical >= ''
  AND emailId >= 450000
  AND emailId < 900000
);

DELETE FROM aggregator.email_master
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and vertical >= ''
AND emailId >= 450000
AND emailId < 900000;


DELETE FROM aggregator.email_properties
WHERE emailId IN  (
  SELECT emailId FROM aggregator.email_master
  WHERE emailAddress NOT LIKE '%@%._%'
  and emailAddress >= ''
  and vertical >= ''
  AND emailId >= 900000
  AND emailId < 1350000
);

DELETE FROM aggregator.email_master
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and vertical >= ''
AND emailId >= 900000
AND emailId < 1350000;


DELETE FROM aggregator.email_properties
WHERE emailId IN(
  SELECT emailId FROM aggregator.email_master
  WHERE emailAddress NOT LIKE '%@%._%'
  and emailAddress >= ''
  and vertical >= ''
  AND emailId >= 1800000
);

DELETE FROM aggregator.email_master
WHERE emailAddress NOT LIKE '%@%._%'
and emailAddress >= ''
and vertical >= ''
AND emailId >= 1800000;
