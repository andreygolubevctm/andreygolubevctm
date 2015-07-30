ALTER TABLE aggregator.fuel_sites
	CHANGE COLUMN `state` `state` ENUM('ACT','NSW','NT','QLD','SA','TAS','UNK','VIC','WA') NOT NULL DEFAULT 'UNK' AFTER `Name`;
