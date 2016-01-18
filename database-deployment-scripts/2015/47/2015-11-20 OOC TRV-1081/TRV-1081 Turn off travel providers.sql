-- UPDATE 
SET @cov = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = '1COV');
SET @ski = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'SKII');
SET @und = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = '30UN');
SET @kan = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'KANG');
SET @trk = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'ITRK');
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES (1,2,@cov,'2015-11-20 23:59:59','2040-12-31 23:59:59');
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES (1,2,@ski,'2015-11-20 23:59:59','2040-12-31 23:59:59');
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES (1,2,@und,'2015-11-20 23:59:59','2040-12-31 23:59:59');
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES (1,2,@kan,'2015-11-20 23:59:59','2040-12-31 23:59:59');
INSERT INTO ctm.stylecode_provider_exclusions (styleCodeId,verticalId,providerId,excludeDateFrom,excludeDateTo) VALUES (1,2,@trk,'2015-11-20 23:59:59','2040-12-31 23:59:59');

-- CHECK - Zero before and five after
SET @cov = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = '1COV');
SET @ski = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'SKII');
SET @und = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = '30UN');
SET @kan = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'KANG');
SET @trk = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'ITRK');
SELECT * FROM ctm.stylecode_provider_exclusions WHERE providerId IN (@cov,@ski,@und,@kan,@trk) AND excludeDateFrom='2015-11-20 23:59:59' AND excludeDateTo='2040-12-31 23:59:59';

/* ROLLBACK
SET @cov = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = '1COV');
SET @ski = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'SKII');
SET @und = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = '30UN');
SET @kan = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'KANG');
SET @trk = (SELECT ProviderId FROM ctm.provider_master WHERE providerCode = 'ITRK');
DELETE FROM ctm.stylecode_provider_exclusions WHERE providerId IN (@cov,@ski,@und,@kan,@trk) AND CURRENT_DATE BETWEEN excludeDateFrom AND excludeDateTo; 
*/