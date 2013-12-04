-- Test
SELECT * FROM `aggregator`.`product_properties`
WHERE (`ProductId`='117' and`PropertyId`='medical' and`SequenceNo`='0')
OR `ProductId`='118' and`PropertyId`='medical' and`SequenceNo`='0';

-- UPLOAD
UPDATE `aggregator`.`product_properties` SET `Value`='10000000', `Text`='$10,000,000' WHERE `ProductId`='117' and`PropertyId`='medical' and`SequenceNo`='0';
UPDATE `aggregator`.`product_properties` SET `Value`='10000000', `Text`='$10,000,000' WHERE `ProductId`='118' and`PropertyId`='medical' and`SequenceNo`='0';