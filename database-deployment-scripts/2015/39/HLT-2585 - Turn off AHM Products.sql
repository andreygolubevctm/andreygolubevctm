SET @providerID = 9;

-- TEST  count=70
 SELECT count(productId) FROM `ctm`.`product_master` pm
 WHERE Status != 'X'
 AND providerID = @providerID
 AND productId > 0
 AND ProductCat = 'HEALTH'
 AND EffectiveStart < now()
 AND EffectiveEnd > now()
 AND LongTitle IN ('Lite Cover',
                    'Lite Cover Plus',
                    'Standard Cover')
LIMIT 9999;


UPDATE `ctm`.`product_master` pm
 SET effectiveEnd = '2015-09-30'
 WHERE providerID = @providerID
 AND Status != 'X'
 AND pm.ProductCat = 'HEALTH'
 AND EffectiveStart < now()
 AND EffectiveEnd > now()
 AND LongTitle IN ('Lite Cover',
                    'Lite Cover Plus',
                    'Standard Cover')


-- TEST  count=0
 SELECT count(productId) FROM `ctm`.`product_master` pm
 WHERE Status != 'X'
 AND providerID = @providerID
 AND productId > 0
 AND ProductCat = 'HEALTH'
 AND '2015-10-01' BETWEEN EffectiveStart AND EffectiveEnd
 AND LongTitle IN ('Lite Cover',
                    'Lite Cover Plus',
                    'Standard Cover')
LIMIT 9999;

