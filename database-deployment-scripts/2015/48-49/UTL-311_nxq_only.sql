UPDATE ctm.service_properties 
SET servicePropertyValue='http://www.utilityworld.com.au/comparethemarket/response/results_lookup_response_new.php'
WHERE serviceMasterID = (SELECT serviceMasterId FROM service_master WHERE serviceCode='resultsService' 
AND verticalId=5)
AND servicePropertyKey = 'serviceUrl'