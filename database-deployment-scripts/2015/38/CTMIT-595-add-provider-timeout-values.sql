-- Constants
SET @START_DATE = '2014-01-01 00:00:00';
SET @END_DATE = '2038-01-19 00:00:00';

-- Travel Vertical
set @TRAVEL_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'TRAVEL');
SET @TRAVEL_SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@TRAVEL_VERTICAL_ID AND serviceCode='quoteServiceBER');

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = '1FOW'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'BUDD'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'VIRG'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'OTIS'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'AMEX'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'CLBS'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'FAST'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'DUIN'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = '1COV'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'SKII'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = '30UN'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'INGO'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'TINZ'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'KANG'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'ITRK'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'WEBJ'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'ZUJI'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'PPTI'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'ACET'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'TICK'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE'),
  (@TRAVEL_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'GOIN'), '0', 0, 'timeout','20',@START_DATE, @END_DATE, 'SERVICE')
;

-- Car Vertical
set @CAR_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'CAR');
SET @CAR_SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@CAR_VERTICAL_ID AND serviceCode='carServiceBER');

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = '1FOW'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'BUDD'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'CBCK'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'AGCH'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'EXDD'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'EXPO'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'IECO'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'OZIC'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'RETI'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'VIRG'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'REAL'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'WOOL'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@CAR_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'AI'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE')
;

-- H and C Vertical
set @HNC_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HOME');
SET @HNC_SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId=@HNC_VERTICAL_ID AND serviceCode='homeServiceBER');

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HNC_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'BUDD'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@HNC_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'VIRG'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@HNC_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'REAL'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE'),
  (@HNC_SERVICE_MASTER_ID, (select providerId from ctm.provider_master where providerCode = 'WOOL'), '0', 0, 'timeout','35',@START_DATE, @END_DATE, 'SERVICE')
;

  -- Health Vertical
SET @HEALTH_VERTICAL_ID = (SELECT verticalId FROM ctm.vertical_master WHERE verticalCode = 'HEALTH');
SET @HEALTH_SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master where verticalId = @HEALTH_VERTICAL_ID AND serviceCode = 'appService' );

INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'AHM'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'AUF'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'BUD'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'BUP'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'CBH'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'CUA'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'FRA'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'GMF'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'GMH'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'HCF'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'HIF'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'NIB'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE'),
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'QCH'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE')
;

-- Some environments have the CTM test brand
INSERT INTO ctm.service_properties (serviceMasterId, providerId, environmentCode, styleCodeId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_SERVICE_MASTER_ID, (select providerId from ctm.provider_properties where PropertyId = 'FundCode' and Text = 'CTM'), '0', 0, 'timeout','270',@START_DATE, @END_DATE, 'SERVICE')
;