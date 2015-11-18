use ctm;
SET @StartDate = '2015-11-18 00:00:00';
SET @EndDate = '2040-06-30 23:59:59';
SET @providerId = 12;

/* Expire current brochures */
UPDATE ctm.content_control cc
INNER JOIN ctm.content_control_provider ccp
ON ccp.contentControlId = cc.contentControlId
SET effectiveEnd = DATE_SUB(@StartDate, INTERVAL 1 SECOND)
WHERE ccp.providerId = @providerId
AND cc.styleCodeId = 0
AND cc.verticalId = 4
AND cc.contentCode = 'Promo'
AND cc.contentKey = 'promo' AND effectiveEnd > @StartDate AND cc.contentControlId > 0;

/* Insert new brochures */
SET @HospitalPDFCUA_Health_Brochure = '/CUA/CUA_Health_Brochure.pdf';
SET @ExtraPDFCUA_Health_Brochure = '/CUA/CUA_Health_Brochure.pdf';
/* Insert new brochure hospitalCoverName: CUA_Health_Brochure */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`); 
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','CUA_Health_Brochure');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFCUA_Health_Brochure);
/* Insert new brochure hospitalCoverName: CUA_Health_Brochure extrasCoverName: CUA_Health_Brochure */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','CUA_Health_Brochure');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','CUA_Health_Brochure');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFCUA_Health_Brochure);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFCUA_Health_Brochure);