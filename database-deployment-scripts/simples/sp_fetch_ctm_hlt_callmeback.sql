USE `simples`;
DROP procedure IF EXISTS `fetch_ctm_hlt_callmeback`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `fetch_ctm_hlt_callmeback`(_sourceId INT)
BEGIN
-- -----------------------------
-- NOTE: Please ensure that any changes to this procedure are recorded via SVN.
-- -----------------------------

DECLARE _tranIdMarker INT UNSIGNED;

-- Record the start time
UPDATE simples.message_source SET lastExecuteStart = NOW() WHERE id = _sourceId;

-- Get the marker to improve selection speed
SELECT tranIdMarker INTO _tranIdMarker FROM simples.message_source WHERE id = _sourceId;

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
	header.rootId,
	_sourceId AS sourceId,
	MAX(detailsPhoneMobile.textValue) AS phoneNumber1,
	NULL AS phoneNumber2,
	MAX(detailsName.textValue) AS contactName,
	MAX(detailsState.textValue) AS state

FROM aggregator.transaction_header AS header

	-- Transactions will be EXCLUDED if they have these touches
	LEFT JOIN ctm.touches AS touchExclude ON touchExclude.transaction_id = header.TransactionId
		AND touchExclude.type IN ('C')

	-- Has customer opted in?
	LEFT JOIN aggregator.transaction_details AS callbackOptin
		ON header.TransactionId = callbackOptin.transactionId
		AND callbackOptin.xpath = 'health/callmeback/optin'
		AND callbackOptin.textValue = 'Y'

	-- Contact phone numbers
	LEFT JOIN aggregator.transaction_details detailsPhoneMobile
		ON header.transactionId = detailsPhoneMobile.transactionid
		AND detailsPhoneMobile.xpath = 'health/callmeback/phone'

	-- Contact name
	LEFT JOIN aggregator.transaction_details AS detailsName
		ON header.TransactionId = detailsName.transactionId
		AND detailsName.xpath = 'health/callmeback/name'

	-- State
	LEFT JOIN aggregator.transaction_details AS detailsState
		ON header.TransactionId = detailsState.transactionId
		AND detailsState.xpath = 'health/situation/state'

WHERE
	header.TransactionId >= _tranIdMarker
	AND header.rootId >= _tranIdMarker

	AND header.StartDate >= CURDATE()
	AND header.PreviousId = 0

	-- CTM Health only
	AND header.ProductType = 'HEALTH'
	AND header.styleCodeId = 1

	AND detailsPhoneMobile.textValue IS NOT NULL
	AND detailsPhoneMobile.textValue != ''

	-- Exclude if they'll be picked up by other message sources
	AND NOT EXISTS (
		SELECT okToCall.transactionid FROM aggregator.transaction_details AS okToCall
		WHERE header.transactionId = okToCall.transactionid
		AND okToCall.xpath = 'health/contactDetails/call'
		AND okToCall.textValue = 'Y'
	)

GROUP BY
	header.rootId, sourceId

 HAVING
 	-- Run the touches rules from above
  	COUNT(touchExclude.id) = 0

-- -----------------------------
-- END QUERY
-- -----------------------------
;

-- Record a marker to improve speed next time this is run
UPDATE simples.message_source SET lastExecuteEnd = NOW(), tranIdMarker = (
	SELECT IFNULL(MIN(transactionId), _tranIdMarker)
	FROM `temp_simples_fetches`
	WHERE sourceId = _sourceId
) WHERE id = _sourceId;

END$$

DELIMITER ;