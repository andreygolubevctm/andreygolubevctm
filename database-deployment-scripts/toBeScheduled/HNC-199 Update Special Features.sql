/** Update Special Feature **/
UPDATE `aggregator`.`features` SET `description`='Save 30% when you buy Home & Contents online*' WHERE `productId`='BUDD-05-29-HHZ' and`code`='speFea';
UPDATE `aggregator`.`features` SET `description`='Save 15% when you buy Home online*' WHERE `productId`='BUDD-05-29-HHB' and`code`='speFea';
UPDATE `aggregator`.`features` SET `description`='Save 15% when you buy Contents online*' WHERE `productId`='BUDD-05-29-HHC' and`code`='speFea';

/** Checker 
SELECT * FROM aggregator.features WHERE productId LIKE 'BUDD-05-29%' AND code='speFea';
**/
/** El ROLLBACKO 
UPDATE `aggregator`.`features` SET `description`='Home + Contents =35% discount' WHERE `productId`='BUDD-05-29-HHZ' and`code`='speFea';
UPDATE `aggregator`.`features` SET `description`='Home =20% discount' WHERE `productId`='BUDD-05-29-HHB' and`code`='speFea';
UPDATE `aggregator`.`features` SET `description`='Contents =20% discount' WHERE `productId`='BUDD-05-29-HHC' and`code`='speFea';
**/