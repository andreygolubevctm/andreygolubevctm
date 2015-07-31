-- ================ TESTS =====================
-- ========= BEFORE INSERT TESTS ==============
-- When this is run before anything else on the ctm.product_properties table, query should return 42 rows
SELECT count(*) FROM ctm.product_properties WHERE ProductId IN(37,38) AND SequenceNo > 0 LIMIT 999999;

/* Delete existing prices in product properties */
DELETE FROM ctm.product_properties WHERE ProductId IN(37,38) AND SequenceNo > 0 LIMIT 42;

/* Insert product properties pricing*/
INSERT INTO ctm.product_properties VALUES ( 38, 'ageMax', 1, 49, '49', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'durMax', 1, 365, '365', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-DUO', 1, 548.20, '$548.20', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'ageMin', 1, 0, '0', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-SIN', 1, 274.10, '$274.10', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'durMin', 1, 1, '1', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-FAM', 1, 548.20, '$548.20', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'ageMax', 2, 59, '59', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'durMax', 2, 365, '365', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-DUO', 2, 746.50, '$746.50', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'ageMin', 2, 50, '50', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-SIN', 2, 373.25, '$373.25', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'durMin', 2, 1, '1', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-FAM', 2, 746.50, '$746.50', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'ageMax', 3, 69, '69', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'durMax', 3, 365, '365', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-DUO', 3, 892.94, '$892.94', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'ageMin', 3, 60, '60', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-SIN', 3, 446.47, '$446.47', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'durMin', 3, 1, '1', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 38, 'R1-FAM', 3, 892.94, '$892.94', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'ageMax', 1, 49, '49', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'durMax', 1, 365, '365', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-DUO', 1, 330.48, '$330.48', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'ageMin', 1, 0, '0', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-SIN', 1, 165.24, '$165.24', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'durMin', 1, 1, '1', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-FAM', 1, 330.48, '$330.48', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'ageMax', 2, 59, '59', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'durMax', 2, 365, '365', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-DUO', 2, 449.72, '$449.72', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'ageMin', 2, 50, '50', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-SIN', 2, 224.86, '$224.86', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'durMin', 2, 1, '1', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-FAM', 2, 449.72, '$449.72', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'ageMax', 3, 69, '69', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'durMax', 3, 365, '365', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-DUO', 3, 528.76, '$528.76', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'ageMin', 3, 60, '60', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-SIN', 3, 264.38, '$264.38', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'durMin', 3, 1, '1', NULL, CURDATE(), '2040-12-31', '', 0 ) ,
  ( 37, 'R1-FAM', 3, 528.76, '$528.76', NULL, CURDATE(), '2040-12-31', '', 0 );


-- ========= AFTER INSERT TESTS ==============
-- When this is run after the insert statements on the ctm.product_properties table, query should return 42 rows
SELECT count(*) FROM ctm.product_properties WHERE ProductId IN(37,38) AND SequenceNo > 0 LIMIT 999999;
-- ================ =====================

