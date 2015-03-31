USE `simples`;
DROP procedure IF EXISTS `fetch_ctm_hlt_singlecouple_under30`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `fetch_ctm_hlt_singlecouple_under30`(_sourceId INT)
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------

-- Record the start time
UPDATE simples.message_source SET lastExecuteStart = NOW() WHERE id = _sourceId;

-- Set up temp table to store the selected transactions
CREATE TEMPORARY TABLE IF NOT EXISTS `temp_simples_fetches` (
	transactionId INT UNSIGNED,
	sourceId INT,
	phoneNumber1 VARCHAR(15),
	phoneNumber2 VARCHAR(15),
	contactName VARCHAR(255),
	state VARCHAR(3)
)
ENGINE=MEMORY;

INSERT INTO `temp_simples_fetches` (transactionId, sourceId, phoneNumber1, phoneNumber2, contactName, state)

-- -----------------------------
-- START QUERY
-- The following section is used to select the transaction for this source
-- -----------------------------
SELECT
	H.rootId,
	_sourceId AS sourceId,
	detailsPhoneMobile.textValue AS phoneNumber1,
	detailsPhoneOther.textValue AS phoneNumber2,
	detailsName.textValue AS contactName,
	detailsState.textValue AS state

FROM 
	(	
		SELECT
			MAX(header.transactionId) AS transactionId,
			header.rootId
 
		FROM aggregator.transaction_header AS header
	 		LEFT JOIN ctm.touches AS touchInclude ON touchInclude.transaction_id = header.TransactionId
	 		AND touchInclude.type IN ('R')
	 		AND touchInclude.operator_id = 'ONLINE'

			-- Transactions will be EXCLUDED if they have these touches
	 		LEFT JOIN ctm.touches AS touchExclude ON touchExclude.transaction_id = header.TransactionId
	 		AND touchExclude.type IN ('A', 'C')

		WHERE
			-- limit to 2 days to improve the query speed, as well as handle the case 
			-- where we could miss the quote e.g. created at 23:57:00, because we fetch in 10 mins interval,
			-- if only use CURDATE() and we fetchs at 23:55:00 and 00:05:00, 
			-- we could miss all quotes created from 23:55:01 to 23:59:59
			header.startDate >= DATE_SUB(CURDATE(), INTERVAL 1 DAY)

			-- CTM Health only
			AND header.ProductType = 'HEALTH'
			AND header.styleCodeId = 1

		GROUP BY
			header.rootId

		HAVING
			-- Run the touches rules from above
			COUNT(touchInclude.id) > 0 AND COUNT(touchExclude.id) = 0

			-- Minimum and maximum time since the relevant touch
			AND TIMESTAMPDIFF(MINUTE, MAX(TIMESTAMP(touchInclude.date, touchInclude.time)), CURRENT_TIMESTAMP()) BETWEEN 1 AND 1440
	) H

	-- Has customer opted in?
	LEFT JOIN aggregator.transaction_details AS okToCall
		ON H.TransactionId = okToCall.transactionId
		AND okToCall.xpath = 'health/contactDetails/call'
		AND okToCall.textValue = 'Y'

	-- Singles and couples
	LEFT JOIN aggregator.transaction_details AS situation
		ON H.TransactionId = situation.transactionId
		AND situation.xpath = 'health/situation/healthCvr'
		AND situation.textValue IN ('S', 'C')

	-- Under 30s
	LEFT JOIN aggregator.transaction_details AS age
		ON H.TransactionId = age.transactionId
		AND age.xpath = 'health/healthCover/primary/dob'

	-- Contact phone numbers
	LEFT JOIN aggregator.transaction_details detailsPhoneMobile
		ON H.transactionId = detailsPhoneMobile.transactionid
		AND detailsPhoneMobile.xpath = 'health/contactDetails/contactNumber/mobile'
	LEFT JOIN aggregator.transaction_details detailsPhoneOther
		ON H.transactionId = detailsPhoneOther.transactionid
		AND detailsPhoneOther.xpath = 'health/contactDetails/contactNumber/other'

	-- Contact name
	LEFT JOIN aggregator.transaction_details AS detailsName
		ON H.TransactionId = detailsName.transactionId
		AND detailsName.xpath = 'health/contactDetails/name'

	-- State
	LEFT JOIN aggregator.transaction_details AS detailsState
		ON H.TransactionId = detailsState.transactionId
		AND detailsState.xpath = 'health/situation/state'

	-- Get the call me back phone
	LEFT JOIN aggregator.transaction_details AS callMeBack
		ON H.TransactionId = callMeBack.transactionId
		AND callMeBack.xpath = 'health/callmeback/phone'

WHERE
	-- Exclude this if the customer requested a call back
	(callMeBack.textValue IS NULL OR callMeBack.textValue = '')

	-- Restrict by age
	AND age.textValue IS NOT NULL
	AND age.textValue != ''
 	AND TIMESTAMPDIFF(YEAR, STR_TO_DATE(age.textValue, '%d/%m/%Y'), CURDATE()) < 30

-- -----------------------------
-- END QUERY
-- -----------------------------
;

-- Record the end time
UPDATE simples.message_source SET lastExecuteEnd = NOW() WHERE id = _sourceId;

END$$

DELIMITER ;