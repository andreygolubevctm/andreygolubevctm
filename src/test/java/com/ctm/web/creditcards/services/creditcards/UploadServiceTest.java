package com.ctm.web.creditcards.services.creditcards;

import com.ctm.web.creditcards.model.UploadRequest;
import org.hamcrest.text.IsEqualIgnoringCase;
import org.hamcrest.text.IsEqualIgnoringWhiteSpace;
import org.junit.Test;

import static com.ctm.common.test.TestUtil.readResourceStream;
import static org.junit.Assert.*;


public class UploadServiceTest {
    @Test
    public void getRates() throws Exception {
        UploadRequest file = new UploadRequest();
        file.providerCode = "1";
        file.uploadedStream  = readResourceStream("com/ctm/creditcard/creditcardwithmschars.csv");
        String expect = "USE ctm;\n" +
                "\n" +
                "-- Get Provider ID from Provider Code\n" +
                "SET @provider_id = (SELECT providerId FROM ctm.provider_master WHERE providerCode = '1');\n" +
                "\n" +
                "-- Create temporary table of product ids\n" +
                "CREATE TEMPORARY TABLE _products SELECT productid FROM ctm.product_master WHERE productCat='CREDITCARD' AND providerid=@provider_id;\n" +
                "\n" +
                "-- Should return less than 12 products for most providers\n" +
                "SELECT * FROM _products;\n" +
                "\n" +
                "-- Delete using join with temporary table\n" +
                "DELETE cpm FROM ctm.category_product_mapping cpm INNER JOIN _products ON cpm.productID=_products.productId;\n" +
                "DELETE pp FROM ctm.product_properties pp INNER JOIN _products ON pp.productID=_products.productId;\n" +
                "DELETE ppt FROM ctm.product_properties_text ppt INNER JOIN _products ON ppt.productID=_products.productId;\n" +
                "DELETE pm FROM ctm.product_master pm INNER JOIN _products ON pm.productID=_products.productId;\n" +
                "\n" +
                "-- Clean up\n" +
                "DROP TEMPORARY TABLE _products;\n" +
                "\n" +
                "\n" +
                "INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, " +
                "LongTitle,EffectiveStart,EffectiveEnd,Status) " +
                "VALUES('CREDITCARD','WEST-LR',@provider_id,'Westpac Low Rate Card'," +
                "'Westpac Low Rate Card','','2040-12-31','');\n" +
                "SET @product_id = LAST_INSERT_ID();\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0," +
                "'The promotional balance transfer rate is available when you apply for a new Westpac credit " +
                "card between 12th October 2016 and 30th January 2017 and request at application " +
                "to transfer balance(s) from up to 3 non-Westpac Australian issued credit, charge or store cards. " +
                "The rates will apply to balance(s) transferred (min $200 up to 95% of your approved " +
                "available credit limit) for the promotional period, unless the amount is paid off earlier. " +
                "Card activation will trigger the processing of the balance transfer. " +
                "The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of " +
                "the promotional period. Westpac will not be responsible for any delays that may occur " +
                "in processing payment to your other card account(s) and will not close the account(s). " +
                "The variable purchase interest rate applies to balance transfers requested at any other time. " +
                "Interest free days don''t apply to balance transfers.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'The introductory rate of 1.00% p.a. on purchases is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017. The introductory rate will be applied from the date of the first purchase on your account and expires 12 months after the date of card approval. At the end of this period the introductory purchase rate will switch to the variable purchase rate then applicable to your card account and any purchases that remain unpaid at that time will revert to the standard variable purchase rate then applicable to your card account.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0," +
                "'-Contactless Payments\n" +
                "-CardShield helps defend against fraudulent activity\n" +
                "-Secure online shopping through Verified by Visa\n" +
                "-Falcon&reg; Fraud Protection 24/7\n" +
                "-Fraud Money Back Guarantee- Cardholders will be will be reimbursed for any unauthorised transactions provided that the customer has not contributed to the loss and contacted Westpac promptly. " +
                "Refer to your card''s conditions of use for full details, " +
                "including when a customer will be liable.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,1.0,'1%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,25000.0,'$25000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'Pay 0% p.a. on balance transfers for 16 months, receive complimentary insurances and access a platinum concierge service for a low annual fee.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,59.0,'$59',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('LOWINTERESTRATE','BALANCETRANSFER','INTERESTFREE');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'westpac-low-rate',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,12.0,'12',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Enjoy summer and all its festivities with a low rate on purchases for up to a year.\n" +
                "1%p.a.interest on purchases for up to 12 months from card approval.\n" +
                "0%p.a.on balance transfers for 16 months requested at card application \n" +
                "Offer ends 30 January 2017. New cards only.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low Interest',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,13.49,'13.49%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'2%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,9.0,'$9',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lxWv/destination:http://adsfac.net/link.asp?cc=WCC071.221712.0&clk=1&creativeID=314335&ord=[timestamp]',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,13.49,'13.49%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Conditions, fees and credit criteria apply.\n" +
                "-This card is issued as a Visa card.\n" +
                "-View the terms and conditions:\n" +
                "--[Credit Card Conditions of Use]" +
                "(http://info.westpac.com.au/creditcards/files/Consumer_Conditions_of_use.pdf)'" +
                ",'','2040-12-31','');\n" +
                "\n" +
                "\n" +
                "INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','WEST-LR',@provider_id,'Westpac Low Rate Card','Westpac Low Rate Card','','2040-12-31','');\n" +
                "SET @product_id = LAST_INSERT_ID();\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0," +
                "'The promotional balance transfer rate is available when you apply for a new Westpac " +
                "credit card between 12th October 2016 and 30th January 2017 and request at " +
                "application to transfer balance(s) from up to 3 non-Westpac Australian issued credit, " +
                "charge or store cards. The rates will apply to balance(s) " +
                "transferred (min $200 up to 95% of your approved available credit limit) for the " +
                "promotional period, unless the amount is paid off earlier. " +
                "Card activation will trigger the processing of the balance transfer. " +
                "The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of the promotional period. Westpac will not be responsible for any delays that may occur in processing payment to your other card account(s) and will not close the account(s). The variable purchase interest rate applies to balance transfers requested at any other time. Interest free days don''t apply to balance transfers.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'The introductory rate of 1.00% p.a. on purchases is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017. The introductory rate will be applied from the date of the first purchase on your account and expires 12 months after the date of card approval. At the end of this period the introductory purchase rate will switch to the variable purchase rate then applicable to your card account and any purchases that remain unpaid at that time will revert to the standard variable purchase rate then applicable to your card account.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,0,'No',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.49,'21.49%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-Contactless Payments\n" +
                "-CardShield helps defend against fraudulent activity\n" +
                "-Secure online shopping through Verified by Visa\n" +
                "-Falcon&reg; Fraud Protection 24/7\n" +
                "-Fraud Money Back Guarantee- Cardholders will be will be reimbursed for any unauthorised transactions provided that the customer has not contributed to the loss and contacted Westpac promptly. " +
                "Refer to your card''s conditions of use for full details, including when a customer will be liable.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,1.0,'1%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,25000.0,'$25000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,15000.0,'$15000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'Pay 0% p.a. on balance transfers for 16 months, receive complimentary insurances and access a platinum concierge service for a low annual fee.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,59.0,'$59',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('LOWINTERESTRATE','BALANCETRANSFER','INTERESTFREE');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,1000.0,'$1000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'westpac-low-rate',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,12.0,'12',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Enjoy summer and all its festivities with a low rate on purchases for up to a year.\n" +
                "1%p.a.interest on purchases for up to 12 months from card approval.\n" +
                "0%p.a.on balance transfers for 16 months requested at card application \n" +
                "Offer ends 30 January 2017. New cards only.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Low Interest',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,0,'No',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,13.49,'13.49%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'2%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,9.0,'$9',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lxWv/destination:http://adsfac.net/link.asp?cc=WCC071.221712.0&clk=1&creativeID=314335&ord=[timestamp]',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,13.49,'13.49%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Conditions, fees and credit criteria apply.\n" +
                "-This card is issued as a Visa card.\n" +
                "-View the terms and conditions:\n" +
                "--[Credit Card Conditions of Use](http://info.westpac.com.au/creditcards/files/Consumer_Conditions_of_use.pdf)','','2040-12-31','');\n" +
                "\n" +
                "\n" +
                "INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','WEST-AP',@provider_id,'Westpac Altitude Platinum','Westpac Altitude Platinum','','2040-12-31','');\n" +
                "SET @product_id = LAST_INSERT_ID();\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.0,'1',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'The promotional balance transfer rate is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017 and request at application to transfer balance(s) from up to 3 non-Westpac Australian issued credit, charge or store cards. The rates will apply to balance(s) transferred (min $200 up to 95% of your approved available credit limit) for the promotional period, unless the amount is paid off earlier. Card activation will trigger the processing of the balance transfer. The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of the promotional period. Westpac will not be responsible for any delays that may occur in processing payment to your other card account(s) and will not close the account(s). The variable purchase interest rate applies to balance transfers requested at any other time. Interest free days don''t apply to balance transfers.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa/American Express',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'-New cards only. Apply between 6 January 2015 and 19 April 2015.\n" +
                "-Switches, upgrades, customers accessing employee benefits or packaged cards are ineligible for this offer\n" +
                "-Introductory rate on purchases is not available in conjunction with any promotion','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,20.74,'20.74%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-24/7 personal concierge services\n" +
                "-Extended complimentary insurances\n" +
                "-Extended warranty insurance\n" +
                "-Tap & Pay \n" +
                "-Access to American Express Connect','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,1.0,'1%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,30000.0,'$30000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,2.0,'2',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,30000.0,'$30000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'50,000 bonus Qantas or Altitude Points on a new card, when you spend $2500 within 90 days from card approval. Exclusions apply. " +
                "Offer ends 30th January 2017.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-If you choose Altitude Rewards:\n" +
                "--2 Altitude Points - Altitude Platinum American Express'' trade Card\n" +
                "--1 Altitude Point - Altitude Platinum Visa Card\n" +
                "--For each statement cycle a points cap of 7,500 Altitude Points applies when using either or both car','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,150.0,'$150',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('PLATINUM','REWARDS','INTERESTFREE');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'westpac-altitude-platinum',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,12.0,'12',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Enjoy the best parts of summer with 50,000 bonus points as well as a low purchase rate for up to 12 months.\n" +
                "Offer ends 30 January 2017. New cards only.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,45.0,'45',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Platinum',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'[Westpac Platinum Rewards Concierge Terms and Conditions](https://www.westpac.com.au/content/dam/public/wbc/documents/pdf/pb/plat_rewards_cards_concierge_tcs.pdf)\n" +
                "[Westpac Rewards Credit Cards Emergency Travel Assistance](https://www.westpac.com.au/content/dam/public/wbc/documents/pdf/pb/rewards_cards_emergency_travel_assit_tcs.pdf)','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.24,'20.24%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'[Westpac Credit Cards Complimentary Insurance Policy](http://www.westpac.com.au/docs/pdf/pb/westpac_credit_card_comp_insurance_policy_after21Oct2012)\n" +
                "[Westpac Rewards Credit Cards Emergency Travel Assistance](http://www.westpac.com.au/docs/pdf/pb/rewards_cards_emergency_travel_assit_tcs.pdf)\n" +
                "[Westpac Rewards Cards Concierge Service Terms and Conditions](http://www.westpac.com.au/docs/pdf/pb/plat_rewards_cards_concierge_tcs.pdf)','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'2%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,9.0,'$9',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'Yes - Conditons apply',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lxWv/destination:http://adsfac.net/link.asp?cc=WCC071.221712.0&clk=1&creativeID=314340&ord=[timestamp]',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.24,'20.24%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Conditions, fees and credit criteria apply.\n" +
                "-This card is issued as a Visa card.\n" +
                "-View the terms and conditions:\n" +
                "--[Credit Card Conditions of Use](http://info.westpac.com.au/creditcards/files/Consumer_Conditions_of_use.pdf)','','2040-12-31','');\n" +
                "\n" +
                "\n" +
                "INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','WEST-AB',@provider_id,'Westpac Altitude Black','Westpac Altitude Black','','2040-12-31','');\n" +
                "SET @product_id = LAST_INSERT_ID();\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,1.25,'1.25',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0,'The promotional balance transfer rate is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017 and request at application to transfer balance(s) from up to 3 non-Westpac Australian issued credit, charge or store cards. The rates will apply to balance(s) transferred (min $200 up to 95% of your approved available credit limit) for the promotional period, unless the amount is paid off earlier. Card activation will trigger the processing of the balance transfer. The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of the promotional period. Westpac will not be responsible for any delays that may occur in processing payment to your other card account(s) and will not close the account(s). The variable purchase interest rate applies to balance transfers requested at any other time. Interest free days don''t apply to balance transfers','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa/American Express',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'-New cards only. Apply between 6 January 2015 and 19 April 2015.\n" +
                "-Switches, upgrades, customers accessing employee benefits or packaged cards are ineligible for this offer\n" +
                "-Introductory rate on purchases is not available in conjunction with any promotion','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,20.74,'20.74%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,50000.0,'50000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-24/7 personal concierge services\n" +
                "-Extended complimentary insurances\n" +
                "-Extended warranty insurance\n" +
                "-Tap & Pay \n" +
                "-Access to American Express Connect\n" +
                "-Complimentary Qantas Frequent Flyer membership','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,1.0,'1%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,75000.0,'$75000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,3.0,'3',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,75000.0,'$75000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'50,000 bonus Qantas or Altitude Points on a new card, when you spend $2500 within 90 days from card approval. Exclusions apply. Offer ends 30th January 2017.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'-If you choose Altitude Rewards:\n" +
                "--1.25 points - Altitude Black World MasterCard &trade; (Australian Merchants)\n" +
                "--3 points - Altitude Black World MasterCard &trade; (Overseas Merchants)\n" +
                "--3 points - Altitude Black American Express Card (Australian Merchants)','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,395.0,'$395',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('BLACK','REWARDS','BALANCETRANSFER','INTERESTFREE');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,15000.0,'$15000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'westpac-altitude-black',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,12.0,'12',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'Summer''s yours to enjoy with 50,000 bonus points and the impressive range of Altitude Black benefits.\n" +
                "50,000 bonus Qantas or Altitude points when you spend $2,500 on eligible purchases within 90 days of card approval\n" +
                "1%p.a.interest on purchases for up to 12 months from card approval\n" +
                "Offer ends 30 January 2017. New cards only.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,45.0,'45',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Black',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'[Altitude Rewards and Altitude Qantas Terms and Conditions](http://www.westpac.com.au/docs/pdf/pb/credit-cards/Altitude_Rewards_Terms_and_1.pdf)\n" +
                "[Westpac Rewards Credit Cards Emergency Travel Assistance](https://www.westpac.com.au/content/dam/public/wbc/documents/pdf/pb/rewards_cards_emergency_travel_assit_tcs.pdf)','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,20.24,'20.24%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'[Westpac Credit Cards Complimentary Insurance Policy](http://www.westpac.com.au/docs/pdf/pb/westpac_credit_card_comp_insurance_policy_after21Oct2012)\n" +
                "[Westpac Rewards Credit Cards Emergency Travel Assistance](http://www.westpac.com.au/docs/pdf/pb/rewards_)\n" +
                "[Westpac Altitude Rewards](https://www.westpac.com.au/content/dam/public/wbc/documents/pdf/pb/credit-cards/Altitude_Rewards_Terms_and_1.pdf)','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'2%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,9.0,'$9',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lxWv/destination:http://adsfac.net/link.asp?cc=WCC071.221712.0&clk=1&creativeID=315859&ord=[timestamp]',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,20.24,'20.24%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Conditions, fees and credit criteria apply.\n" +
                "-This card is issued as a Visa card.\n" +
                "-View the terms and conditions:\n" +
                "--[Credit Card Conditions of Use](http://info.westpac.com.au/creditcards/files/Consumer_Conditions_of_use.pdf)','','2040-12-31','');\n" +
                "\n" +
                "\n" +
                "INSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','WEST-A',@provider_id,'Westpac 55 Day Platinum','Westpac 55 Day Platinum','','2040-12-31','');\n" +
                "SET @product_id = LAST_INSERT_ID();\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-standard-card-points',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-balance-transfer',0," +
                "'The promotional balance transfer rate is available when you apply for a new Westpac credit card " +
                "between 12th October 2016 and 30th January 2017 and request at application to transfer balance(s) " +
                "from up to 3 non-Westpac Australian issued credit, charge or store cards. The rates will apply to balance(s) transferred (min $200 up to 95% of your approved available credit limit) for the promotional period, unless the amount is paid off earlier. Card activation will trigger the processing of the balance transfer. The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of the promotional period. Westpac will not be responsible for any delays that may occur in processing payment to your other card account(s) and will not close the account(s). The variable purchase interest rate applies to balance transfers requested at any other time. " +
                "Interest free days don''t apply to balance transfers.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'card-class',0,0,'Visa',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-interest-rate',0,'The introductory rate of 1.00% p.a. on purchases is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017. The introductory rate will be applied from the date of the first purchase on your account and expires 12 months after the date of card approval. At the end of this period the introductory purchase rate will switch to the variable purchase rate then applicable to your card account and any purchases that remain unpaid at that time will revert to the standard variable purchase rate then applicable to your card account.','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'extended-warranty',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'cash-advance-rate',0,21.29,'21.29%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-bonus-points',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'other-features',0,'-24/7 personal concierge services\n" +
                "-Extended complimentary insurances\n" +
                "-Extended warranty insurance\n" +
                "-Tap & Pay','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate',0,1.0,'1%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'maximum-credit-limit',0,50000.0,'$50000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'rewards-amex-card-points',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-fee',0,NULL,'',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-income',0,30000.0,'$30000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee-period',0,12.0,'12',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate',0,0.0,'0.00%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'special-offer',0,0,'$0 annual fee in the first year on a new card. Plus, $0 annual fee in subsequent years when you spend $10,000 or more on purchases in each 12 months from the date of the first transaction on your account, currently saving you $90.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'rewards-desc',0,'','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'annual-fee',0,90.0,'$90',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('PLATINUM','INTERESTFREE','BALANCETRANSFER');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-credit-limit',0,6000.0,'$6000',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'slug',0,0,'westpac-55day-platinum',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-rate-period',0,12.0,'12',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-desc',0,0,'With a suite of premium benefits, a $0 annual fee offer and a 0% p.a. balance transfer for 16 months, Westpac''s 55 Day Platinum Visa credit card is looking more attractive than ever.\n" +
                "Offer ends 30 January 2017. New cards only.',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-free-days',0,55.0,'55',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'product-type',0,0,'Platinum',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'foreign-exchange-fees',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-rewards',0,'','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'complimentary-travel-insurance',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'interest-rate',0,19.84,'19.84%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-annual-fee',0,0.0,'$0',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-other-features',0,'[Westpac Credit Cards Complimentary Insurance Policy](https://www.westpac.com.au/content/dam/public/wbc/documents/pdf/pb/westpac_credit_card_comp_insurance_policy_after21Oct2012.pdf)\n" +
                "[Westpac Rewards Cards Concierge Service Terms and Conditions](https://www.westpac.com.au/content/dam/public/wbc/documents/pdf/pb/55DayPlatinum_Concierge_TCs.pdf)','','2040-12-31','');\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'minimum-monthly-repayment',0,2.0,'2%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'late-payment-fee',0,9.0,'$9',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'available-temporary-residents',0,0,'No',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'handover-url',0,0,'http://prf.hn/click/camref:1100lxWv/destination:http://adsfac.net/link.asp?cc=WCC071.221712.0&clk=1&creativeID=314339&ord=[timestamp]',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'additional-card-holder',0,1,'Yes',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'balance-transfer-rate',0,19.84,'19.84%',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties VALUES(@product_id,'intro-balance-transfer-rate-period',0,16.0,'16',NULL,'','2040-12-31','',0);\n" +
                "INSERT INTO ctm.product_properties_text VALUES(@product_id,'terms-general',0,'-Conditions, fees and credit criteria apply.\n" +
                "-This card is issued as a Visa card.\n" +
                "-View the terms and conditions:\n" +
                "--[Credit Card Conditions of Use](http://info.westpac.com.au/creditcards/files/Consumer_Conditions_of_use.pdf)','','2040-12-31','');\n";
        String result = UploadService.getRates(file);
        assertThat(result, IsEqualIgnoringWhiteSpace.equalToIgnoringWhiteSpace(expect));
    }

    @Test
    public void replaceMsCharactersTest() throws Exception {
        String text = "The promotional balance transfer rate is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017 and request at application to transfer balance(s) from up to 3 non-Westpac Australian issued credit, charge or store cards. The rates will apply to balance(s) transferred (min $200 up to 95% of your approved available credit limit) for the promotional period, unless the amount is paid off earlier. Card activation will trigger the processing of the balance transfer. The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of the promotional period. Westpac will not be responsible for any delays that may occur in processing payment to your other card account(s) and will not close the account(s). The variable purchase interest rate applies to balance transfers requested at any other time. " +
                "Interest free days don’t apply to balance transfers.\n";
        String expect = "The promotional balance transfer rate is available when you apply for a new Westpac credit card between 12th October 2016 and 30th January 2017 and request at application to transfer balance(s) from up to 3 non-Westpac Australian issued credit, charge or store cards. The rates will apply to balance(s) transferred (min $200 up to 95% of your approved available credit limit) for the promotional period, unless the amount is paid off earlier. Card activation will trigger the processing of the balance transfer. The variable purchase rate will apply to balance(s) transferred but left unpaid at the end of the promotional period. Westpac will not be responsible for any delays that may occur in processing payment to your other card account(s) and will not close the account(s). The variable purchase interest rate applies to balance transfers requested at any other time. " +
                "Interest free days don't apply to balance transfers.\n";
        assertEquals(expect, UploadService.replaceMsCharacters(text));
    }

}