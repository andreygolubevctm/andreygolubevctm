SET @CREDITCARD = 'CREDITCARD';

 -- UPDATE ctm.service_properties SET environmentCode='0' WHERE serviceMasterId=@SERVICE_MASTER_ID AND servicePropertyKey='validationFile' AND environmentCode='LOCALHOST' limit 1;
update ctm.product_master set effectiveEnd = '2015-12-07'
 where productCat = @CREDITCARD and productCode in ('BNKW-FF','BNKW-FFG','BNKW-FFP') limit 3;

-- expect 3
select count(*) from ctm.product_master where ProductCat = @CREDITCARD and productCode in ('BNKW-FF','BNKW-FFG','BNKW-FFP');

-- rollback
/*
update ctm.product_master set effectiveEnd = '2040-12-31'
 where productCat = @CREDITCARD and productCode in ('BNKW-FF','BNKW-FFG','BNKW-FFP') limit 3;
 */


