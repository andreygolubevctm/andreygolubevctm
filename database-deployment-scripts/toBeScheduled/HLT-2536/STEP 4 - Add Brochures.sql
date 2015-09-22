/* insert black+white starter PDFs */
use ctm;
SET @fundCode = '9';
SET @productName = 'black+white starter';
SET @startDate = '2015-04-01 00:00:01';
SET @endDate = '2016-03-31 00:00:00';
SET @pdfLocation = '/AHM/black_+_white_starter.pdf';

/* don't forget to replace 'REPLACE ME' with real values  */
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`)
VALUES (0,4,'Promo','promo','',@startDate,@endDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid, @fundCode);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital',@productName);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@pdfLocation);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','black+white starter');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'extrasPDF',@pdfLocation);

/* insert black+white lite PDFs */
use ctm;
SET @fundCode = '9';
SET @productName = 'black+white lite';
SET @startDate = '2015-04-01 00:00:01';
SET @endDate = '2016-03-31 00:00:00';
SET @pdfLocation = '/AHM/black_+_white_lite.pdf';

/* don't forget to replace 'REPLACE ME' with real values  */
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`)
VALUES (0,4,'Promo','promo','',@startDate,@endDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid, @fundCode);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital',@productName);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@pdfLocation);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','black+white lite');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'extrasPDF',@pdfLocation);


/* insert black+white classic PDFs */
use ctm;
SET @fundCode = '9';
SET @productName = 'black+white classic';
SET @startDate = '2015-04-01 00:00:01';
SET @endDate = '2016-03-31 00:00:00';
SET @pdfLocation = '/AHM/black_+_white_classic.pdf';

/* don't forget to replace 'REPLACE ME' with real values  */
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`)
VALUES (0,4,'Promo','promo','',@startDate,@endDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid, @fundCode);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital',@productName);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@pdfLocation);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','black+white classic');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'extrasPDF',@pdfLocation);


/* insert black+white deluxe PDFs */
use ctm;
SET @fundCode = '9';
SET @productName = 'black+white deluxe';
SET @startDate = '2015-04-01 00:00:01';
SET @endDate = '2016-03-31 00:00:00';
SET @pdfLocation = '/AHM/black_+_white_deluxe.pdf';

/* don't forget to replace 'REPLACE ME' with real values  */
INSERT INTO `content_control` (`styleCodeId`,`verticalId`,`contentCode`,`contentKey`,`contentStatus`,`effectiveStart`,`effectiveEnd`,`contentValue`)
VALUES (0,4,'Promo','promo','',@startDate,@endDate,'product');
SET @newid = LAST_INSERT_ID();
INSERT INTO `content_control_provider` (`contentControlId`,`providerId`) VALUES (@newid, @fundCode);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@hospital',@productName);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'hospitalPDF',@pdfLocation);
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'@extras','black+white deluxe');
INSERT INTO `content_supplementary` (`contentControlId`,`supplementaryKey`,`supplementaryValue`)
VALUES (@newid ,'extrasPDF',@pdfLocation);

