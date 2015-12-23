-- UPDATER
UPDATE aggregator.general SET description='Hospital and Extras' WHERE type='healthCvrType' AND code='C';
UPDATE aggregator.general SET description='Hospital Only' WHERE type='healthCvrType' AND code='H';
UPDATE aggregator.general SET description='Extras Only' WHERE type='healthCvrType' AND code='E';

-- CHECKER
SELECT * FROM aggregator.general WHERE type='healthCvrType';

/* ROLLBACK
UPDATE aggregator.general SET description='Combined' WHERE type='healthCvrType' AND code='C';
UPDATE aggregator.general SET description='Hospital' WHERE type='healthCvrType' AND code='H';
UPDATE aggregator.general SET description='Extras' WHERE type='healthCvrType' AND code='E';
*/