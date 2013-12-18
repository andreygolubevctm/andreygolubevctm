-- TEST
SELECT * FROM `test`.`features_brands` WHERE `id`='38';

-- DELETE
START TRANSACTION;
DELETE FROM `test`.`features_brands` WHERE `id`='38';
-- ROLLBACK
-- COMMIT