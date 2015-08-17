-- Turn the brand off in yahoo
INSERT INTO `ctm`.`stylecode_provider_exclusions` (`styleCodeId`, `verticalId`, `providerId`, `excludeDateFrom`, `excludeDateTo`) VALUES ('4', '4', '16', '2015-05-25 00:00:00', '2040-12-31 23:59:59');

-- UPDATE THE FOOTER
UPDATE ctm.content_control 
SET contentValue = 'ahm, Australian Unity, Budget Direct, Bupa, CBHS, QCHF, CUA, Frank, GMHBA, HCF, HIF and nib'
where contentKey = 'footerParticipatingSuppliers' 
and verticalid = 4
AND styleCodeid = 1;

-- BROCHURES.

use ctm;
SET @StartDate = '2015-04-01 00:00:00';
SET @EndDate = '2016-03-31 23:59:59';
SET @providerId = 16;

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
SET @HospitalPDFIntermediateHospital = '/QCH/Intermediate_Hospital.pdf';
SET @HospitalPDFSinglesandCouples = '/QCH/Singles_and_Couples.pdf';
SET @HospitalPDFTopHospital = '/QCH/Top_Hospital.pdf';
SET @ExtraPDFEssential = '/QCH/Essential_Extras.pdf';
SET @ExtraPDFPremium = '/QCH/Premium_Extras.pdf';
SET @ExtraPDFSinglesandCouples = '/QCH/Singles_and_Couples.pdf';
SET @ExtraPDFYoung = '/QCH/Young_Extras.pdf';
/* Insert new brochure extrasCoverName: Young */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','Young');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFYoung);
/* Insert new brochure hospitalCoverName: Intermediate Hospital */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Intermediate Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFIntermediateHospital);
/* Insert new brochure hospitalCoverName: Intermediate Hospital extrasCoverName: Essential */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@hospital','Intermediate Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@extras','Essential');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'hospitalPDF',@HospitalPDFIntermediateHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssential);
/* Insert new brochure hospitalCoverName: Intermediate Hospital extrasCoverName: Premium */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@hospital','Intermediate Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@extras','Premium');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'hospitalPDF',@HospitalPDFIntermediateHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFPremium);
/* Insert new brochure hospitalCoverName: Intermediate Hospital extrasCoverName: Young */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@hospital','Intermediate Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@extras','Young');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'hospitalPDF',@HospitalPDFIntermediateHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFYoung);
/* Insert new brochure hospitalCoverName: Singles and Couples extrasCoverName: Singles and Couples */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@hospital','Singles and Couples');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@extras','Singles and Couples');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'hospitalPDF',@HospitalPDFSinglesandCouples);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSinglesandCouples);
/* Insert new brochure hospitalCoverName: Top Hospital */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Top Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
/* Insert new brochure hospitalCoverName: Top Hospital extrasCoverName: Essential */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@hospital','Top Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@extras','Essential');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssential);
/* Insert new brochure hospitalCoverName: Top Hospital extrasCoverName: Premium */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@hospital','Top Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@extras','Premium');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFPremium);
/* Insert new brochure hospitalCoverName: Top Hospital extrasCoverName: Young */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@hospital','Top Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'@extras','Young');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFYoung);


-- TESTS

-- Should be 10 Rows
SELECT * FROM ctm.content_control cc
INNER JOIN ctm.content_control_provider ccp
ON ccp.contentControlId = cc.contentControlId
WHERE ccp.providerId = 16
AND cc.styleCodeId = 0
AND cc.verticalId = 4
AND cc.contentCode = 'Promo'
AND cc.contentKey = 'promo' ;

-- Should be 34 Rows
SELECT cc.contentControlId, cc.effectiveStart, cc.effectiveEnd, cs.supplementaryKey, cs.supplementaryValue
FROM ctm.content_control cc
INNER JOIN ctm.content_control_provider ccp
ON ccp.contentControlId = cc.contentControlId
INNER JOIN ctm.content_supplementary cs
ON cs.contentControlId = cc.contentControlId
WHERE ccp.providerId = 16
AND cc.styleCodeId = 0
AND cc.verticalId = 4
AND cc.contentCode = 'Promo'
AND cc.contentKey = 'promo' ;

-- CHECK is included in the footer
SELECT * FROM ctm.content_control where contentKey = 'footerParticipatingSuppliers' 
and verticalid = 4
AND styleCodeid = 1;