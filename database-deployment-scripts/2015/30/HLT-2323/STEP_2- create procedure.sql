USE `aggregator`;
DROP PROCEDURE IF EXISTS `aggregator`.`update_productCode_hlt_touchTable_procedure`;


DELIMITER $$
CREATE DEFINER=`server`@`%` PROCEDURE `aggregator`.`update_productCode_hlt_touchTable_procedure`()
BEGIN
	DECLARE done INT DEFAULT false;
		DECLARE _textvalue,_functionOutput VARCHAR(1000);
		DECLARE _productCode VARCHAR(50);
		DECLARE _trxnDate DATE;
		DECLARE _touchesId,_transactionId   INT(11);
-- cursor 1 for HOT transaction to check with products
		DECLARE cur1 CURSOR FOR
				SELECT tp.touchesId,td.transactionId,td.textValue,tp.productCode,th.startDate
				FROM ctm.touches_products tp
				JOIN ctm.touches t ON t.id = tp.touchesId
				JOIN aggregator.transaction_header th ON t.transaction_id = th.TransactionId AND th.productType = 'HEALTH'
				LEFT JOIN aggregator.transaction_details td ON td.transactionId = t.transaction_id AND
									xpath = 'health/application/productId';
-- cursor 1 for COLD transaction to check with products
		DECLARE cur2 CURSOR FOR
				  select tp.touchesId,td.transactionId,td.textValue,tp.productCode ,th.transactionStartDateTime
				  from ctm.touches_products tp
				  join ctm.touches t on t.id = tp.touchesId
				  join aggregator.transaction_header2_cold th on t.transaction_id = th.TransactionId and th.verticalId = 4
				  LEFT join aggregator.transaction_details2_cold td on td.transactionId = t.transaction_id and td.fieldId=299;

		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

		OPEN cur1;
		read_loop: LOOP
			FETCH cur1 INTO _touchesId, _transactionId, _textvalue, _productCode, _trxnDate;
			IF done THEN
				LEAVE read_loop;
			END IF;
			select aggregator.update_productCode_hlt_touchTable_function(_touchesId, _transactionId, _textvalue, _productCode,_trxnDate)
			into _functionOutput;
			if _functionOutput <> 'Success' then
				 CALL logging.doLog(concat('upd_tch :',_functionOutput),'MK-20002');
				 CALL logging.saveLog();
			end if;

	END LOOP;
	CLOSE cur1;

    SET done = FALSE;
		OPEN cur2;
		read_loop: LOOP
			FETCH cur2 INTO _touchesId, _transactionId, _textvalue, _productCode, _trxnDate;
			IF done THEN
				LEAVE read_loop;
			END IF;

			select aggregator.update_productCode_hlt_touchTable_function(_touchesId, _transactionId, _textvalue, _productCode,_trxnDate)
			into _functionOutput;
			if _functionOutput <> 'Success' then
				 CALL logging.doLog(concat('upd_tch :',_functionOutput),'MK-20002');
				 CALL logging.saveLog();
			end if;
		END LOOP;
		CLOSE cur2;


END$$
DELIMITER ;
