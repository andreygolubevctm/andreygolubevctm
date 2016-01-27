use ctm;
SET @StartDate = '2015-04-01 00:00:00';
SET @EndDate = '2016-03-31 23:59:59';
SET @providerId = 10;

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
SET @HospitalPDFBasicHospital = '';
SET @HospitalPDFBasicHospitalExcess500 = '';
SET @HospitalPDFCBHSPrestige = '';
SET @HospitalPDFComprehensiveHospital = '';
SET @HospitalPDFComprehensiveHospital100 = '';
SET @HospitalPDFComprehensiveHospital70 = '';
SET @HospitalPDFFlexiSaver = '';
SET @HospitalPDFKickstart = '';
SET @HospitalPDFLimitedHospital = '';
SET @HospitalPDFLimitedHospital100 = '';
SET @HospitalPDFLimitedHospital70 = '';
SET @HospitalPDFStepUp = '';
SET @ExtraPDFCBHSPrestige = '';
SET @ExtraPDFEssentialExtras = '';
SET @ExtraPDFFlexiSaver = '';
SET @ExtraPDFIntermediateExtras = '';
SET @ExtraPDFKickstart = '';
SET @ExtraPDFStepUp = '';
SET @ExtraPDFTopExtras = '';

/* Insert new brochure extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Basic Hospital */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`);
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Basic Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFBasicHospital);

/* Insert new brochure hospitalCoverName: Basic Hospital extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Basic Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBasicHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure hospitalCoverName: Basic Hospital extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Basic Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBasicHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Basic Hospital extrasCoverName: Top Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Basic Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Top Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBasicHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTopExtras);

/* Insert new brochure hospitalCoverName: Basic Hospital Excess 500 */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`);
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Basic Hospital Excess 500');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFBasicHospitalExcess500);

/* Insert new brochure hospitalCoverName: Basic Hospital Excess 500 extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Basic Hospital Excess 500');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBasicHospitalExcess500);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure hospitalCoverName: Basic Hospital Excess 500 extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Basic Hospital Excess 500');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBasicHospitalExcess500);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Basic Hospital Excess 500 extrasCoverName: Top Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Basic Hospital Excess 500');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Top Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBasicHospitalExcess500);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTopExtras);

/* Insert new brochure hospitalCoverName: CBHS Prestige extrasCoverName: CBHS Prestige */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','CBHS Prestige');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','CBHS Prestige');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFCBHSPrestige);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFCBHSPrestige);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`);
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Comprehensive Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital extrasCoverName: Top Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Top Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTopExtras);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital 100 */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`);
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Comprehensive Hospital 100');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital100);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital 100 extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital 100');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital100);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital 100 extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital 100');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital100);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital 100 extrasCoverName: Top Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital 100');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Top Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital100);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTopExtras);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital 70 */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`);
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Comprehensive Hospital 70');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital70);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital 70 extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital 70');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital70);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital 70 extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital 70');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital70);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Comprehensive Hospital 70 extrasCoverName: Top Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Comprehensive Hospital 70');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Top Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFComprehensiveHospital70);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTopExtras);

/* Insert new brochure hospitalCoverName: FlexiSaver extrasCoverName: FlexiSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','FlexiSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','FlexiSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFFlexiSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFFlexiSaver);

/* Insert new brochure hospitalCoverName: Kickstart extrasCoverName: Kickstart */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Kickstart');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Kickstart');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFKickstart);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFKickstart);

/* Insert new brochure hospitalCoverName: Limited Hospital */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`);
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Limited Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital);

/* Insert new brochure hospitalCoverName: Limited Hospital extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure hospitalCoverName: Limited Hospital extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Limited Hospital extrasCoverName: Top Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Top Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTopExtras);

/* Insert new brochure hospitalCoverName: Limited Hospital 100 */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`);
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Limited Hospital 100');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital100);

/* Insert new brochure hospitalCoverName: Limited Hospital 100 extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital 100');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital100);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure hospitalCoverName: Limited Hospital 100 extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital 100');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital100);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Limited Hospital 100 extrasCoverName: Top Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital 100');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Top Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital100);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTopExtras);

/* Insert new brochure hospitalCoverName: Limited Hospital 70 */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`);
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','Limited Hospital 70');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital70);

/* Insert new brochure hospitalCoverName: Limited Hospital 70 extrasCoverName: Essential Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital 70');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Essential Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital70);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFEssentialExtras);

/* Insert new brochure hospitalCoverName: Limited Hospital 70 extrasCoverName: Intermediate Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital 70');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Intermediate Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital70);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFIntermediateExtras);

/* Insert new brochure hospitalCoverName: Limited Hospital 70 extrasCoverName: Top Extras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','Limited Hospital 70');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','Top Extras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFLimitedHospital70);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTopExtras);

/* Insert new brochure hospitalCoverName: StepUp extrasCoverName: StepUp */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','StepUp');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','StepUp');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFStepUp);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFStepUp);
