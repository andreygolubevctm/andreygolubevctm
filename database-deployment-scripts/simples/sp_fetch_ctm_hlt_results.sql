USE `simples`;
DROP procedure IF EXISTS `fetch_ctm_hlt_results`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `fetch_ctm_hlt_results`(_sourceId INT)
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
	MAX(detailsPhoneOther.textValue) AS phoneNumber2,
	MAX(detailsName.textValue) AS contactName,
	MAX(detailsState.textValue) AS state

FROM aggregator.transaction_header AS header

	-- Transactions will be INCLUDED if they have these touches
	-- ONLINE restriction is used to knock out call centre transactions.
	LEFT JOIN ctm.touches AS touchInclude ON touchInclude.transaction_id = header.TransactionId
		AND touchInclude.type IN ('R')
		AND touchInclude.operator_id = 'ONLINE'

	-- Transactions will be EXCLUDED if they have these touches
	LEFT JOIN ctm.touches AS touchExclude ON touchExclude.transaction_id = header.TransactionId
		AND touchExclude.type IN ('A', 'C')

	-- Has customer opted in?
	LEFT JOIN aggregator.transaction_details AS okToCall
		ON header.TransactionId = okToCall.transactionId
		AND okToCall.xpath = 'health/contactDetails/call'
		AND okToCall.textValue = 'Y'

	-- Why is this one needed?
	/*
	LEFT JOIN aggregator.transaction_details AS situation
		ON header.TransactionId = situation.transactionId
		AND situation.xpath = 'health/situation/healthCvr'
		AND situation.textValue IN ('S', 'C', 'F', 'SPF')
	*/

	-- Contact phone numbers
	LEFT JOIN aggregator.transaction_details detailsPhoneMobile
		ON header.transactionId = detailsPhoneMobile.transactionid
		AND detailsPhoneMobile.xpath = 'health/contactDetails/contactNumber/mobile'
	LEFT JOIN aggregator.transaction_details detailsPhoneOther
		ON header.transactionId = detailsPhoneOther.transactionid
		AND detailsPhoneOther.xpath = 'health/contactDetails/contactNumber/other'

	-- Contact name
	LEFT JOIN aggregator.transaction_details AS detailsName
		ON header.TransactionId = detailsName.transactionId
		AND detailsName.xpath = 'health/contactDetails/name'

	-- State
	LEFT JOIN aggregator.transaction_details AS detailsState
		ON header.TransactionId = detailsState.transactionId
		AND detailsState.xpath = 'health/situation/state'

	-- Get the call me back phone
	LEFT JOIN aggregator.transaction_details AS callMeBack
		ON header.TransactionId = callMeBack.transactionId
		AND callMeBack.xpath = 'health/callmeback/phone'

	-- Get the tracking CID
	LEFT JOIN aggregator.transaction_details AS trackingCID
		ON header.TransactionId = trackingCID.transactionId
		AND trackingCID.xpath = 'health/tracking/cid'

WHERE
	header.TransactionId >= _tranIdMarker
	AND header.rootId >= _tranIdMarker

	-- CTM Health only
	AND header.ProductType = 'HEALTH'
	AND header.styleCodeId = 1

	-- Exclude this if the customer requested a call back
	AND (callMeBack.textValue IS NULL OR callMeBack.textValue = '')

	-- Exclude this if the customer came from a particular offer (is this still relevant?)
	AND (trackingCID.textValue IS NULL OR trackingCID.textValue != 'em:cm:offer')

GROUP BY
	header.rootId, sourceId

 HAVING
 	-- Run the touches rules from above
  	COUNT(touchInclude.id) > 0 AND COUNT(touchExclude.id) = 0

  	-- Minimum and maximum time since the relevant touch
	AND TIMESTAMPDIFF(MINUTE, MAX(TIMESTAMP(touchInclude.date, touchInclude.time)), CURRENT_TIMESTAMP()) BETWEEN 1 AND 1440

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