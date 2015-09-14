-- UPDATER
SET @FOW = (SELECT providerId FROM ctm.provider_master WHERE providerCode='1FOW');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@FOW,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @BUDD = (SELECT providerId FROM ctm.provider_master WHERE providerCode='BUDD');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@BUDD,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @CBCK = (SELECT providerId FROM ctm.provider_master WHERE providerCode='CBCK');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@CBCK,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @AGCH = (SELECT providerId FROM ctm.provider_master WHERE providerCode='AGCH');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@AGCH,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @EXDD = (SELECT providerId FROM ctm.provider_master WHERE providerCode='EXDD');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@EXDD,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @EXPO = (SELECT providerId FROM ctm.provider_master WHERE providerCode='EXPO');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@EXPO,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @IECO = (SELECT providerId FROM ctm.provider_master WHERE providerCode='IECO');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@IECO,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @OZIC = (SELECT providerId FROM ctm.provider_master WHERE providerCode='OZIC');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@OZIC,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @RETI = (SELECT providerId FROM ctm.provider_master WHERE providerCode='RETI');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@RETI,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @VIRG = (SELECT providerId FROM ctm.provider_master WHERE providerCode='VIRG');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@VIRG,'authToken','46gh4h6gyew45y','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @REAL = (SELECT providerId FROM ctm.provider_master WHERE providerCode='REAL');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@REAL,'authToken','nu6984th7aseq7','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @WOOL = (SELECT providerId FROM ctm.provider_master WHERE providerCode='WOOL');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@WOOL,'authToken','nu6984th7aseq7','2015-08-25 00:00:00','2040-12-31 23:59:59','');
SET @AI   = (SELECT providerId FROM ctm.provider_master WHERE providerCode='AI');
INSERT INTO ctm.provider_properties (SequenceNo,ProviderId,PropertyId,Text,EffectiveStart,effectiveEnd,Status) VALUES ('0',@AI,'authToken','b90nn9u8u9rdij','2015-08-25 00:00:00','2040-12-31 23:59:59','');

-- CHECKER
SET @FOW = (SELECT providerId FROM ctm.provider_master WHERE providerCode='1FOW');
SET @BUDD = (SELECT providerId FROM ctm.provider_master WHERE providerCode='BUDD');
SET @CBCK = (SELECT providerId FROM ctm.provider_master WHERE providerCode='CBCK');
SET @AGCH = (SELECT providerId FROM ctm.provider_master WHERE providerCode='AGCH');
SET @EXDD = (SELECT providerId FROM ctm.provider_master WHERE providerCode='EXDD');
SET @EXPO = (SELECT providerId FROM ctm.provider_master WHERE providerCode='EXPO');
SET @IECO = (SELECT providerId FROM ctm.provider_master WHERE providerCode='IECO');
SET @OZIC = (SELECT providerId FROM ctm.provider_master WHERE providerCode='OZIC');
SET @RETI = (SELECT providerId FROM ctm.provider_master WHERE providerCode='RETI');
SET @VIRG = (SELECT providerId FROM ctm.provider_master WHERE providerCode='VIRG');
SET @REAL = (SELECT providerId FROM ctm.provider_master WHERE providerCode='REAL');
SET @WOOL = (SELECT providerId FROM ctm.provider_master WHERE providerCode='WOOL');
SET @AI   = (SELECT providerId FROM ctm.provider_master WHERE providerCode='AI');
SELECT * FROM ctm.provider_properties WHERE ProviderId IN (@FOW,@BUDD,@CBCK,@AGCH,@EXDD,@EXPO,@IECO,@OZIC,@RETI,@VIRG,@REAL,@WOOL,@AI) AND PropertyId='authToken';

-- ROLLBACK
/*SET @FOW = (SELECT providerId FROM ctm.provider_master WHERE providerCode='1FOW');
SET @BUDD = (SELECT providerId FROM ctm.provider_master WHERE providerCode='BUDD');
SET @CBCK = (SELECT providerId FROM ctm.provider_master WHERE providerCode='CBCK');
SET @AGCH = (SELECT providerId FROM ctm.provider_master WHERE providerCode='AGCH');
SET @EXDD = (SELECT providerId FROM ctm.provider_master WHERE providerCode='EXDD');
SET @EXPO = (SELECT providerId FROM ctm.provider_master WHERE providerCode='EXPO');
SET @IECO = (SELECT providerId FROM ctm.provider_master WHERE providerCode='IECO');
SET @OZIC = (SELECT providerId FROM ctm.provider_master WHERE providerCode='OZIC');
SET @RETI = (SELECT providerId FROM ctm.provider_master WHERE providerCode='RETI');
SET @VIRG = (SELECT providerId FROM ctm.provider_master WHERE providerCode='VIRG');
SET @REAL = (SELECT providerId FROM ctm.provider_master WHERE providerCode='REAL');
SET @WOOL = (SELECT providerId FROM ctm.provider_master WHERE providerCode='WOOL');
SET @AI   = (SELECT providerId FROM ctm.provider_master WHERE providerCode='AI');
DELETE FROM ctm.provider_properties WHERE ProviderId IN (@FOW,@BUDD,@CBCK,@AGCH,@EXDD,@EXPO,@IECO,@OZIC,@RETI,@VIRG,@REAL,@WOOL,@AI) AND PropertyId='authToken';
*/