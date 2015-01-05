/** Update ordering of car features **/
UPDATE `aggregator`.`features_details` SET `sequence`='1' WHERE `vertical` = "car_" AND `resultPath` = "features.product.value";
UPDATE `aggregator`.`features_details` SET `sequence`='4' WHERE `vertical` = "car_" AND `resultPath` = "features.cvrTyp.value";
UPDATE `aggregator`.`features_details` SET `sequence`='3' WHERE `vertical` = "car_" AND `resultPath` = "features.speFea.value";
UPDATE `aggregator`.`features_details` SET `sequence`='2' WHERE `vertical` = "car_" AND `resultPath` = "features.excess.value";

/** ROLLBACK
UPDATE `aggregator`.`features_details` SET `sequence`='3' WHERE `vertical` = "car_" AND `resultPath` = "features.product.value";
UPDATE `aggregator`.`features_details` SET `sequence`='3' WHERE `vertical` = "car_" AND `resultPath` = "features.cvrTyp.value";
UPDATE `aggregator`.`features_details` SET `sequence`='2' WHERE `vertical` = "car_" AND `resultPath` = "features.speFea.value";
UPDATE `aggregator`.`features_details` SET `sequence`='1' WHERE `vertical` = "car_" AND `resultPath` = "features.excess.value";
*/