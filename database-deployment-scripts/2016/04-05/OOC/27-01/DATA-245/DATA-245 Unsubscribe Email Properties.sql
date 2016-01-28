-- CHECKER: 4 records
SELECT * FROM aggregator.email_properties WHERE emailAddress='rossdavidson@bigpond.com' AND propertyId IN ('marketing','okToCall') AND value='Y';

-- UPDATE
UPDATE aggregator.email_properties SET value='N' WHERE emailAddress='rossdavidson@bigpond.com' AND propertyId IN ('marketing','okToCall') AND value='Y';

-- CHECKER: 0 records
SELECT * FROM aggregator.email_properties WHERE emailAddress='rossdavidson@bigpond.com' AND propertyId IN ('marketing','okToCall') AND value='Y';

/** ROLLBACK
UPDATE aggregator.email_properties SET value='Y' WHERE emailAddress='rossdavidson@bigpond.com' AND propertyId IN ('marketing','okToCall') AND value='N';
-- CHECKER: 4 records
SELECT * FROM aggregator.email_properties WHERE emailAddress='rossdavidson@bigpond.com' AND propertyId IN ('marketing','okToCall') AND value='Y';
*/