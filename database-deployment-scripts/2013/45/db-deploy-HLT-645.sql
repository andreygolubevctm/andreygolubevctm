delimiter $$
CREATE TABLE `aggregator`.`ranking_details_data` (
`TransactionId` int(11) NOT NULL,
`CalcSequence` int(11) NOT NULL,
`RankSequence` int(11) NOT NULL,
`RankPosition` int(11) NOT NULL,
`property` varchar(255) NOT NULL,
`value` varchar(255) NOT NULL,
PRIMARY KEY  (`TransactionId`,`CalcSequence`,`RankSequence`,`RankPosition`,`property`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$

/*
The thoery behind this database locking, is that without a primary key reference the database locks all rows (or a greater set of rows)
By providing a range limitation, and primary key references, the update should lock a 'smaller' set of information
*/
UPDATE `aggregator`.`ranking_details`
SET `Property` = 'productid', `Value` = ProductId
WHERE coalesce(`Property`,`Value`, 'never') = 'never'
AND transactionId > 767050
AND transactionId < 867051
AND CalcSequence > 0
AND RankSequence > 0
AND RankPosition > 0
LIMIT 100000;

-- Step 1 - add additional columns to ranking_details
ALTER TABLE `aggregator`.`ranking_details`
ADD COLUMN `Property` VARCHAR(25) NULL DEFAULT NULL  AFTER `ProductId`,
ADD COLUMN `Value` VARCHAR(2048) NULL DEFAULT NULL  AFTER `Property`;

-- Step 2 - Migrate existing data to new columns
UPDATE `aggregator`.`ranking_details`
SET `Property` = 'productid', `Value` = ProductId
WHERE `Property` IS NULL AND `Value` IS NULL;

-- Step 3 - Update properties of new columns and update primary key to include new Property column
ALTER TABLE `aggregator`.`ranking_details`
CHANGE COLUMN `Property` `Property` VARCHAR(25) NOT NULL DEFAULT '0',
CHANGE COLUMN `Value` `Value` VARCHAR(2048) NULL
, DROP PRIMARY KEY
, ADD PRIMARY KEY (`TransactionId`, `CalcSequence`, `RankSequence`, `RankPosition`, `Property`);

/* CLEAN UP, RUN LATER
-- Step 4 - Remove original ProductId column
ALTER TABLE `aggregator`.`ranking_details`
DROP COLUMN `ProductId`;
*/

