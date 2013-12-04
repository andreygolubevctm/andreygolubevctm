-- database deploy
CREATE TABLE aggregator.statistic_description (
	TransactionId int(11) NOT NULL,
	CalcSequence int(11) NOT NULL,
	ServiceId varchar(10) NOT NULL,
	ErrorType varchar(128) NOT NULL,
	ErrorMessage varchar(255) NOT NULL,
	ErrorDetail text,
	PRIMARY KEY  (`TransactionId`,`CalcSequence`,`ServiceId`)
)

-- rollback
DROP TABLE aggregator.statistic_description;