-- TEST
SELECT * FROM `test`.`features`
WHERE `productId` IN('WOOL-01-02','WOOL-01-01')
AND code = 'speFea';

-- UPDATE
START TRANSACTION;
UPDATE `test`.`features` SET `description`='Get a $100 fuel gift card<sup>#</sup>' WHERE `productId`='WOOL-01-02' and`code`='speFea';
UPDATE `test`.`features` SET `description`='Get a $100 fuel gift card<sup>#</sup>' WHERE `productId`='WOOL-01-01' and`code`='speFea';

-- ROLLBACK
-- COMMIT