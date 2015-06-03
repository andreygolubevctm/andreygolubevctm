/*
RBA Home Loan Campaign (DBA-319)

From the CTM database – for the Last 3 months:
	Has obtained a Quote for home & contents, home loan & IP
AND	Has opted-in to receive marketing communications.
AND	Has Email Address
AND	Has FirstName

Output Schema Requirements:
•	First Name
•	email address
•	State
•	City
•	Postcode
•	Vertical
•	Unsubscribe URL

*/


SELECT
	-- tdFirstName.xpath,
	CONCAT(UCASE(SUBSTRING(`tdFirstName`.`textValue`, 1, 1)),LOWER(SUBSTRING(`tdFirstName`.`textValue`, 2))) AS `FirstName`,
	-- tdEmail.xpath,
	tdEmail.textValue AS `EmailAddress`,
	-- tdState.xpath,
	tdState.textValue AS `State`,		
	-- City
	tdSuburb.textValue AS `City`,	
	-- tdPostCode.xpath,
	tdPostCode.textValue AS `PostCode`,
	H.vertical,
-- 	moi.optInStatus,
	CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?vertical=', CASE H.productType WHEN 'QUOTE' THEN 'car'	ELSE LCASE(H.productType) END, '&email=',tdEmail.textValue,'&unsubscribe_email=',emHash.hashedEmail, CASE H.styleCodeId WHEN 2 THEN '&brand=meer' ELSE '' END ) AS `unsubscribeURL`,
	H.transactionId

FROM 
	(	SELECT
			transactionId,
			productType AS `vertical`,
			productType,
			styleCodeId
		FROM aggregator.transaction_header 
		WHERE styleCodeId = 1 -- IN (1,2)
			AND startDate != CURDATE()
			AND startDate >= CURDATE() - INTERVAL 3 MONTH
			AND productType IN ('HOME', 'IP')
	) H

	-- Email -- ordering by the field ensures we have the correct hierarchy, making it descending adds default values to the end, e.g. reversed 
	JOIN aggregator.transaction_details tdEmail ON H.TransactionId = tdEmail.transactionId AND tdEmail.sequenceNo = (	SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionId = H.transactionId AND xpath LIKE('%/email') AND textValue LIKE('%@%.%') ORDER BY FIELD(xpath,'health/contactDetails/email','save/email','saved/email','life/sendEmail','homeloan/enquiry/contact/email','health/application/email') DESC LIMIT 1)
	
	-- OptIn
	JOIN ctm.marketingOptIn moi ON H.styleCodeId = moi.styleCodeID AND moi.fieldCategory = 1 AND moi.optInTarget = tdEmail.textValue AND moi.optInStatus = 1
	
	-- First Name
	LEFT JOIN aggregator.transaction_details tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId AND tdFirstName.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionId = tdEmail.transactionId AND (xpath like '%/name' OR xpath like '%/firstname') ORDER BY FIELD(xpath,'utilities/application/details/firstName','ip/primary/firstName','life/primary/firstName','homeloan/contact/firstName','homeloan/enquiry/contact/firstName','home/policyHolder/firstName','quote/drivers/regular/firstname','health/contact/details/firstName','health/contactDetails/name','health/application/partner/firstname') DESC LIMIT 1)

	-- State										`
	LEFT JOIN aggregator.transaction_details tdState ON tdEmail.TransactionId = tdState.transactionId AND tdState.sequenceNo = (	SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionId = tdEmail.transactionId AND xpath LIKE('%/state') ORDER BY FIELD(xpath,'home/property/address/state','health/situation/state','health/application/address/state') DESC LIMIT 1)   										
										
	-- City (suburb)
	LEFT JOIN aggregator.transaction_details tdSuburb ON H.TransactionId = tdSuburb.transactionID AND tdSuburb.sequenceNo = (SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionID = H.transactionId AND xpath IN (	'homeloan/details/suburb', 'home/property/address/suburb', 'home/property/address/suburbName') LIMIT 1)									
										
	-- PostCode
	LEFT JOIN aggregator.transaction_details tdPostCode ON tdEmail.TransactionId = tdPostCode.transactionId AND tdPostCode.sequenceNo = (	SELECT sequenceNo FROM aggregator.transaction_details WHERE transactionId = tdEmail.transactionId AND xpath LIKE('%/postcode') LIMIT 1)
										
	LEFT JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = H.styleCodeId
