-- Ya happy Luke/Smerdo?
SET @BUDGET_LOW_KMS = (SELECT carProductId FROM ctm.car_product WHERE code = 'BUDD-05-15');

-- TEST: 0 BEFORE and 1 AFTER
-- SELECT count(*) AS total FROM `ctm`.`car_product_content` WHERE `disclaimer`='The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.' AND `carProductId`= @BUDGET_LOW_KMS;


UPDATE `ctm`.`car_product_content` SET `disclaimer`='The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.' WHERE `carProductId`= @BUDGET_LOW_KMS LIMIT 1;

-- ROLLBACK
-- UPDATE `ctm`.`car_product_content` SET `disclaimer`='The indicative quote includes any applicable online discount and is subject to meeting the insurer's underwriting criteria and may change due to factors such as:<br>- Driver's history or offences or claims<br>- Age or licence type of additional drivers<br>- Vehicle condition, accessories and modifications<br>' WHERE `carProductId`= @BUDGET_LOW_KMS;