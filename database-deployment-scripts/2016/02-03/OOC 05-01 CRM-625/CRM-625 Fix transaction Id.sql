ALTER TABLE `leads`.`leads`
CHANGE COLUMN `transactionId` `transactionId` INT(11) UNSIGNED NOT NULL ,
CHANGE COLUMN `rootId` `rootId` INT(11) UNSIGNED NOT NULL ;