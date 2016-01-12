ALTER TABLE `leads`.`leads`
CHANGE COLUMN `action` `action` ENUM('AddedToSalesForce','UpdatedSalesForce','SalesForceError','InvalidInput','InvalidInputFatal','NotProcessed') NOT NULL ;