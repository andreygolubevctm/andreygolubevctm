ALTER TABLE aggregator.fuel_results_regional
	CHANGE COLUMN `state` `state` ENUM('ACT','NSW','NT','QLD','SA','TAS','UNK','VIC','WA') NOT NULL DEFAULT 'UNK' AFTER `UpdateId`;

UPDATE aggregator.fuel_results_regional SET state='TAS' WHERE state='';