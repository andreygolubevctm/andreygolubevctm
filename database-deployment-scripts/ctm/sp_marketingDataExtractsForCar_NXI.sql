-- CREATE THIS AS A STORED PROCEDURE THAT CAN PULL 'MORE' DATA FROM IT IN A MUCH NICER WAY

-- A find out the Min and Max transaction IDs for the period
-- min 8190505
-- max 9357779
-- ALSO what is the CURDATE for double checking

-- MAKE THIS AS A STORED PROCEDURE



/* *************************************
CREATE: CAR 11, 23, 35 month email lists
************************************* */
-- This is made to reference the data entries of multiple date points

USE `ctm`;
DROP procedure IF EXISTS `marketingDataExtractsForCar`;

DELIMITER $$
USE `ctm`$$
CREATE DEFINER=`server`@`%` PROCEDURE `ctm`.`marketingDataExtractsForCar`()
BEGIN


DECLARE $url VARCHAR(256) DEFAULT "http://nxi.secure.comparethemarket.com.au/ctm/"; -- NOTE: needs to be upgraded per environment but is useful for stopping rogue lists
DECLARE $marketingDataExtractsForCar INT DEFAULT 0;

-- get the used dates and the minimum/maximum transactionIds
DECLARE $today DATE DEFAULT CURDATE();

DECLARE $11monthDate DATE DEFAULT $today - INTERVAL 333 DAY;
	DECLARE $11monthDateMin DATE DEFAULT $11monthDate - INTERVAL 30 DAY;
	DECLARE $11monthDateMax DATE DEFAULT $11monthDate + INTERVAL 30 DAY;

DECLARE $23monthDate DATE DEFAULT $11monthDate - INTERVAL 1 YEAR;
	DECLARE $23monthDateMin DATE DEFAULT $23monthDate - INTERVAL 30 DAY;
	DECLARE $23monthDateMax DATE DEFAULT $23monthDate + INTERVAL 30 DAY;

DECLARE $35monthDate DATE DEFAULT $11monthDate - INTERVAL 2 YEAR;
	DECLARE $35monthDateMin DATE DEFAULT  $35monthDate - INTERVAL 30 DAY;
	DECLARE $35monthDateMax DATE DEFAULT  $35monthDate + INTERVAL 30 DAY;

DECLARE	$11monthTransactionIdMin INT UNSIGNED DEFAULT 0;
DECLARE	$11monthTransactionIdMax INT UNSIGNED DEFAULT 0;
DECLARE	$23monthTransactionIdMin INT UNSIGNED DEFAULT 0;
DECLARE	$23monthTransactionIdMax INT UNSIGNED DEFAULT 0;
DECLARE	$35monthTransactionIdMin INT UNSIGNED DEFAULT 0;
DECLARE	$35monthTransactionIdMax INT UNSIGNED DEFAULT 0;


-- Opt Ins
SELECT sT.`dateTime` INTO @lastOptInDate
FROM ctm.marketingOptIn mT
	LEFT JOIN ctm.stamping sT ON mT.stampId = sT.stampID AND sT.archive > 0
	WHERE fieldCategory = 1
	ORDER BY mT.stampId DESC
	LIMIT 1
;

-- BUSINESS RULE: ensure that the marketing Opt-In table is up-to-date, otherwise throw an error
IF @lastOptInDate > NOW() - INTERVAL 2 DAY THEN
	SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Cannot Proceed. The marketing Opt Ins are out of date.';
END IF;


-- TransactionId Ranges
SELECT min(transactionId), max(TransactionId) INTO $11monthTransactionIdMin,$11monthTransactionIdMax
FROM aggregator.transaction_header
	WHERE startDate >= $11monthDateMin AND startDate <= $11monthDateMax
;
SELECT min(transactionId), max(TransactionId) INTO $23monthTransactionIdMin,$23monthTransactionIdMax
FROM aggregator.transaction_header
	WHERE startDate >= $23monthDateMin AND startDate <= $23monthDateMax
;
SELECT min(transactionId), max(TransactionId) INTO $35monthTransactionIdMin,$35monthTransactionIdMax
FROM aggregator.transaction_header
	WHERE startDate >= $35monthDateMin AND startDate <= $35monthDateMax
;


	/* *****************************
	(21) 11,23,35 MONTH CAR EMAIL PROFILES
	***************************** */
	-- Create the 11,23,35 Month Email Segment
	-- If we do not put a throttle around this, we could wind up with a very large query to make

	SELECT
		tdEmail.textValue AS emailAddress,
		carYearlySegments.transactionIdMax AS subscriberKey,
		DATEDIFF($today,carYearlySegments.startDateMin) AS reminderDays,
		1 AS brand,
		2 AS vertical,
		tdName.textValue AS firstName,
		CONCAT($url,'unsubscribe.jsp?vartical=car','&email=',tdEmail.textValue,'&unsubscribe_email=',emHash.hashedEmail) AS unsubscribeURL,
		CONCAT($url,'email/incoming/gateway.json?vertical=car&type=promotion&email=',tdEmail.textValue,'&id=',carYearlySegments.transactionIdMax,'&hash=',emHash.hashedEmail,
			'&cid=',
				CASE carYearlySegments.startDateMin
					WHEN $11monthDate THEN 'em:11m:car'
					WHEN $23monthDate THEN 'em:23m:car'
					WHEN $35monthDate THEN 'em:35m:car'
					ELSE 'em:0m:car'
				END
		)
		AS quoteURL,
		carYearlySegments.startDateMin AS quoteDate,
		carYearlySegments.transactionIdMax AS transactionId,
		tdMake.textValue AS vehicleMake,
		tdModel.textValue AS vehicleModel,
		tdYear.textValue AS vehicleYear,
		optIn.optInStatus AS emailOptIn
	FROM (
		-- GET THE COMPLETE GROUP OF QUOTES TOGETHER
		SELECT
			ms21.transactionId
			,(SELECT max(ms21.transactionId)) AS transactionIdMax
			,(SELECT min(thDates.startDate)) AS startDateMin
		FROM ctm.marketingSegments ms21
			JOIN aggregator.transaction_header thDates USING(transactionId)
		WHERE ms21.marketingSegmentId = 21
			AND (
				(ms21.transactionId >= $11monthTransactionIdMin AND ms21.transactionId <= $11monthTransactionIdMax)
				OR(ms21.transactionId >= $23monthTransactionIdMin AND ms21.transactionId <= $23monthTransactionIdMax)
				OR (ms21.transactionId >= $35monthTransactionIdMin AND ms21.transactionId <= $35monthTransactionIdMax)
			)
			AND thDates.styleCodeID = 1
		GROUP BY ms21.marketingSegmentValueHash
		HAVING startDateMin IN ($11monthDate,$23monthDate,$35monthDate)
	) AS carYearlySegments
		JOIN aggregator.transaction_details tdEmail ON carYearlySegments.transactionId = tdEmail.transactionId AND tdEmail.xpath = 'quote/contact/email'
		JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = 1 AND optInStatus = 1
		JOIN aggregator.transaction_details tdYear ON carYearlySegments.transactionId = tdYear.transactionId AND tdYear.xpath = 'quote/vehicle/year'
		JOIN aggregator.transaction_details tdMake ON carYearlySegments.transactionId = tdMake.transactionId AND tdMake.xpath = 'quote/vehicle/makeDes'
		JOIN aggregator.transaction_details tdModel ON carYearlySegments.transactionId = tdModel.transactionId AND tdModel.xpath = 'quote/vehicle/modelDes'
		LEFT JOIN aggregator.transaction_details tdName ON carYearlySegments.transactionId = tdName.transactionId AND tdName.xpath = 'quote/drivers/regular/firstname'
		LEFT JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = 1
	;

	SET $marketingDataExtractsForCar = FOUND_ROWS();

	-- INSERT: this request into stamping as an auditable table
	INSERT INTO ctm.stamping (`styleCodeId`,`action`,`brand`,`vertical`,`target`,`value`,`comment`,`operatorId`,`datetime`,`IpAddress`)
	VALUES (
		1,'extract_data','ctm','car','marketingDataExtractsForCar',
		CONCAT($11monthDate,', ',$23monthDate,', ',$35monthDate),
		CONCAT($marketingDataExtractsForCar,' Rows Returned'),
		(SELECT CAST(current_user() AS CHAR(45))),
		NOW(),
		(SELECT CAST(host AS CHAR(15)) from information_schema.processlist WHERE ID=connection_id())
	);

END$$

DELIMITER ;