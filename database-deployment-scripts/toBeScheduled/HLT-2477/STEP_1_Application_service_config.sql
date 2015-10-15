-- All in ctm
USE ctm;

-- New master services.
SET @APPLY_SERVICE = 'healthApplyServiceBER';
SET @VERTICAL_ID = (SELECT verticalId FROM vertical_master WHERE verticalCode = 'HEALTH');
INSERT INTO service_master (verticalId, serviceCode) VALUES (@VERTICAL_ID, @APPLY_SERVICE);

-- Set master id's to use for later inserts.
SET @HEALTH_APP_BASE_MASTER_ID = (SELECT serviceMasterId FROM service_master where serviceCode = @APPLY_SERVICE AND verticalId = @VERTICAL_ID);
SET @STARTDATE = '2015-09-09';
SET @ENDDATE = '2038-01-19';

-- ----------------------
-- APPLICATION SERVICE --
-- ----------------------

-- -----
-- AHM --
-- -----
SET @SERVICE_NAME = 'AHM';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://webagdev.ahm.com.au/WHICSServices/MembershipService.svc', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://webag.ahm.com.au/WHICSServices/MembershipService.svc', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', 'AHM', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'AHM-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;

-- ------
-- AUF --
-- ------
SET @SERVICE_NAME = 'AUF';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://sit-sales.b2b.health-insurance.australianunity.com.au/CompareTheMarket.Soap11', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'NXQ', 0, @PROVIDERID, 'url', 'https://stage-sales.b2b.health-insurance.australianunity.com.au/CompareTheMarket.Soap11', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://sales.b2b.health-insurance.australianunity.com.au/CompareTheMarket.Soap11', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', 'AUF', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'AUF-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'outboundParams', 'ssl-no-host-verify=Y', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'inboundParams', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;
-- Might need these
-- (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'soap-action', 'http://ws.australianunity.com.au/B2B/Broker/ProcessApplication', @STARTDATE, @ENDDATE, 'SERVICE'),
-- (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'soap-action', 'auHealthRetailTasksPci.ws_b2bSalesService_Binder_ProcessApplication', @STARTDATE, @ENDDATE, 'SERVICE'),


-- ---------
-- BUDGET --
-- ---------
SET @SERVICE_NAME = 'BUD';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://staging.api.gmhba.com.au/SOAP/Membership.svc/basic', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://api.gmhba.com.au/SOAP/membership.svc/basic', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'user', 'comparethemarket', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', 'y$ha6ESw', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'BUD-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'outboundParams', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'inboundParams', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;
--  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'soap-action', 'http://tempuri.org/IMembership/SubmitMembershipTransactionUsingSTP', @STARTDATE, @ENDDATE, 'SERVICE'),

-- -------
-- Bupa --
-- -------
SET @SERVICE_NAME = 'BUP';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://ctmtest.bupa.com.au:446/CompareTheMarket.svc', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://ctm.bupa.com.au:446/CompareTheMarket.svc', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'user', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'BUP-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'outboundParams', 'clientType=BupaCTM', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'inboundParams', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;

-- ------
-- CtM --
-- ------
SET @SERVICE_NAME = 'CTM';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'url', 'http://localhost:8080/ctm/rating/health/health_submit_to_file_or_sftp.jsp', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'user', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'password', 'test', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'errorProductCode', 'CTM-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;

-- -------
-- CBHS --
-- -------
SET @SERVICE_NAME = 'CBH';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://helper.cbhs.com.au/Test/CompareTheMarket/xmlapp.asp', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://helper.cbhs.com.au/CompareTheMarket/xmlapp.asp', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'user', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'CBH-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;

-- ------
-- CUA --
-- ------
SET @SERVICE_NAME = 'CUA';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://testservices.cuahealth.com.au/Service.svc', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://onlineservices.cuahealth.com.au/Service.svc', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'CUA-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'outboundParams', 'keyname=Choosi,keycode=Choosi17', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'NXS', 0, @PROVIDERID, 'outboundParams', 'keyname=Choosi,keycode=CTM27ctm', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'outboundParams', 'keyname=CTM,keycode=CTM27ctm', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;
--  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'soap-action', 'http://HSL.OMS.Public.API.Service/IService/SubmitMembership', @STARTDATE, @ENDDATE, 'SERVICE')

-- --------
-- Frank --
-- --------
SET @SERVICE_NAME = 'FRA';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://staging.api.gmhba.com.au/soap/membership.svc/basic', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://api.gmhba.com.au/soap/membership.svc/basic', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'user', 'comparethemarket', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', 'y$ha6ESw', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'FRA-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;
--  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'soap-action', 'http://tempuri.org/IMembership/SubmitMembershipTransactionUsingSTP', @STARTDATE, @ENDDATE, 'SERVICE'),

-- --------
-- GMHBA --
-- -------
SET @SERVICE_NAME = 'GMH';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://staging.api.gmhba.com.au/SOAP/Membership.svc/basic', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://api.gmhba.com.au/soap/membership.svc/basic', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'user', 'Comparethemarket', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', 'y$ha6ESw', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'GMH-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;
--  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'soap-action', 'http://tempuri.org/IMembership/SubmitMembershipTransactionUsingSTP', @STARTDATE, @ENDDATE, 'SERVICE'),

-- ------
-- HCF --
-- ------
SET @SERVICE_NAME = 'HCF';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://www.uat.hcf.com.au/EAPP/EAPPService.svc/EnrolNewMember', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://www.hcf.com.au/EAPP/EAPPService.svc/EnrolNewMember', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'user', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', 'P@$$w0rd', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'password', 'C@oDm*T7M*', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', '-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'inboundParams', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;
--  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'soap-action', 'https://www.uat.hcf.com.au/EAPP/EAPPService.svc/EnrolNewMember', @STARTDATE, @ENDDATE, 'SERVICE'),

-- ------
-- HIF --
-- ------
SET @SERVICE_NAME = 'HIF';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://testservices.hif.com.au/Service.svc', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://members.hif.com.au/Service.svc', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'user', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'HIF-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'outboundParams', 'keyname=CompareTM,keycode=Compare', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'outboundParams', 'keyname=CompareTM,keycode=Compare456', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'inboundParams', 'bccEmail=ctm.test@hif.com.au', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'inboundParams', 'bccEmail=ctm@hif.com.au', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;
--  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'soap-action', 'http://HSL.OMS.Public.API.Service/IService/SubmitMembership', @STARTDATE, @ENDDATE, 'SERVICE'),

-- ------
-- NIB --
-- ------
SET @SERVICE_NAME = 'NIB';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', 'https://services-review.nib.com.au/brokertest/joinservice.asmx', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'url', 'https://services.nib.com.au/asmx/broker/joinService.asmx', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'user', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', '-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'inboundParams', 'brokerId=45211,password=AD12890C-2BB3-4499-85C6-2F2849D64439', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'inboundParams', 'brokerId=45249,password=AD12890C-2BB3-4499-85C6-2F2849D64439', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;
--  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'soap-action', 'http://www.nib.com.au/Broker/Gateway/Enrol', @STARTDATE, @ENDDATE, 'SERVICE'),

-- --------
-- QCF ----
-- --------
SET @SERVICE_NAME = 'QCH';
SET @PROVIDERID = (SELECT ProviderId FROM provider_properties WHERE PropertyId = 'FundCode' AND Text = @SERVICE_NAME);
INSERT INTO service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceType', 'soap', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'url', '', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'serviceName', @SERVICE_NAME, @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'errorProductCode', 'QCF-ERROR', @STARTDATE, @ENDDATE, 'SERVICE'),
  (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'timeout', '240', @STARTDATE, @ENDDATE, 'SERVICE')
;

-- ------------------------------------------
-- Rollback --
/*
USE ctm;
SET @APPLY_SERVICE = 'healthApplyServiceBER';
SET @VERTICAL_ID = (SELECT verticalId FROM vertical_master WHERE verticalCode = 'HEALTH');
SET @HEALTH_APP_BASE_MASTER_ID = (SELECT serviceMasterId FROM service_master where serviceCode = @APPLY_SERVICE AND verticalId = @VERTICAL_ID);

DELETE FROM service_properties WHERE serviceMasterId = @HEALTH_APP_BASE_MASTER_ID;

DELETE FROM service_master WHERE verticalId = @VERTICAL_ID AND serviceCode = @APPLY_SERVICE;

 */



-- GATEWAY STUFF

-- --------
-- Frank --
-- --------
-- GATEWAY
-- INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'gatewayProvider', 'Westpac', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'tokenUrl', 'https://quickstream.support.qvalent.com/CommunityTokenRequestServlet', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'tokenUrl', 'https://ws.qvalent.com/services/quickweb/CommunityTokenRequestServlet', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'username', 'AHMG', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'password', 'AHMG', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'password', 'K47731xVM', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'registerUrl', 'https://quickstream.support.qvalent.com/AccountRegistrationServlet', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'registerUrl', 'https://quickweb.westpac.com.au/AccountRegistrationServlet', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'cd_community', 'AHMG', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'cd_supplier_business', 'CTM', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'cd_supplier_business', 'AGG', @STARTDATE, @ENDDATE, 'GATEWAY')
-- ;

-- ------
-- HIF --
-- ------
-- GATEWAY
-- INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'gatewayProvider', 'NAB', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'gatewayURL', 'https://testservices.hif.com.au/NAB/HIF_CTM_IFrame.aspx', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'gatewayURL', 'https://members.hif.com.au/NAB/HIF_CTM_Prod_IFrame.aspx', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'domain', 'https://testservices.hif.com.au', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'domain', 'https://members.hif.com.au', @STARTDATE, @ENDDATE, 'GATEWAY')
-- ;

-- ------
-- CUA --
-- ------
-- GATEWAY
-- INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'gatewayProvider', 'NAB', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'gatewayURL', 'https://testservices.cuahealth.com.au/NAB/CUA_CTM_IFrame.aspx', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'gatewayURL', 'https://onlineservices.cuahealth.com.au/NAB/CUA_CTM_Prod_IFrame.aspx', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'domain', 'https://testservices.cuahealth.com.au', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'PRO', 0, @PROVIDERID, 'domain', 'https://onlineservices.cuahealth.com.au', @STARTDATE, @ENDDATE, 'GATEWAY')
-- ;

-- ------
-- CtM --
-- ------
-- GATEWAY
-- INSERT INTO ctm.service_properties (serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope) VALUES
--   (@HEALTH_APP_BASE_MASTER_ID, '0'  , 0, @PROVIDERID, 'gatewayProvider', 'NAB', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'gatewayURL', 'external/hambs/mockPaymentGateway.html', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, @ENV_NXI, 0, @PROVIDERID, 'gatewayURL', 'external/hambs/mockPaymentGateway.html', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, 'LOCALHOST', 0, @PROVIDERID, 'domain', 'http://localhost:8080', @STARTDATE, @ENDDATE, 'GATEWAY'),
--   (@HEALTH_APP_BASE_MASTER_ID, @ENV_NXI, 0, @PROVIDERID, 'domain', 'http://nxi.secure.comparethemarket.com.au', @STARTDATE, @ENDDATE, 'GATEWAY')
-- ;




-- -------
-- QCHF --
-- -------
-- SET @PROVIDERID = 16;







-- Rollback
-- NOTES: Must run in this order (delete service properties before service master.), if you delete the master items first it will be harder to delete then service properties.
/*
SET @HEALTH_APP_BASE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master where serviceCode = 'appService' AND verticalId = '4');

DELETE FROM ctm.service_properties WHERE serviceMasterId = @HEALTH_APP_BASE_MASTER_ID;

DELETE FROM ctm.service_master WHERE verticalId = '4' AND serviceCode IN ('appService');

*/