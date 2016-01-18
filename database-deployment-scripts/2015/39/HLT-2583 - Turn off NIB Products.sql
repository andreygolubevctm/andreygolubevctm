SET @providerID = 3;

-- TEST  count=1120
 SELECT count(productId) FROM `ctm`.`product_master` pm
 WHERE Status != 'X'
 AND providerID = @providerID
 AND productId > 0
 AND ProductCat = 'HEALTH'
 AND EffectiveStart < now()
 AND EffectiveEnd > now()
 AND LongTitle IN ('Mid Hospital ($250 Excess)',
'Mid Hospital ($500 Excess)',
'Mid Hospital (Nil Excess)',
'Mid Hospital with Core and Family Extras',
'Mid Hospital with Core and Wellbeing Extras',
'Mid Hospital with Core and Young at Heart Extras',
'Mid Hospital with Core Extras',
'Mid Hospital with Core Extras Plus',
'Mid Hospital with Core Plus and Family Extras',
'Mid Hospital with Core Plus and Wellbeing Extras',
'Mid Hospital with Core Plus and Young at Heart Extras',
'Mid Hospital with Core Plus, Family and Wellbeing Extras',
'Mid Hospital with Core Plus, Family and Young at Heart Extras',
'Mid Hospital with Core Plus, Wellbeing and Young at Heart Extras',
'Mid Hospital with Core, Family and Wellbeing Extras',
'Mid Hospital with Core, Family and Young at Heart Extras',
'Mid Hospital with Core, Wellbeing and Young at Heart Extras',
'Mid Hospital with Top Extras',
'Mid Hospital with Top Extras ($250 excess)',
'Mid Hospital with Top Extras ($500 excess)',
'Top Hospital No Pregnancy ($250 Excess)',
'Top Hospital No Pregnancy ($500 Excess)',
'Top Hospital No Pregnancy (Nil Excess)',
'Top Hospital No Pregnancy with Core and Family Extras',
'Top Hospital No Pregnancy with Core and Wellbeing Extras',
'Top Hospital No Pregnancy with Core and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Extras',
'Top Hospital No Pregnancy with Core Extras Plus',
'Top Hospital No Pregnancy with Core Plus and Family Extras',
'Top Hospital No Pregnancy with Core Plus and Wellbeing Extras',
'Top Hospital No Pregnancy with Core Plus and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Plus, Family and Wellbeing Extras',
'Top Hospital No Pregnancy with Core Plus, Family and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Plus, Wellbeing and Young at Heart Extras',
'Top Hospital No Pregnancy with Core, Family and Wellbeing Extras',
'Top Hospital No Pregnancy with Core, Family and Young at Heart Extras',
'Top Hospital No Pregnancy with Core, Wellbeing and Young at Heart Extras',
'Top Hospital No Pregnancy with Top Extras',
'Top Hospital No Pregnancy with Top Extras (No excess)',
'Top Hospital No Pregnancy with Top Extras ($250 excess)',
'Top Hospital No Pregnancy with Top Extras ($500 excess)')
LIMIT 9999;


UPDATE `ctm`.`product_master` pm
 SET effectiveEnd = '2015-09-30'
 WHERE providerID = @providerID
 AND Status != 'X'
 AND pm.ProductCat = 'HEALTH'
 AND EffectiveStart < now()
 AND EffectiveEnd > now()
 AND LongTitle IN ('Mid Hospital ($250 Excess)',
'Mid Hospital ($500 Excess)',
'Mid Hospital (Nil Excess)',
'Mid Hospital with Core and Family Extras',
'Mid Hospital with Core and Wellbeing Extras',
'Mid Hospital with Core and Young at Heart Extras',
'Mid Hospital with Core Extras',
'Mid Hospital with Core Extras Plus',
'Mid Hospital with Core Plus and Family Extras',
'Mid Hospital with Core Plus and Wellbeing Extras',
'Mid Hospital with Core Plus and Young at Heart Extras',
'Mid Hospital with Core Plus, Family and Wellbeing Extras',
'Mid Hospital with Core Plus, Family and Young at Heart Extras',
'Mid Hospital with Core Plus, Wellbeing and Young at Heart Extras',
'Mid Hospital with Core, Family and Wellbeing Extras',
'Mid Hospital with Core, Family and Young at Heart Extras',
'Mid Hospital with Core, Wellbeing and Young at Heart Extras',
'Mid Hospital with Top Extras',
'Mid Hospital with Top Extras ($250 excess)',
'Mid Hospital with Top Extras ($500 excess)',
'Top Hospital No Pregnancy ($250 Excess)',
'Top Hospital No Pregnancy ($500 Excess)',
'Top Hospital No Pregnancy (Nil Excess)',
'Top Hospital No Pregnancy with Core and Family Extras',
'Top Hospital No Pregnancy with Core and Wellbeing Extras',
'Top Hospital No Pregnancy with Core and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Extras',
'Top Hospital No Pregnancy with Core Extras Plus',
'Top Hospital No Pregnancy with Core Plus and Family Extras',
'Top Hospital No Pregnancy with Core Plus and Wellbeing Extras',
'Top Hospital No Pregnancy with Core Plus and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Plus, Family and Wellbeing Extras',
'Top Hospital No Pregnancy with Core Plus, Family and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Plus, Wellbeing and Young at Heart Extras',
'Top Hospital No Pregnancy with Core, Family and Wellbeing Extras',
'Top Hospital No Pregnancy with Core, Family and Young at Heart Extras',
'Top Hospital No Pregnancy with Core, Wellbeing and Young at Heart Extras',
'Top Hospital No Pregnancy with Top Extras',
'Top Hospital No Pregnancy with Top Extras (No excess)',
'Top Hospital No Pregnancy with Top Extras ($250 excess)',
'Top Hospital No Pregnancy with Top Extras ($500 excess)');


-- TEST  count=0
 SELECT count(productId) FROM `ctm`.`product_master` pm
 WHERE Status != 'X'
 AND providerID = @providerID
 AND productId > 0
 AND ProductCat = 'HEALTH'
 AND '2015-10-01' BETWEEN EffectiveStart AND EffectiveEnd
 AND LongTitle IN ('Mid Hospital ($250 Excess)',
'Mid Hospital ($500 Excess)',
'Mid Hospital (Nil Excess)',
'Mid Hospital with Core and Family Extras',
'Mid Hospital with Core and Wellbeing Extras',
'Mid Hospital with Core and Young at Heart Extras',
'Mid Hospital with Core Extras',
'Mid Hospital with Core Extras Plus',
'Mid Hospital with Core Plus and Family Extras',
'Mid Hospital with Core Plus and Wellbeing Extras',
'Mid Hospital with Core Plus and Young at Heart Extras',
'Mid Hospital with Core Plus, Family and Wellbeing Extras',
'Mid Hospital with Core Plus, Family and Young at Heart Extras',
'Mid Hospital with Core Plus, Wellbeing and Young at Heart Extras',
'Mid Hospital with Core, Family and Wellbeing Extras',
'Mid Hospital with Core, Family and Young at Heart Extras',
'Mid Hospital with Core, Wellbeing and Young at Heart Extras',
'Mid Hospital with Top Extras',
'Mid Hospital with Top Extras ($250 excess)',
'Mid Hospital with Top Extras ($500 excess)',
'Top Hospital No Pregnancy ($250 Excess)',
'Top Hospital No Pregnancy ($500 Excess)',
'Top Hospital No Pregnancy (Nil Excess)',
'Top Hospital No Pregnancy with Core and Family Extras',
'Top Hospital No Pregnancy with Core and Wellbeing Extras',
'Top Hospital No Pregnancy with Core and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Extras',
'Top Hospital No Pregnancy with Core Extras Plus',
'Top Hospital No Pregnancy with Core Plus and Family Extras',
'Top Hospital No Pregnancy with Core Plus and Wellbeing Extras',
'Top Hospital No Pregnancy with Core Plus and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Plus, Family and Wellbeing Extras',
'Top Hospital No Pregnancy with Core Plus, Family and Young at Heart Extras',
'Top Hospital No Pregnancy with Core Plus, Wellbeing and Young at Heart Extras',
'Top Hospital No Pregnancy with Core, Family and Wellbeing Extras',
'Top Hospital No Pregnancy with Core, Family and Young at Heart Extras',
'Top Hospital No Pregnancy with Core, Wellbeing and Young at Heart Extras',
'Top Hospital No Pregnancy with Top Extras',
'Top Hospital No Pregnancy with Top Extras (No excess)',
'Top Hospital No Pregnancy with Top Extras ($250 excess)',
'Top Hospital No Pregnancy with Top Extras ($500 excess)')
LIMIT 9999;

