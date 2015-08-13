use ctm;

-- Wipe the mappings
DELETE FROM ctm.category_product_mapping WHERE productId IN(SELECT productId FROM ctm.product_master WHERE productCat='CREDITCARD');

-- Wipe the properties for credit card products that are a credit card property
DELETE FROM ctm.product_properties WHERE productId IN(SELECT productId FROM ctm.product_master WHERE productCat='CREDITCARD')  AND propertyId IN('additional-card-holder', 'annual-fee', 'available-temporary-residents', 'balance-transfer-fee', 'balance-transfer-rate', 'card-class', 'cash-advance-rate', 'complimentary-travel-insurance', 'extended-warranty', 'foreign-exchange-fees', 'handover-url', 'interest-free-days', 'interest-rate', 'intro-annual-fee', 'intro-annual-fee-period', 'intro-balance-transfer-rate', 'intro-balance-transfer-rate-period', 'intro-rate', 'intro-rate-period', 'late-payment-fee', 'maximum-credit-limit', 'meta-page-desc', 'meta-page-title', 'minimum-credit-limit', 'minimum-income', 'minimum-monthly-repayment', 'other-features', 'product-desc', 'product-type', 'rewards-amex-card-points', 'rewards-bonus-points', 'rewards-bonus-points-type', 'rewards-desc', 'rewards-standard-card-class', 'rewards-standard-card-points', 'slug', 'special-offer', 'terms-balance-transfer', 'terms-general', 'terms-interest-rate', 'terms-other-features', 'terms-rewards');

-- Wipe the properties text for credit card products that are a credit card property
DELETE FROM ctm.product_properties_text WHERE productId IN(SELECT productId FROM ctm.product_master WHERE productCat='CREDITCARD') AND propertyId IN('additional-card-holder', 'annual-fee', 'available-temporary-residents', 'balance-transfer-fee', 'balance-transfer-rate', 'card-class', 'cash-advance-rate', 'complimentary-travel-insurance', 'extended-warranty', 'foreign-exchange-fees', 'handover-url', 'interest-free-days', 'interest-rate', 'intro-annual-fee', 'intro-annual-fee-period', 'intro-balance-transfer-rate', 'intro-balance-transfer-rate-period', 'intro-rate', 'intro-rate-period', 'late-payment-fee', 'maximum-credit-limit', 'meta-page-desc', 'meta-page-title', 'minimum-credit-limit', 'minimum-income', 'minimum-monthly-repayment', 'other-features', 'product-desc', 'product-type', 'rewards-amex-card-points', 'rewards-bonus-points', 'rewards-bonus-points-type', 'rewards-desc', 'rewards-standard-card-class', 'rewards-standard-card-points', 'slug', 'special-offer', 'terms-balance-transfer', 'terms-general', 'terms-interest-rate', 'terms-other-features', 'terms-rewards');

DELETE FROM ctm.product_master where productcat='CREDITCARD';



INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-PE',284,'The American Express&reg; Platinum Edge Credit Card','The American Express&reg; Platinum Edge Credit Card','2015-08-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,10000.0,'10000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary domestic return flight each year
-Complimentary domestic and international Travel Insurance
-Receive 10,000 Membership Rewards points when you apply by 30 September 2015 are approved and spend $500 on your Card within the first 2 months of Card Membership. This introductory offer is available to new American Express Card Members only','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,50000.0,'$50000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Membership Reward points',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.99,'0.99%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*The everyday spend Card with up to 3 points per $1 spent!*
Enjoy a complimentary Virgin Australia domestic economy return flight every year, and up to 10,000 bonus Membership Reward points when you apply before 30 September 2015 are approved, and spend $500 in the first two months of Card Membership.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-3 points per dollar spent at major supermarkets
-2 points per dollar spent at major petrol stations
-1 point per dollar spent on all other purchases, except those listed in 0.5 points
- 0.5 points per dollar spent on utilities, insurance (except those issued by American Express), telecommunication providers and government bodies','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,195.0,'$195',NULL,'2015-08-05','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','REWARDS','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,3000.0,'$3000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'american-express-platinum-edge',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*The everyday spend Card with up to 3 points per $1 spent!*
Enjoy a complimentary Virgin Australia domestic economy return flight every year, and up to 10,000 bonus Membership Reward points when you apply before 30 September 2015 are approved, and spend $500 in the first two months of Card Membership.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Platinum',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289320839;116323831;h',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,6.0,'6',NULL,'2015-08-05','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-VE',284,'The American Express Velocity Escape Card','The American Express Velocity Escape Card','2015-08-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,7500.0,'7500',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-American Express will repair or refund the cost of an item bought using your Card if they are damaged or stolen within 90 days. Plus, if you have a change of heart and are refused a refund on an unused, eligible item within 90 days, Refund Protection will reimburse you
-Receive up to 7,500 bonus Velocity Points when you apply by the 30 September 2015, are approved and spend $300 on your Card within the first 3 months. This introductory offer is available to new American Express Card Members only','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,40000.0,'$40000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Velocity Points',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.99,'0.99%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Escape Sooner*
Receive 7,500 bonus Velocity Points when you apply by 30 September 2015, are approved and spend $300 in the first 3 months of Card Membership. Plus, get rewarded with up to 2 Velocity Points per $1 spent.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn up to 2 Velocity Points for every $1 spent on your Card with Virgin Australia and 1 Point for every $1 spent everywhere else.','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,0.0,'$0',NULL,'2015-08-05','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','VELOCITY','BALANCETRANSFER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,2000.0,'$2000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'american-express-velocity-escape',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Escape Sooner*
Receive 7,500 bonus Velocity Points when you apply by 30 September 2015, are approved and spend $300 in the first 3 months of Card Membership. Plus, get rewarded with up to 2 Velocity Points per $1 spent.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Entry',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289320851;116323157;c',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,6.0,'6',NULL,'2015-08-05','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-VP',284,'The American Express Velocity Platinum Card','The American Express Velocity Platinum Card','2015-08-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,100000.0,'100000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary Virgin Australia return domestic flight every year after your first Card spend
-Enjoy two complimentary Single Entry passes to the Virgin Australia lounge each year at selected domestic airports.
-Domestic and International Travel Insurance when you pay for eligible travel on your Card
-Receive up to 100,000 bonus Velocity Points when you apply by the 30 September 2015, are approved and spend $1000 on your Card within the first 3 months. This introductory offer is available to new American Express Card Members only','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,65000.0,'$65000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Velocity Points',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.99,'0.99%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Get the rewards you deserve faster*
Receive up to 100,000 bonus Velocity Points when you apply by 30 September 2015, are approved and spend $1000 within 3 months.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-3 Velocity Points per dollar spent on Virgin Australia and restaurants Australia-wide
-2 Velocity Points per dollar spent on airlines, accommodation and in foreign currency
-1 Velocity Point per dollar spent on everything else, except those listed in 0.5 points
-0.5 Velocity Points per dollar spent on utilities, non American Express provided insurance and government bodies','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,349.0,'$349',NULL,'2015-08-05','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','REWARDS','VELOCITY');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,3000.0,'$3000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'american-express-velocity-platinum',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Get the rewards you deserve faster*
Receive up to 100,000 bonus Velocity Points when you apply by 30 September 2015, are approved and spend $1000 within 3 months.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Platinum',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289320852;116327038;f',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,6.0,'6',NULL,'2015-08-05','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-D',284,'The Qantas American Express Discovery Card','The Qantas American Express Discovery Card','2015-08-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,7500.0,'7500',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Earn up to 7,500 extra Qantas Frequent Flyer Points when you apply by 30 September 2015, are approved and meet the spend criteria. This introductory offer is available to new American Express Card members only.','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,35000.0,'$35000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.99,'0.99%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Broaden your travel*
Receive up to 7,500 bonus Qantas Points when you apply by 30 September 2015, are approved and meet the spend criteria. Plus, get rewarded with up to 2 Qantas Points per $1 spent.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1 Qantas point per $1 spent on Card purchases
-Earn 1 additional Qantas Point per dollar spent on your Card on selected Qantas products and services in Australia','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,0.0,'$0',NULL,'2015-08-05','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('DISCOVERY','FREQUENTFLYER','BALANCETRANSFER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,2000.0,'$2000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'qantas-american-express-discovery',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Broaden your travel*
Receive up to 7,500 bonus Qantas Points when you apply by 30 September 2015, are approved and meet the spend criteria. Plus, get rewarded with up to 2 Qantas Points per $1 spent.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Entry',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289323356;116326014;a',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,6.0,'6',NULL,'2015-08-05','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-U',284,'The Qantas American Express Ultimate Card','The Qantas American Express Ultimate Card','2015-08-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Receive up to *50,000 extra Qantas Points* when you apply by 30 September 2015, are approved and meet the spend criteria:
--*5,000 points* when you make your first  purchase on your new Card
--*42,500 points* after you spend $500 on  purchases on your new Card in the first 3  months of becoming a Card Member
--*2,500 points* after your first Card spend in  Australia on selected Qantas products and  services
--This introductory offer is available to new American Express Card Members only.
-Receive a complimentary Qantas domestic return economy flight every year after your first Card spend on selected Qantas products and services
-Look forward to complimentary domestic and overseas travel insurance','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,65000.0,'$65000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.99,'0.99%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Go more places faster*
Receive up to 50,000 extra Qantas Points when you apply by 30 September 2015, are approved and meet the spend criteria. Plus, earn up to 3 Qantas Points per $1 spent on eligible purchases.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-3 points per dollar spent at tens of thousands of restaurants Australia-wide and on selected Qantas products and services in Australia
-2 points per dollar spent on airlines, accommodation and in foreign currency
-1 point per dollar spent on everything else, except those listed in 0.5 points
-0.5 points per dollar spent on utilities, telecommunications, non American Express provided insurance and government bodies','2015-08-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,450.0,'$450',NULL,'2015-08-05','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','REWARDS','FREQUENTFLYER','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,3000.0,'$3000',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'qantas-american-express-ultimate',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Go more places faster*
Receive up to 50,000 extra Qantas Points when you apply by 30 September 2015, are approved and meet the spend criteria. Plus, earn up to 3 Qantas Points per $1 spent on eligible purchases.',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Platinum',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289319580;116323138;i',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-08-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,6.0,'6',NULL,'2015-08-05','2040-12-31','',0);



INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-P',48,'ANZ Platinum','ANZ Platinum','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'- Complimentary overseas travel and medical insurance
- You could save up to $800 on overseas travel and medical insurance
-Flexible payment options for travel related purchases of $500 AUD or more on your ANZ Platinum credit card account
-Best Price Guarantee Scheme
-90-day Purchase Security Insurance
-Interstate Flight Inconvenience Insurance
-Rental Excess Cover','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,2.0,'2%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,50000.0,'$50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee
$0 Annual Fee for the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,87.0,'$87',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','BALANCETRANSFER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-platinum',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee
$0 Annual Fee for the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low annual fee',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.74,'19.74%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1100l4',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.74,'19.74%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'*Offer for new & approved applications on selected cards. Transfers from non-ANZ cards only.  Apply by 20th August 2015. T&Cs, fees and charges apply.  After the first 16 months any remaining balance transfer will revert to the standard balance transfer annual percentage rate. Subject to credit approval.','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-F',48,'ANZ First','ANZ First','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-90-day purchase security insurance against loss, theft or breakage. 
-ANZ Falcon&trade;- around the clock monitoring for suspicious transactions.
-ANZ''s Fraud Money Back Guarantee
-Worldwide emergency credit card replacement','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,2.0,'2%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,30.0,'$30',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('LOWANNUALFEE','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-first',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low annual fee',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.74,'19.74%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1011l13',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.74,'19.74%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'*Offer for new & approved applications on selected cards. Transfers from non-ANZ cards only.  Apply by 20th August 2015. T&Cs, fees and charges apply.  After the first 16 months any remaining balance transfer will revert to the standard balance transfer annual percentage rate. Subject to credit approval.','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-LR',48,'ANZ Low Rate','ANZ Low Rate','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Global Network- immediate worldwide access to your funds
-MasterCard Global Service&trade; -putting you in touch with a representative- 24 hours a day, 365 days of the year
-MasterCard offers and promotions','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,2.0,'2%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,58.0,'$58',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('LOWINTERESTRATE','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-low-rate',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low interest rate',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,13.49,'13.49% p.a',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1100l5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,13.49,'13.49%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'*Offer for new & approved applications on selected cards. Transfers from non-ANZ cards only.  Apply by 20th August 2015. T&Cs, fees and charges apply.  After the first 16 months any remaining balance transfer will revert to the standard balance transfer annual percentage rate. Subject to credit approval.','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-LRP',48,'ANZ Low Rate Platinum','ANZ Low Rate Platinum','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary overseas travel and medical insurance
- You could save up to $800 on overseas travel and medical insurance (eligibility criteria applies)
-MasterCard Platinum Privileges','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,2.0,'2%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,50000.0,'$50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,99.0,'$99',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('LOWINTERESTRATE','PLATINUM','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-low-rate-platinum',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low interest rate with Platinum benefits',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,13.49,'13.49% p.a',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you
is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1100l3',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,13.49,'13.49%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'*Offer for new & approved applications on selected cards. Transfers from non-ANZ cards only.  Apply by 20th August 2015. T&Cs, fees and charges apply.  After the first 16 months any remaining balance transfer will revert to the standard balance transfer annual percentage rate. Subject to credit approval.','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-R',48,'ANZ Rewards','ANZ Rewards','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.5,'1.5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,20.99,'20.99%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Worldwide emergency credit card replacement for your ANZ Rewards cards.
-As an ANZ Rewards account holder, you have access to a range of optional extra services including
--eDine
--ANZ Car Rental Cover','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,2.0,'2',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Reward Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'50,000 reward points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn 2 Reward Points for every $1 spent on purchases using your ANZ Rewards American Express card 
-Earn 1.5 Reward Points for every $1 spent on purchases using your ANZ Rewards Visa card.
-Choose from a wide range of everyday rewards: Shopping vouchers and gift cards, merchandise and gifts, frequent flyer points, travel and accomodation and entertainment.','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,89.0,'$89',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-rewards',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'50,000 reward points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Reward Credit Card',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,18.79,'18.79%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1101l4',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Apply by 20th August 2015. Offer available on new and approved ANZ Rewards applications, once per eligible customer when $3000 purchases made within first 3 months. T&Cs, fees & charges apply, and are subject to change, available at anz.com/rewardsoffer','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-RP',48,'ANZ Rewards Platinum','ANZ Rewards Platinum','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.5,'1.5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,20.99,'20.99%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Worldwide emergency credit card replacement for your ANZ Rewards Platinum cards.
-Exclusive access to ANZ''s Gift with Purchase program
-Access to Personal Concierge and Visa Platinum privileges with ANZ Rewards Platinum Visa
-Flexibility to add up to 9 additional ANZ Rewards Platinum credit cardholders to your account.
-As an ANZ Rewards Platinum account holder, you have access to a range of optional services including: eDine','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,3.0,'3',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,50000.0,'$50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Reward Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'50,000 reward points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn 3 Reward Points for every $1 spent on purchases using your ANZ Rewards American Express card 
-Earn 1.5 Reward Points for every $1 spent on purchases using your ANZ Rewards Visa card.','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,149.0,'$149',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','REWARDS','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-rewards-platinum',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'50,000 reward points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Reward Credit Card',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,18.79,'18.79%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1011l14',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Apply by 20th August. Offer available on new and approved ANZ Rewards Platinum applications, once per eligible customer when $3000 purchases made within first 3 months. T&Cs, fees & charges apply, and are subject to change, available at anz.com/rewardsoffer','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-RB',48,'ANZ Rewards Black','ANZ Rewards Black','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,2.0,'2',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,20.99,'20.99%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Unlimited access to participating airport lounges outside Australia
-Comprehensive overseas travel and medical insurance
-Visa entertainment- providing you with access to special events, exlusive merchandise packages and home entertainment products
-Enjoy handpicked offers from American Express retail and lifestyle partners, and the convenience of saving offers to your Card.
-Rental Excess Cover for when you rent a car in Australia
-Interstate Flight Inconvenience Insurance protection against the unexpected while on holiday in Australia.
-Worldwide emergency credit card replacement for your ANZ Rewards Black cards.','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,3.0,'3',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,75000.0,'$75000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Reward Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'50,000 reward points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'- Earn 3 Reward Points for every $1 spent on purchases using your ANZ Rewards American Express card 
-Earn 2 Reward Points for every $1 spent on purchases using your ANZ Rewards Visa card.
-ANZ''s highest Reward Point earn rates
-Choice of Rewards-Including Cashback onto an ANZ credit card or transaction account.','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,375.0,'$375',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','BLACK','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,15000.0,'$15000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-rewards-black',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'50,000 reward points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Reward Credit Card',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,18.79,'18.79%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you
is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1100l7',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Apply by 20th August 2015. Offer available on new and approved ANZ Rewards Black applications, once per eligible customer when $3000 purchases made within first 3 months. T&Cs, fees & charges apply, and are subject to change, available at anz.com/rewardsoffer','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-FF',48,'ANZ Frequent Flyer','ANZ Frequent Flyer','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary Qantas Frequent Flyer membership','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'50,000 Qantas Points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20 August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1 Qantas Point per $1 spent on eligible purchases using ANZ Frequent Flyer American Express cards up to $3,000 per statement period
-0.5 Qantas Point per $1 spent on eligible purchases using ANZ Frequent Flyer Visa cards up to $3,000 per statement period','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,95.0,'$95',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','FREQUENTFLYER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-frequent-flyer',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'50,000 Qantas Points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20 August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1101l6',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Apply by 20th August 2015. Offer available on new and approved ANZ Frequent Flyer applications, once per eligible customer when $3000 purchases made within first 3 months. T&Cs, fees & charges apply, and are subject to change, available at anz.com/affoffer','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-FFP',48,'ANZ Frequent Flyer Platinum','ANZ Frequent Flyer Platinum','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Exclusive offers and benefits with entr&eacute; for ANZ Frequent Flyer Platinum American Express cardholders.
-Get a complimentary Qantas Frequent Flyer membership - apply online at the Qantas website and save $89.50.
-Overseas travel and medical insurance, provided by QBE Insurance.
-ANZ Frequent Flyer Platinum Visa card holders are eligible for Visa Platinum privileges.
-ANZ Visa payWave contactless payments
-Worldwide emergency credit card replacement for your ANZ Frequent Flyer Platinum cards.
-Access to optional services
-eDine&reg;','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.5,'1.5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,50000.0,'$50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'50,000 Qantas Points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1.5 Qantas Point per $1 spent on eligible purchases using ANZ Frequent Flyer American Express cards up to $6,000 per statement period
-0.5 Qantas Point per $1 spent on eligible purchases using ANZ Frequent Flyer Visa cards up to $6,000 per statement period','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,295.0,'$295',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','REWARDS','FREQUENTFLYER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-frequent-flyer-platinum',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'50,000 Qantas Points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1101l5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Apply by 20th August 2015. Offer available on new and approved ANZ Frequent Flyer Platinum applications, once per eligible customer when $3000 purchases made within first 3 months. T&Cs, fees & charges apply, and are subject to change, available at anz.com/affoffer','2015-06-28','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-FFB',48,'ANZ Frequent Flyer Black','ANZ Frequent Flyer Black','2015-06-28','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.5,'1.5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Two complimentary Qantas club Lounge invitiations each year for use when flying on Qantas or Jetstart flights
-Qantas Club Membership offer- you could save up to $455 in your first year of membership when you use your ANZ Frequent Flyer Black card to purchase your Qantas Club membership
-Unlimited access to participating airport lounges outstide Australia, through Veloce
-Personal Concierge
-Comprehensive overseas travel and medical insurance
-Worldwide emergency credit card replacement for your ANZ Frequent Flyer Black cards.
-24/7 ANZ Falcon&trade; around the clock monitoring for suspcious transactions.
-ANZ Visa payWave and American Express contactless
-90-day Purchase Security Insurance
-Best Price Guarantee Scheme
-Visa entertainment- providing you with access to special events, exclusive merchandise packages and home entertainment products.
-Enjoy handpicked offers from American Express retail and lifestyle partners','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.5,'1.5',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,75000.0,'$75000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'50,000 Qantas Points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn 1.5 point per $1 spent on purchases using the ANZ American Express card 
-Earn 1.5 point per $2 spent on purchases using the ANZ Visa card','2015-06-28','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,425.0,'$425',NULL,'2015-06-28','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','FREQUENTFLYER','BLACK','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,15000.0,'$15000',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-frequent-flyer-black',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'50,000 Qantas Points when you spend $3,000 on purchases within the first 3 months. No Annual fee in the first year. Offer ends 20th August 2015.',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer Points',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'0',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lIt/creativeref:1100l6',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-06-28','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Apply by 20th August 2015. Offer available on new and approved ANZ Frequent Flyer Black applications, once per eligible customer when $3000 purchases made within first 3 months. T&Cs, fees & charges apply, and are subject to change, available at anz.com/affoffer','2015-06-28','2040-12-31','');



INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','BNKW-FF',315,'Bankwest Qantas MasterCard','Bankwest Qantas MasterCard','2015-07-20','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.99,'21.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,2000.0,'2000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Worldwide Emergency Card Replacement','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,2.99,'2.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Receive 2,000 introductory bonus Qantas Points*
-Earn 1 Qantas Point^ for every $2 you spend on eligible purchases
- If you''re eligible for Platinum, enjoy 0.75 Qantas Points for every $1 you spend on eligible purchase#','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,100.0,'$100.00',NULL,'2015-07-20','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','FREQUENTFLYER','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'bankwest-qantas',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Looking for a credit card where you''ll earn Qantas Points every time you spend? You''ve found it. The Bankwest Qantas MasterCard offers you exactly this, helping you to get to your dream destination sooner.',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'-Rewards Program
--*Qantas Points are earned in accordance with and subject to the Bankwest Qantas Rewards Terms and Conditions. Qantas Points are earned on eligible purchases only. Exclusions, limitations and points caps apply.  Qantas points, including any bonus points, will only be transferred to your Qantas Frequent Flyer Account at the end of the 2 month period from account opening and once you have spent at least $1500 on eligible purchases.
-Frequent Flyer Membership
--^You must be a member of the Qantas Frequent Flyer program to earn and redeem points. Complimentary Qantas Frequent Flyer membership is available from Bankwest if you join at qantas.com/joinffbankwest.
--Membership and the earning and redemption of Qantas Points are subject to the terms and conditions of the Qantas Frequent Flyer program.','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.49,'20.49%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'Greater of 2% of the closing balance or $20 whichever is greater',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,25.0,'$25.00',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=13805359&PluID=0&ord=[timestamp]',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.49,'20.49%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,9.0,'9',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Fees and charges apply, T&Cs apply and available on request.','2015-07-20','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','BNKW-FFG',315,'Bankwest Qantas Gold MasterCard','Bankwest Qantas Gold MasterCard','2015-07-20','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.99,'21.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,4000.0,'4000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Worldwide Emergency Card Replacement
-Complimentary Credit Card Travel Insurance
-Purchase Security Cover
-Purchase Extended Warranty
-Purchase Price Guarantee','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,2.99,'2.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'- Receive 4,000 introductory bonus Qantas Points*
-Earn 1 Qantas Point^ for every $2 you spend on eligible purchases*
-If you''re eligible for Platinum, enjoy 0.75 Qantas Points^ for every $1 you spend on eligible purchases','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,150.0,'$150.00',NULL,'2015-07-20','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','FREQUENTFLYER','GOLD','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,5000.0,'$5000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'bankwest-qantas-gold',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Looking for a credit card where you''ll earn Qantas Points every time you spend? You''ve found it. The Bankwest Qantas MasterCard offers you exactly this, helping you to get to your dream destination sooner.',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'-Rewards Program
--*Qantas Points are earned in accordance with and subject to the Bankwest Qantas Rewards Terms and Conditions. Qantas Points are earned on eligible purchases only. Exclusions, limitations and points caps apply.  Qantas points, including any bonus points, will only be transferred to your Qantas Frequent Flyer Account at the end of the 2 month period from account opening and once you have spent at least $1500 on eligible purchases.
-Frequent Flyer Membership
--^You must be a member of the Qantas Frequent Flyer program to earn and redeem points. Complimentary Qantas Frequent Flyer membership is available from Bankwest if you join at qantas.com/joinffbankwest. Membership and the earning and redemption of Qantas Points are subject to the terms and conditions of the Qantas Frequent Flyer program.','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.49,'20.49%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'Greater of 2% of the closing balance or $20 whichever is greater',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,25.0,'$25.00',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=13805359&PluID=0&ord=[timestamp]',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.49,'20.49%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,9.0,'9',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Fees and charges apply, T&Cs apply and available on request.','2015-07-20','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','BNKW-FFP',315,'Bankwest Qantas Platinum MasterCard','Bankwest Qantas Platinum MasterCard','2015-07-20','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.75,'0.75',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.99,'21.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,8000.0,'8000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-No foreign transaction fees on online and overseas purchases
- International travel insurance for you and your family
-Up to 12 months extra warranty on top of the manufacturer''s warranty
-Purchase security cover. 3 months of free insurance against loss, theft or accidental damage on personal goods purchased anywhere in the world','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,2.99,'2.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn 0.75 Qantas Points^ for every $1 you spend on eligible purchases*
-Receive 8,000 introductory bonus Qantas Points*','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,160.0,'$160.00',NULL,'2015-07-20','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','FREQUENTFLYER','PLATINUM','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'bankwest-rewards-platinum',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Looking for a credit card where you''ll earn Qantas Points every time you spend? You''ve found it. The Bankwest Qantas MasterCard offers you exactly this, helping you to get to your dream destination sooner.',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'-Rewards Program
--*Qantas Points are earned in accordance with and subject to the Bankwest Qantas Rewards Terms and Conditions. Qantas Points are earned on eligible purchases only. Exclusions, limitations and points caps apply.  Qantas points, including any bonus points, will only be transferred to your Qantas Frequent Flyer Account at the end of the 2 month period from account opening and once you have spent at least $1500 on eligible purchases.
-Frequent Flyer Membership
--^You must be a member of the Qantas Frequent Flyer program to earn and redeem points. Complimentary Qantas Frequent Flyer membership is available from Bankwest if you join at qantas.com/joinffbankwest. Membership and the earning and redemption of Qantas Points are subject to the terms and conditions of the Qantas Frequent Flyer program.','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.49,'20.49%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'Greater of 2% of the closing balance or $20 whichever is greater',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,25.0,'$25.00',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=13805359&PluID=0&ord=[timestamp]',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.49,'20.49%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,9.0,'9',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Fees and charges apply, T&Cs apply and available on request.','2015-07-20','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','BNKW-BLR',315,'Bankwest Breeze MasterCard','Bankwest Breeze MasterCard','2015-07-20','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.99,'21.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Up to 3 additional cardholders at no additional cost
-If you''re eligible for Platinum, enjoy extra benefits such as no foreign transaction fees on online and overseas purchases','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,0.0,'0%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,59.0,'$59.00',NULL,'2015-07-20','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('LOWINTERESTRATE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'bankwest-breeze',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,3.0,'3',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Looking for a credit card where you''ll save heaps on interest? You''ve found it.',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low rate',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,12.99,'12.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'Greater of 2% of the closing balance or $20 whichever is greater',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,25.0,'$25.00',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=13805360&PluID=0&ord=[timestamp]',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Lending criteria, fees and charges apply. Terms and conditions apply and are available on request. Rates are subject to change Overseas ATM access fee may apply. One Bankwest Breeze MasterCard per customer.
-Introductory rate on eligible purchases available to new Bankwest Breeze MasterCard customers who apply and are approved for a Bankwest Breeze MasterCard from 6 July 2015 to 30 September 2015. Introductory rate on purchases excludes cash advances and balance transfers and applies from the date the card is opened, regardless of when any purchase is processed by Bankwest. After the introductory period, the standard purchase rate will apply.
-Annual fee is waived for the first year for new Bankwest Breeze MasterCard applications received from 6 July 2015 to 30 September 2015 (annual fee will apply to applications received outside these dates). Annual fee will be payable after the first year and in subsequent years after the anniversary of the card opening.','2015-07-20','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','BNKW-BLRG',315,'Bankwest Breeze Gold MasterCard','Bankwest Breeze Gold MasterCard','2015-07-20','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.99,'21.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary Credit Card Travel Insurance for you and the family^
-Up to 12 months extra warranty on top of the manufacturer''s warranty^
-Purchase security cover. 3 months of free insurance against loss, theft or accidental damage on personal goods purchased anywhere in the world^
-If you''re eligible for Platinum, enjoy extra benefits such as no foreign transaction fees on online and overseas purchases','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,0.0,'0%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,89.0,'$89.00',NULL,'2015-07-20','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('LOWINTERESTRATE','GOLD');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,5000.0,'$5000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'bankwest-breeze-gold',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,3.0,'3',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Looking for a credit card where you''ll save heaps on interest? You''ve found it.',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low rate',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,12.99,'12.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'Greater of 2% of the closing balance or $20 whichever is greater',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,25.0,'$25.00',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=13805360&PluID=0&ord=[timestamp]',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-^Applicable for purchases made on or after 1 October 2014. Limitations and exclusions apply. See Complimentary Credit Card Insurance booklet for details.
-Lending criteria, fees and charges apply. Terms and conditions apply and are available on request. Rates are subject to change Overseas ATM access fee may apply. One Bankwest Breeze MasterCard per customer.
-Introductory rate on eligible purchases available to new Bankwest Breeze MasterCard customers who apply and are approved for a Bankwest Breeze MasterCard from 6 July 2015 to 30 September 2015. Introductory rate on purchases excludes cash advances and balance transfers and applies from the date the card is opened, regardless of when any purchase is processed by Bankwest. After the introductory period, the standard purchase rate will apply.
-Annual fee is waived for the first year for new Bankwest Breeze MasterCard applications received from 6 July 2015 to 30 September 2015 (annual fee will apply to applications received outside these dates). Annual fee will be payable after the first year and in subsequent years after the anniversary of the card opening.','2015-07-20','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','BNKW-BLRP',315,'Bankwest Breeze Platinum MasterCard','Bankwest Breeze Platinum MasterCard','2015-07-20','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.99,'21.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-No foreign transaction fees on online and overseas purchases
-Complimentary Credit Card Travel Insurance for you and the family^
-Up to 12 months extra warranty on top of the manufacturer''s warranty^
-Purchase security cover. 3 months of free insurance against loss, theft or accidental damage on personal goods purchased anywhere in the world^','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,0.0,'0%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-07-20','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,99.0,'$99.00',NULL,'2015-07-20','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('LOWINTERESTRATE','PLATINUM');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'bankwest-breeze-platinum',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,3.0,'3',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Looking for a credit card where you''ll save heaps on interest? You''ve found it.',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low rate',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,12.99,'12.99%',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'Greater of 2% of the closing balance or $20 whichever is greater',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,25.0,'$25.00',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://bs.serving-sys.com/BurstingPipe/adServer.bs?cn=tf&c=20&mc=click&pli=13805360&PluID=0&ord=[timestamp]',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-07-20','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-^Applicable for purchases made on or after 1 October 2014. Limitations and exclusions apply. See Complimentary Credit Card Insurance booklet for details.
-Lending criteria, fees and charges apply. Terms and conditions apply and are available on request. Rates are subject to change Overseas ATM access fee may apply. One Bankwest Breeze MasterCard per customer.
-Introductory rate on eligible purchases available to new Bankwest Breeze MasterCard customers who apply and are approved for a Bankwest Breeze MasterCard from 6 July 2015 to 30 September 2015. Introductory rate on purchases excludes cash advances and balance transfers and applies from the date the card is opened, regardless of when any purchase is processed by Bankwest. After the introductory period, the standard purchase rate will apply.
-Annual fee is waived for the first year for new Bankwest Breeze MasterCard applications received from 6 July 2015 to 30 September 2015 (annual fee will apply to applications received outside these dates). Annual fee will be payable after the first year and in subsequent years after the anniversary of the card opening.','2015-07-20','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','DJON-R',322,'David Jones American Express Card','David Jones American Express Card','2015-06-01','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,30000.0,'30000',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Access a great range of exclusive, complimentary instore benefits at David Jones
-Purchase Protection for peace of mind with insurance of up to 90 days if your eligible item purchased with the Card is stolen or damaged
-Online Fraud Protection to protect you against unauthorised purchases made using your Card
-Emergency Card replacement with David Jones'' global network of offices, they can usually get a replacement Card to you within 48 hours virtually anywhere in the world
-When you visit David Jones, instore or online, you can look forward to being treated as a special customer. Their Card Members are entitled to a range of exclusive benefits:
--Enjoy Complimentary Standard Delivery for items purchased instore or online with the Card
--Enjoy Complimentary Gift Wrapping instore or online at David Jones when you purchase using your Card
--Enjoy up to 4 Years Interest Free with no deposit when you spend $500 or more on homewares, furniture, bedding or electrical items instore at David Jones
--Fashion Pay Later Option - you won''t pay a cent for 3 months when you spend $250 or more on your Card on any women''s or men''s apparel, shoes and fashion accessories instore at David Jones
--Christmas Deferred Payment Option means you won''t have to make any payments until February of the following year on purchases made between 1 November and 24 December instore at David Jones
--Exclusive Fashion Events. Be their guest at Four Days of Fashion, Previews and more
--Instant Rewards exclusive Card Member offers on fashion, accessories, homewares and more','2015-06-01','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,40000.0,'$40000',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Reward Points',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'- Earn up to 3 Reward Points per dollar spent
-Choose either Membership Rewards or Qantas Frequent Flyer as your rewards program, and your Reward Points will be automatically converted at the following rate:
--1 Reward Point = 1 Membership Rewards point
--1 Reward Point = 0.75 Qantas Points
-Membership Rewards
-Choose Membership Rewards and use your points in all these ways:
--Shop with Points. Use your Card to shop online at David Jones and pay for your entire purchase using Membership Rewards points, or a combination of Points + Pay.
--Gift Cards. Redeem your points for Gift Cards from David Jones and a range of other retailers.
--Travel with Points. Redeem for flights with 9 leading airlines including Virgin Australia, Singapore Airlines and Emirates. Excludes Qantas.
--Entertainment. Use your points to purchase concert tickets with Ticketmaster or movie tickets at Hoyts or Greater Union through American Express Membership Rewards
--Credit to your account. You can also turn your Membership Rewards points into a credit on your account.
-Qantas Frequent Flyer
-Choose Qantas Frequent Flyer and use your points in all these ways:
--Fly with Qantas and 30+ partner airlines. Redeem Qantas Points for Award flights with Qantas and over 30+ partner airlines and their affiliates, including oneworld&reg; alliance airlines.
--Classic Awards. These great value seats are an ideal option when you can book in advance, as availability is limited.
--Any Seat Awards. These offer extra flexibility, allowing you to use your Qantas Points for any available seat on any Qantas or Jetstar flight with a QF or JQ flight number.
--Flight Upgrades. Use your Qantas Points to request a Flight Upgrade Award on eligible Qantas domestic and international flights.
--Merchandise and Gift Cards. Shop with Qantas Points for more than 3,000 products, Gift Cards and experiences in the online Qantas Store.
--Points Plus Pay. You can book Qantas flights or shop for most items in the Qantas Store using a combination of Qantas Points and money at qantas.com','2015-06-01','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,99.0,'$99',NULL,'2015-06-01','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,2000.0,'$2000.00',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'david-jones-american-express',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Apply now and receive a generous welcome bonus of 30,000 Reward Points when you spend three times outside of David Jones within the first month of becoming a Card Member',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Rewards',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,30.0,'The greater of $30 or 2.5% of the standard plan closing balance',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289710077;116766478;w',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','DJON-P',322,'David Jones American Express Platinum Card','David Jones American Express Platinum Card','2015-06-01','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,40000.0,'40000',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Enjoy up to 4 Years Interest Free with no deposit when you spend $500 or more on homewares, furniture, bedding or electrical items instore at David Jones.
-Up to 4 Supplementary Cards for no extra fee, $99 p.a. for each Card thereafter
-Enjoy Complimentary Travel Insurance and Buyers Advantage extended warranty
-Purchase Protection for peace of mind with insurance of up to 90 days if your eligible item purchased with the Card is stolen or damaged
-Online Fraud Protection to protect you against unauthorised purchases made using your Card
-Emergency Card replacement - with our global network of offices, we can usually get a replacement Card to you within 48 hours virtually anywhere in the world.
-Exclusive Benefits for Card Members at David Jones
--When you visit David Jones, instore or online, you can look forward to being treated as a special customer. Our Card Members are entitled to a range of exclusive benefits:
--Complimentary Priority Delivery to your door by courier the following day for items purchased instore
--Complimentary Alterations on all women''s and men''s apparel purchased instore, such as shortening or lengthening a hem or trouser length and shortening a sleeve.
--Exclusive Invitations to VIP unique experiences like Season Launch Fashion Parades
--Priority Booking at our Personal Shopping Suites for the ultimate David Jones experience
--Complimentary Gift Wrapping instore or online at David Jones when you purchase using your Card
--Fashion Pay Later Option which means you won''t pay a cent for 3 months when you spend $250 or more on your Card on any women''s or men''s apparel, shoes and fashion accessories instore at David Jones
--Christmas Deferred Payment Option26 delays your payments for purchases made between 1 November and 24 December instore at David Jones, until February of the following year
--Instant Rewards exclusive Card Member offers on fashion, accessories, homewares and more','2015-06-01','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,65000.0,'$65000',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Reward Points',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-With a David Jones American Express Platinum Card, you can earn Reward Points for every dollar you spend on everyday items such as groceries and petrol.
--Earn 4 Reward Points per dollar spent at David Jones
--Earn 3 Reward Points per dollar spent at major supermarkets and petrol stations
--Earn 1 Reward Point per dollar spent everywhere else
-Choose either Membership Rewards or Qantas Frequent Flyer as your rewards program, and your Reward Points will be automatically converted at the following rate:
--1 Reward Point = 1 Membership Rewards point
--1 Reward Point = 0.75 Qantas Points
-Membership Rewards
--Choose Membership Rewards and use your points in all these ways:
--Shop with Points. Use your Card to shop online at David Jones and pay for your entire purchase using Membership Rewards points, or a combination of Points + Pay.
--Gift Cards. Redeem your points for Gift Cards from David Jones and a range of other retailers.
--Travel with Points. Redeem for flights with 9 leading airlines including Virgin Australia, Singapore Airlines and Emirates. Excludes Qantas.
--Entertainment. Use your points to purchase concert tickets with Ticketmaster or movie tickets at Hoyts or Greater Union through American Express Membership Rewards
--Credit your account. You can also turn your Membership Rewards points into a credit on your account.
-Qantas Frequent Flyer
--Choose Qantas Frequent Flyer and use your points in all these ways:
--Fly with Qantas and 30+ partner airlines. Redeem Qantas Points for Award flights with Qantas and over 30+ partner airlines and their affiliates, including oneworld&reg; alliance airlines.
--Classic Awards. These great value seats are an ideal option when you can book in advance, as availability is limited.
--Any Seat Awards. These offer extra flexibility, allowing you to use your Qantas Points for any available seat on any Qantas or Jetstar flight with a QF or JQ flight number.
--Flight Upgrades. Use your Qantas Points to request a Flight Upgrade Award on eligible Qantas domestic and international flights.
--Merchandise and Gift Cards. Shop with Qantas Points for more than 3,000 products, Gift Cards and experiences in the online Qantas Store.
--Points Plus Pay. You can book Qantas flights or shop for most items in the Qantas Store using a combination of Qantas Points and money at qantas.com','2015-06-01','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,295.0,'$295',NULL,'2015-06-01','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','PLATINUM');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,2000.0,'$2000.00',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'david-jones-american-express-platinum',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Apply now and a receive a generous welcome bonus of  40,000 Reward Points when you spend outside of David Jones three times within the first month of becoming a Card Member',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Rewards',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,30.0,'The greater of $30 or 2.5% of the standard plan closing balance',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/290983975;118204851;r',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-06-01','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-LR',320,'NAB Low Rate Card','NAB Low Rate Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Secure online shopping with Verified by Visa','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,0.0,'0%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,4.99,'4.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. on purchases for 12 months.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,59.0,'$59',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('LOWINTERESTRATE','BALANCETRANSFER','INTERESTFREE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,500.0,'500',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-low-rate',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,12.0,'12',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. on purchases for 12 months. You''ll also enjoy the benefits of our lowest ongoing rate on everday purchases.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low Rate',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,13.99,'13.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.50%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1011lba',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,13.99,'13.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,6.0,'6',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-LF',320,'NAB Low Fee Card','NAB Low Fee Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa/MasterCard',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Purchase Protection Insurance
-Contactless purchases with NAB Visa payWave or MasterCardPayPass
-Emergency Travel Assistance
-Secure online shopping with Verified by Visa','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,2500.0,'2500',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,4.99,'4.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'$0 annual fee for first year ($30 p.a. thereafter).',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,30.0,'$30',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('LOWANNUALFEE','BALANCETRANSFER','INTERESTFREE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,500.0,'500',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-low-fee',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'No Annual fee for the first year and with our lowest annual card fee on going, this is a handy card for everyday use.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low Fee',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.74,'19.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'-The complimentary insurances are issued by QBE Insurance (Australia) Limited ABN 78 003 191 035 AFSL 239545 to NAB. Access to the benefit of cover under the NAB card insurances is provided to eligible NAB cardholders by operation of s48 of the Insurance Contracts Act 1984 (Cth). The terms, conditions and exclusions of the Purchase Protection Insurance policy are specified in the NAB Purchase Protection Policy Information booklet.  A qualifying purchase is required to get the benefits of the complimentary insurances.','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.50%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lyR',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.74,'19.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,6.0,'6',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-If you pay your account in full by the due date each month.
-You will not receive interest free days on purchases while you have an outstanding balance transfer.
-Offer is not available in conjunction with any other offer, to NAB credit card customers transferring from another NAB credit card or to NAB staff under Employee''s Choice.
[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)
-MasterCard&reg; and the MasterCard&reg; Brand Mark are registered trademarks of MasterCard&reg; International Incorporated. PayPass is the trademark of MasterCard International Incorporated.','2015-06-22','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-P2',320,'NAB Premium Card','NAB Premium Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa/MasterCard',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Concierge Service
-VIP Lost Card Cover (complimentary for the first 12 months)
-NAB Visa payWave
-Visa Front Line Access lets cardholders reserve tickets to some of the biggest concerts and most exciting sports events
-Emergency travel assistance','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,2.0,'2%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. on balance transfers  for 18 months.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,90.0,'$90',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PREMIUM','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'6000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-premium-v2',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. on balance transfers for 18 months with a 2% balance transfer fee. You''ll also get all the benefits of platinum',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Premium',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.74,'19.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'2.00%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100l3QV',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,18.0,'18',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-QR',320,'NAB Qantas Rewards Card','NAB Qantas Rewards Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express/MasterCard',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,20000.0,'20000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Contactless purchases with MasterCardPayPass&trade;
-Shop online at any US or UK store, and receive discounted shipping to your Australian address with MasterCard and bordelinx
-Emergency travel assistance from MasterCard Global Service, 24/7
-Global Hotel Program
-Car Rental-complimentary upgrades and priority service where available from nab''s card rental partners.
-American Express Invites-giving you access to pre-sales, the best seats in the house and the American Express Invites Lounge at Australian entertainment events.
-Global Dining Program','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. on balance transfers for 15 months and 20,000 bonus Qantas Points.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1 pt: $1 Amex
-0.5 pts: $1 MasterCard','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,95.0,'$95',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','FREQUENTFLYER','BALANCETRANSFER','INTERESTFREE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,500.0,'500',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-qantas-rewards',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. on balance transfers for 15 months and 20,000 bonus Qantas Points when you make an everyday purchase.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Rewards',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/qantas-rewards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.50%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lyS',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,15.0,'15',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-QRP',320,'NAB Qantas Rewards Premium Card','NAB Qantas Rewards Premium Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express/Visa',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,40000.0,'40000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Contactless purchases with MasterCardPayPass&trade;
-Shop online at any US or UK store, and receive discounted shipping to your Australian address with MasterCard and bordelinx
-Emergency travel assistance from MasterCard Global Service, 24/7
-Global Hotel Program
-Car Rental-complimentary upgrades and priority service where available from nab''s card rental partners.
-American Express Invites-giving you access to pre-sales, the best seats in the house and the American Express Invites Lounge at Australian entertainment events.
-Global Dining Program','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.5,'1.5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. on balance transfers for 15 months and 40,000 bonus Qantas Points.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1.5 pt = $1 Amex
-0.5 pts = $1 Visa','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,250.0,'$250',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PREMIUM','FREQUENTFLYER','BALANCETRANSFER','INTERESTFREE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'6000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-qantas-rewards-premium',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. on balance transfers for 15 months and 40,000 bonus Qantas Points when you make an everyday purchase.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Rewards Premium',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'[NAB Qantas Credit Card Account: Rewards Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/qantas-rewards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.50%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lyT',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,15.0,'15',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-VR',320,'NAB Velocity Rewards Card','NAB Velocity Rewards Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express/Visa',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,10000.0,'10000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Seven Complimentary Insurances','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Velocity Points',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. on balance transfers  for 15 months and 10,000 bonus Velocity Points.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1 pt = $1 Amex
-0.5 pts = $1 Visa','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,95.0,'$95',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','VELOCITY','BALANCETRANSFER','INTERESTFREE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,500.0,'500',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-velocity-rewards',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. on balance transfers for 15 months and 10,000 bonus Velocity Points when you make an everyday purchase.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Velocity Rewards',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'[Velocity NAB Credit Card Account](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/velocity-rewards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.50%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1101lz8',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,15.0,'15',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-VRP',320,'NAB Velocity Rewards Premium Card','NAB Velocity Rewards Premium Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express/Visa',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,20000.0,'20000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Seven Complimentary Insurances
-Access to the NAB 24/7 Service Centre
-Visa Front Line Access lets cardholders reserve tickets to some of the biggest concerts and most exciting sport events- before pre-sales and before they go on sale to the general public
-Contactless purchases with Visa payWave
-Special offers on shows, events, experiences and movies from Visa Entertainment
-Emergency travel assistance from Visa Global Customer Assistance Services
-Secure online shopping with Verified by Visa
-Enjoy first-class travel with American Express including:
--Luxury Hotel Program
--Car Rental- up to 15% discount off the best available rates
--American Express Invites- gives you access to pre-sales, the best seats inn the house and the American Express Invites Lounge at Australian entertainment events
--Global Event Program
--Global Dining Program','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.5,'1.5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Velocity Points',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. on balance transfers for 15 months and 20,000 bonus Velocity Points.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1.5 pt = $1 Amex
-0.5 pts = $1 Visa','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,150.0,'$150',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','VELOCITY','BALANCETRANSFER','INTERESTFREE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'6000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-velocity-rewards-premium',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. on balance transfers for 15 months and 20,000 bonus Velocity Points when you make an everyday purchase.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Velocity Rewards',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.50%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1011lAb',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,15.0,'15',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-FR',320,'NAB flybuys Rewards Card','NAB flybuys Rewards Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.0,'1',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,10000.0,'10000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Concierge Service
-VIP Lost Card Cover, complimentary for the first 12 months','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Flybuys Points',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. on balance transfers for 15 months and 10,000 Flybuys BONUS POINTS.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1 pt = $1 Visa','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,95.0,'$95',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','FLYBUYS','BALANCETRANSFER','INTERESTFREE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'6000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-flybuys-rewards',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. on balance transfers for 15 months and 10,000 Flybuys BONUS POINTS when you make an everyday purchase.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Flybuys Rewards',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.50%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lyQ',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.99,'19.99%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,15.0,'15',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','NABA-P',320,'NAB Premium Card','NAB Premium Card','2015-06-22','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa/MasterCard',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Concierge Service
-VIP Lost Card Cover (complimentary for the first 12 months)
-NAB Visa payWave
-Visa Front Line Access lets cardholders reserve tickets to some of the biggest concerts and most exciting sports events
-Emergency travel assistance','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. on balance transfers  for 15 months.',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,90.0,'$90',NULL,'2015-06-22','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PREMIUM','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'6000',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'nab-premium-v1',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. on balance transfers for 15 months. You''ll also get all the benefits of platinum',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Premium',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.74,'19.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','2015-06-22','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'2.00%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,5.0,'5',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1011lfm',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,21.74,'21.74%',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,15.0,'15',NULL,'2015-06-22','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'[NAB Credit Card Terms and Conditions](http://www.nab.com.au/content/dam/nab/personal/credit-cards/credit-card-terms-conditions-and-other-information/documents/nab-credit-cards-tcs.pdf)','2015-06-22','2040-12-31','');
