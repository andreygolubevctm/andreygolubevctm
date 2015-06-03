/*
Customer opt-ins, last 9 months (unsubscribed) for Hot and Cold tables
AB: 2015-04-13 - CRM-332
*/
-- HOT TABLES

SELECT
	tdFirstName.textValue 	AS FirstName,
	optIn.optInTarget 		AS EmailAddress,
	thR.ProductType 		As Vertical,
	CONCAT(	
	    'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical='
			,CASE thR.ProductType WHEN 'QUOTE' THEN 'car' ELSE LCASE(thR.ProductType) END
			,'&email='
			,tdEmail.textValue
			,'&unsubscribe_email='
			,emHash.hashedEmail
			) 				
			AS `unsubscribeURL` 
FROM aggregator.transaction_header thR	
    -- EMAIL
	JOIN aggregator.transaction_details tdEmail ON thR.TransactionId = tdEmail.transactionId
		AND tdEmail.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = thR.transactionId
							 AND xpath LIKE('%/email')
							 AND (textValue LIKE('%@%') 
								 AND textValue !='preload.testing@comparethemarket.com.au' 
								 AND textValue != 'gomez.testing@aihco.com.au' 
								 AND textValue NOT LIKE '%Fake%' 
								 AND textValue NOT LIKE '%SPAM%')
							 LIMIT 1)
	-- First Name
	LEFT JOIN aggregator.transaction_details tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = tdEmail.transactionId
							 AND (xpath like '%/name' OR xpath like '%/firstname')
							 LIMIT 1)
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.ProductType = vm.verticalCode
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optInStatus = 1

	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
	-- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId AND stamp.archive > 0 
	--	AND stamp.`dateTime` > CURDATE() - INTERVAL 1 MONTH    
		AND DATE(stamp.`dateTime`) BETWEEN DATE('2014-07-14') AND DATE('2015-04-14')
WHERE 	
		thR.ProductType in ('CAR','HOMELMI','HOMELOAN','ROADSIDE','LIFE','IP','UTILITIES')
    AND thR.styleCodeId = 1
	

UNION ALL

-- COLD TABLES
SELECT
	tdFirstName.textValue 	AS FirstName,
	optIn.optInTarget 		AS EmailAddress,
	vm.verticalCode			As Vertical,
	CONCAT(	
	    'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical='
			,CASE vm.verticalCode WHEN 'QUOTE' THEN 'car' ELSE LCASE(vm.verticalCode) END
			,'&email='
			,tdEmail.textValue
			,'&unsubscribe_email='
			,emHash.hashedEmail
			) 				
			AS `unsubscribeURL` 
FROM aggregator.transaction_header2_cold thR	
	JOIN aggregator.transaction_details2_cold tdEmail ON thR.TransactionId = tdEmail.transactionId
		AND tdEmail.fieldId = 
							(SELECT fieldId FROM aggregator.transaction_details2_cold
							 WHERE transactionId = thR.transactionId
							 AND fieldId IN(680,709,786,1058,1622,1738)
							 AND (textValue LIKE('%@%') 
								 AND textValue !='preload.testing@comparethemarket.com.au' 
								 AND textValue != 'gomez.testing@aihco.com.au')
							 LIMIT 1)
	LEFT JOIN aggregator.transaction_details2_cold tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.fieldId = 
							(SELECT fieldId FROM aggregator.transaction_details2_cold
							 WHERE transactionId = tdEmail.transactionId
							 AND fieldId IN(681,713,742,793,828,1070,1623)
							 LIMIT 1)
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.verticalId = vm.verticalId
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optIn.optInStatus = 1 AND optIn.stampId != 0 -- Note this is for Opted Outs

	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
    -- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId AND stamp.archive > 0 
-- 	 AND (stamp.`dateTime` >= CURDATE() - INTERVAL 12 MONTH and stamp.`dateTime` <= CURDATE() - INTERVAL 6 MONTH)
 	AND DATE(stamp.`dateTime`) BETWEEN DATE('2014-07-14') AND DATE('2015-04-14')
WHERE 
		thR.verticalId in (3,11,13,1,6,8,5)
    AND thR.styleCodeId = 1
