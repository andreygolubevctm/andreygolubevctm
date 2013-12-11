# Create new table for product information

CREATE TABLE aggregator.results_properties (
	`transactionId` int(11) NOT NULL,
	`productId` varchar(25) NOT NULL,
	`property` varchar(128) NOT NULL,
	`value` varchar(512) NOT NULL,
	PRIMARY KEY  (`TransactionId`,`productId`,`property`)
);



-- rollback
DROP TABLE aggregator.results_properties;