/*
HomeLoans Extract for Hot and Cold tables
AB: 2015-02-20 - DBA-242
*/

-- COLD TABLES
SELECT
	emHash.emailAddress AS emailAddress,
	emHash.emailAddress AS subscriberKey,
	thR.transactionId AS transactionId,
	sc.styleCode AS brand,
	vm.verticalCode AS vertical,
	DATE(thR.transactionStartDateTime) AS quoteDate,
	tdFirstName.textValue  AS firstName,
	tdLastName.textValue  AS lastName,
	tdSuburb.textValue AS suburb,
	tdState.textValue AS state,
	tdPostCode.textValue AS postCode,
	optIn.optInStatus AS emailOptIn,
	CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?unsubscribe_email=',emHash.hashedEmail,'&vertical=',LCASE(vm.verticalCode),'&email=',emHash.emailAddress) AS unsubscribeURL
FROM aggregator.transaction_header2_cold thR
	-- EMAIL
    JOIN aggregator.transaction_details2_cold tdEmail ON thR.TransactionId = tdEmail.transactionID AND thR.verticalId = tdEmail.verticalID AND tdEmail.fieldId = (SELECT fieldId FROM aggregator.transaction_details2_cold WHERE transactionID = thR.transactionId AND verticalId = thR.verticalId AND fieldId IN(1519,1523,680,2102) AND textValue LIKE '%@%.%' ORDER BY FIELD(fieldId,680,2102) DESC LIMIT 1)
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.verticalId = vm.verticalId
	-- BRAND
    JOIN ctm.stylecodes sc ON thR.styleCodeId = sc.styleCodeId
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optInStatus = 1    
    -- HASH
    JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
    -- SUBURB
    LEFT JOIN aggregator.transaction_details2_cold tdSuburb ON tdSuburb.transactionID = thR.TransactionId AND tdSuburb.verticalID = thR.verticalId AND tdSuburb.fieldId = 688
    -- STATE
    LEFT JOIN aggregator.transaction_details2_cold tdState ON tdState.transactionID = thR.TransactionId AND tdState.verticalID = thR.verticalId AND tdState.fieldId = 687
    -- POSTCODE
    LEFT JOIN aggregator.transaction_details2_cold tdPostCode ON tdPostCode.transactionID = thR.TransactionId AND tdPostCode.verticalID = thR.verticalId AND tdPostCode.fieldId = 685
    -- FIRST NAME
    LEFT JOIN aggregator.transaction_details2_cold tdFirstName ON tdFirstName.transactionID = thR.TransactionId AND tdFirstName.verticalID = thR.verticalId AND tdFirstName.fieldId = 681
	-- LAST NAME
    LEFT JOIN aggregator.transaction_details2_cold tdLastName ON tdLastName.transactionID = thR.TransactionId AND tdLastName.verticalID = thR.verticalId AND tdLastName.fieldId = 682
WHERE thR.verticalId = 13
	AND thR.transactionStartDateTime < CURDATE()
    AND thR.styleCodeId = 1
	AND thR.transactionId IN (SELECT tcR.transaction_ID FROM ctm.touches tcR WHERE tcR.transaction_Id = thR.transactionId AND tcR.`type` = 'R') -- This avoids having multiple left joins for 'R' touches
    
UNION ALL

-- HOT TABLES
SELECT
	emHash.emailAddress AS emailAddress,
	emHash.emailAddress AS subscriberKey,
	thR.transactionId AS transactionId,
	sc.styleCode AS brand,
	vm.verticalCode AS vertical,
	thR.startDate AS quoteDate,
	tdFirstName.textValue  AS firstName,
	tdLastName.textValue  AS lastName,
	tdSuburb.textValue AS suburb,
	tdState.textValue AS state,
	tdPostCode.textValue AS postCode,
	optIn.optInStatus AS emailOptIn,
	CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?unsubscribe_email=',emHash.hashedEmail,'&vertical=',LCASE(vm.verticalCode),'&email=',emHash.EmailAddress) AS unsubscribeURL
FROM aggregator.transaction_header thR
	-- EMAIL
    JOIN aggregator.transaction_details tdEmail ON thR.TransactionId = tdEmail.transactionID AND tdEmail.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath LIKE('%/email') AND textValue LIKE '%@%.%' ORDER BY FIELD(xpath,'homeloan/contact/email','homeloan/enquiry/contact/email') DESC LIMIT 1)
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.ProductType = vm.verticalCode
	-- BRAND
    JOIN ctm.stylecodes sc ON thR.styleCodeId = sc.styleCodeId
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optInStatus = 1
    -- HASH
    JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
	-- SUBURB
    LEFT JOIN aggregator.transaction_details tdSuburb ON thR.TransactionId = tdSuburb.transactionID AND tdSuburb.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath = 'homeloan/details/suburb' LIMIT 1)            
    -- STATE
    LEFT JOIN aggregator.transaction_details tdState ON thR.TransactionId = tdState.transactionID AND tdState.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath = 'homeloan/details/state' LIMIT 1)
    -- POSTCODE
    LEFT JOIN aggregator.transaction_details tdPostCode ON thR.TransactionId = tdPostCode.transactionID AND tdPostCode.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath = 'homeloan/details/postcode' LIMIT 1)    
	-- FIRST NAME
    LEFT JOIN aggregator.transaction_details tdFirstName ON thR.TransactionId = tdFirstName.transactionID AND tdFirstName.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath = 'homeloan/contact/firstName' LIMIT 1)
	-- LAST NAME
    LEFT JOIN aggregator.transaction_details tdLastName ON thR.TransactionId = tdLastName.transactionID AND tdLastName.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = thR.transactionId AND xpath = 'homeloan/contact/lastName' LIMIT 1)        
WHERE thR.productType = 'HOMELOAN'
	AND thR.startDate != CURDATE()
    AND thR.styleCodeId = 1
	AND thR.transactionId IN (SELECT tcR.transaction_ID FROM ctm.touches tcR WHERE tcR.transaction_Id = thR.transactionId AND tcR.`type` = 'R') -- This avoids having multiple left joins for 'R' touches
;