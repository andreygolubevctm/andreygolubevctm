/** Updater **/
UPDATE ctm.content_control SET contentValue='Budget Direct, Ozicare, 1st for Women, Real Insurance and AI Insurance' WHERE verticalId=3 AND styleCodeId=8 AND contentKey='footerParticipatingSuppliers';

/** Checker - returns one result to confirm contentValue field **/
SELECT * FROM ctm.content_control WHERE verticalId=3 AND styleCodeId=8 AND contentKey='footerParticipatingSuppliers';

/** Rollback **/
-- UPDATE ctm.content_control SET contentValue='Budget Direct,  Ozicare, 1st for Women and Real Insurance' WHERE verticalId=3 AND styleCodeId=8 AND contentKey='footerParticipatingSuppliers';
