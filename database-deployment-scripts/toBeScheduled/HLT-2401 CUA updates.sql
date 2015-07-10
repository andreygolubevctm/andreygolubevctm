/* update products to be not available */
UPDATE `ctm`.`product_master`
SET Status = 'N'
WHERE providerID = 12
AND Status != 'X'
AND NOW() BETWEEN EffectiveStart and EffectiveEnd
AND LongTitle IN (
	'Gold Extras',
	'Private Hospital 100%',
	'Private Hospital 100% + Gold Extras',
	'Private Hospital 100% + Silver Extras',
	'Private Hospital 100% - $250 Excess',
	'Private Hospital 100% - $250 Excess + Gold Extras',
	'Private Hospital 100% - $250 Excess + Silver Extras',
	'Silver Extras'
);

/* Test - should return - 224
SELECT * FROM `ctm`.`product_master` pm 
WHERE providerID = 12
AND Status = 'N'
AND NOW() BETWEEN EffectiveStart and EffectiveEnd
AND LongTitle IN (
	'Gold Extras',
	'Private Hospital 100%',
	'Private Hospital 100% + Gold Extras',
	'Private Hospital 100% + Silver Extras',
	'Private Hospital 100% - $250 Excess',
	'Private Hospital 100% - $250 Excess + Gold Extras',
	'Private Hospital 100% - $250 Excess + Silver Extras',
	'Silver Extras'
);
*/

/* add Private Hospital 75% to exclusion */
INSERT INTO ctm.product_capping_exclusions
SELECT ProductId, '2015-04-01', '2016-03-31' FROM ctm.product_master
WHERE providerID = 12
AND Status != 'X'
AND NOW() BETWEEN EffectiveStart and EffectiveEnd
AND LongTitle = 'Private Hospital 75%';

/* Test - should return - 28
SELECT * FROM ctm.product_capping_exclusions pce
where productId in (
SELECT productId FROM `ctm`.`product_master` pm 
WHERE providerID = 12
AND Status != 'X'
AND NOW() BETWEEN EffectiveStart and EffectiveEnd
)