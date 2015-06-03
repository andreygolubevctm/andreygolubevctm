/*
2015-05-05 - HML-115
*/
-- HOT TABLES only as date range is 2 months

SELECT
	tdFirstName.textValue	AS FirstName,
	optIn.optInTarget 		AS EmailAddress,
	CONCAT
	(   'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical='
		,LCASE(thR.ProductType)
		,'&email='
		,tdEmail.textValue
		,'&unsubscribe_email='
		,emHash.hashedEmail) AS `unsubscribeURL` 
		
FROM aggregator.transaction_header thR	
    -- EMAIL
	JOIN aggregator.transaction_details tdEmail ON thR.TransactionId = tdEmail.transactionId
		AND tdEmail.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = thR.transactionId
							 AND xpath IN('homeloan/contact/email', 'life/contactDetails/email', 'ip/contactDetails/email')
							 AND (	 textValue LIKE('%@%') 
								 AND textValue !='preload.testing@comparethemarket.com.au' 
								 AND textValue != 'gomez.testing@aihco.com.au') 
							 ORDER BY FIELD(xpath,'homeloan/contact/email', 'life/contactDetails/email', 'ip/contactDetails/email')
							 LIMIT 1)
	-- First Name
	LEFT JOIN aggregator.transaction_details tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = tdEmail.transactionId
							 AND xpath IN ('homeloan/contact/firstName', 'life/primary/firstName', 'ip/primary/firstName')
							 ORDER BY FIELD(xpath,'homeloan/contact/firstName', 'life/primary/firstName', 'ip/primary/firstName')
							 LIMIT 1)
							
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.ProductType = vm.verticalCode
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optInStatus = 1
	-- Hash Email
	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
	-- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId AND stamp.archive = 1 
		AND DATE(stamp.`dateTime`) BETWEEN DATE('2015-03-05') AND DATE('2015-05-05')
WHERE 	
		thR.ProductType in ('HOMELOAN','LIFE','IP')
    AND thR.styleCodeId = 1


