use ctm;

-- Wipe the mappings
DELETE FROM ctm.category_product_mapping
WHERE productId IN (
  SELECT productId
  FROM ctm.product_master
  WHERE productCat = 'CREDITCARD'
  AND productCode LIKE '%AMEX%'
);

-- Wipe the properties for credit card products that are a credit card property
DELETE FROM ctm.product_properties
WHERE productId IN (
  SELECT productId
  FROM ctm.product_master
  WHERE productCat = 'CREDITCARD'
  AND productCode LIKE '%AMEX%'
) AND propertyId IN ('additional-card-holder', 'annual-fee', 'available-temporary-residents', 'balance-transfer-fee', 'balance-transfer-rate', 'card-class', 'cash-advance-rate', 'complimentary-travel-insurance', 'extended-warranty', 'foreign-exchange-fees', 'handover-url', 'interest-free-days', 'interest-rate', 'intro-annual-fee', 'intro-annual-fee-period', 'intro-balance-transfer-rate', 'intro-balance-transfer-rate-period', 'intro-rate', 'intro-rate-period', 'late-payment-fee', 'maximum-credit-limit', 'meta-page-desc', 'meta-page-title', 'minimum-credit-limit', 'minimum-income', 'minimum-monthly-repayment', 'other-features', 'product-desc', 'product-type', 'rewards-amex-card-points', 'rewards-bonus-points', 'rewards-bonus-points-type', 'rewards-desc', 'rewards-standard-card-class', 'rewards-standard-card-points', 'slug', 'special-offer', 'terms-balance-transfer', 'terms-general', 'terms-interest-rate', 'terms-other-features', 'terms-rewards');

-- Wipe the properties text for credit card products that are a credit card property
DELETE FROM ctm.product_properties_text
WHERE productId IN (
  SELECT productId
  FROM ctm.product_master
  WHERE productCat = 'CREDITCARD'
  AND productCode LIKE '%AMEX%'
) AND propertyId IN ('additional-card-holder', 'annual-fee', 'available-temporary-residents', 'balance-transfer-fee', 'balance-transfer-rate', 'card-class', 'cash-advance-rate', 'complimentary-travel-insurance', 'extended-warranty', 'foreign-exchange-fees', 'handover-url', 'interest-free-days', 'interest-rate', 'intro-annual-fee', 'intro-annual-fee-period', 'intro-balance-transfer-rate', 'intro-balance-transfer-rate-period', 'intro-rate', 'intro-rate-period', 'late-payment-fee', 'maximum-credit-limit', 'meta-page-desc', 'meta-page-title', 'minimum-credit-limit', 'minimum-income', 'minimum-monthly-repayment', 'other-features', 'product-desc', 'product-type', 'rewards-amex-card-points', 'rewards-bonus-points', 'rewards-bonus-points-type', 'rewards-desc', 'rewards-standard-card-class', 'rewards-standard-card-points', 'slug', 'special-offer', 'terms-balance-transfer', 'terms-general', 'terms-interest-rate', 'terms-other-features', 'terms-rewards');

DELETE FROM ctm.product_master
WHERE productcat = 'CREDITCARD'
AND productCode LIKE '%AMEX%';

-- INSERTS


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-PE',284,'The American Express&reg; Platinum Edge Credit Card','The American Express&reg; Platinum Edge Credit Card','2015-12-23','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'The maximum balance transfer that you can be approved for is $10,000 or 70% of your approved credit limit, whichever is less','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,10000.0,'10000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary domestic return flight each year
-Complimentary domestic and international Travel Insurance
-Receive 10,000 Membership Rewards points when you apply by 2nd February 2016 are approved and spend $550 on your Card within the first 2 months of Card Membership. This introductory offer is available to new American Express Card Members only','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,1.0,'1% balance transfer fee',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,50000.0,'$50000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Membership Reward points',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0.0%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*The everyday spend Card with up to 3 points per $1 spent!*
Enjoy a complimentary Virgin Australia domestic economy return flight every year, and up to 10,000 bonus Membership Reward points when you apply before 2nd February 2016 are approved, and spend $550 in the first two months of Card Membership.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-3 points per dollar spent at major supermarkets
-2 points per dollar spent at major petrol stations
-1 point per dollar spent on all other purchases, except those listed in 0.5 points
- 0.5 points per dollar spent on utilities, insurance (except those issued by American Express), telecommunication providers and government bodies','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,195.0,'$195',NULL,'2015-12-23','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','REWARDS','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,3000.0,'$3000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'american-express-platinum-edge',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*The everyday spend Card with up to 3 points per $1 spent!*
Enjoy a complimentary Virgin Australia domestic economy return flight every year, and up to 10,000 bonus Membership Reward points when you apply before 2nd February 2016 are approved, and spend $550 in the first two months of Card Membership.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Platinum',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289320839;116323831;h',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,12.0,'12',NULL,'2015-12-23','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-VE',284,'The American Express Velocity Escape Card','The American Express Velocity Escape Card','2015-12-23','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'The maximum balance transfer that you can be approved for is $10,000 or 70% of your approved credit limit, whichever is less','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,7500.0,'7500',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-American Express will repair or refund the cost of an item bought using your Card if they are damaged or stolen within 90 days. Plus, if you have a change of heart and are refused a refund on an unused, eligible item within 90 days, Refund Protection will reimburse you
-Receive up to 7,500 bonus Velocity Points when you apply by the 2nd February, 2016, are approved and spend $300 on your Card within the first 3 months. This introductory offer is available to new American Express Card Members only','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,1.0,'1% balance transfer fee',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,40000.0,'$40000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Velocity Points',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0.0%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Escape Sooner*
Receive 7,500 bonus Velocity Points when you apply by 2nd February 2016, are approved and spend $300 in the first 3 months of Card Membership. Plus, get rewarded with up to 2 Velocity Points per $1 spent.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn up to 2 Velocity Points for every $1 spent on your Card with Virgin Australia and 1 Point for every $1 spent everywhere else.','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,0.0,'$0',NULL,'2015-12-23','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','VELOCITY','BALANCETRANSFER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,2000.0,'$2000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'american-express-velocity-escape',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Escape Sooner*
Receive 7,500 bonus Velocity Points when you apply by 2nd February 2016, are approved and spend $300 in the first 3 months of Card Membership. Plus, get rewarded with up to 2 Velocity Points per $1 spent.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Entry',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289320851;116323157;c',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,12.0,'12',NULL,'2015-12-23','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-VP',284,'The American Express Velocity Platinum Card','The American Express Velocity Platinum Card','2015-12-23','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'The maximum balance transfer that you can be approved for is $10,000 or 70% of your approved credit limit, whichever is less','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary Virgin Australia return domestic flight every year after your first Card spend
-Enjoy two complimentary Single Entry passes to the Virgin Australia lounge each year at selected domestic airports.
-Domestic and International Travel Insurance when you pay for eligible travel on your Card
-Receive up to 50,000 bonus Velocity Points when you apply by the 2nd February 2016, are approved and spend $1000 on your Card within the first 3 months. This introductory offer is available to new American Express Card Members only','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,1.0,'1% balance transfer fee',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,65000.0,'$65000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Velocity Points',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0.0%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Get the rewards you deserve faster*
-Receive 50,000 bonus Velocity Points when you apply by 9th November 2015, are approved and spend $500 on your new Card within the first 3 months1. Card Members who currently hold or who have previously held any other Card product offered by American Express Australia Limited in the preceding 12 month period are ineligible for this offer.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-3 Velocity Points per dollar spent on Virgin Australia and restaurants Australia-wide
-2 Velocity Points per dollar spent on airlines, accommodation and in foreign currency
-1 Velocity Point per dollar spent on everything else, except those listed in 0.5 points
-0.5 Velocity Points per dollar spent on utilities, non American Express provided insurance and government bodies','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,349.0,'$349',NULL,'2015-12-23','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','REWARDS','VELOCITY');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,3000.0,'$3000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'american-express-velocity-platinum',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Get the rewards you deserve faster*
-Receive 50,000 bonus Velocity Points when you apply by 9th November 2015, are approved and spend $500 on your new Card within the first 3 months1. Card Members who currently hold or who have previously held any other Card product offered by American Express Australia Limited in the preceding 12 month period are ineligible for this offer.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Platinum',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289320852;116327038;f',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,12.0,'12',NULL,'2015-12-23','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-D',284,'The Qantas American Express Discovery Card','The Qantas American Express Discovery Card','2015-12-23','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'The maximum balance transfer that you can be approved for is $10,000 or 70% of your approved credit limit, whichever is less','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,7500.0,'7500',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Earn up to 7,500 extra Qantas Frequent Flyer Points when you apply by 2nd February 2016, are approved and meet the spend criteria. This introductory offer is available to new American Express Card members only.','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,1.0,'1% balance transfer fee',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,35000.0,'$35000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0.0%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Broaden your travel*
Receive up to 7,500 bonus Qantas Points when you apply by 2nd February 2016, are approved and meet the spend criteria. Plus, get rewarded with up to 2 Qantas Points per $1 spent.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1 Qantas point per $1 spent on Card purchases
-Earn 1 additional Qantas Point per dollar spent on your Card on selected Qantas products and services in Australia','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,0.0,'$0',NULL,'2015-12-23','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('DISCOVERY','FREQUENTFLYER','BALANCETRANSFER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,2000.0,'$2000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'qantas-american-express-discovery',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Broaden your travel*
Receive up to 7,500 bonus Qantas Points when you apply by 2nd February 2016, are approved and meet the spend criteria. Plus, get rewarded with up to 2 Qantas Points per $1 spent.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Entry',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289323356;116326014;a',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,12.0,'12',NULL,'2015-12-23','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-U',284,'The Qantas American Express Ultimate Card','The Qantas American Express Ultimate Card','2015-12-23','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'The maximum balance transfer that you can be approved for is $10,000 or 70% of your approved credit limit, whichever is less','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Receive up to *50,000 extra Qantas Points* when you apply by 2nd February 2016, are approved and meet the spend criteria:
--*5,000 points* when you make your first  purchase on your new Card
--*42,500 points* after you spend $500 on  purchases on your new Card in the first 3  months of becoming a Card Member
--*2,500 points* after your first Card spend in  Australia on selected Qantas products and  services
--This introductory offer is available to new American Express Card Members only.
-Receive a complimentary Qantas domestic return economy flight every year after your first Card spend on selected Qantas products and services
-Look forward to complimentary domestic and overseas travel insurance','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,1.0,'1% balance transfer fee',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,65000.0,'$65000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0.0%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Go more places faster*
Receive up to 50,000 extra Qantas Points when you apply by 2nd February, 2016, are approved and meet the spend criteria. Plus, earn up to 3 Qantas Points per $1 spent on eligible purchases.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-3 points per dollar spent at tens of thousands of restaurants Australia-wide and on selected Qantas products and services in Australia
-2 points per dollar spent on airlines, accommodation and in foreign currency
-1 point per dollar spent on everything else, except those listed in 0.5 points
-0.5 points per dollar spent on utilities, telecommunications, non American Express provided insurance and government bodies','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,450.0,'$450',NULL,'2015-12-23','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('PLATINUM','REWARDS','FREQUENTFLYER','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,3000.0,'$3000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'qantas-american-express-ultimate',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Go more places faster*
Receive up to 50,000 extra Qantas Points when you apply by 2nd February, 2016, are approved and meet the spend criteria. Plus, earn up to 3 Qantas Points per $1 spent on eligible purchases.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Platinum',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://ad.doubleclick.net/ddm/clk/289319580;116323138;i',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,12.0,'12',NULL,'2015-12-23','2040-12-31','',0);


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','AMEX-E',284,'The American Express Essential Credit Card','The American Express Essential Credit Card','2015-12-23','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
DELETE FROM ctm.product_properties WHERE productid = @product_id;
DELETE FROM ctm.product_properties_text WHERE productid = @product_id;
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'-1. Offer available to new Card Members only. Excludes Card Members who have held any other Card issued by American Express in the preceding twelve (12) month period. The $50 credit will be applied to the eligible account 8-10 weeks after the offer criteria are met. This advertised offer is not valid in conjunction with any other advertised or promotional offer.','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'American Express',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'-American Express credit approval criteria applies. Subject to Terms and Conditions. Fees and charges apply. All Interest Rates are quoted as an Annual Percentage Rate. All information is correct as at 2 November 2015 and is subject to change. This offer is only available to Australian residents. Cards are offered, issued and administered by American Express Australia Limited (ABN 92 108 952 085, Australian Credit Licence No. 291313)(American Express).
-6. Interest rate is correct as at 2 November 2015 and is subject to change. This interest rate does not apply for Cash Advances and associated fees.','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Receive a $50 credit when you apply online by 2 February 2016, are approved and spend $500 on your  new Card within the first 2 months of Card Membership
- $0 annual fee
-Smartphone Screen Insurance for up to $500 for screen repairs to your Smartphone when you pay for your phone or contract with your Essential Credit Card
-World-class service
-When you pay for purchases using your American Express Essential Credit Card you can enjoy cover with the following protection;
--Purchase Protection - if an item is stolen or breaks within 90 days of purchase, it can be repaired or refunded up to$2,500 per claim, up to $10,000 per year and with a $50 excess per claim
--Buyer\'s Advantage - extends the manufacturer\'s warranty by up to 12 months for up to $7,000 per claim and $7,000 per year, with no excess
--Refund Protection - if you have a change of heart and are refused a refund on an unused item within 90 days of purchase, you will be reimbursed for up to $500 per claim and $2,000 per year, with no excess
--Online Fraud Protection - guarantees you against unauthorised charges. If you see something unusual on your statement, let us know immediately and you won\'t be held responsible
--Emergency Card replacement - if your card is lost or stolen, rest assured because we can usually have it replaced within 48 hours, virtually anywhere in the world11','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,40000.0,'$40000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Membership Reward points',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0.0%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'*Rewarding Free Thinkers*
Receive a $50 credit when you apply by 2nd February 2016 and spend $500 within the first 2 months. No annual fee and 0% balance transfer rate for the first 12 months. Earn up to 1 membership point for every $1 spent, transferable to a choice of 8 airline reward partner programs. Earn rewards faster by getting a Supplementary card at no additional costs.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'- Earn up to 1 Membership Rewards point for every $1 spent2
-Transfer your points to a choice of 8 airline rewards partner programs3
-Reward Yourself
With the Essential Credit Card you\'ll receive complimentary enrolment into the Membership Rewards Gateway program2
-- Earn 1 Membership Rewards point per dollar spent on all purchases except utilities, insurance, telecommunications providers and government bodies in Australia where you will earn 0.5 points per dollar spent
--Transfer your points to a choice of 8 airline rewards partner programs3, or redeem online for a gift card from one of our top retail partners
--Use your points to pay charges on your statement with Select + Pay with points, saving your hard-earned cash
-- Spend more and earn more points by getting a Supplementary Card for family members at no additional cost','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,0.0,'$0',NULL,'2015-12-23','2040-12-31','',0);
DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('REWARDS','BALANCETRANSFER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,2000.0,'$2000',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'american-express-essential',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'*Rewarding Free Thinkers*
Receive a $50 credit when you apply by 2nd February 2016 and spend $500 within the first 2 months. No annual fee and 0% balance transfer rate for the first 12 months. Earn up to 1 membership point for every $1 spent, transferable to a choice of 8 airline reward partner programs. Earn rewards faster by getting a Supplementary card at no additional costs.',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Gold',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'-2. Subject to the Terms and Conditions of the Membership Rewards Gateway program available at membershiprewards.com.au. Certain transactions will earn 0.5 points per dollar with merchants classified as; \'utilities\' including gas, water, electricity and telecommunications providers; \'government\', including the Australian Taxation Office, the Australian Postal Corporation (Australia Post), federal/state and local government bodies; and \'insurance\' excluding insurances offered by American Express.
-3. Subject to the Terms and Conditions of the Membership Rewards Gateway program available at membershiprewards.com.au. You must be a member of the partner program, joining fees may apply and points transferred will be subject to the terms and conditions of the applicable program.
-8. Subject to the Terms and Conditions of the Membership Rewards Gateway program available at membershiprewards.com.au/termsandconditions. Minimum of 1,000 points required. Any credit to your Card Account cannot exceed the current outstanding balance on your Account. Points will be debited immediately and credit will take up to three business days to appear on your online statement.','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,14.99,'14.99%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'-4. Insurance cover is underwritten by ACE Insurance Limited (ABN 23 001 642 020, AFSL No. 239687) (ACE) and is subject to the terms, conditions and exclusions contained in the American Express Essential Credit Card Insurances policy between American Express and ACE available [here](http://www.acegroup.com/au-en/) and (https://web.aexp-static.com/au/content/pdf/essentialinsurance.pdf). For Smartphone Screen Insurance, maximum of 2 claims per 12 month period, maximum cover of $500 per claim and an excess of 10% of the claimed amount applies.
-5. Excludes Card Members who have held any Card issued by American Express Australia Limited in the preceding 60 day period. Available to new applicants who apply online by 2 February 2016 and are approved. The maximum balance transfer that can be approved is $10,000 or 70% of your approved credit limit, whichever is less. Balances may not be transferred from another Credit Card issued by American Express. The promotional interest rate will apply for twelve months from approval, after which any remaining balance will revert to the standard rate of interest at that time. There are no interest free days for balance transfers. Click here  for full Balance Transfer terms and conditions.
-7. Gift card or voucher rewards are not redeemable or exchangeable for cash or credit and are valid for a period of 3 months from the date of issue, unless otherwise stated. Subject to the retailer\'s standard gift card / voucher conditions.
-9. Supplementary Card Members must be over 18 years of age. You will be liable to pay for all Supplementary Card spending on your account.','2015-12-23','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.5,'2.5% or $30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,30.0,'$30',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/297665154;124772469;w',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.74,'20.74%',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,12.0,'12',NULL,'2015-12-23','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-10. Provided that you notify us immediately upon discovery of any fraudulent transactions and you have complied with your Card Member Agreement, you will not be held liable for any unauthorised charges.
-11. If your Card is lost or stolen, you must report it immediately. You can call American Express 24 hours a day. In Australia, call us on 1300 363 687. If you are overseas, report your lost or stolen Card to the nearest American Express Travel Service or Representative Office. Once you have notified us, you will not be liable for any unauthorised charges.','2015-12-23','2040-12-31','');