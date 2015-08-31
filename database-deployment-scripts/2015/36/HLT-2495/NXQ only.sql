SET @providerID = 2;
/* This SQL has been written just to fix crapped data created due to previous failed deployment of ratesheet*/
/* 560 records  to be updates */
UPDATE `ctm`.`product_master` pm
SET STATUS = 'X'
WHERE
 pm.Status != 'X'
AND pm.providerID =  @providerID
AND  pm.EffectiveStart = '2015-04-01' and pm.EffectiveEnd='2016-03-31'
AND pm.ProductCat = 'HEALTH'
	AND pm.LongTitle in (
						'Accident Only Hospital Cover and Gold Extras',
						'Accident Only Hospital Cover and Platinum Extras',
						'Basic Hospital $250 Excess and Gold Extras',
						'Basic Hospital $250 Excess and Platinum Extras',
						'Basic Hospital $500 Excess and Gold Extras',
						'Basic Hospital $500 Excess and Platinum Extras',
						'Gold Extras',
						'Mid Hospital $250 Excess and Gold Extras',
						'Mid Hospital $250 Excess and Platinum Extras',
						'Mid Hospital $500 Excess and Gold Extras',
						'Mid Hospital $500 Excess and Platinum Extras',
						'Mid Plus Hospital $250 Excess and Gold Extras',
						'Mid Plus Hospital $500 Excess and Gold Extras',
						'Platinum Extras',
						'Premium Hospital $250 Excess and Gold Extras',
						'Premium Hospital $250 Excess and Platinum Extras',
						'Premium Hospital $500 Excess and Gold Extras',
						'Premium Hospital $500 Excess and Platinum Extras',
						'Premium Hospital Nil Excess and Gold Extras',
						'Premium Hospital Nil Excess and Platinum Extras',
						'Accident Only Hospital Cover and Silver Plus Extras'
					 )
limit 99999999;


