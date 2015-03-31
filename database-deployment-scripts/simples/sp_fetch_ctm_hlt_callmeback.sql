USE `simples`;
DROP procedure IF EXISTS `fetch_ctm_hlt_callmeback`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `fetch_ctm_hlt_callmeback`(_sourceId INT)
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
	NULL AS phoneNumber2,
	detailsName.textValue AS contactName,
	detailsState.textValue AS state

FROM 
	(	
		SELECT
			MAX(header.transactionId) AS transactionId,
			header.rootId
 
		FROM aggregator.transaction_header AS header

		-- Transactions will be EXCLUDED if they have these touches
		LEFT JOIN ctm.touches AS touchExclude ON touchExclude.transaction_id = header.TransactionId
		AND touchExclude.type IN ('C')

		WHERE
			-- limit to 2 days to improve the query speed, as well as handle the case 
			-- where we could miss the quote e.g. created at 23:57:00, because we fetch in 10 mins interval,
			-- if only use CURDATE() and we fetchs at 23:55:00 and 00:05:00, 
			-- we could miss all quotes created from 23:55:01 to 23:59:59
			header.startDate >= DATE_SUB(CURDATE(), INTERVAL 1 DAY)
			AND header.PreviousId = 0

			-- CTM Health only
  			AND header.ProductType = 'HEALTH'
			AND header.styleCodeId = 1

		GROUP BY
			header.rootId

		HAVING
			-- Run the touches rules from above
			COUNT(touchExclude.id) = 0

	) H

	-- Has customer opted in?
	LEFT JOIN aggregator.transaction_details AS callbackOptin
		ON H.TransactionId = callbackOptin.transactionId
		AND callbackOptin.xpath = 'health/callmeback/optin'
		AND callbackOptin.textValue = 'Y'

	-- Contact phone numbers
	LEFT JOIN aggregator.transaction_details detailsPhoneMobile
		ON H.transactionId = detailsPhoneMobile.transactionid
		AND detailsPhoneMobile.xpath = 'health/callmeback/phone'

	-- Contact name
	LEFT JOIN aggregator.transaction_details AS detailsName
		ON H.TransactionId = detailsName.transactionId
		AND detailsName.xpath = 'health/callmeback/name'

	-- State
	LEFT JOIN aggregator.transaction_details AS detailsState
		ON H.TransactionId = detailsState.transactionId
		AND detailsState.xpath = 'health/situation/state'

	-- Exclude if they'll be picked up by other message sources (only where: okToCall.transactionid IS NULL)
	LEFT JOIN aggregator.transaction_details AS okToCall
		ON H.transactionId = okToCall.transactionid
		AND okToCall.xpath = 'health/contactDetails/call'
		AND okToCall.textValue = 'Y'

WHERE
	detailsPhoneMobile.textValue IS NOT NULL
	AND detailsPhoneMobile.textValue != ''
	AND okToCall.transactionid IS NULL

-- -----------------------------
-- END QUERY
-- -----------------------------
;

-- Record the end time
UPDATE simples.message_source SET lastExecuteEnd = NOW() WHERE id = _sourceId;

END$$

DELIMITER ;