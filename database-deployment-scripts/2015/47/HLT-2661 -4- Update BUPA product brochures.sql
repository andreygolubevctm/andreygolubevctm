use ctm;
SET @StartDate = '2015-04-01 00:00:00';
SET @EndDate = '2016-03-31 23:59:59';
SET @providerId = 15;

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
SET @HospitalPDFBudgetHospital = '/BUP/BudgetHospital.pdf';
SET @HospitalPDFNSW_ActiveSaver = '/BUP/NSW_ActiveSaver.pdf';
SET @HospitalPDFNSW_BudgetFamily = '/BUP/NSW_BudgetFamily.pdf';
SET @HospitalPDFNSW_YoungSinglesCouplesSaver = '/BUP/NSW_YoungSinglesCouplesSaver.pdf';
SET @HospitalPDFNT_ActiveSaver = '/BUP/NT_ActiveSaver.pdf';
SET @HospitalPDFNT_BudgetFamily = '/BUP/NT_BudgetFamily.pdf';
SET @HospitalPDFNT_YoungSinglesCouplesSaver = '/BUP/NT_YoungSinglesCouplesSaver.pdf';
SET @HospitalPDFQLD_ActiveSaver = '/BUP/QLD_ActiveSaver.pdf';
SET @HospitalPDFQLD_BudgetFamily = '/BUP/QLD_BudgetFamily.pdf';
SET @HospitalPDFQLD_YoungSinglesCouplesSaver = '/BUP/QLD_YoungSinglesCouplesSaver.pdf';
SET @HospitalPDFSA_ActiveSaver = '/BUP/SA_ActiveSaver.pdf';
SET @HospitalPDFSA_BudgetFamily = '/BUP/SA_BudgetFamily.pdf';
SET @HospitalPDFSA_YoungSinglesCouplesSaver = '/BUP/SA_YoungSinglesCouplesSaver.pdf';
SET @HospitalPDFTAS_ActiveSaver = '/BUP/TAS_ActiveSaver.pdf';
SET @HospitalPDFTAS_BudgetFamily = '/BUP/TAS_BudgetFamily.pdf';
SET @HospitalPDFTAS_YoungSinglesCouplesSaver = '/BUP/TAS_YoungSinglesCouplesSaver.pdf';
SET @HospitalPDFTopHospital = '/BUP/TopHospital.pdf';
SET @HospitalPDFVIC_ActiveSaver = '/BUP/VIC_ActiveSaver.pdf';
SET @HospitalPDFVIC_BudgetFamily = '/BUP/VIC_BudgetFamily.pdf';
SET @HospitalPDFVIC_YoungSinglesCouplesSaver = '/BUP/VIC_YoungSinglesCouplesSaver.pdf';
SET @HospitalPDFWA_ActiveSaver = '/BUP/WA_ActiveSaver.pdf';
SET @HospitalPDFWA_BudgetFamily = '/BUP/WA_BudgetFamily.pdf';
SET @HospitalPDFWA_YoungSinglesCouplesSaver = '/BUP/WA_YoungSinglesCouplesSaver.pdf';
SET @ExtraPDFNSW_ActiveSaver = '/BUP/NSW_ActiveSaver.pdf';
SET @ExtraPDFNSW_BronzeExtras = '/BUP/NSW_BronzeExtras.pdf';
SET @ExtraPDFNSW_BudgetFamily = '/BUP/NSW_BudgetFamily.pdf';
SET @ExtraPDFNSW_GoldExtras = '/BUP/NSW_GoldExtras.pdf';
SET @ExtraPDFNSW_SilverExtras = '/BUP/NSW_SilverExtras.pdf';
SET @ExtraPDFNSW_YoungSinglesCouplesSaver = '/BUP/NSW_YoungSinglesCouplesSaver.pdf';
SET @ExtraPDFNT_ActiveSaver = '/BUP/NT_ActiveSaver.pdf';
SET @ExtraPDFNT_BronzeExtras = '/BUP/NT_BronzeExtras.pdf';
SET @ExtraPDFNT_BudgetFamily = '/BUP/NT_BudgetFamily.pdf';
SET @ExtraPDFNT_GoldExtras = '/BUP/NT_GoldExtras.pdf';
SET @ExtraPDFNT_SilverExtras = '/BUP/NT_SilverExtras.pdf';
SET @ExtraPDFNT_YoungSinglesCouplesSaver = '/BUP/NT_YoungSinglesCouplesSaver.pdf';
SET @ExtraPDFQLD_ActiveSaver = '/BUP/QLD_ActiveSaver.pdf';
SET @ExtraPDFQLD_BronzeExtras = '/BUP/QLD_BronzeExtras.pdf';
SET @ExtraPDFQLD_BudgetFamily = '/BUP/QLD_BudgetFamily.pdf';
SET @ExtraPDFQLD_GoldExtras = '/BUP/QLD_GoldExtras.pdf';
SET @ExtraPDFQLD_SilverExtras = '/BUP/QLD_SilverExtras.pdf';
SET @ExtraPDFQLD_YoungSinglesCouplesSaver = '/BUP/QLD_YoungSinglesCouplesSaver.pdf';
SET @ExtraPDFSA_ActiveSaver = '/BUP/SA_ActiveSaver.pdf';
SET @ExtraPDFSA_BronzeExtras = '/BUP/SA_BronzeExtras.pdf';
SET @ExtraPDFSA_BudgetFamily = '/BUP/SA_BudgetFamily.pdf';
SET @ExtraPDFSA_GoldExtras = '/BUP/SA_GoldExtras.pdf';
SET @ExtraPDFSA_SilverExtras = '/BUP/SA_SilverExtras.pdf';
SET @ExtraPDFSA_YoungSinglesCouplesSaver = '/BUP/SA_YoungSinglesCouplesSaver.pdf';
SET @ExtraPDFTAS_ActiveSaver = '/BUP/TAS_ActiveSaver.pdf';
SET @ExtraPDFTAS_BronzeExtras = '/BUP/TAS_BronzeExtras.pdf';
SET @ExtraPDFTAS_BudgetFamily = '/BUP/TAS_BudgetFamily.pdf';
SET @ExtraPDFTAS_GoldExtras = '/BUP/TAS_GoldExtras.pdf';
SET @ExtraPDFTAS_SilverExtras = '/BUP/TAS_SilverExtras.pdf';
SET @ExtraPDFTAS_YoungSinglesCouplesSaver = '/BUP/TAS_YoungSinglesCouplesSaver.pdf';
SET @ExtraPDFVIC_ActiveSaver = '/BUP/VIC_ActiveSaver.pdf';
SET @ExtraPDFVIC_BronzeExtras = '/BUP/VIC_BronzeExtras.pdf';
SET @ExtraPDFVIC_BudgetFamily = '/BUP/VIC_BudgetFamily.pdf';
SET @ExtraPDFVIC_GoldExtras = '/BUP/VIC_GoldExtras.pdf';
SET @ExtraPDFVIC_SilverExtras = '/BUP/VIC_SilverExtras.pdf';
SET @ExtraPDFVIC_YoungSinglesCouplesSaver = '/BUP/VIC_YoungSinglesCouplesSaver.pdf';
SET @ExtraPDFWA_ActiveSaver = '/BUP/WA_ActiveSaver.pdf';
SET @ExtraPDFWA_BronzeExtras = '/BUP/WA_BronzeExtras.pdf';
SET @ExtraPDFWA_BudgetFamily = '/BUP/WA_BudgetFamily.pdf';
SET @ExtraPDFWA_GoldExtras = '/BUP/WA_GoldExtras.pdf';
SET @ExtraPDFWA_SilverExtras = '/BUP/WA_SilverExtras.pdf';
SET @ExtraPDFWA_YoungSinglesCouplesSaver = '/BUP/WA_YoungSinglesCouplesSaver.pdf';
/* Insert new brochure extrasCoverName: NSW_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','NSW_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_BronzeExtras);
/* Insert new brochure extrasCoverName: NSW_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','NSW_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_GoldExtras);
/* Insert new brochure extrasCoverName: NSW_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','NSW_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_SilverExtras);
/* Insert new brochure extrasCoverName: NT_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','NT_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_BronzeExtras);
/* Insert new brochure extrasCoverName: NT_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','NT_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_GoldExtras);
/* Insert new brochure extrasCoverName: NT_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','NT_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_SilverExtras);
/* Insert new brochure extrasCoverName: QLD_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','QLD_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_BronzeExtras);
/* Insert new brochure extrasCoverName: QLD_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','QLD_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_GoldExtras);
/* Insert new brochure extrasCoverName: QLD_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','QLD_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_SilverExtras);
/* Insert new brochure extrasCoverName: SA_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','SA_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_BronzeExtras);
/* Insert new brochure extrasCoverName: SA_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','SA_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_GoldExtras);
/* Insert new brochure extrasCoverName: SA_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','SA_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_SilverExtras);
/* Insert new brochure extrasCoverName: TAS_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','TAS_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_BronzeExtras);
/* Insert new brochure extrasCoverName: TAS_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','TAS_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_GoldExtras);
/* Insert new brochure extrasCoverName: TAS_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','TAS_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_SilverExtras);
/* Insert new brochure extrasCoverName: VIC_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','VIC_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_BronzeExtras);
/* Insert new brochure extrasCoverName: VIC_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','VIC_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_GoldExtras);
/* Insert new brochure extrasCoverName: VIC_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','VIC_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_SilverExtras);
/* Insert new brochure extrasCoverName: WA_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','WA_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_BronzeExtras);
/* Insert new brochure extrasCoverName: WA_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','WA_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_GoldExtras);
/* Insert new brochure extrasCoverName: WA_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@extras','WA_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_SilverExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`); 
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: NSW_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_BronzeExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: NSW_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_GoldExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: NSW_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_SilverExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: NT_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_BronzeExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: NT_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_GoldExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: NT_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_SilverExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: QLD_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_BronzeExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: QLD_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_GoldExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: QLD_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_SilverExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: SA_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_BronzeExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: SA_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_GoldExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: SA_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_SilverExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: TAS_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_BronzeExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: TAS_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_GoldExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: TAS_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_SilverExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: VIC_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_BronzeExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: VIC_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_GoldExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: VIC_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_SilverExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: WA_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_BronzeExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: WA_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_GoldExtras);
/* Insert new brochure hospitalCoverName: BudgetHospital extrasCoverName: WA_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','BudgetHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFBudgetHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_SilverExtras);
/* Insert new brochure hospitalCoverName: NSW_ActiveSaver extrasCoverName: NSW_ActiveSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','NSW_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFNSW_ActiveSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_ActiveSaver);
/* Insert new brochure hospitalCoverName: NSW_BudgetFamily extrasCoverName: NSW_BudgetFamily */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','NSW_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFNSW_BudgetFamily);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_BudgetFamily);
/* Insert new brochure hospitalCoverName: NSW_YoungSinglesCouplesSaver extrasCoverName: NSW_YoungSinglesCouplesSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','NSW_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFNSW_YoungSinglesCouplesSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_YoungSinglesCouplesSaver);
/* Insert new brochure hospitalCoverName: NT_ActiveSaver extrasCoverName: NT_ActiveSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','NT_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFNT_ActiveSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_ActiveSaver);
/* Insert new brochure hospitalCoverName: NT_BudgetFamily extrasCoverName: NT_BudgetFamily */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','NT_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFNT_BudgetFamily);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_BudgetFamily);
/* Insert new brochure hospitalCoverName: NT_YoungSinglesCouplesSaver extrasCoverName: NT_YoungSinglesCouplesSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','NT_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFNT_YoungSinglesCouplesSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_YoungSinglesCouplesSaver);
/* Insert new brochure hospitalCoverName: QLD_ActiveSaver extrasCoverName: QLD_ActiveSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','QLD_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFQLD_ActiveSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_ActiveSaver);
/* Insert new brochure hospitalCoverName: QLD_BudgetFamily extrasCoverName: QLD_BudgetFamily */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','QLD_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFQLD_BudgetFamily);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_BudgetFamily);
/* Insert new brochure hospitalCoverName: QLD_YoungSinglesCouplesSaver extrasCoverName: QLD_YoungSinglesCouplesSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','QLD_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFQLD_YoungSinglesCouplesSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_YoungSinglesCouplesSaver);
/* Insert new brochure hospitalCoverName: SA_ActiveSaver extrasCoverName: SA_ActiveSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','SA_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFSA_ActiveSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_ActiveSaver);
/* Insert new brochure hospitalCoverName: SA_BudgetFamily extrasCoverName: SA_BudgetFamily */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','SA_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFSA_BudgetFamily);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_BudgetFamily);
/* Insert new brochure hospitalCoverName: SA_YoungSinglesCouplesSaver extrasCoverName: SA_YoungSinglesCouplesSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','SA_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFSA_YoungSinglesCouplesSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_YoungSinglesCouplesSaver);
/* Insert new brochure hospitalCoverName: TAS_ActiveSaver extrasCoverName: TAS_ActiveSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TAS_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTAS_ActiveSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_ActiveSaver);
/* Insert new brochure hospitalCoverName: TAS_BudgetFamily extrasCoverName: TAS_BudgetFamily */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TAS_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTAS_BudgetFamily);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_BudgetFamily);
/* Insert new brochure hospitalCoverName: TAS_YoungSinglesCouplesSaver extrasCoverName: TAS_YoungSinglesCouplesSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TAS_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTAS_YoungSinglesCouplesSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_YoungSinglesCouplesSaver);
/* Insert new brochure hospitalCoverName: TopHospital */;
SET @newid = (SELECT Max(contentControlId) + 1 FROM `ctm`.`content_control_provider`); 
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_control` (`contentControlId`,`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (@newid ,0,4,'Promo','promo','',@StartDate,@EndDate,'product');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: NSW_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_BronzeExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: NSW_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_GoldExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: NSW_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NSW_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNSW_SilverExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: NT_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_BronzeExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: NT_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_GoldExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: NT_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','NT_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFNT_SilverExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: QLD_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_BronzeExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: QLD_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_GoldExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: QLD_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','QLD_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFQLD_SilverExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: SA_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_BronzeExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: SA_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_GoldExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: SA_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','SA_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFSA_SilverExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: TAS_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_BronzeExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: TAS_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_GoldExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: TAS_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','TAS_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFTAS_SilverExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: VIC_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_BronzeExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: VIC_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_GoldExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: VIC_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_SilverExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: WA_BronzeExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_BronzeExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_BronzeExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: WA_GoldExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_GoldExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_GoldExtras);
/* Insert new brochure hospitalCoverName: TopHospital extrasCoverName: WA_SilverExtras */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','TopHospital');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_SilverExtras');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFTopHospital);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_SilverExtras);
/* Insert new brochure hospitalCoverName: VIC_ActiveSaver extrasCoverName: VIC_ActiveSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','VIC_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFVIC_ActiveSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_ActiveSaver);
/* Insert new brochure hospitalCoverName: VIC_BudgetFamily extrasCoverName: VIC_BudgetFamily */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','VIC_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFVIC_BudgetFamily);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_BudgetFamily);
/* Insert new brochure hospitalCoverName: VIC_YoungSinglesCouplesSaver extrasCoverName: VIC_YoungSinglesCouplesSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','VIC_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','VIC_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFVIC_YoungSinglesCouplesSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFVIC_YoungSinglesCouplesSaver);
/* Insert new brochure hospitalCoverName: WA_ActiveSaver extrasCoverName: WA_ActiveSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','WA_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_ActiveSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFWA_ActiveSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_ActiveSaver);
/* Insert new brochure hospitalCoverName: WA_BudgetFamily extrasCoverName: WA_BudgetFamily */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','WA_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_BudgetFamily');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFWA_BudgetFamily);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_BudgetFamily);
/* Insert new brochure hospitalCoverName: WA_YoungSinglesCouplesSaver extrasCoverName: WA_YoungSinglesCouplesSaver */;
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`) VALUES (0,4,'Promo','promo','',@StartDate,@EndDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid,@providerId);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital','WA_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','WA_YoungSinglesCouplesSaver');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@HospitalPDFWA_YoungSinglesCouplesSaver);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`) VALUES (@newid ,'extrasPDF',@ExtraPDFWA_YoungSinglesCouplesSaver);