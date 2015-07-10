

-- Updater
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = 3 AND serviceCode = 'carQuoteService');
UPDATE ctm.service_properties SET environmentCode='0' WHERE serviceMasterId=@SERVICE_MASTER_ID AND servicePropertyKey='validationFile' AND environmentCode='LOCALHOST';
/**Tester **/
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = 3 AND serviceCode = 'carQuoteService');
select * from ctm.service_properties where environmentCode = '0' and serviceMasterId = @SERVICE_MASTER_ID and servicePropertyKey = 'validationFile';

/*
-- rollback
SET @SERVICE_MASTER_ID = (SELECT serviceMasterId FROM ctm.service_master WHERE verticalId = 3 AND serviceCode = 'carQuoteService');
UPDATE ctm.service_properties set environmentCode = 'LOCALHOST' where serviceMasterId = @SERVICE_MASTER_ID;
/*

