SET @pId = (SELECT carProductId FROM ctm.car_product WHERE code='BUDD-05-15');
SET @oldDisc = 'The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.';
SET @newDisc = 'The indicative quote includes any applicable online discount and is subject to meeting the insurer\'s underwriting criteria and may change due to factors such as:<br>- Driver\'s history or offences or claims<br>- Age or licence type of additional drivers<br>- Vehicle condition, accessories and modifications<br>';

-- UPDATER
UPDATE ctm.car_product_content SET disclaimer=@newDisc WHERE carProductId=@pId LIMIT 1;

-- CHECKER
-- Before = The indicative quote is subject to meeting the insurer's underwriting criteria. Please see below for further details.
-- After = The indicative quote includes any applicable online discount and is subject to meeting the insurer's underwriting criteria and may change due to factors such as:<br>- Driver's history or offences or claims<br>- Age or licence type of additional drivers<br>- Vehicle condition, accessories and modifications<br>
SELECT disclaimer FROM ctm.car_product_content WHERE carProductId=@pId;

/* ROLLBACK
UPDATE ctm.car_product_content SET disclaimer=@oldDisc WHERE carProductId=@pId LIMIT 1;
*/