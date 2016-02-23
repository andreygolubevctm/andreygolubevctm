USE aggregator;

INSERT INTO `email_token` (`transactionId`,`emailId`,`emailTokenType`,`action`,`totalAttempts`,`effectiveStart`,`effectiveEnd`) VALUES (24494430,1865613,'brochures','load',0,'2016-02-19','2016-04-19');
INSERT INTO `email_token` (`transactionId`,`emailId`,`emailTokenType`,`action`,`totalAttempts`,`effectiveStart`,`effectiveEnd`) VALUES (24494430,1865613,'brochures','unsubscribe',0,'2016-02-19','2016-04-19');

INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('app','load',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('app','unsubscribe',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('bestprice','load',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('bestprice','unsubscribe',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('brochures','load',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('brochures','unsubscribe',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('edm','load',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('edm','unsubscribe',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('promotion','load',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('promotion','unsubscribe',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('quote','load',4,60);
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`)
VALUES ('quote','unsubscribe',4,60);

INSERT INTO `email_master` (`emailAddress`,`styleCodeId`,`emailPword`,
`emailPwordHash`,`vertical`,`source`,
`firstName`,`lastName`,`createDate`,`changeDate`,`emailId`,`transactionId`,`hashedEmail`,`oldHashedEmail`,`brand`)
VALUES ('-@no.com',1,'9KqUZUaF/dyoGEF5oFpUTe8MTnAzCgRqPlIjk/70RwE=',
NULL,'','CCCQ',
'sfasf','werwer','2011-11-23','2014-12-22',1000,
NULL,'71f76921931d153e69e0cd36a0bc426dcc49f146','897ae9172d7eec9383bc89e455edf5b46bc46391','');


INSERT INTO `transaction_header` (`TransactionId`,`styleCodeId`,`PreviousId`,
`ProductType`,`EmailAddress`,`IpAddress`,`StartDate`,`StartTime`,
`StyleCode`,`AdvertKey`,`SessionId`,`Status`,`rootId`,`prevRootId`)
VALUES (1000,1,0,'HEALTH',NULL,'/182.50.78.8','2015-12-17','01:40:10','CTM',0,'','',2694168,NULL);

