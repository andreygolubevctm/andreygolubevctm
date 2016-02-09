SET @id = (SELECT servicePropertiesId FROM ctm.service_properties sp WHERE sp.serviceMasterId = (
  SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode IN ('leadService')
) AND sp.servicePropertyKey='enabled');

-- SELECT @id

UPDATE ctm.service_properties SET servicePropertyValue='true'
WHERE servicePropertiesId = @id
LIMIT 1;

/* TEST: Value should be 'true'

SELECT servicePropertyKey, servicePropertyValue FROM ctm.service_properties sp WHERE sp.serviceMasterId = (
    SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode IN ('leadService')
  ) AND sp.servicePropertyKey='enabled';

*/