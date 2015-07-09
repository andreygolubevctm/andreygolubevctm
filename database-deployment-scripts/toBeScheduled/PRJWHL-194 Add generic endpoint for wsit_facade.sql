-- Test -- return 0 results before, 1 after
SELECT * FROM ctm.service_master WHERE serviceCode = 'wsitFacadeService';

-- Run -- 
INSERT INTO `ctm`.`service_master` (`verticalId`, `serviceCode`) VALUES ('0', 'wsitFacadeService');

-- Test -- return 0 results before, 7 after
SELECT * 
FROM ctm.service_properties
WHERE serviceMasterId = (
	SELECT serviceMasterId
    FROM ctm.service_master
    WHERE serviceCode = 'wsitFacadeService'
);


-- Run --
-- Note that these values are the same between PRO and all other environments for now until we properly sort out the dev environments.
-- I have included both so that the PRO config will be ready to go on deploy.
INSERT INTO ctm.service_properties(serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
SELECT serviceMasterId, 'PRO', 0, 0, 'serviceLocation', 'NEEDS_TO_BE_CHANGED', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'
FROM ctm.service_master
WHERE serviceCode = 'wsitFacadeService';

INSERT INTO ctm.service_properties(serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
SELECT serviceMasterId, 'NXS', 0, 0, 'serviceLocation', 'http://192.168.149.44/wsit_facade', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'
FROM ctm.service_master
WHERE serviceCode = 'wsitFacadeService';

INSERT INTO ctm.service_properties(serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
SELECT serviceMasterId, 'NXQ', 0, 0, 'serviceLocation', 'http://192.168.149.44/wsit_facade', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'
FROM ctm.service_master
WHERE serviceCode = 'wsitFacadeService';

INSERT INTO ctm.service_properties(serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
SELECT serviceMasterId, 'NXI', 0, 0, 'serviceLocation', 'http://192.168.149.44/wsit_facade', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'
FROM ctm.service_master
WHERE serviceCode = 'wsitFacadeService';

INSERT INTO ctm.service_properties(serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
SELECT serviceMasterId, 'LOCALHOST', 0, 0, 'serviceLocation', 'http://localhost:8081/wsit_facade', '2014-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'
FROM ctm.service_master
WHERE serviceCode = 'wsitFacadeService';


INSERT INTO ctm.service_properties(serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
SELECT serviceMasterId, '0', 0, 0, 'connectionTimeout', '10000', '2015-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'
FROM ctm.service_master
WHERE serviceCode = 'wsitFacadeService';

INSERT INTO ctm.service_properties(serviceMasterId, environmentCode, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, scope)
SELECT serviceMasterId, '0', 0, 0, 'readTimeout', '20000', '2015-01-01 00:00:00', '2038-01-19 00:00:00', 'SERVICE'
FROM ctm.service_master
WHERE serviceCode = 'wsitFacadeService';