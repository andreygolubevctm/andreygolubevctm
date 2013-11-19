/*
 * Add HIF as a new provider
 */

-- CTM
INSERT INTO ctm.provider_master (ProviderId, `Name`, EffectiveStart, EffectiveEnd) VALUES (11, 'HIF', '2013-07-01', '2040-12-31');
INSERT INTO ctm.provider_properties (ProviderId, PropertyId, SequenceNo, `Text`, EffectiveStart, EffectiveEnd) VALUES (11, 'FundCode', 0, 'HIF', '2013-07-01', '2040-12-31');

-- STAGING
INSERT INTO ctm_staging.provider_master (ProviderId, `Name`, EffectiveStart, EffectiveEnd) VALUES (11, 'HIF', '2013-07-01', '2040-12-31');
INSERT INTO ctm_staging.provider_properties (ProviderId, PropertyId, SequenceNo, `Text`, EffectiveStart, EffectiveEnd) VALUES (11, 'FundCode', 0, 'HIF', '2013-07-01', '2040-12-31');
