/*
Customer Unsubscribes for Health only, last 6 months (unsubscribed) for Hot and Cold tables
AB: 2015-02-20 - CRM-330
*/

-- COLD TABLES
SELECT
	optIn.optInTarget AS emailAddress,
    DATE(stamp.`dateTime`) AS unsubscribeDate,
	thR.transactionId AS transactionId,
	sc.styleCode AS brand,
	LCASE(vm.verticalCode) AS vertical,
	DATE(thR.transactionStartDateTime) AS quoteDate,
	optIn.optInStatus AS emailOptIn
FROM aggregator.transaction_header2_cold thR	
	-- EMAIL
    JOIN aggregator.transaction_details2_cold tdEmail ON thR.TransactionId = tdEmail.transactionID AND thR.verticalId = tdEmail.verticalID AND tdEmail.fieldId = (SELECT fieldId FROM aggregator.transaction_details2_cold WHERE transactionID = thR.transactionId AND verticalId = thR.verticalId AND fieldId IN(2402,411,531,1523,1519,245) AND textValue LIKE '%@%.%' ORDER BY FIELD(fieldId,2402,411,531,1523,1519,245) DESC LIMIT 1)
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.verticalId = vm.verticalId
	-- BRAND
    JOIN ctm.stylecodes sc ON thR.styleCodeId = sc.styleCodeId    
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optIn.optInStatus = 0 AND optIn.stampId != 0 -- Note this is for Opted Outs
    -- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId AND stamp.archive > 0 AND stamp.`dateTime` > CURDATE() - INTERVAL 6 MONTH
WHERE thR.verticalId = 4
    AND thR.styleCodeId = 1
    
UNION ALL

-- HOT TABLES
SELECT
	optIn.optInTarget AS emailAddress,
    DATE(stamp.`dateTime`) AS unsubscribeDate,
	thR.transactionId AS transactionId,
	sc.styleCode AS brand,
	LCASE(vm.verticalCode) AS vertical,
	thR.startDate AS quoteDate,
	optIn.optInStatus AS emailOptIn
FROM aggregator.transaction_header thR	
    -- EMAIL
    JOIN aggregator.transaction_details tdEmail ON thR.TransactionId = tdEmail.transactionID AND tdEmail.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath LIKE('%/email') AND textValue LIKE '%@%.%' ORDER BY FIELD(xpath,'homeloan/contact/email','homeloan/enquiry/contact/email') DESC LIMIT 1)
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.ProductType = vm.verticalCode
	-- BRAND
    JOIN ctm.stylecodes sc ON thR.styleCodeId = sc.styleCodeId
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optInStatus = 1
	-- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId AND stamp.archive > 0 AND stamp.`dateTime` > CURDATE() - INTERVAL 6 MONTH    
WHERE thR.productType = 'HEALTH'
    AND thR.styleCodeId = 1
;