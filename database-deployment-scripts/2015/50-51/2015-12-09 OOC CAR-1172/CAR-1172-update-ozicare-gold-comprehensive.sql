-- Ya happy Luke/Smerdo?
SET @OZICAR_GOLD = (SELECT carProductId FROM ctm.car_product WHERE code = 'OZIC-05-04');

UPDATE `ctm`.`car_product_content` SET `disclaimer`='The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.' WHERE `carProductId`= @OZICAR_GOLD LIMIT 1;
-- TEST: 0 BEFORE and 1 AFTER
-- SELECT count(*) AS total FROM `ctm`.`car_product_content` WHERE `disclaimer`='The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.' AND `carProductId`= @OZICAR_GOLD;

UPDATE `ctm`.`car_product_content` SET `disclaimer`='The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.' WHERE `carProductId`= @OZICAR_GOLD LIMIT 1;
-- TEST: 0 BEFORE and 1 AFTER
-- SELECT count(*) AS total FROM `ctm`.`car_product_content` WHERE `disclaimer`='The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.' AND `carProductId`= @OZICAR_GOLD;

/* ROLLBACK
UPDATE `ctm`.`car_product_content` SET `disclaimer`='The indicative quote includes any applicable online discount and is subject to meeting the insurer's underwriting criteria and may change due to factors such as:<br>- Driver's history or offences or claims<br>- Age or licence type of additional drivers<br>- Vehicle condition, accessories and modifications<br>' WHERE `carProductId`= @OZICAR_GOLD;
DELETE FROM ctm.car_product_features WHERE code = 'disclaimer' AND carProductContentId = (SELECT cpc.carProductContentId FROM ctm.car_product cp JOIN ctm.car_product_content cpc ON cp.carProductId = cpc.carProductId WHERE cp.providerId = (SELECT providerId FROM ctm.provider_master where providerCode = 'OZIC') AND cp.code = 'OZIC-05-04')
*/