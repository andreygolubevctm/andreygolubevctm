SET @PVIDER = (select providerId from ctm.provider_master where providerCode = '30UN');


UPDATE ctm.travel_provider_benefit_mapping
  SET providerBenefitCode = '7' where providerId = @PVIDER and providerBenefitCode = '17' limit 1;

-- TEST expect 1
select count(*) from ctm.travel_provider_benefit_mapping where providerId = @PVIDER and providerBenefitCode = '7';

