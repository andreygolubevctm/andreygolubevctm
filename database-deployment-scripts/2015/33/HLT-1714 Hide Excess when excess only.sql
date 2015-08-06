-- Test = Should be 1 row
SELECT * FROM aggregator.features_details where type = 'section' and name = 'Excess';
6

-- Perform update to class
UPDATE `aggregator`.`features_details` SET `className`='excessSection selection_Hospital' WHERE type = 'section' and name = 'Excess';

-- Test = Should be 1 row with 2 classes
SELECT className FROM aggregator.features_details where type = 'section' and name = 'Excess';

-- ROLLBACK
-- UPDATE `aggregator`.`features_details` SET `className`='excessSection' WHERE type = 'section' and name = 'Excess';