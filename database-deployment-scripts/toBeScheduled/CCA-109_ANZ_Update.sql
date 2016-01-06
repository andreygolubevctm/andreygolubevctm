DELETE FROM ctm.category_product_mapping WHERE productid IN (SELECT productid FROM ctm.product_master WHERE productCat='CREDITCARD' AND providerid=48);
DELETE FROM ctm.product_properties_text WHERE productid IN (SELECT productid FROM ctm.product_master WHERE productCat='CREDITCARD' AND providerid=48);
DELETE FROM ctm.product_properties WHERE productid IN (SELECT productid FROM ctm.product_master WHERE productCat='CREDITCARD' AND providerid=48);
DELETE FROM ctm.product_master WHERE productCat='CREDITCARD' AND providerid=48;


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-P',48,'ANZ Platinum','ANZ Platinum','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'- Complimentary overseas travel and medical insurance
- You could save up to $800 on overseas travel and medical insurance
-Flexible payment options for travel related purchases of $500 AUD or more on your ANZ Platinum credit card account
-Best Price Guarantee Scheme
-90-day Purchase Security Insurance
-Interstate Flight Inconvenience Insurance
-Rental Excess Cover','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,3.0,'3%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,35000.0,'$35000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee
$0 Annual Fee for the first year.',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,87.0,'$87',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('PLATINUM','BALANCETRANSFER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-platinum',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. first 16 months on balance transfers, plus 2% Balance Transfer fee
$0 Annual Fee for the first year.',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low annual fee',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.74,'19.74%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/261182836;116033926;d',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.74,'19.74%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,18.0,'18',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'3% Balance Transfer Fee, eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-F',48,'ANZ First','ANZ First','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-90-day purchase security insurance against loss, theft or breakage. 
-ANZ Falcon&trade;- around the clock monitoring for suspicious transactions.
-ANZ''s Fraud Money Back Guarantee
-Worldwide emergency credit card replacement','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,3.0,'3%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. first 18 months on balance transfers, plus 3% Balance Transfer fee.',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,30.0,'$30',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('LOWANNUALFEE','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-first',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. first 18 months on balance transfers, plus 3% Balance Transfer fee.',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low annual fee',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.74,'19.74%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/261182835;116033653;z',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.74,'19.74%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,18.0,'18',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'3% Balance Transfer Fee, eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-LR',48,'ANZ Low Rate','ANZ Low Rate','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Global Network- immediate worldwide access to your funds
-MasterCard Global Service&trade; -putting you in touch with a representative- 24 hours a day, 365 days of the year
-MasterCard offers and promotions','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,3.0,'3%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. first 18 months on balance transfers, plus 3% Balance Transfer fee.',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,58.0,'$58',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('LOWINTERESTRATE','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-low-rate',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. first 18 months on balance transfers, plus 3% Balance Transfer fee.',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low interest rate',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,13.49,'13.49% p.a',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/261182833;116030897;e',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,13.49,'13.49%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,18.0,'18',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'3% Balance Transfer Fee, eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-LRP',48,'ANZ Low Rate Platinum','ANZ Low Rate Platinum','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'MasterCard',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.74,'21.74%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary overseas travel and medical insurance
- You could save up to $800 on overseas travel and medical insurance (eligibility criteria applies)
-MasterCard Platinum Privileges','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,3.0,'3%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,35000.0,'$35000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'0% p.a. first 18 months on balance transfers, plus 3% Balance Transfer fee.',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,99.0,'$99',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('LOWINTERESTRATE','PLATINUM','BALANCETRANSFER');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-low-rate-platinum',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'0% p.a. first 18 months on balance transfers, plus 3% Balance Transfer fee.',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low interest rate with Platinum benefits',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,13.49,'13.49% p.a',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you
is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/264606485;116032947;j',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,13.49,'13.49%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,18.0,'18',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'3% Balance Transfer Fee, eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-R',48,'ANZ Rewards','ANZ Rewards','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.5,'1.5',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,20.99,'20.99%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,25000.0,'25000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Worldwide emergency credit card replacement for your ANZ Rewards cards.
-As an ANZ Rewards account holder, you have access to a range of optional extra services including
--eDine
--ANZ Car Rental Cover','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,2.0,'2',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Reward Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'No annual fee for the first year & 25,000 Reward Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn 2 Reward Points for every $1 spent on purchases using your ANZ Rewards American Express card 
-Earn 1.5 Reward Points for every $1 spent on purchases using your ANZ Rewards Visa card.
-Choose from a wide range of everyday rewards: Shopping vouchers and gift cards, merchandise and gifts, frequent flyer points, travel and accomodation and entertainment.','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,89.0,'$89',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('REWARDS','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-rewards',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'No annual fee for the first year & 25,000 Reward Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Reward Credit Card',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,18.79,'18.79%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/261182831;116033729;z',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Spend $2,500 on eligible purchases within the first 3 months. Eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-RP',48,'ANZ Rewards Platinum','ANZ Rewards Platinum','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.5,'1.5',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,20.99,'20.99%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Worldwide emergency credit card replacement for your ANZ Rewards Platinum cards.
-Exclusive access to ANZ''s Gift with Purchase program
-Access to Personal Concierge and Visa Platinum privileges with ANZ Rewards Platinum Visa
-Flexibility to add up to 9 additional ANZ Rewards Platinum credit cardholders to your account.
-As an ANZ Rewards Platinum account holder, you have access to a range of optional services including: eDine','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,3.0,'3',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,35000.0,'$35000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Reward Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'No annual fee for the first year & 50,000 Reward Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn 3 Reward Points for every $1 spent on purchases using your ANZ Rewards American Express card 
-Earn 1.5 Reward Points for every $1 spent on purchases using your ANZ Rewards Visa card.','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,149.0,'$149',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('PLATINUM','REWARDS','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-rewards-platinum',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'No annual fee for the first year & 50,000 Reward Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Reward Credit Card',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,18.79,'18.79%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/263376941;116030343;x',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Spend $2,500 on eligible purchases within the first 3 months. Eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-RB',48,'ANZ Rewards Black','ANZ Rewards Black','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,2.0,'2',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,20.99,'20.99%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,75000.0,'75000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Unlimited access to participating airport lounges outside Australia
-Comprehensive overseas travel and medical insurance
-Visa entertainment- providing you with access to special events, exlusive merchandise packages and home entertainment products
-Enjoy handpicked offers from American Express retail and lifestyle partners, and the convenience of saving offers to your Card.
-Rental Excess Cover for when you rent a car in Australia
-Interstate Flight Inconvenience Insurance protection against the unexpected while on holiday in Australia.
-Worldwide emergency credit card replacement for your ANZ Rewards Black cards.','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,3.0,'3',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,75000.0,'$75000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Reward Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'No annual fee for the first year & 75,000 Reward Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'- Earn 3 Reward Points for every $1 spent on purchases using your ANZ Rewards American Express card 
-Earn 2 Reward Points for every $1 spent on purchases using your ANZ Rewards Visa card.
-ANZ''s highest Reward Point earn rates
-Choice of Rewards-Including Cashback onto an ANZ credit card or transaction account.','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,375.0,'$375',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('REWARDS','BLACK','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,15000.0,'$15000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-rewards-black',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'No annual fee for the first year & 75,000 Reward Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Reward Credit Card',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,18.79,'18.79%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you
is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/282862299;116034616;l',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Spend $2,500 on eligible purchases within the first 3 months. Eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-FF',48,'ANZ Frequent Flyer','ANZ Frequent Flyer','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,25000.0,'25000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Complimentary Qantas Frequent Flyer membership','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.0,'1',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'No annual fee for the first year & 25,000 Qantas Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1 Qantas Point per $1 spent on eligible purchases using ANZ Frequent Flyer American Express cards up to $3,000 per statement period
-0.5 Qantas Point per $1 spent on eligible purchases using ANZ Frequent Flyer Visa cards up to $3,000 per statement period','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,95.0,'$95',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('REWARDS','FREQUENTFLYER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-frequent-flyer',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'No annual fee for the first year & 25,000 Qantas Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,44.0,'44',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/261182834;116033937;d',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Spend $2,500 on eligible purchases within the first 3 months. Eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-FFP',48,'ANZ Frequent Flyer Platinum','ANZ Frequent Flyer Platinum','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,0.5,'0.5',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Exclusive offers and benefits with entr&eacute; for ANZ Frequent Flyer Platinum American Express cardholders.
-Get a complimentary Qantas Frequent Flyer membership - apply online at the Qantas website and save $89.50.
-Overseas travel and medical insurance, provided by QBE Insurance.
-ANZ Frequent Flyer Platinum Visa card holders are eligible for Visa Platinum privileges.
-ANZ Visa payWave contactless payments
-Worldwide emergency credit card replacement for your ANZ Frequent Flyer Platinum cards.
-Access to optional services
-eDine&reg;','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.5,'1.5',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,35000.0,'$35000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'No annual fee for the first year & 50,000 Qantas Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-1.5 Qantas Point per $1 spent on eligible purchases using ANZ Frequent Flyer American Express cards up to $6,000 per statement period
-0.5 Qantas Point per $1 spent on eligible purchases using ANZ Frequent Flyer Visa cards up to $6,000 per statement period','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,295.0,'$295',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('PLATINUM','REWARDS','FREQUENTFLYER','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-frequent-flyer-platinum',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'No annual fee for the first year & 50,000 Qantas Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/261182832;116033843;x',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Spend $2,500 on eligible purchases within the first 3 months. Eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');


INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','ANZ-FFB',48,'ANZ Frequent Flyer Black','ANZ Frequent Flyer Black','2015-01-05','2040-12-31','');
SET @product_id = LAST_INSERT_ID();
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.5,'1.5',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa & American Express',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,75000.0,'75000',NULL,'2015-01-05','2040-12-31','',0);
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
-Enjoy handpicked offers from American Express retail and lifestyle partners','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,1.5,'1.5',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,75000.0,'$75000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points-type',0,0,'Qantas Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'No annual fee for the first year & 75,000 Qantas Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-Earn 1.5 point per $1 spent on purchases using the ANZ American Express card 
-Earn 1.5 point per $2 spent on purchases using the ANZ Visa card','2015-01-05','2040-12-31','');
INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,425.0,'$425',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('REWARDS','FREQUENTFLYER','BLACK','NOANNUALFEE');
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,15000.0,'$15000',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'anz-frequent-flyer-black',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'No annual fee for the first year & 75,000 Qantas Points when you spend $2,500 on purchases within the first 3 months',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Qantas Frequent Flyer Points',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.99,'19.99%',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'0',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'The Minimum Monthly Payment  required from you is generally 2% of the relevant Closing Balance
(subject to a minimum of $25).',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,20.0,'$20',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'https://ad.doubleclick.net/ddm/clk/282869129;116032645;k',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,NULL,'',NULL,'2015-01-05','2040-12-31','',0);
INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'Spend $2,500 on eligible purchases within the first 3 months. Eligibility criteria, T&Cs, fees and charges apply.','2015-01-05','2040-12-31','');
