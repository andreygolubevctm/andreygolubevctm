/*
Customer opt-ins, Travel, last 6 months (unsubscribed) for Hot and Cold tables
AB: 2015-04-16 - DBA-330
*/




-- -------------------------------------------------------------------------------
-- The version with temp tables (runs on Master Server)
-- -------------------------------------------------------------------------------


-- HOT TABLES

SELECT
	tdFirstName.textValue	AS FirstName,
	optIn.optInTarget 		AS EmailAddress,
	tdPolicyType.textValue 	As PolicyType,
	optIn.optInTarget 		As SubscriberKey,
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
							 AND xpath ='travel/email'
							 AND (textValue LIKE('%@%') 
								 AND textValue !='preload.testing@comparethemarket.com.au' 
								 AND textValue != 'gomez.testing@aihco.com.au' 
								 AND textValue NOT LIKE '%Fake%' 
								 AND textValue NOT LIKE '%SPAM%') LIMIT 1)
	-- First Name
	LEFT JOIN aggregator.transaction_details tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = tdEmail.transactionId
							 AND xpath ='travel/firstName'  LIMIT 1)
	-- Policy Type
	LEFT JOIN aggregator.transaction_details tdPolicyType ON tdEmail.TransactionId = tdPolicyType.transactionId
		AND tdPolicyType.sequenceNo = 
							(SELECT sequenceNo FROM aggregator.transaction_details
							 WHERE transactionId = tdEmail.transactionId
							 AND xpath = 'travel/policyType' LIMIT 1)							 
    -- OPTIN
  JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget AND optIn.fieldCategory = 1 AND optIn.styleCodeId = thR.styleCodeId AND optInStatus = 1
	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress AND emHash.StyleCodeId = thR.styleCodeId
	-- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId AND stamp.archive > 0 
	--	AND stamp.`dateTime` > CURDATE() - INTERVAL 1 MONTH    
		AND DATE(stamp.`dateTime`) BETWEEN DATE('2014-10-16') AND DATE('2015-04-16')
WHERE 	
		thR.ProductType in ('Travel')
    AND thR.styleCodeId = 1
	

UNION

-- COLD TABLES
SELECT
	tdFirstName.textValue 	AS FirstName,
	optIn.optInTarget 		AS EmailAddress,
	tdPolicyType.textValue 	As PolicyType,
	optIn.optInTarget 		As SubscriberKey,
	CONCAT(
			'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical='
			,LCASE(vm.verticalCode) 
			,'&email='
			,tdEmail.textValue
			,'&unsubscribe_email='
			,emHash.hashedEmail
			)  				AS `unsubscribeURL` 

FROM aggregator.transaction_header2_cold thR	
	JOIN aggregator.transaction_details2_cold tdEmail ON thR.TransactionId = tdEmail.transactionId
		AND tdEmail.fieldId = 1585
		and  (textValue LIKE('%@%') 
			 AND textValue !='preload.testing@comparethemarket.com.au' 
			 AND textValue !='gomez.testing@aihco.com.au') 
	-- First Name								 
	LEFT JOIN aggregator.transaction_details2_cold tdFirstName ON tdEmail.TransactionId = tdFirstName.transactionId
		AND tdFirstName.fieldId = 1586
	-- Policy Type
	LEFT JOIN aggregator.transaction_details2_cold tdPolicyType ON tdEmail.TransactionId = tdPolicyType.transactionId
		AND tdPolicyType.fieldId = 1592									 
    -- VERTICAL
    JOIN ctm.vertical_master vm ON thR.verticalId = vm.verticalId
    -- OPTIN
    JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget 
		AND optIn.fieldCategory = 1 
		AND optIn.styleCodeId = thR.styleCodeId 
		AND optIn.optInStatus = 1 
		AND optIn.stampId != 0 
	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress 
		AND emHash.StyleCodeId = thR.styleCodeId
    -- OPTOUT DATE
    JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId 
		AND stamp.archive = 1 
-- 	 AND (stamp.`dateTime` >= CURDATE() - INTERVAL 12 MONTH and stamp.`dateTime` <= CURDATE() - INTERVAL 6 MONTH)
 		AND DATE(stamp.`dateTime`) BETWEEN DATE('2014-10-16') AND DATE('2015-04-16')
WHERE 
		thR.verticalId = 2
    AND thR.styleCodeId = 1
;




-- NEW VERSION 2015-04-05

SELECT
	tdFirstName.textValue 	AS FirstName,
	tBase.optInTarget 		AS EmailAddress,
	tdPolicyType.textValue 	As PolicyType,
	tBase.optInTarget 		As SubscriberKey,
	unsubscribeURL
FROM
	(
/*	drop table if exists tBase;
	create temporary table tBase as
*/
	SELECT thR.transactionId, thR.styleCodeId, optIn.optInTarget, tdEmail.textValue, 
		CONCAT(	'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical='
				,LCASE(vm.verticalCode) 
				,'&email='
				,tdEmail.textValue
				,'&unsubscribe_email='
				,emHash.hashedEmail
				) 		AS `unsubscribeURL`
	FROM aggregator.transaction_header2_cold thR	
		JOIN ctm.vertical_master vm ON thR.verticalId = vm.verticalId
		JOIN aggregator.transaction_details2_cold tdEmail ON thR.TransactionId = tdEmail.transactionId
			AND tdEmail.fieldId = 1585
			and  (	  textValue LIKE('%@%') 
				  AND textValue !='preload.testing@comparethemarket.com.au' 
				  AND textValue !='gomez.testing@aihco.com.au') 
		JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress 
			AND emHash.StyleCodeId = thR.styleCodeId
		-- OPTIN
		JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget 
			AND optIn.styleCodeId = thR.styleCodeId 
			AND optIn.fieldCategory = 1 
			AND optIn.optInStatus = 1 
			AND optIn.stampId != 0 
		-- OPTOUT DATE
		JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId 
			AND stamp.archive = 1 
			AND DATE(stamp.`dateTime`) >= DATE('2014-10-16') 
			AND DATE(stamp.`dateTime`) <= DATE('2015-04-16')
	 WHERE 
			thR.verticalId = 2
		AND thR.styleCodeId = 1 
	) tBase
	-- First Name								 
	LEFT JOIN aggregator.transaction_details2_cold tdFirstName ON tBase.TransactionId = tdFirstName.transactionId
		AND tdFirstName.fieldId = 1586
	-- Policy Type
	LEFT JOIN aggregator.transaction_details2_cold tdPolicyType ON tBase.TransactionId = tdPolicyType.transactionId
		AND tdPolicyType.fieldId = 1592		
;
		

-- -------------------------------------------------------------------------------
-- The version with temp tables (runs on Master Server)
-- -------------------------------------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS t1;
CREATE TEMPORARY TABLE t1 AS	
SELECT thR.TransactionId,
	-- 	tdFirstName.textValue 	AS FirstName,
		optIn.optInTarget 		AS EmailAddress,
	-- 	tdPolicyType.textValue 	As PolicyType,
		optIn.optInTarget 		As SubscriberKey,
		CONCAT(	'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical='
				,LCASE(vm.verticalCode) 
				,'&email='
				,tdEmail.textValue
				,'&unsubscribe_email='
				,emHash.hashedEmail
				) 				AS `unsubscribeURL`

	FROM aggregator.transaction_header2_cold thR	
		JOIN ctm.vertical_master vm ON thR.verticalId = vm.verticalId
		-- EMAIL
		JOIN aggregator.transaction_details2_cold tdEmail ON thR.TransactionId = tdEmail.transactionId
			AND tdEmail.fieldId = 1585
			and  (	  textValue LIKE('%@%') 
				  AND textValue !='preload.testing@comparethemarket.com.au' 
				  AND textValue !='gomez.testing@aihco.com.au') 
		-- HASH EMAIL
		JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress 
			AND emHash.StyleCodeId = thR.styleCodeId
		-- OPTIN
		JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget 
			AND optIn.styleCodeId = thR.styleCodeId 
			AND optIn.fieldCategory = 1 
			AND optIn.optInStatus = 1 
			AND optIn.stampId != 0 
		-- OPTOUT DATE
		JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId 
			AND stamp.archive = 1 
			AND DATE(stamp.`dateTime`) >= DATE('2014-10-05') 
			AND DATE(stamp.`dateTime`) <= DATE('2015-03-05')
	 WHERE 
	/*	(	thR.transactionStartDateTime  >= DATE('2014-10-05') AND thR.transactionStartDateTime <= DATE('2015-03-05'))
		AND*/	thR.verticalId = 2
		AND thR.styleCodeId = 1 
;
Create index t1_ndx1 	on t1(transactionId);


DROP TEMPORARY TABLE IF EXISTS t2;
CREATE TEMPORARY TABLE t2 AS	
	select 	thR.TransactionId,
			tdFirstName.textValue 	AS FirstName,
			tdPolicyType.textValue 	As PolicyType
		FROM aggregator.transaction_header2_cold thR	
			-- First Name
			LEFT JOIN aggregator.transaction_details2_cold tdPolicyType ON thR.TransactionId = tdPolicyType.transactionId and tdPolicyType.verticalId = thR.verticalId
			-- Policy Type
			LEFT JOIN aggregator.transaction_details2_cold tdFirstName ON thR.TransactionId = tdFirstName.transactionId and tdFirstName.verticalId = thR.verticalId 
	WHERE 
	/*		(	thR.transactionStartDateTime  >= DATE('2014-10-05') AND thR.transactionStartDateTime <= DATE('2015-03-05'))
			AND*/	thR.verticalId = 2
			AND thR.styleCodeId = 1 
			AND tdFirstName.fieldId = 1586
			AND tdPolicyType.fieldId = 1592	
;
Create index t2_ndx1 	on t2(transactionId);


SELECT t2.FirstName, t1.EmailAddress, t2.PolicyType, t1.SubscriberKey, t1.unsubscribeURL
FROM   t1
	left JOIN t2 ON t1.TransactionId = t2.TransactionId
;




-- -------------------------------------------------------------------------------
-- The Latest / Fastest version  (runs on any Slave Server)
-- -------------------------------------------------------------------------------

SELECT thR.TransactionId,
	 	tdFirstName.textValue 	AS FirstName,
		optIn.optInTarget 		AS EmailAddress,
	 	tdPolicyType.textValue 	As PolicyType,
		optIn.optInTarget 		As SubscriberKey,
		CONCAT(	'https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical='
				,LCASE(vm.verticalCode) 
				,'&email='
				,tdEmail.textValue
				,'&unsubscribe_email='
				,emHash.hashedEmail
				) 				AS `unsubscribeURL`

FROM aggregator.transaction_header2_cold thR	
	JOIN ctm.vertical_master vm ON thR.verticalId = vm.verticalId
	-- EMAIL
	JOIN aggregator.transaction_details2_cold tdEmail ON thR.TransactionId = tdEmail.transactionId
		AND tdEmail.fieldId = 1585
		and  (	  textValue LIKE('%@%') 
			  AND textValue !='preload.testing@comparethemarket.com.au' 
			  AND textValue !='gomez.testing@aihco.com.au') 
	-- HASH EMAIL
	JOIN aggregator.email_master emHash ON tdEmail.textValue = emHash.emailAddress 
		AND emHash.StyleCodeId = thR.styleCodeId
	-- OPTIN
	JOIN ctm.marketingOptIn optIn ON tdEmail.textValue = optIn.optinTarget 
		AND optIn.styleCodeId = thR.styleCodeId 
		AND optIn.fieldCategory = 1 
		AND optIn.optInStatus = 1 
		AND optIn.stampId != 0 
	-- OPTOUT DATE
	JOIN ctm.stamping stamp ON optIn.stampId = stamp.stampId 
		AND stamp.archive = 1 
		AND DATE(stamp.`dateTime`) >= DATE('2014-10-05') 
		AND DATE(stamp.`dateTime`) <= DATE('2015-03-05')
	-- First Name
	LEFT JOIN aggregator.transaction_details2_cold tdPolicyType ON thR.TransactionId = tdPolicyType.transactionId and tdPolicyType.verticalId = thR.verticalId 
	-- Policy Type
	LEFT JOIN aggregator.transaction_details2_cold tdFirstName ON thR.TransactionId = tdFirstName.transactionId and tdFirstName.verticalId = thR.verticalId 

 WHERE 
		thR.verticalId = 2
	AND thR.styleCodeId = 1 
	AND tdPolicyType.fieldId = 1592	
	AND tdFirstName.fieldId = 1586
