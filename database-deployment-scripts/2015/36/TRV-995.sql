UPDATE ctm.country_provider_mapping SET countryvalue='IDN' WHERE isocode='BAL' AND providerid=(SELECT providerid from ctm.provider_master WHERE ProviderCode='GOIN');
