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
INSERT INTO `email_token_type` (`emailTokenType`,`action`,`maxAttempts`,`expiryDays`) VALUES ('quote','unsubscribe',4,60);

