/*
HomeLoans/Utilities Extract for Hot Tables
AB: 2015-02-20 - CRM-339
*/

-- HOT TABLES ONLY
SELECT
	emHash.emailAddress AS emailAddress,
	emHash.emailAddress AS subscriberKey,
	thR.transactionId AS transactionId,
	sc.styleCode AS brand,
	LCASE(vm.verticalCode) AS vertical,
	thR.startDate AS quoteDate,
	tdFirstName.textValue  AS firstName,
	optIn.optInStatus AS emailOptIn,
	CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?unsubscribe_email=',emHash.hashedEmail,'&vertical=',LCASE(vm.verticalCode),'&email=',emHash.EmailAddress) AS unsubscribeURL
FROM aggregator.transaction_header thR
	-- EMAIL
    JOIN aggregator.transaction_details tdEmail ON thR.TransactionId = tdEmail.transactionID AND tdEmail.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath LIKE('%/email') AND textValue LIKE '%@%.%' ORDER BY FIELD(xpath,'utilities/resultsDisplayed/email','utilities/sendEmail','utilities/leadFeed/email',' utilities/application/details/email') DESC LIMIT 1)        
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.ProductType = vm.verticalCode
	-- BRAND
    JOIN ctm.stylecodes sc ON thR.styleCodeId = sc.styleCodeId
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optInStatus = 1
    -- HASH
    JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
    -- FIRST NAME
    LEFT JOIN aggregator.transaction_details tdFirstName ON thR.TransactionId = tdFirstName.transactionID AND tdFirstName.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath IN('utilities/application/details/firstName','utilities/leadFeed/firstName','utilities/resultsDisplayed/firstname') ORDER BY FIELD(xpath,'utilities/resultsDisplayed/firstname','utilities/leadFeed/firstName','utilities/application/details/firstName') DESC LIMIT 1)
WHERE thR.productType = 'UTILITIES'
	AND startDate >= CURDATE() - INTERVAL 2 MONTH
	AND thR.startDate < CURDATE()
    AND thR.styleCodeId = 1
	AND thR.transactionId IN (SELECT tcR.transaction_ID FROM ctm.touches tcR WHERE tcR.transaction_Id = thR.transactionId AND tcR.`type` = 'R') -- This avoids having multiple left joins for 'R' touches
;