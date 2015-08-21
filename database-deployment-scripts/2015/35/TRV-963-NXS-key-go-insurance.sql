-- [TEST] SET @pID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='GOIN');
-- SELECT * FROM ctm.provider_properties WHERE ProviderId = @pID AND PropertyId='providerKey';
-- RESULT BEFORE INSERT: 0

SET @pID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='GOIN');
INSERT INTO `ctm`.`provider_properties` (`ProviderId`, `PropertyId`, `Text`, `EffectiveStart`, `EffectiveEnd`) VALUES (@pID, 'providerKey', 'goin_89Esd3qzDa', '2000-12-12', '2040-12-12');

-- RESULT AFTER INSERT: 1

-- =====================================================
-- ======================= ROLLBACK ====================
-- =====================================================

-- [TEST] SET @pID = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode='GOIN');
-- SELECT * FROM ctm.provider_properties WHERE ProviderId = @pID AND PropertyId='providerKey';
-- RESULT BEFORE INSERT: 1

DELETE FROM `ctm`.`provider_properties` WHERE `PropertyId` = 'goin_89Esd3qzDa' AND `Text` = 'goin_89Esd3qzDa';

-- RESULT AFTER INSERT: 0