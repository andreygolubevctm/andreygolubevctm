/* insert Smart Essentials PDFs */
use ctm;
SET @fundCode = '1';
SET @productName = 'Smart Essentials';
SET @startDate = '2015-04-01 00:00:01';
SET @endDate = '2040-06-30 00:00:00';
SET @pdfLocation = '/AUF/Smart_Essentials.pdf';



INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`)
VALUES (0,4,'Promo','promo','',@startDate,@endDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid, @fundCode);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital',@productName);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@pdfLocation);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras',@productName);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'extrasPDF',@pdfLocation);

