SET @MASTERID = SELECT serviceMasterId FROM ctm.service_master WHERE serviceCode='quoteServiceBER' AND verticalId=2;

UPDATE ctm.service_properties SET servicePropertyValue='10' WHERE servicePropertyKey='timeout' AND servicemasterId=@MASTERID;