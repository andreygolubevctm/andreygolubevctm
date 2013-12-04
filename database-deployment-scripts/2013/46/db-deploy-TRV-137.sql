/* TEST */
SELECT * FROM `aggregator`.`product_properties`
WHERE 1=1
AND (
(`ProductId`='90' and`PropertyId`='durMin' and`SequenceNo`='13')
OR (`ProductId`='90' and`PropertyId`='durMin' and`SequenceNo`='31')
OR (`ProductId`='90' and`PropertyId`='durMin' and`SequenceNo`='49')
OR (`ProductId`='91' and`PropertyId`='durMin' and`SequenceNo`='13')
OR (`ProductId`='91' and`PropertyId`='durMin' and`SequenceNo`='31')
OR (`ProductId`='91' and`PropertyId`='durMin' and`SequenceNo`='49')
OR (`ProductId`='92' and`PropertyId`='durMin' and`SequenceNo`='13')
OR (`ProductId`='92' and`PropertyId`='durMin' and`SequenceNo`='31')
OR (`ProductId`='92' and`PropertyId`='durMin' and`SequenceNo`='49')
);

/* TRV 137 */
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='90' and`PropertyId`='durMin' and`SequenceNo`='13';
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='90' and`PropertyId`='durMin' and`SequenceNo`='31';
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='90' and`PropertyId`='durMin' and`SequenceNo`='49';
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='91' and`PropertyId`='durMin' and`SequenceNo`='13';
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='91' and`PropertyId`='durMin' and`SequenceNo`='31';
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='91' and`PropertyId`='durMin' and`SequenceNo`='49';
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='92' and`PropertyId`='durMin' and`SequenceNo`='13';
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='92' and`PropertyId`='durMin' and`SequenceNo`='31';
UPDATE `aggregator`.`product_properties` SET `Value`='156', `Text`='156' WHERE `ProductId`='92' and`PropertyId`='durMin' and`SequenceNo`='49';