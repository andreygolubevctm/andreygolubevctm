use ctm;
SET @StartDate = '2015-04-01 00:00:00';
SET @EndDate = '2040-06-30 23:59:59';
SET @providerId = 2;


/* Insert new brochures */

SET @HospitalPDFAccident_Only_Hospital_and_Silver_Plus_Extras = '/HCF/Accident_Only_Hospital_and_Silver_Plus_Extras.pdf';
SET @HospitalPDFBasic_Hospital_and_Silver_Plus_Extras = '/HCF/Basic_Hospital_and_Silver_Plus_Extras.pdf';
SET @HospitalPDFMid_Hospital_and_Silver_Plus_Extras = '/HCF/Mid_Hospital_and_Silver_Plus_Extras.pdf';
SET @HospitalPDFPremium_Hospital_and_Silver_Plus_Extras = '/HCF/Premium_Hospital_and_Silver_Plus_Extras.pdf';
SET @ExtraPDFAccident_Only_Hospital_and_Silver_Plus_Extras = '/HCF/Accident_Only_Hospital_and_Silver_Plus_Extras.pdf';
SET @ExtraPDFBasic_Hospital_and_Silver_Plus_Extras = '/HCF/Basic_Hospital_and_Silver_Plus_Extras.pdf';
SET @ExtraPDFMid_Hospital_and_Silver_Plus_Extras = '/HCF/Mid_Hospital_and_Silver_Plus_Extras.pdf';
SET @ExtraPDFPremium_Hospital_and_Silver_Plus_Extras = '/HCF/Premium_Hospital_and_Silver_Plus_Extras.pdf';
SET @ExtraPDFSilver_Plus_Extras = '/HCF/Silver_Plus_Extras.pdf';


/* Insert new brochure extrasCoverName: Silver_Plus_Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSilver_Plus_Extras);
/* Insert new brochure hospitalCoverName: Accident_Only_Hospital_and_Silver_Plus_Extras extrasCoverName: Accident_Only_Hospital_and_Silver_Plus_Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Accident_Only_Hospital_and_Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Accident_Only_Hospital_and_Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFAccident_Only_Hospital_and_Silver_Plus_Extras);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFAccident_Only_Hospital_and_Silver_Plus_Extras);
/* Insert new brochure hospitalCoverName: Basic_Hospital_and_Silver_Plus_Extras extrasCoverName: Basic_Hospital_and_Silver_Plus_Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Basic_Hospital_and_Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Basic_Hospital_and_Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBasic_Hospital_and_Silver_Plus_Extras);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFBasic_Hospital_and_Silver_Plus_Extras);
/* Insert new brochure hospitalCoverName: Mid_Hospital_and_Silver_Plus_Extras extrasCoverName: Mid_Hospital_and_Silver_Plus_Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Mid_Hospital_and_Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Mid_Hospital_and_Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFMid_Hospital_and_Silver_Plus_Extras);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFMid_Hospital_and_Silver_Plus_Extras);
/* Insert new brochure hospitalCoverName: Premium_Hospital_and_Silver_Plus_Extras extrasCoverName: Premium_Hospital_and_Silver_Plus_Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Premium_Hospital_and_Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Premium_Hospital_and_Silver_Plus_Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFPremium_Hospital_and_Silver_Plus_Extras);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFPremium_Hospital_and_Silver_Plus_Extras);