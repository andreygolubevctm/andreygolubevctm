--------------------------------------------------------------------------------------------------------
-- Fuel tables
--------------------------------------------------------------------------------------------------------
DROP INDEX `postcode_UNIQUE` ON `aggregator`.`fuel_postcodes`;

-- fuel_results
ALTER ONLINE TABLE `aggregator`.`fuel_results` CHANGE UpdateId UpdateId UNSIGNED SMALLINT NOT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_results` CHANGE SiteId SiteId UNSIGNED MEDIUMINT NOT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_results` CHANGE FuelId FuelId UNSIGNED TINYINT NOT NULL; -- Values from 2-9
ALTER ONLINE TABLE `aggregator`.`fuel_results` CHANGE Price Price UNSIGNED SMALLINT NOT NULL;
-- ALTER ONLINE TABLE `aggregator`.`fuel_results` CHANGE RecordedTime RecordedTime DATETIME DEFAULT '0000-00-00'; ????????

-- fuel_results_regional
ALTER ONLINE TABLE `aggregator`.`fuel_results_regional` CHANGE UpdateId UpdateId UNSIGNED SMALLINT NOT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_results_regional` CHANGE FuelId FuelId UNSIGNED TINYINT NOT NULL; -- Values from 2-9
ALTER ONLINE TABLE `aggregator`.`fuel_results_regional` CHANGE AvgPrice AvgPrice UNSIGNED SMALLINT NOT NULL;
-- ALTER ONLINE TABLE `aggregator`.`fuel_results` CHANGE RecordedTime RecordedTime DATETIME DEFAULT '0000-00-00'; ????????

-- fuel_updates
ALTER ONLINE TABLE `aggregator`.`fuel_updates` CHANGE UpdateId UpdateId UNSIGNED SMALLINT NOT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_updates` CHANGE `Status` `Status` UNSIGNED SMALLINT DEFAULT NULL;
-- Below indexes reduced query execution from 79 secs to 8 secs. And they are going to be used in 4 SQLs.
ALTER ONLINE TABLE `aggregator`.`fuel_updates` ADD INDEX `status_idx` (`status`);
ALTER ONLINE TABLE `aggregator`.`fuel_updates` ADD INDEX `type_idx` (`type`);

-- fuel_sites
ALTER ONLINE TABLE `aggregator`.`fuel_sites` CHANGE SiteId SiteId UNSIGNED MEDIUMINT NOT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_sites` CHANGE `state` `state` ENUM('ACT','QLD','NSW','NT','SA','VIC','WA','UNK') NOT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_sites` ADD INDEX `postcode_idx` (`PostCode`);
ALTER ONLINE TABLE `aggregator`.`fuel_sites` CHANGE PostCode PostCode SMALLINT NOT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_sites` CHANGE Lat Lat FLOAT DEFAULT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_sites` CHANGE Lon Lon FLOAT DEFAULT NULL;
ALTER ONLINE TABLE `aggregator`.`fuel_sites` CHANGE Name Name VARCHAR(255) NOT NULL;



