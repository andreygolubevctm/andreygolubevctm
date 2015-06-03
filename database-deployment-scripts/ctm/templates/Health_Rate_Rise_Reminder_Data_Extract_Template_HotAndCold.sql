/*
HLT-2018
A reminder about Health Rate Rise - extract of verticals that have an email address (and current opt-in)
*/

		-- HOT -------------------
SELECT
	tdFirstName.textValue 	AS `FirstName`,
	tdEmail.textValue 		AS `EmailAddress`,	
-- 	th.transactionId	 	AS `transactionId`,
	th.productType 			AS `Vertical`,
	CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?vertical=',
			CASE th.productType WHEN 'QUOTE' THEN 'car' 		ELSE LCASE(th.productType) 	END,
			'&email=',tdEmail.textValue,'&unsubscribe_email=',emHash.hashedEmail,
			CASE th.styleCodeId WHEN 2 		 THEN '&brand=meer' ELSE '' 					END 
			) 				AS `unsubscribeURL`
FROM aggregator.transaction_header th
	-- ADDING IN ALL OF THE JOINS FOR THE ADDITIONAL DATA, ensuring there is only one as often there are multiple variants
	-- Email
	JOIN aggregator.transaction_details tdEmail ON th.TransactionId = tdEmail.transactionId
		AND tdEmail.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = th.transactionId
							 AND xpath LIKE('%/email')
                             AND (textValue LIKE('%@%') AND textValue !='preload.testing@comparethemarket.com.au' AND textValue != 'gomez.testing@aihco.com.au')
							 -- ordering by the field ensures we have the correct hierarchy, making it descending adds default values to the end, e.g. reversed
							 ORDER BY FIELD(xpath,'health/contactDetails/email','save/email','saved/email','life/sendEmail','homeloan/enquiry/contact/email','health/application/email') DESC
							 LIMIT 1)
	-- OptIn
	JOIN ctm.marketingOptIn moi ON th.styleCodeId = moi.styleCodeID AND moi.fieldCategory = 1 AND moi.optInTarget = tdEmail.textValue AND moi.optInStatus = 1
	-- First Name
	LEFT JOIN aggregator.transaction_details tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = tdEmail.transactionId
							 AND (xpath like '%/name' OR xpath like '%/firstname')
							 ORDER BY FIELD(xpath,'utilities/application/details/firstName','ip/primary/firstName','life/primary/firstName','homeloan/contact/firstName','homeloan/enquiry/contact/firstName','home/policyHolder/firstName','quote/drivers/regular/firstname','health/contact/details/firstName','health/contactDetails/name','health/application/partner/firstname') DESC
							 LIMIT 1)
	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = th.styleCodeId
WHERE th.styleCodeId = 1 -- IN (1,2)
	AND th.startDate != CURDATE()
	AND th.productType <> 'HEALTH'
	
UNION 	-- COLD -----------------------

SELECT
	tdFirstName.`textValue` AS FirstName,
	tdEmail.`textValue` 	AS EmailAddress,
-- 	th2c.`transactionId` 	AS transactionId,
	vm.`verticalCode` 		AS Vertical,
	CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?vertical=',
			LCASE(vm.`verticalCode`),
			'&email=',tdEmail.textValue,'&unsubscribe_email=',emHash.hashedEmail,
			CASE th2c.styleCodeId WHEN 2 THEN '&brand=meer' ELSE '' END
			) 				AS unsubscribeURL
FROM aggregator.transaction_header2_cold th2c
	-- ADDING IN ALL OF THE JOINS FOR THE ADDITIONAL DATA, ensuring there is only one as often there are multiple variants
	-- Email
	JOIN aggregator.transaction_details2_cold tdEmail ON th2c.TransactionId = tdEmail.transactionId
		AND tdEmail.fieldId = 
							(SELECT fieldId FROM aggregator.transaction_details2_cold
							 WHERE transactionId = th2c.transactionId
							 AND fieldId IN(531,664,770,857,1439,1740,22,245,411,620,680,709,786,1058,1519,1523,1585,1622,1738,1774,1839,1878,2102,2202,2272,2402)
                             AND (textValue LIKE('%@%') AND textValue !='preload.testing@comparethemarket.com.au' AND textValue != 'gomez.testing@aihco.com.au')
							 -- ordering by the field ensures we have the correct hierarchy, making it descending adds default values to the end, e.g. reversed
							 ORDER BY FIELD(fieldId,fieldId,411,1519,1523,531,664,770,1439,1740,857,2102,245) DESC
							 LIMIT 1)
	-- OptIn
	JOIN ctm.marketingOptIn moi ON th2c.styleCodeId = moi.styleCodeID AND moi.fieldCategory = 1 AND moi.optInTarget = tdEmail.textValue AND moi.optInStatus = 1
	-- Product Type
    JOIN ctm.vertical_master vm ON th2c.verticalId = vm.verticalId
	-- First Name
	LEFT JOIN aggregator.transaction_details2_cold tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.fieldId = 
							(SELECT fieldId FROM aggregator.transaction_details2_cold
							 WHERE transactionId = tdEmail.transactionId
							 AND fieldId IN(393,416,473,477,487,504,1787,2282,2312,28,294,414,621,681,713,742,793,828,1070,1586,1623,1778,2273,2251,2179,2170,2103,1988)
							 ORDER BY FIELD(fieldId,1623,2179,742,828,681,2103,621,1070,416,414,294) DESC
							 LIMIT 1)
	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = th2c.styleCodeId
WHERE th2c.styleCodeId = 1 -- IN (1,2)
	AND th2c.transactionStartDateTime != CURDATE()
	AND th2c.verticalId <> 4
;
	