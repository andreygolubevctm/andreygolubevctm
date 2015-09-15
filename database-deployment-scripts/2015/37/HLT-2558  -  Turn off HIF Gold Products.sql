SET @EffectiveStart = '2015-04-01';
SET @EffectiveEnd = '2016-03-31';
SET @providerID = 11;

-- TEST  count=28
 SELECT count(productId) FROM `ctm`.`product_master` pm
 WHERE Status != 'X' 
 AND providerID = @providerID
 AND productId > 0
 AND ProductCat = 'HEALTH'
 AND EffectiveStart = @EffectiveStart
 AND EffectiveEnd = @EffectiveEnd
 AND pm.LongTitle IN (
	'Gold Vital $500 Excess',
	'Gold Vital $500 Excess and Saver Options',
	'Gold Vital $500 Excess and Special Options',
	'Gold Vital $500 Excess and Super Options'
);

/* Disable current products product master update count = 70*/
UPDATE `ctm`.`product_master` pm
 SET STATUS = 'X'
 WHERE now() between pm.EffectiveStart AND pm.EffectiveEnd
 AND providerID = @providerID
 AND Status != 'X'
 AND pm.ProductCat = 'HEALTH'
 AND pm.LongTitle IN (
	'Gold Vital $500 Excess',
	'Gold Vital $500 Excess and Saver Options',
	'Gold Vital $500 Excess and Special Options',
	'Gold Vital $500 Excess and Super Options'
);

-- TEST  count=0
 SELECT count(productId) FROM `ctm`.`product_master` pm
 WHERE Status != 'X'
 AND providerID = @providerID
 AND productId > 0
 AND ProductCat = 'HEALTH'
 AND EffectiveStart = @EffectiveStart
 AND EffectiveEnd = @EffectiveEnd
 AND pm.LongTitle IN (
	'Gold Vital $500 Excess',
	'Gold Vital $500 Excess and Saver Options',
	'Gold Vital $500 Excess and Special Options',
	'Gold Vital $500 Excess and Super Options'
);