DROP TABLE IF EXISTS `cam_tbCRM_418_MeerkatAcquisitionCampaign`;
CREATE TABLE `cam_tbCRM_418_MeerkatAcquisitionCampaign` (
  `Id` 				 int(11) NOT NULL AUTO_INCREMENT,
  
 --  `transactionId`	varchar(50) DEFAULT NULL,
  `FirstName` 		varchar(50) DEFAULT NULL,
  `EmailAddress` 	varchar(256) DEFAULT NULL,
  `unsubscribeURL` 	varchar(500) DEFAULT NULL,
  
  `SoldPoliciesID` 	 int(11) DEFAULT NULL,
  `ExtractsOutputFK` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `cam_tbExtractsOutput_tbCRM_418_MeerkatAcquisitionCampaign` (`ExtractsOutputFK`),
  KEY `rep_tbSoldPolicies_tbCRM_418_MeerkatAcquisitionCampaign` (`SoldPoliciesID`),
  CONSTRAINT `cam_tbExtractsOutput_tbCRM_418_MeerkatAcquisitionCampaign` 	FOREIGN KEY (`ExtractsOutputFK`) REFERENCES `cam_tbExtractsOutput` (`ExtractId`) 	ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rep_tbSoldPolicies_tbCRM_418_MeerkatAcquisitionCampaign` 	FOREIGN KEY (`SoldPoliciesID`) 	 REFERENCES `rep_tbSoldPolicies` (`SoldPoliciesId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ================================================================================
DROP PROCEDURE IF EXISTS `cam_spGetCRM_418_MeerkatAcquisitionCampaign`;
DELIMITER $$
CREATE PROCEDURE `cam_spGetCRM_418_MeerkatAcquisitionCampaign`(ExtractFilePath VARCHAR(500))
BEGIN
	DECLARE Last_Extract_Id INTEGER;

	INSERT INTO cam_tbExtractsOutput(DateExtractCreated, ExtractPathAndFileName, CampaignName) VALUES(CURRENT_DATE, ExtractFilePath, 'CRM_418_MeerkatAcquisitionCampaign');
	SET Last_Extract_Id = LAST_INSERT_ID();


	UPDATE `cam_tbCRM_418_MeerkatAcquisitionCampaign` 
	SET ExtractsOutputFK = Last_Extract_Id 
	WHERE ExtractsOutputFK IS NULL;


	-- Mark globally ALL sales (for removal) ------------------
	UPDATE 	`cam_tbCRM_418_MeerkatAcquisitionCampaign` cam
	JOIN 	`rep_tbSoldPolicies` SP ON SP.EmailAddress = cam.emailAddress and Coalesce(SP.EmailAddress, '') <> ''
	SET 	cam.SoldPoliciesId = SP.SoldPoliciesId;
/*	
	UPDATE 	`cam_tbCRM_418_MeerkatAcquisitionCampaign` cam
	JOIN 	`rep_tbSoldPolicies` SP ON SP.TransactionId = cam.transactionId  and Coalesce(SP.TransactionId, 0) <> 0
	SET 	cam.SoldPoliciesId = SP.SoldPoliciesId;
*/

	-- De-dup
	DROP TEMPORARY TABLE IF EXISTS tmpCam;
	CREATE TEMPORARY TABLE tmpCam AS
	SELECT 
-- 		cam.transactionId	AS `transactionId`,
		CONCAT(UCASE(LEFT(cam.FirstName, 1)), SUBSTRING(cam.FirstName, 2)) AS `FirstName`,	
		cam.EmailAddress 	AS `EmailAddress`,	
		cam.unsubscribeURL 	AS `unsubscribeURL`
	FROM 	
		cam_tbCRM_418_MeerkatAcquisitionCampaign cam
	WHERE	cam.SoldPoliciesId IS NULL			
  		AND	cam.ExtractsOutputFK = Last_Extract_Id 
	GROUP BY 
		cam.EmailAddress;

	IF NOT EXISTS(SELECT DISTINCT index_name FROM information_schema.statistics WHERE table_schema = 'central_repository' AND TABLE_NAME = 'tmpCam' 	AND index_name LIKE 'tmpCam_ndx1') THEN Create index tmpCam_ndx1 	on tmpCam(FirstName); 		END IF;
	IF NOT EXISTS(SELECT DISTINCT index_name FROM information_schema.statistics WHERE table_schema = 'central_repository' AND TABLE_NAME = 'tmpCam' 	AND index_name LIKE 'tmpCam_ndx2') THEN Create index tmpCam_ndx2 	on tmpCam(EmailAddress); 	END IF;


	-- Final select after the Profanity check
	SELECT  DISTINCT
 -- 		cam.transactionId, 
		cam.FirstName,		
		cam.EmailAddress, 
        cam.unsubscribeURL	
	FROM 
		tmpCam cam
	WHERE 	`rb_fnIsInProfanityList`(cam.FirstName) = 0 
		AND `rb_fnIsInProfanityList`(cam.EmailAddress) = 0

;
END$$
DELIMITER ;



-- ==========================================================================================================
-- =============================== QUERY ====================================================================
-- ==========================================================================================================


/*
2015-07-06 - CRM-403
*/


SELECT /* 'Hot Utilities' */
	  td3.textValue AS FirstName
	, td2.textValue AS EmailAddress
	, CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', th.productType, '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   aggregator.transaction_header th
	JOIN ctm.touches t		      			ON th.TransactionId = t.transaction_id 	AND th.ProductType = 'UTILITIES' AND t.date BETWEEN  '" + context.quoteFromDate + "' AND '" + context.quoteToDate + "'
	JOIN aggregator.transaction_details td2 ON th.TransactionId = td2.transactionId AND (td2.xpath = 'utilities/application/details/email')
	JOIN aggregator.transaction_details td3 ON th.TransactionId = td3.transactionId AND (td3.xpath = 'utilities/application/details/firstName')
	JOIN ctm.marketingOptIn mo   			ON mo.optInTarget = td2.textValue 		AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
	JOIN aggregator.email_master emHash 	ON td2.textValue = emHash.emailAddress 	AND emHash.StyleCodeId = 1

UNION	

SELECT /* 'Hot HOMELOAN' */
         td3.textValue AS FirstName
       , td2.textValue AS EmailAddress
       , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', th.productType, '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   aggregator.transaction_header th
       INNER JOIN ctm.touches t		      ON th.TransactionId = t.transaction_id 	AND th.ProductType = 'HOMELOAN' AND t.date > '" + context.quoteFromDate + "' AND t.date <= '" + context.quoteToDate + "'
       INNER JOIN aggregator.transaction_details td2 ON th.TransactionId = td2.transactionId 	AND (td2.xpath = 'homeloan/contact/email')
       INNER JOIN aggregator.transaction_details td3 ON th.TransactionId = td3.transactionId 	AND (td3.xpath = 'homeloan/contact/firstName')
       INNER JOIN ctm.marketingOptIn mo   ON mo.optInTarget = td2.textValue 		AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash ON td2.textValue = emHash.emailAddress AND emHash.StyleCodeId = 1
       
UNION

SELECT /* 'Hot IP' */
         td3.textValue AS FirstName
       , td2.textValue AS EmailAddress
       , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', th.productType, '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   aggregator.transaction_header th
       INNER JOIN ctm.touches t		      ON th.TransactionId = t.transaction_id 	AND th.ProductType = 'IP' AND t.date > '" + context.quoteFromDate + "' AND t.date <= '" + context.quoteToDate + "'
       INNER JOIN aggregator.transaction_details td2 ON th.TransactionId = td2.transactionId 	AND (td2.xpath = 'ip/contactDetails/email')
       INNER JOIN aggregator.transaction_details td3 ON th.TransactionId = td3.transactionId 	AND (td3.xpath = 'ip/primary/firstName')
       INNER JOIN ctm.marketingOptIn mo   ON mo.optInTarget = td2.textValue 		AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash ON td2.textValue = emHash.emailAddress AND emHash.StyleCodeId = 1
       
UNION

SELECT /* 'Cold Utilities' */
	  td3.textValue AS FirstName
	, td2.textValue AS EmailAddress
	, CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', 'UTILITIES', '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   aggregator.transaction_header2_cold th
	JOIN ctm.touches t			         			ON th.TransactionId = t.transaction_id  AND th.verticalId = (Select VerticalId From ctm.vertical_master Where VerticalCode = 'UTILITIES') AND t.date BETWEEN  '" + context.quoteFromDate + "' AND '" + context.quoteToDate + "'
	JOIN aggregator.transaction_details2_cold td2	ON th.TransactionId = td2.transactionId AND td2.verticalId = th.verticalId AND td2.fieldId = (SELECT fieldId FROM aggregator.transaction_fields TF WHERE TF.fieldCode IN ('utilities/application/details/email')) -- ??? -- 'utilities/contact/email'
	JOIN aggregator.transaction_details2_cold td3	ON th.TransactionId = td3.transactionId AND td3.verticalId = th.verticalId AND td3.fieldId = (SELECT fieldId FROM aggregator.transaction_fields TF WHERE TF.fieldCode IN ('utilities/application/details/firstName')) -- ??? -- 'utilities/contact/firstName'
	JOIN ctm.marketingOptIn mo          			ON mo.optInTarget = td2.textValue 		AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
	JOIN aggregator.email_master emHash 			ON td2.textValue = emHash.emailAddress  AND emHash.StyleCodeId = 1   

UNION

SELECT /* 'Hot LIFE' */
         td3.textValue AS FirstName
       , td2.textValue AS EmailAddress
       , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', th.productType, '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   aggregator.transaction_header th
       INNER JOIN ctm.touches t		      ON th.TransactionId = t.transaction_id 	AND th.ProductType = 'LIFE' AND t.date > '" + context.quoteFromDate + "' AND t.date <= '" + context.quoteToDate + "'
       INNER JOIN aggregator.transaction_details td2 ON th.TransactionId = td2.transactionId 	AND (td2.xpath = 'life/contactDetails/email')
       INNER JOIN aggregator.transaction_details td3 ON th.TransactionId = td3.transactionId 	AND (td3.xpath = 'life/primary/firstName')
       INNER JOIN ctm.marketingOptIn mo   ON mo.optInTarget = td2.textValue 		AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash ON td2.textValue = emHash.emailAddress AND emHash.StyleCodeId = 1
       
       
UNION	/* COLD SOURCE */


SELECT /* 'Cold HOMELOAN' */
         td3.textValue AS FirstName
       , td2.textValue AS EmailAddress
       , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', 'HOMELOAN', '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   aggregator.transaction_header2_cold th
       INNER JOIN ctm.touches t			         ON th.TransactionId = t.transaction_id  AND th.verticalId = (Select VerticalId From ctm.vertical_master Where VerticalCode = 'HOMELOAN') AND t.date > '" + context.quoteFromDate + "' AND t.date <= '" + context.quoteToDate + "'
       INNER JOIN aggregator.transaction_details2_cold td2  ON th.TransactionId = td2.transactionId AND td2.verticalId = th.verticalId AND td2.fieldId = (SELECT fieldId FROM aggregator.transaction_fields TF WHERE TF.fieldCode IN ('homeloan/contact/email')) -- 680 -- 'homeloan/contact/email'
       INNER JOIN aggregator.transaction_details2_cold td3  ON th.TransactionId = td3.transactionId AND td3.verticalId = th.verticalId AND td3.fieldId = (SELECT fieldId FROM aggregator.transaction_fields TF WHERE TF.fieldCode IN ('homeloan/contact/firstName')) -- 681 -- 'homeloan/contact/firstName'
       INNER JOIN ctm.marketingOptIn mo          ON mo.optInTarget = td2.textValue 		 AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash ON td2.textValue = emHash.emailAddress  AND emHash.StyleCodeId = 1
  
UNION

SELECT /* 'Cold IP' */
         td3.textValue AS FirstName
       , td2.textValue AS EmailAddress
       , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', 'IP', '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   aggregator.transaction_header2_cold th
       INNER JOIN ctm.touches t         		 ON th.TransactionId = t.transaction_id  AND th.verticalId = (Select VerticalId From ctm.vertical_master Where VerticalCode = 'IP') AND t.date > '" + context.quoteFromDate + "' AND t.date <= '" + context.quoteToDate + "'
       INNER JOIN aggregator.transaction_details2_cold td2  ON th.TransactionId = td2.transactionId AND td2.verticalId = th.verticalId AND td2.fieldId = (SELECT fieldId FROM aggregator.transaction_fields TF WHERE TF.fieldCode IN ('ip/contactDetails/email')) -- 709 -- ip/contactDetails/email
       INNER JOIN aggregator.transaction_details2_cold td3  ON th.TransactionId = td3.transactionId AND td3.verticalId = th.verticalId AND td3.fieldId = (SELECT fieldId FROM aggregator.transaction_fields TF WHERE TF.fieldCode IN ('ip/primary/firstName')) -- 742 -- ip/primary/firstName
       INNER JOIN ctm.marketingOptIn mo          ON mo.optInTarget = td2.textValue 		 AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash ON td2.textValue = emHash.emailAddress  AND emHash.StyleCodeId = 1
       
UNION

SELECT /* 'Cold LIFE' */
         td3.textValue AS FirstName
       , td2.textValue AS EmailAddress
       , CONCAT('https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp? vertical=', 'LIFE', '&email=', td2.textValue, '&unsubscribe_email=', emHash.hashedEmail) AS `unsubscribeURL`
FROM   aggregator.transaction_header2_cold th
       INNER JOIN ctm.touches t         		 ON th.TransactionId = t.transaction_id  AND th.verticalId = (Select VerticalId From ctm.vertical_master Where VerticalCode = 'LIFE') AND t.date > '" + context.quoteFromDate + "' AND t.date <= '" + context.quoteToDate + "'
       INNER JOIN aggregator.transaction_details2_cold td2  ON th.TransactionId = td2.transactionId AND td2.verticalId = th.verticalId AND td2.fieldId = (SELECT fieldId FROM aggregator.transaction_fields TF WHERE TF.fieldCode IN ('life/contactDetails/email')) -- 786 -- life/contactDetails/email
       INNER JOIN aggregator.transaction_details2_cold td3  ON th.TransactionId = td3.transactionId AND td3.verticalId = th.verticalId AND td3.fieldId = (SELECT fieldId FROM aggregator.transaction_fields TF WHERE TF.fieldCode IN ('life/primary/firstName')) -- 828 -- life/primary/firstName
       INNER JOIN ctm.marketingOptIn mo          ON mo.optInTarget = td2.textValue 		 AND mo.optInStatus = 1 AND mo.styleCodeId = 1 AND fieldcategory = 1
       INNER JOIN aggregator.email_master emHash ON td2.textValue = emHash.emailAddress  AND emHash.StyleCodeId = 1
;






