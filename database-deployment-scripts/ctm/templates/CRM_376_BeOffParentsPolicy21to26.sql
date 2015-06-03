CREATE TABLE `cam_tbCRM_376_BeOffParentsPolicy21to26` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) DEFAULT NULL,
  `EmailAddress` varchar(256) DEFAULT NULL,
  `DOB` varchar(20) DEFAULT NULL,
  `unsubscribeURL` varchar(500) DEFAULT NULL,
  `SoldPoliciesID` int(11) DEFAULT NULL,
  `ExtractsOutputFK` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `cam_tbExtractsOutput_tbCRM_376_BeOffParentsPolicy21to26` (`ExtractsOutputFK`),
  KEY `rep_tbSoldPolicies_tbCRM_376_BeOffParentsPolicy21to26` (`SoldPoliciesID`),
  CONSTRAINT `cam_tbExtractsOutput_tbCRM_376_BeOffParentsPolicy21to26` FOREIGN KEY (`ExtractsOutputFK`) REFERENCES `cam_tbExtractsOutput` (`ExtractId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rep_tbSoldPolicies_tbCRM_376_BeOffParentsPolicy21to26` FOREIGN KEY (`SoldPoliciesID`) REFERENCES `rep_tbSoldPolicies` (`SoldPoliciesId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ================================================================================
DROP PROCEDURE IF EXISTS `cam_spGetCRM_376_BeOffParentsPolicy21to26`;
DELIMITER $$
CREATE PROCEDURE `cam_spGetCRM_376_BeOffParentsPolicy21to26`(ExtractFilePath VARCHAR(500))
BEGIN
	DECLARE Last_Extract_Id INTEGER;

	INSERT INTO cam_tbExtractsOutput(DateExtractCreated, ExtractPathAndFileName, CampaignName) VALUES(CURRENT_DATE, ExtractFilePath, 'CRM_376_BeOffParentsPolicy21to26');
	SET Last_Extract_Id = LAST_INSERT_ID();


	UPDATE `cam_tbCRM_376_BeOffParentsPolicy21to26` 
	SET ExtractsOutputFK = Last_Extract_Id 
	WHERE ExtractsOutputFK IS NULL;


	-- Marking sales per vertical (for removal) ---------------

	-- Health (from A&G)
	UPDATE 	`cam_tbCRM_376_BeOffParentsPolicy21to26` cam
	JOIN 	`rep_tbSoldPolicies` SP 					 ON SP.EmailAddress = cam.emailAddress and Coalesce(SP.EmailAddress, '') <> ''
	JOIN 	`datafeeds`.`dfd_tbProcessedAgHealthSale3` H ON  H.EmailAddress = cam.emailAddress and Coalesce( H.EmailAddress, '') <> ''
	SET 	cam.SoldPoliciesId = SP.SoldPoliciesId;

	-- Woolworths (Car)
	UPDATE 	`cam_tbCRM_376_BeOffParentsPolicy21to26` cam
	JOIN 	`rep_tbSoldPolicies` SP 					 			 ON SP.EmailAddress = cam.emailAddress and Coalesce(SP.EmailAddress, '') <> ''
	JOIN 	`datafeeds`.`dfd_tbProcessedHollardWoolworthsCarSale` WC ON WC.EmailAddress = cam.emailAddress and Coalesce(WC.EmailAddress, '') <> ''
	SET 	cam.SoldPoliciesId = SP.SoldPoliciesId;

	-- Woolworths (Travel)
	UPDATE 	`cam_tbCRM_376_BeOffParentsPolicy21to26` cam
	JOIN 	`rep_tbSoldPolicies` SP 					 				ON SP.EmailAddress = cam.emailAddress and Coalesce(SP.EmailAddress, '') <> ''
	JOIN 	`datafeeds`.`dfd_tbProcessedHollardWoolworthsTravelSale` WT	ON WT.EmailAddress = cam.emailAddress and Coalesce(WT.EmailAddress, '') <> ''
	SET 	cam.SoldPoliciesId = SP.SoldPoliciesId;


/*	-- Mark globally ALL sales (for removal) ------------------
	UPDATE 	`cam_tbCRM_376_BeOffParentsPolicy21to26` cam
	JOIN 	`rep_tbSoldPolicies` SP ON SP.EmailAddress = cam.emailAddress and Coalesce(SP.EmailAddress, '') <> ''
	SET 	cam.SoldPoliciesId = SP.SoldPoliciesId;
	
	UPDATE 	`cam_tbCRM_376_BeOffParentsPolicy21to26` cam
	JOIN 	`rep_tbSoldPolicies` SP ON SP.TransactionId = cam.transactionId  and Coalesce(SP.TransactionId, 0) <> 0
	SET 	cam.SoldPoliciesId = SP.SoldPoliciesId;
*/

	-- De-dup
	DROP TEMPORARY TABLE IF EXISTS tmpCam;
	CREATE TEMPORARY TABLE tmpCam AS
	SELECT 
		CONCAT(UCASE(LEFT(cam.FirstName, 1)), SUBSTRING(cam.FirstName, 2)) AS `FirstName`,	
		cam.EmailAddress 	AS `EmailAddress`,	
		cam.DOB 			AS `DOB`,	
		cam.unsubscribeURL 	AS `unsubscribeURL`
	FROM 	
		cam_tbCRM_376_BeOffParentsPolicy21to26 cam
/*	 -- Remove Woolworths sales (old method - it is not updating SoldPoliciesId fileld)
	 LEFT JOIN 
		(		SELECT COALESCE(TransactionId,'') as 'transactionId', Coalesce(EmailAddress, '') AS 'EmailAddress' FROM datafeeds.dfd_tbProcessedHollardWoolworthsCarSale 	
		UNION	SELECT COALESCE(TransactionId,'') as 'transactionId', Coalesce(EmailAddress, '') AS 'EmailAddress' FROM datafeeds.dfd_tbProcessedHollardWoolworthsTravelSale  
		) W ON W.EmailAddress = cam.EmailAddress -- and W.transactionId = cam.transactionId
	WHERE 
			W.EmailAddress IS NULL AND
*/	WHERE	cam.SoldPoliciesId IS NULL			
  		AND	cam.ExtractsOutputFK = Last_Extract_Id 
	GROUP BY 
		cam.EmailAddress;

	IF NOT EXISTS(SELECT DISTINCT index_name FROM information_schema.statistics WHERE table_schema = 'central_repository' AND TABLE_NAME = 'tmpCam' 	AND index_name LIKE 'tmpCam_ndx1') THEN Create index tmpCam_ndx1 	on tmpCam(FirstName); 		END IF;
	IF NOT EXISTS(SELECT DISTINCT index_name FROM information_schema.statistics WHERE table_schema = 'central_repository' AND TABLE_NAME = 'tmpCam' 	AND index_name LIKE 'tmpCam_ndx2') THEN Create index tmpCam_ndx2 	on tmpCam(EmailAddress); 	END IF;


	-- Final select after the Profanity check
	SELECT  DISTINCT
		cam.FirstName,		
		cam.EmailAddress, 
		cam.DOB, 
        cam.unsubscribeURL	
	FROM 
		tmpCam cam
	WHERE 	`rb_fnIsInProfanityList`(cam.FirstName) = 0 
		AND `rb_fnIsInProfanityList`(cam.EmailAddress) = 0

;
END$$
DELIMITER ;

