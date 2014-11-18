-- Populate via the stored procedure
USE `ctm`;
DROP procedure IF EXISTS `populateMarketingSegments`;

DELIMITER $$
USE `ctm`$$
CREATE DEFINER=`server`@`%` PROCEDURE `ctm`.`populateMarketingSegments`()
BEGIN

-- Declaring the variables for being used
DECLARE $today DATE DEFAULT CURDATE();
DECLARE $carTransactionIdMinimum INT DEFAULT 0;


	/* *****************************
	(21) 11 MONTH CAR EMAIL PROFILES
	***************************** */
	-- Create the 11 Month Email Segment
	-- If we do not put a throttle around this, we could wind up with a very large query to make
	SET $carTransactionIdMinimum = (SELECT IFNULL(max(transactionId), 0) FROM ctm.marketingSegments WHERE marketingSegmentId = 21);

	INSERT INTO `ctm`.`marketingSegments`
	(transactionId,marketingSegmentId,marketingSegmentValueHash,marketingSegmentDataHash)
		SELECT
			thR.transactionId,
			21 AS marketingSegmentId,
			SHA1(CONCAT(tdEmail.textValue,tdMake.textValue,tdModel.textValue)) AS marketingSegmentValue,
			NULL AS marketingSegmentData
		FROM aggregator.transaction_header thR
			-- email with a slight business rule
			-- the following selects are using sequenceNo to remove the fact we may have multiple xpaths, due to the primary key
			JOIN aggregator.transaction_details tdEmail ON thR.TransactionId = tdEmail.transactionID AND tdEmail.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath IN('quote/contact/email','save/email') AND textValue LIKE '%@%.%' ORDER BY xpath DESC LIMIT 1)
			JOIN aggregator.transaction_details tdMake ON thR.TransactionId = tdMake.transactionId AND tdMake.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath = 'quote/vehicle/make' LIMIT 1)
			JOIN aggregator.transaction_details tdModel ON thR.TransactionId = tdModel.transactionId AND tdModel.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath = 'quote/vehicle/model' LIMIT 1)
			LEFT JOIN aggregator.transaction_details tdCid ON thR.TransactionId = tdCid.transactionId AND tdCid.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath like '%/cid' LIMIT 1)
		WHERE thR.transactionId > $carTransactionIdMinimum
		AND thR.startDate != $today
		AND thR.productType IN ('CAR','QUOTE')
		AND thR.transactionId IN (SELECT tcR.transaction_ID FROM ctm.touches tcR WHERE tcR.transaction_Id = thR.transactionId AND tcR.`type` = 'R') -- This avoids having multiple left joins for 'R' touches
		AND (tdCid.textValue IS NULL OR tdCid.textValue NOT IN ('em:11m:car','em:23m:car','em:35m:car','em:23m:car')) -- CAR-740 (analytics tracking codes)
		LIMIT 100000 -- This should be the theoretical maximum for one day's worth of car quotes - which would be more than enough for a 'percentage' of the marketing segment
		;

	-- This the final output of the affected rows
	SELECT ROW_COUNT() AS car11MonthEmailSegments;

END$$

DELIMITER ;
