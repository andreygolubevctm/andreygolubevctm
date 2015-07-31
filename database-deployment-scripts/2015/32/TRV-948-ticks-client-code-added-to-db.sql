-- [TEST] SELECT count(servicePropertiesId) AS total FROM ctm.service_properties WHERE providerid=323 AND servicePropertyKey = 'outBoundParams' AND servicePropertyValue = 'SPName=au.com.Compare,clientID=507';
-- BEFORE UPDATE RESULT: 0

UPDATE `ctm`.`service_properties` SET `servicePropertyValue`='SPName=au.com.Compare,clientID=507' WHERE providerid=323 AND servicePropertyKey = 'outBoundParams' AND servicePropertyValue = 'SPName=au.com.Compare';

-- AFTER UPDATE RESULT: 1

-- =============================================================
-- ======================== ROLLBACK ===========================
-- =============================================================

-- [TEST] SELECT count(servicePropertiesId) AS total FROM ctm.service_properties WHERE providerid=323 AND servicePropertyKey = 'outBoundParams' AND servicePropertyValue = 'SPName=au.com.Compare';
-- BEFORE UPDATE RESULT: 0

-- UPDATE `ctm`.`service_properties` SET `servicePropertyValue`='SPName=au.com.Compare' WHERE providerid=323 AND servicePropertyKey = 'outBoundParams' AND servicePropertyValue = 'SPName=au.com.Compare,clientID=507';

-- AFTER UPDATE RESULT: 1