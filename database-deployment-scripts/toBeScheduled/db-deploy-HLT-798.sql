/*
 * Add THF as a new provider
 */

-- CTM
INSERT INTO ctm.provider_master (ProviderId, `Name`, EffectiveStart, EffectiveEnd) VALUES (13, 'Teachers Health Fund', '2013-07-01', '2040-12-31');
INSERT INTO ctm.provider_properties (ProviderId, PropertyId, SequenceNo, `Text`, EffectiveStart, EffectiveEnd) VALUES (13, 'FundCode', 0, 'THF', '2013-07-01', '2040-12-31');

-- STAGING
INSERT INTO ctm_staging.provider_master (ProviderId, `Name`, EffectiveStart, EffectiveEnd) VALUES (13, 'Teachers Health Fund', '2013-07-01', '2040-12-31');
INSERT INTO ctm_staging.provider_properties (ProviderId, PropertyId, SequenceNo, `Text`, EffectiveStart, EffectiveEnd) VALUES (13, 'FundCode', 0, 'THF', '2013-07-01', '2040-12-31');

UPDATE ctm.dialogue
SET text = 'Today we&#39;ll be comparing some products from NIB, AHM, HCF, GMF, GMHBA, Frank, Australian Unity, Westfund, CUA, HIF, Teachers Health Fund and CBHS. If you decide to purchase through us, we will arrange the sale on behalf of the fund and we&#39;ll receive a commission from them so we don&#39;t charge you a fee for our service.'
			WHERE dialogueID = 11;

INSERT INTO test.help (id, header, des)
VALUES (521,'Valid Relationships', '<p>If you are related to someone who is eligible to join Teachers Health Fund then you are also eligible to join</p><br /><p>Related to includes the following relationships</p><ul><li>Spouse/Partner</li><li>Former spouse/Partner</li><li>Dependent children</li><li>Adult children (or their partner or dependent child)</li><li>Siblings (or their partner or dependent child)</li><li>Parents</li><li>Grandchildren</li></ul>' );

INSERT INTO test.help (id, header, des)
VALUES (523,'Relevant education unions', '<p>Relevant education unions include the following </p><ul><li>AEU ACT Branch</li><li>AEU SA Branch</li><li>AEU NT Branch</li><li>AEU TAS Branch</li><li>AEU VIC Branch</li><li>ASU</li><li>FSU</li><li>IEU SA</li><li>IEU WA</li><li>IEUA</li><li>ISEA NSW</li><li>ISSOA</li><li>NSW TF</li><li>NSW/ACT IEU</li><li>NTEU</li><li>PSA</li><li>QTU</li><li>SSTUWA</li><li>TAS IEU</li><li>TISTA</li><li>VIEU</li></ul>' );


-- ROLLBACK

UPDATE ctm.dialogue
SET text = 'Today we&#39;ll be comparing some products from NIB, AHM, HCF, GMF, GMHBA, Frank, Australian Unity, Westfund, CUA, HIF and CBHS. If you decide to purchase through us, we will arrange the sale on behalf of the fund and we&#39;ll receive a commission from them so we don&#39;t charge you a fee for our service.'
			WHERE dialogueID = 11;

DELETE FROM test.help
WHERE id =  521


