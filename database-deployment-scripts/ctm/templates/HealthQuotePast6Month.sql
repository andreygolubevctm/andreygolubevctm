/*
Customer for Health only, opt-ins, last 6 months (unsubscribed) for Hot and Cold tables
AB: 2015-04-13 - CRM-332
*/
-- HOT TABLES
SELECT
	tdFirstName.textValue 	AS FirstName,
	optIn.optInTarget 		AS emailAddress,
	tdPolicyType.textValue	AS PolicyType,
	CONCAT(	'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?',
			'vertical=health',
			'&email=',tdEmail.textValue,
			'&unsubscribe_email=',emHash.hashedEmail
			) 				AS `unsubscribeURL` 
FROM aggregator.transaction_header thR	
    -- EMAIL
	JOIN aggregator.transaction_details tdEmail ON thR.TransactionId = tdEmail.transactionId
		AND tdEmail.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = thR.transactionId
							 AND xpath LIKE('%/email')
                             AND (textValue LIKE('%@%') AND textValue !='preload.testing@comparethemarket.com.au' AND textValue != 'gomez.testing@aihco.com.au')
							 -- ordering by the field ensures we have the correct hierarchy, making it descending adds default values to the end, e.g. reversed
							 ORDER BY FIELD(xpath,'health/contactDetails/email','health/application/email','save/email','saved/email') DESC
							 LIMIT 1)
	-- First Name
	LEFT JOIN aggregator.transaction_details tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = tdEmail.transactionId
							 AND (xpath like '%/name' OR xpath like '%/firstname')
							 ORDER BY FIELD(xpath,'health/contact/details/firstName','health/contactDetails/name','health/application/partner/firstname') DESC
							 LIMIT 1)
	-- PolicyType
	JOIN aggregator.transaction_details tdPolicyType ON tdEmail.TransactionId = tdPolicyType.transactionId
		AND tdPolicyType.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = tdEmail.transactionId
							 AND (xpath='health/situation/healthCvr')
							 LIMIT 1)
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.ProductType = vm.verticalCode
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optInStatus = 1

	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
	-- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId AND stamp.archive > 0 
	 AND DATE(stamp.`dateTime`) BETWEEN DATE('2015-03-12') AND DATE('2015-04-12')
	 -- AND stamp.`dateTime` > CURDATE() - INTERVAL 1/*6*/   MONTH    
WHERE 
		thR.productType = 'HEALTH'
    AND thR.styleCodeId = 1
	

UNION ALL

-- COLD TABLES
SELECT
	tdFirstName.`textValue` AS FirstName,
	optIn.optInTarget 		AS emailAddress,
	tdPolicyType.textValue	AS PolicyType,
	CONCAT(	'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?',
			'vertical=health',
			'&email=',tdEmail.textValue,
			'&unsubscribe_email=',emHash.hashedEmail
			) 				AS unsubscribeURL

FROM aggregator.transaction_header2_cold thR	
	-- EMAIL
	JOIN aggregator.transaction_details2_cold tdEmail ON thR.TransactionId = tdEmail.transactionId
		AND tdEmail.fieldId = 
							(SELECT fieldId FROM aggregator.transaction_details2_cold
							 WHERE transactionId = thR.transactionId
							 AND fieldId IN(245,411,531,2272)
                             AND (textValue LIKE('%@%') AND textValue !='preload.testing@comparethemarket.com.au' AND textValue != 'gomez.testing@aihco.com.au')
							 -- ordering by the field ensures we have the correct hierarchy, making it descending adds default values to the end, e.g. reversed
							 ORDER BY FIELD(fieldId,245,411,531,2272) DESC
							 LIMIT 1)
	-- First Name
	LEFT JOIN aggregator.transaction_details2_cold tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.fieldId = 
							(SELECT fieldId FROM aggregator.transaction_details2_cold
							 WHERE transactionId = tdEmail.transactionId
							 AND fieldId IN(294,393,414,416,473,477,487,504,2251,2273,2282)
							 ORDER BY FIELD(fieldId,294,393,414,416,473,477,487,504,2251,2273,2282) DESC
							 LIMIT 1)
	-- PolicyType
	JOIN aggregator.transaction_details2_cold tdPolicyType ON tdEmail.TransactionId = tdPolicyType.transactionId
		AND tdFirstName.fieldId = 
							(SELECT fieldId FROM aggregator.transaction_details2_cold
							 WHERE transactionId = tdEmail.transactionId
							 AND fieldId = 551)
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.verticalId = vm.verticalId
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optIn.optInStatus = 1 AND optIn.stampId != 0 -- Note this is for Opted Outs

	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
    -- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId AND stamp.archive > 0 AND DATE(stamp.`dateTime`) BETWEEN DATE('2015-03-01') AND DATE('2015-03-13') -- AND stamp.`dateTime` > CURDATE() - INTERVAL 6 MONTH
WHERE 
		thR.verticalId = 4
    AND thR.styleCodeId = 1
    
;






