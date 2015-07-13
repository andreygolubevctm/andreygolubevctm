USE `aggregator`;
DROP function IF EXISTS `update_productCode_hlt_touchTable_function`;


DELIMITER $$
CREATE DEFINER=`server`@`%` FUNCTION `aggregator`.`update_productCode_hlt_touchTable_function`( _touchesId  INT(11),
_transactionId   INT(11),_textvalue VARCHAR(1000),_productCode VARCHAR(50), _trxnDate date


) RETURNS varchar(1000) CHARSET latin1
BEGIN
DECLARE _productId VARCHAR(50);
DECLARE _message VARCHAR(1000);

	  if _transactionId is not null  then
			-- if trsnsaction_details record exist then text value must have productID just save that ID
			select REPLACE(_textvalue,'PHIO-HEALTH-','') into _productId;
			SET _message = 'Success';
	  else
			-- if trsnsaction_details record not exist chech into product_master table
			-- case 1: check for all products that are active on  _trxnDate and non expired one (status <> 'X')
			select     productId into _productId
				from    ctm.product_master
				where    ProductCode = _productCode
						and status <> 'X'
						and productCat='HEALTH'
						and _trxnDate between EffectiveStart and EffectiveEnd order by productId desc limit 1;
			SET _message = 'Success';

			if _productId is null then
					-- case 2: if case 1 fails check for all products that are active on  _trxnDate
					select     pm.productId into _productId
						from    ctm.product_master pm
						where    ProductCode = _productCode
								and productCat='HEALTH'
								and _trxnDate between EffectiveStart and EffectiveEnd order by productId desc limit 1;
					SET _message = 'Success';

					if _productId is null then
						-- case 3: if case 2 fails then search all the products
						select     productId into _productId
						from    ctm.product_master
						where    ProductCode = _productCode
							     and productCat='HEALTH'
						order by productId desc limit 1;
						SET _message = 'Success';

					end if;
			end if;
	  end IF;
	-- update touches_product table a productID fround from all above case
	  IF _productId is not null then

			update ctm.touches_products
			set productCode = _productId
			where touchesId = _touchesId;

	  else
    -- else return operation failed with touch ID
			SET _message = concat('Failed : ',_touchesId);

	  end if;

	RETURN _message;
END$$
DELIMITER ;
