/****************************
 ********* ROLLBACK *********
 ****************************/

-- Common variables needed for delete scripts
SET @BUD_DOME = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-7');
SET @BUD_ESSE = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-8');
SET @BUD_COMP = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-9');
SET @BUD_LAST = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-10');
SET @BUD_AMT = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 54 AND productCode='AGIS-TRAVEL-11');
SET @FOW_DOME = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-19');
SET @FOW_ESSE = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-20');
SET @FOW_COMP = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-21');
SET @FOW_LAST = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-22');
SET @FOW_AMT = (SELECT providerProductCode FROM ctm.travel_product WHERE providerId = 44 AND productCode='1FOW-TRAVEL-23');
SET @START_DATE = ("2015-07-24 00:00:00");
SET @END_DATE = ("2040-12-31 23:59:59");

-- Remove new benefits assigned to products
SET @DEATH = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DEATH');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DEATH;
SET @TRANSPORT = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRANSPORT');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRANSPORT;
SET @CDXHOLIDAYFEE = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CDXHOLIDAYFEE');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@CDXHOLIDAYFEE;
SET @LUGGAGE_DELAY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='LUGGAGE_DELAY');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@LUGGAGE_DELAY;
SET @DENTAL = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DENTAL');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DENTAL;
SET @EXCESS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='EXCESS');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@EXCESS;
SET @HIJACK_KIDNAP = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='HIJACK_KIDNAP');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@HIJACK_KIDNAP;
SET @HOSPITAL_CASH = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='HOSPITAL_CASH');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@HOSPITAL_CASH;
SET @INCOME_LOSS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='INCOME_LOSS');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@INCOME_LOSS;
SET @MEDICAL_ASSI = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='MEDICAL_ASSI');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@MEDICAL_ASSI;
SET @DISABILITY = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DISABILITY');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DISABILITY;
SET @DOMESTIC_PETS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='DOMESTIC_PETS');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@DOMESTIC_PETS;
SET @JOURNEY_RESUMPTION = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='JOURNEY_RESUMPTION');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@JOURNEY_RESUMPTION;
SET @CASH_THEFT = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='CASH_THEFT');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@CASH_THEFT;
SET @TRAVEL_DELAY_EXP = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRAVEL_DELAY_EXP');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRAVEL_DELAY_EXP;
SET @TRAVEL_DOCS = (SELECT benefitId FROM ctm.travel_benefit_master WHERE benefitName='TRAVEL_DOCS');
DELETE FROM ctm.travel_product_benefits WHERE startDate=@START_DATE AND productId IN (@BUD_DOME,@BUD_ESSE,@BUD_COMP,@BUD_LAST,@BUD_AMT,@FOW_DOME,@FOW_ESSE,@FOW_COMP,@FOW_LAST,@FOW_AMT) AND benefitId=@TRAVEL_DOCS;

 -- Remove new benefit type added to master
DELETE FROM `ctm`.`travel_benefit_master` WHERE `benefitName`='CDXHOLIDAYFEE' AND `effectiveStart`=@START_DATE AND `effectiveEnd`=@END_DATE;