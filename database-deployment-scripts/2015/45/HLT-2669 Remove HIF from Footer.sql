-- Updater
UPDATE ctm.content_control SET contentValue='ahm, Australian Unity, Budget Direct, Bupa, CBHS, CUA, Frank, GMHBA, HCF, nib and QCHF' WHERE contentCode='Footer' AND styleCodeId='1' AND verticalId=4 AND contentKey='footerParticipatingSuppliers';

-- Checker - content value should not contain HIF
SELECT * FROM ctm.content_control WHERE contentCode='Footer' AND styleCodeId='1' AND verticalId=4 AND contentKey='footerParticipatingSuppliers';

-- Rollback
-- UPDATE ctm.content_control SET contentValue='ahm, Australian Unity, Budget Direct, Bupa, CBHS, CUA, Frank, GMHBA, HCF, HIF, nib and QCHF' WHERE contentCode='Footer' AND styleCodeId='1' AND verticalId=4 AND contentKey='footerParticipatingSuppliers';