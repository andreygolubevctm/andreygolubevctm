USE `aggregator`;
DROP PROCEDURE IF EXISTS `aggregator`.`update_productCode_hlt_touchTable_procedure1`;


DELIMITER $$
CREATE DEFINER=`server`@`%` PROCEDURE `aggregator`.`update_productCode_hlt_touchTable_procedure1`()
BEGIN
	DECLARE done INT DEFAULT 0;
		DECLARE _textvalue,_message VARCHAR(1000);
		DECLARE _productCode,_productId  VARCHAR(50);
		DECLARE _trxnDate DATETIME;
		DECLARE _touchesId,_transactionId   INT(11);
-- cursor 1 for HOT transaction to check with products
		DECLARE cur1 CURSOR FOR
				SELECT tp.touchesId,td.transactionId,td.textValue,tp.productCode,th.startDate
				FROM ctm.touches_products tp
				JOIN ctm.touches t ON t.id = tp.touchesId
				JOIN aggregator.transaction_header th ON t.transaction_id = th.TransactionId AND th.productType = 'HEALTH'
				LEFT JOIN aggregator.transaction_details td ON td.transactionId = t.transaction_id AND
									xpath = 'health/application/productId';
		 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

		OPEN cur1;
		read_loop: LOOP
			FETCH cur1 INTO _touchesId, _transactionId, _textvalue, _productCode, _trxnDate;
			IF done = 1 THEN
				LEAVE read_loop;
			END IF;
			-- -------------------------------------------------------------------------- replacement of function start ---------------------------
			 if _transactionId is not null  then
						-- if trsnsaction_details record exist then text value must have productID just save that ID
						select REPLACE(_textvalue,'PHIO-HEALTH-','') into _productId;
			  else
					-- if trsnsaction_details record not exist chech into product_master table
					-- case 1: check for all products that are active on  _trxnDate and non expired one (status <> 'X')
					if (select     count(productId )
						from    ctm.product_master
						where    ProductCode = _productCode
								and status <> 'X'
								and productCat='HEALTH'
								and _trxnDate between EffectiveStart and EffectiveEnd) > 0 then 

							select     productId into _productId
								from    ctm.product_master
								where    ProductCode = _productCode
										and status <> 'X'
										and productCat='HEALTH'
										and _trxnDate between EffectiveStart and EffectiveEnd order by productId desc limit 1;
					elseif (select    count(pm.productId )
							from    ctm.product_master pm
							where    ProductCode = _productCode
									and productCat='HEALTH'
									and _trxnDate between EffectiveStart and EffectiveEnd) > 0 then 
							-- case 2: if case 1 fails check for all products that are active on  _trxnDate
									select     pm.productId into _productId
										from    ctm.product_master pm
										where    ProductCode = _productCode
												and productCat='HEALTH'
												and _trxnDate between EffectiveStart and EffectiveEnd order by productId desc limit 1;
					elseif (select     count(productId) from    ctm.product_master
								where    ProductCode = _productCode
										 and productCat='HEALTH') > 0 then 
								-- case 3: if case 2 fails then search all the products
								select     productId into _productId
								from    ctm.product_master
								where    ProductCode = _productCode
										 and productCat='HEALTH'
								order by productId desc limit 1;
					end if;
				end if;
				-- update touches_product table a productID fround from all above case
				  IF _productId is not null then

						update ctm.touches_products
						set productCode = _productId
						where touchesId = _touchesId;
						SET _message = 'Success';

				  else
				-- else return operation failed with touch ID
						SET _message = concat('Failed : ',_touchesId);

				  end if;
-- -------------------------------------------------------------------------- replacement of function end ---------------------------
			if _message <> 'Success' then
				 CALL logging.doLog(concat('upd_tch :',_message),'MK-20002');
				 CALL logging.saveLog();
			end if;
			set _productId = null;
	END LOOP read_loop;
	CLOSE cur1;



END$$
DELIMITER ;