-- UPDATER
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_active','0','1','4','Y') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_count','0','1','4','4') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_1_jVal','0','1','4','1') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_1_range','0','1','4','25') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_2_jVal','0','1','4','2') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_2_range','0','1','4','50') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_3_jVal','0','1','4','3') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_3_range','0','1','4','75') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_4_jVal','0','1','4','4') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);
INSERT INTO ctm.configuration (configCode,environmentCode,styleCodeId,verticalId,configValue) 
	VALUES ('splitTest_optins_4_range','0','1','4','100') ON DUPLICATE KEY UPDATE configValue=VALUES(configValue);

-- CHECKER : Zero before and 10 After
SELECT * FROM ctm.configuration WHERE styleCodeId=1 AND verticalId=4 AND configCode LIKE 'splitTest_optins_%';

/* ROLLBACK
DELETE FROM ctm.configuration WHERE styleCodeId=1 AND verticalId=4 AND configCode LIKE 'splitTest_optins_%';
*/