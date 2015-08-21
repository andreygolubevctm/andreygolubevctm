
SET @GOIN = (select providerId from ctm.provider_master where providerCode = 'GOIN');

-- benefits mapping
INSERT INTO `ctm`.`travel_provider_benefit_mapping` (`benefitId`, `providerId`, `providerBenefitCode`, `effectiveStart`, `effectiveEnd`)
 VALUES ('2', @GOIN, 'excess', '2015-08-05', '2040-12-31');
INSERT INTO `ctm`.`travel_provider_benefit_mapping` (`benefitId`, `providerId`, `providerBenefitCode`, `effectiveStart`, `effectiveEnd`)
 VALUES ('4', @GOIN, 'medical', '2015-08-05', '2040-12-31');
INSERT INTO `ctm`.`travel_provider_benefit_mapping` (`benefitId`, `providerId`, `providerBenefitCode`, `effectiveStart`, `effectiveEnd`)
 VALUES ('6', @GOIN, 'luggage', '2015-08-05', '2040-12-31');
INSERT INTO `ctm`.`travel_provider_benefit_mapping` (`benefitId`, `providerId`, `providerBenefitCode`, `effectiveStart`, `effectiveEnd`)
 VALUES ('1', @GOIN, 'cancellation', '2015-08-05', '2040-12-31');
-- expect 4
select count(*) from ctm.travel_provider_benefit_mapping where providerId = @GOIN;

-- rollback
-- uncomment below for rollback
-- SET @GOINBACK = (select providerId from ctm.provider_master where providerCode = 'GOIN');
-- delete from ctm.travel_provider_benefit_mapping where providerId = @GOINBACK LIMIT 4;