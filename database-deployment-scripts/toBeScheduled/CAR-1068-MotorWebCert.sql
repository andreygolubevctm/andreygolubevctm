/* Test */
SELECT * from ctm.service_properties
WHERE serviceMasterId = (SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode = 'motorwebRegoLookupService') and servicePropertyKey = 'certificate';

UPDATE service_properties SET servicePropertyValue = 'WEB-INF/classes/motorweb-certificate.p12'
WHERE serviceMasterId = (SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode = 'motorwebRegoLookupService') and servicePropertyKey = 'certificate';

