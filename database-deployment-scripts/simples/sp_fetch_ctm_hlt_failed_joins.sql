USE `simples`;
DROP procedure IF EXISTS `fetch_ctm_hlt_failed_joins`;

DELIMITER $$
USE `simples`$$
CREATE DEFINER=`server`@`%` PROCEDURE `fetch_ctm_hlt_failed_joins`(_sourceId INT)
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
	CONCAT(MAX(detailsName.textValue), ' ', MAX(detailsSurname.textValue)) AS contactName,
	MAX(detailsState.textValue) AS state

FROM aggregator.transaction_header AS header

	-- Transactions will be INCLUDED if they have these touches
	-- ONLINE restriction is used to knock out call centre transactions.
	LEFT JOIN ctm.touches AS touchInclude ON touchInclude.transaction_id = header.TransactionId
		AND touchInclude.type IN ('F')
		AND touchInclude.operator_id = 'ONLINE'

	-- Transactions will be EXCLUDED if they have these touches
	LEFT JOIN ctm.touches AS touchExclude ON touchExclude.transaction_id = header.TransactionId
		AND touchExclude.type IN ('C')

	-- Contact phone numbers
	LEFT JOIN aggregator.transaction_details detailsPhoneMobile
		ON header.transactionId = detailsPhoneMobile.transactionid
		AND detailsPhoneMobile.xpath = 'health/application/mobile'
	LEFT JOIN aggregator.transaction_details detailsPhoneOther
		ON header.transactionId = detailsPhoneOther.transactionid
		AND detailsPhoneOther.xpath = 'health/contactDetails/contactNumber/other'

	-- Contact name
	LEFT JOIN aggregator.transaction_details AS detailsName
		ON header.TransactionId = detailsName.transactionId
		AND detailsName.xpath = 'health/application/primary/firstname'
	LEFT JOIN aggregator.transaction_details AS detailsSurname
		ON header.TransactionId = detailsSurname.transactionId
		AND detailsSurname.xpath = 'health/application/primary/surname'

	-- State
	LEFT JOIN aggregator.transaction_details AS detailsState
		ON header.TransactionId = detailsState.transactionId
		AND detailsState.xpath = 'health/situation/state'

WHERE
	header.TransactionId >= _tranIdMarker
	AND header.rootId >= _tranIdMarker

	-- CTM Health only
	AND header.ProductType = 'HEALTH'
	AND header.styleCodeId = 1

	-- Shaun's list; what are these?
	AND header.IpAddress NOT IN ('114.111.151.218','202.177.206.170','63.128.6.197',
		'206.31.247.235','206.31.247.241','206.31.247.249','64.95.77.131',
		'64.95.77.131','64.95.77.131','206.31.247.245','206.31.247.236',
		'206.31.247.228','206.31.247.245')

 GROUP BY
	header.rootId, sourceId

 HAVING
 	-- Run the touches rules from above
  	COUNT(touchInclude.id) > 0 AND COUNT(touchExclude.id) = 0

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