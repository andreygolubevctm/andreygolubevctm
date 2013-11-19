--
-- Add CUA as a new provider
--

-- STAGING
INSERT INTO ctm.provider_master (ProviderId, `Name`, EffectiveStart, EffectiveEnd) VALUES (12, 'CUA', CURDATE(), '2040-12-31');
INSERT INTO ctm.provider_properties (ProviderId, PropertyId, SequenceNo, `Text`, EffectiveStart, EffectiveEnd) VALUES (12, 'FundCode', 0, 'CUA', CURDATE(), '2040-12-31');

-- PRODUCTION
INSERT INTO ctm_staging.provider_master (ProviderId, `Name`, EffectiveStart, EffectiveEnd) VALUES (12, 'CUA', CURDATE(), '2040-12-31');
INSERT INTO ctm_staging.provider_properties (ProviderId, PropertyId, SequenceNo, `Text`, EffectiveStart, EffectiveEnd) VALUES (12, 'FundCode', 0, 'CUA', CURDATE(), '2040-12-31');
UPDATE ctm.dialogue
SET text = 'Today we&#39;ll be comparing some products from NIB, AHM, HCF, GMF, GMHBA, Frank, Australian Unity, Westfund, CUA and CBHS. If you decide to purchase through us, we will arrange the sale on behalf of the fund and we&#39;ll receive a commission from them so we don&#39;t charge you a fee for our service.'
			WHERE dialogueID = 11;

-- rollback
DELETE FROM ctm_staging.provider_master WHERE ProviderId = 12;
DELETE FROM ctm_staging.provider_properties WHERE ProviderId = 12 AND PropertyId = 'FundCode';

UPDATE ctm.dialogue
SET text = 'Today we&#39;ll be comparing some products from NIB, AHM, HCF, GMF, GMHBA, Frank, Australian Unity, Westfund and CBHS. If you decide to purchase through us, we will arrange the sale on behalf of the fund and we&#39;ll receive a commission from them so we don&#39;t charge you a fee for our service.'
			WHERE dialogueID = 11
