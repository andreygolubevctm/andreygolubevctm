-- Updater
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) VALUES ('BenchMarketingScriptEnabled','0',0,0,'N');
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) VALUES ('BenchMarketingScriptEnabled','LOCALHOST',0,0,'Y');
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) VALUES ('BenchMarketingScriptEnabled','NXI',0,0,'Y');
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) VALUES ('BenchMarketingScriptEnabled','NXS',0,0,'Y');
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) VALUES ('BenchMarketingScriptEnabled','NXQ',0,0,'Y');
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) VALUES ('BenchMarketingScriptEnabled','PRO',1,0,'Y');
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) VALUES ('BenchMarketingScriptEnabled','PRO',1,14,'N');

-- Checker
SELECT * FROM ctm.configuration WHERE configCode = 'BenchMarketingScriptEnabled';

-- Rollback
-- ETE FROM ctm.configuration WHERE configCode = 'BenchMarketingScriptEnabled';