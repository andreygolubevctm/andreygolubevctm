-- UPDATER
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) VALUE ('journeyOverride','0',0,4,'Y');

-- CHECKER
SELECT * FROM ctm.configuration WHERE configCode='journeyOverride';

/* ROLLBACK 
DELETE FROM ctm.configuration WHERE configCode='journeyOverride';
*/