-- UPDATER
-- INSERT INTO `ctm`.`travel_benefit_master` (`benefitId`, `benefitName`, `effectiveStart`, `effectiveEnd`) VALUES ('', 'CDXHOLIDAYFEE', '2015-07-24 00:00:00', '2040-12-31 23:59:59');

SET @BUD_DOME = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-7');
SET @BUD_ESSE = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-8');
SET @BUD_COMP = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-9');
SET @BUD_LAST = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-10');
SET @BUD_AMT = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-11');

SET @FOW_DOME = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-19');
SET @FOW_ESSE = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-20');
SET @FOW_COMP = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-21');
SET @FOW_LAST = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-22');
SET @FOW_AMT = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-23');

SET @START_DATE = ("2015-07-24 00:00:00");
SET @END_DATE = ("2040-12-31 23:59:59");

SET @DEATH = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DEATH');
SET @COPY = ("Accidental Death");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@DEATH,@COPY,@COPY,15000,'$15,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@DEATH,@COPY,@COPY,20000,'$20,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@DEATH,@COPY,@COPY,20000,'$20,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@DEATH,@COPY,@COPY,15000,'$15,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@DEATH,@COPY,@COPY,20000,'$20,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@DEATH,@COPY,@COPY,20000,'$20,000',0,@START_DATE,@END_DATE);
SET @EXPENSES = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='EXPENSES');
SET @COPY = ("Additional Expenses");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@EXPENSES,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@EXPENSES,@COPY,@COPY,12500,'$12,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@EXPENSES,@COPY,@COPY,40000,'$40,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_LAST,@EXPENSES,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@EXPENSES,@COPY,@COPY,40000,'$40,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@EXPENSES,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@EXPENSES,@COPY,@COPY,12500,'$12,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@EXPENSES,@COPY,@COPY,40000,'$40,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_LAST,@EXPENSES,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@EXPENSES,@COPY,@COPY,40000,'$40,000',0,@START_DATE,@END_DATE);
SET @TRANSPORT = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRANSPORT');
SET @COPY = ("Alternative Transport Expenses");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@TRANSPORT,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@TRANSPORT,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@TRANSPORT,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@TRANSPORT,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@TRANSPORT,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@TRANSPORT,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@TRANSPORT,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@TRANSPORT,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE);
SET @CXDFEE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CXDFEE');
SET @COPY = ("Cancellation & Amendment Fees");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@CXDFEE,@COPY,@COPY,7500,'$7,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@CXDFEE,@COPY,@COPY,12500,'$12,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@CXDFEE,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@CXDFEE,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@CXDFEE,@COPY,@COPY,7500,'$7,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@CXDFEE,@COPY,@COPY,12500,'$12,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@CXDFEE,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@CXDFEE,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE);
SET @CDXHOLIDAYFEE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CDXHOLIDAYFEE');
SET @COPY = ("Cutting Your Trip Short");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@CDXHOLIDAYFEE,@COPY,@COPY,7500,'$7,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@CDXHOLIDAYFEE,@COPY,@COPY,12500,'$12,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@CDXHOLIDAYFEE,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@CDXHOLIDAYFEE,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@CDXHOLIDAYFEE,@COPY,@COPY,7500,'$7,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@CDXHOLIDAYFEE,@COPY,@COPY,12500,'$12,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@CDXHOLIDAYFEE,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@CDXHOLIDAYFEE,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE);
SET @LUGGAGE_DELAY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LUGGAGE_DELAY');
SET @COPY = ("Delayed Luggage Allowance");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@LUGGAGE_DELAY,@COPY,@COPY,250,'$250',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@LUGGAGE_DELAY,@COPY,@COPY,400,'$400',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@LUGGAGE_DELAY,@COPY,@COPY,600,'$600',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@LUGGAGE_DELAY,@COPY,@COPY,600,'$600',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@LUGGAGE_DELAY,@COPY,@COPY,250,'$250',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@LUGGAGE_DELAY,@COPY,@COPY,400,'$400',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@LUGGAGE_DELAY,@COPY,@COPY,600,'$600',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@LUGGAGE_DELAY,@COPY,@COPY,600,'$600',0,@START_DATE,@END_DATE);
SET @DENTAL = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DENTAL');
SET @COPY = ("Dental Expenses (per person)");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_ESSE,@DENTAL,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@DENTAL,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_LAST,@DENTAL,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@DENTAL,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@DENTAL,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@DENTAL,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_LAST,@DENTAL,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@DENTAL,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE);
SET @EXCESS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='EXCESS');
SET @COPY = ("Excess on claims");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,54,@BUD_LAST,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,44,@FOW_LAST,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@EXCESS,@COPY,@COPY,200,'$200',0,@START_DATE,@END_DATE);
SET @HIJACK_KIDNAP = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='HIJACK_KIDNAP');
SET @COPY = ("Hijack");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_COMP,@HIJACK_KIDNAP,@COPY,@COPY,1500,'$1,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@HIJACK_KIDNAP,@COPY,@COPY,1500,'$1,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@HIJACK_KIDNAP,@COPY,@COPY,1500,'$1,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@HIJACK_KIDNAP,@COPY,@COPY,1500,'$1,500',0,@START_DATE,@END_DATE);
SET @HOSPITAL_CASH = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='HOSPITAL_CASH');
SET @COPY = ("Hospital Cash Allowance");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_COMP,@HOSPITAL_CASH,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@HOSPITAL_CASH,@COPY,@COPY,1000,'$1,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@HOSPITAL_CASH,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@HOSPITAL_CASH,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@HOSPITAL_CASH,@COPY,@COPY,1000,'$1,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@HOSPITAL_CASH,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE);
SET @INCOME_LOSS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='INCOME_LOSS');
SET @COPY = ("Loss of Income");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_COMP,@INCOME_LOSS,@COPY,@COPY,10400,'$10,400',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@INCOME_LOSS,@COPY,@COPY,10400,'$10,400',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@INCOME_LOSS,@COPY,@COPY,10400,'$10,400',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@INCOME_LOSS,@COPY,@COPY,10400,'$10,400',0,@START_DATE,@END_DATE);
SET @LUGGAGE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LUGGAGE');
SET @COPY = ("Luggage & Personal Effects");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@LUGGAGE,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@LUGGAGE,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@LUGGAGE,@COPY,@COPY,7500,'$7,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_LAST,@LUGGAGE,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@LUGGAGE,@COPY,@COPY,7500,'$7,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@LUGGAGE,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@LUGGAGE,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@LUGGAGE,@COPY,@COPY,7500,'$7,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_LAST,@LUGGAGE,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@LUGGAGE,@COPY,@COPY,7500,'$7,500',0,@START_DATE,@END_DATE);
SET @MEDICAL = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='MEDICAL');
SET @COPY = ("Overseas Emergency Medical & Hospital Expenses");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_ESSE,@MEDICAL,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@MEDICAL,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,54,@BUD_LAST,@MEDICAL,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@MEDICAL,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@MEDICAL,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@MEDICAL,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_LAST,@MEDICAL,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@MEDICAL,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE);
SET @MEDICAL_ASSI = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='MEDICAL_ASSI');
SET @COPY = ("Overseas Emergency Medical Assistance");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_ESSE,@MEDICAL_ASSI,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@MEDICAL_ASSI,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,54,@BUD_LAST,@MEDICAL_ASSI,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@MEDICAL_ASSI,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@MEDICAL_ASSI,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@MEDICAL_ASSI,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_LAST,@MEDICAL_ASSI,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@MEDICAL_ASSI,@COPY,@COPY,999999999,'Unlimited',0,@START_DATE,@END_DATE);
SET @DISABILITY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DISABILITY');
SET @COPY = ("Permanent Disability");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@DISABILITY,@COPY,@COPY,15000,'$15,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@DISABILITY,@COPY,@COPY,30000,'$30,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@DISABILITY,@COPY,@COPY,40000,'$40,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@DISABILITY,@COPY,@COPY,40000,'$40,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@DISABILITY,@COPY,@COPY,15000,'$15,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@DISABILITY,@COPY,@COPY,30000,'$30,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@DISABILITY,@COPY,@COPY,40000,'$40,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@DISABILITY,@COPY,@COPY,40000,'$40,000',0,@START_DATE,@END_DATE);
SET @LIABILTY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LIABILTY');
SET @COPY = ("Personal Liability");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@LIABILTY,@COPY,@COPY,1500000,'$1,500,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@LIABILTY,@COPY,@COPY,2000000,'$2,000,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@LIABILTY,@COPY,@COPY,5000000,'$5,000,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_LAST,@LIABILTY,@COPY,@COPY,1000000,'$1,000,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@LIABILTY,@COPY,@COPY,5000000,'$20,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_DOME,@LIABILTY,@COPY,@COPY,1500000,'$1,500,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_ESSE,@LIABILTY,@COPY,@COPY,2000000,'$2,000,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_COMP,@LIABILTY,@COPY,@COPY,5000000,'$5,000,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_LAST,@LIABILTY,@COPY,@COPY,1000000,'$1,000,000',0,@START_DATE,@END_DATE),
	(null,44,@FOW_AMT,@LIABILTY,@COPY,@COPY,5000000,'$5,000,000',0,@START_DATE,@END_DATE);
SET @DOMESTIC_PETS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DOMESTIC_PETS');
SET @COPY = ("Pet Care");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_COMP,@DOMESTIC_PETS,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@DOMESTIC_PETS,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,44,@BUD_COMP,@DOMESTIC_PETS,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE),
	(null,44,@BUD_AMT,@DOMESTIC_PETS,@COPY,@COPY,500,'$500',0,@START_DATE,@END_DATE);
SET @RENTAL_EXCESS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='RENTAL_EXCESS');
SET @COPY = ("Rental Vehicle Excess");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@RENTAL_EXCESS,@COPY,@COPY,4000,'$4,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@RENTAL_EXCESS,@COPY,@COPY,4000,'$4,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@RENTAL_EXCESS,@COPY,@COPY,6000,'$6,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@RENTAL_EXCESS,@COPY,@COPY,6000,'$6,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_DOME,@RENTAL_EXCESS,@COPY,@COPY,4000,'$4,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_ESSE,@RENTAL_EXCESS,@COPY,@COPY,4000,'$4,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_COMP,@RENTAL_EXCESS,@COPY,@COPY,6000,'$6,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_AMT,@RENTAL_EXCESS,@COPY,@COPY,6000,'$6,000',0,@START_DATE,@END_DATE);
SET @JOURNEY_RESUMPTION = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='JOURNEY_RESUMPTION');
SET @COPY = ("Resumption of Journey");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_COMP,@JOURNEY_RESUMPTION,@COPY,@COPY,3000,'$3,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@JOURNEY_RESUMPTION,@COPY,@COPY,3000,'$3,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_COMP,@JOURNEY_RESUMPTION,@COPY,@COPY,3000,'$3,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_AMT,@JOURNEY_RESUMPTION,@COPY,@COPY,3000,'$3,000',0,@START_DATE,@END_DATE);
SET @CASH_THEFT = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CASH_THEFT');
SET @COPY = ("Theft of Cash");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@CASH_THEFT,@COPY,@COPY,250,'$250',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@CASH_THEFT,@COPY,@COPY,250,'$250',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@CASH_THEFT,@COPY,@COPY,400,'$400',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@CASH_THEFT,@COPY,@COPY,400,'$400',0,@START_DATE,@END_DATE),
	(null,44,@BUD_DOME,@CASH_THEFT,@COPY,@COPY,250,'$250',0,@START_DATE,@END_DATE),
	(null,44,@BUD_ESSE,@CASH_THEFT,@COPY,@COPY,250,'$250',0,@START_DATE,@END_DATE),
	(null,44,@BUD_COMP,@CASH_THEFT,@COPY,@COPY,400,'$400',0,@START_DATE,@END_DATE),
	(null,44,@BUD_AMT,@CASH_THEFT,@COPY,@COPY,400,'$400',0,@START_DATE,@END_DATE);
SET @TRAVEL_DELAY_EXP = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRAVEL_DELAY_EXP');
SET @COPY = ("Travel Delay Expenses");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_DOME,@TRAVEL_DELAY_EXP,@COPY,@COPY,1000,'$1,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_ESSE,@TRAVEL_DELAY_EXP,@COPY,@COPY,1000,'$1,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_COMP,@TRAVEL_DELAY_EXP,@COPY,@COPY,2000,'$2,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@TRAVEL_DELAY_EXP,@COPY,@COPY,2000,'$2,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_DOME,@TRAVEL_DELAY_EXP,@COPY,@COPY,1000,'$1,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_ESSE,@TRAVEL_DELAY_EXP,@COPY,@COPY,1000,'$1,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_COMP,@TRAVEL_DELAY_EXP,@COPY,@COPY,2000,'$2,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_AMT,@TRAVEL_DELAY_EXP,@COPY,@COPY,2000,'$2,000',0,@START_DATE,@END_DATE);
SET @TRAVEL_DOCS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRAVEL_DOCS');
SET @COPY = ("Travel Documents, Credit Cards & Travellers Cheques");
INSERT INTO ctm.travel_product_benefits (id,providerId,productId,benefitId,label,description,benefitValue,benefitValueText,overrideExternal,startDate,endDate) VALUES 
	(null,54,@BUD_COMP,@TRAVEL_DOCS,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,54,@BUD_DOME,@TRAVEL_DOCS,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,54,@BUD_AMT,@TRAVEL_DOCS,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_COMP,@TRAVEL_DOCS,@COPY,@COPY,2500,'$2,500',0,@START_DATE,@END_DATE),
	(null,44,@BUD_DOME,@TRAVEL_DOCS,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE),
	(null,44,@BUD_AMT,@TRAVEL_DOCS,@COPY,@COPY,5000,'$5,000',0,@START_DATE,@END_DATE);

-- CHECKER
SET @BUD_DOME = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-7');
SET @BUD_ESSE = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-8');
SET @BUD_COMP = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-9');
SET @BUD_LAST = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-10');
SET @BUD_AMT = (SELECT productId FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-11');
SET @FOW_DOME = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-19');
SET @FOW_ESSE = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-20');
SET @FOW_COMP = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-21');
SET @FOW_LAST = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-22');
SET @FOW_AMT = (SELECT productId FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-23');

SET @DEATH = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DEATH');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DEATH;
/*SET @EXPENSES = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='EXPENSES');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@EXPENSES;
SET @TRANSPORT = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRANSPORT');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRANSPORT;
SET @CXDFEE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CXDFEE');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@CXDFEE;
SET @CDXHOLIDAYFEE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CDXHOLIDAYFEE');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@CDXHOLIDAYFEE;
SET @LUGGAGE_DELAY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LUGGAGE_DELAY');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@LUGGAGE_DELAY;
SET @DENTAL = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DENTAL');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DENTAL;
SET @EXCESS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='EXCESS');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@EXCESS;
SET @HIJACK_KIDNAP = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='HIJACK_KIDNAP');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@HIJACK_KIDNAP;
SET @HOSPITAL_CASH = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='HOSPITAL_CASH');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@HOSPITAL_CASH;
SET @INCOME_LOSS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='INCOME_LOSS');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@INCOME_LOSS;
SET @LUGGAGE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LUGGAGE');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@LUGGAGE;
SET @MEDICAL = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='MEDICAL');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@MEDICAL;
SET @MEDICAL_ASSI = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='MEDICAL_ASSI');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@MEDICAL_ASSI;
SET @DISABILITY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DISABILITY');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DISABILITY;
SET @LIABILTY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LIABILTY');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@LIABILTY;
SET @DOMESTIC_PETS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DOMESTIC_PETS');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DOMESTIC_PETS;
SET @RENTAL_EXCESS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='RENTAL_EXCESS');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@RENTAL_EXCESS;
SET @JOURNEY_RESUMPTION = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='JOURNEY_RESUMPTION');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@JOURNEY_RESUMPTION;
SET @CASH_THEFT = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CASH_THEFT');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@CASH_THEFT;
SET @TRAVEL_DELAY_EXP = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRAVEL_DELAY_EXP');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRAVEL_DELAY_EXP;
SET @TRAVEL_DOCS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRAVEL_DOCS');
SELECT * FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRAVEL_DOCS;
*/

-- ROLLBACK
/*
SET @DEATH = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DEATH');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DEATH;
SET @EXPENSES = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='EXPENSES');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@EXPENSES;
SET @TRANSPORT = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRANSPORT');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRANSPORT;
SET @CXDFEE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CXDFEE');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@CXDFEE;
SET @CDXHOLIDAYFEE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CDXHOLIDAYFEE');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@CDXHOLIDAYFEE;
SET @LUGGAGE_DELAY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LUGGAGE_DELAY');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@LUGGAGE_DELAY;
SET @DENTAL = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DENTAL');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DENTAL;
SET @EXCESS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='EXCESS');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@EXCESS;
SET @HIJACK_KIDNAP = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='HIJACK_KIDNAP');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@HIJACK_KIDNAP;
SET @HOSPITAL_CASH = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='HOSPITAL_CASH');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@HOSPITAL_CASH;
SET @INCOME_LOSS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='INCOME_LOSS');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@INCOME_LOSS;
SET @LUGGAGE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LUGGAGE');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@LUGGAGE;
SET @MEDICAL = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='MEDICAL');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@MEDICAL;
SET @MEDICAL_ASSI = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='MEDICAL_ASSI');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@MEDICAL_ASSI;
SET @DISABILITY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DISABILITY');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DISABILITY;
SET @LIABILTY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LIABILTY');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@LIABILTY;
SET @DOMESTIC_PETS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DOMESTIC_PETS');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DOMESTIC_PETS;
SET @RENTAL_EXCESS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='RENTAL_EXCESS');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@RENTAL_EXCESS;
SET @JOURNEY_RESUMPTION = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='JOURNEY_RESUMPTION');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@JOURNEY_RESUMPTION;
SET @CASH_THEFT = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CASH_THEFT');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@CASH_THEFT;
SET @TRAVEL_DELAY_EXP = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRAVEL_DELAY_EXP');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRAVEL_DELAY_EXP;
SET @TRAVEL_DOCS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRAVEL_DOCS');
DELETE FROM ctm.travel_product_benefits WHERE productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRAVEL_DOCS;
DELETE FROM `ctm`.`travel_benefit_master` WHERE `benefitName`='CDXHOLIDAYFEE' AND `effectiveStart`='2015-07-24 00:00:00' AND `effectiveEnd`='2040-12-31 23:59:59';
*/