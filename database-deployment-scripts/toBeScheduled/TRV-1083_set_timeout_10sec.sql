SET @MASTERID = (SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode='quoteServiceBER' AND verticalId=2);

INSERT INTO ctm.service_properties (`serviceMasterId`, `environmentCode`, `styleCodeId`, `providerId`, `servicePropertyKey`, `servicePropertyValue`, `effectiveStart`, `effectiveEnd`, `scope`)
SELECT @MASTERID, 'PRO', styleCodeId, providerId, servicePropertyKey, 10, effectiveStart, effectiveEnd, scope
  FROM ctm.service_properties WHERE servicePropertyKey='timeout'AND environmentCode='0' AND servicemasterId=@MASTERID;