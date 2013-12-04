/* Rename product */
UPDATE aggregator.product_master SET longTitle = 'Standard - AMT - Inc. USA, Canada, China, Hong Kong &amp; Japan' WHERE ProductId = 29;
UPDATE aggregator.product_master SET shortTitle = 'Standard - AMT - Inc. USA, Canada, China, Hong Kong &amp; Japan' WHERE ProductId = 29;

/* Rename product */
UPDATE aggregator.product_master SET longTitle = 'Premier - AMT - Inc. USA, Canada, China, Hong Kong &amp; Japan' WHERE ProductId = 30;
UPDATE aggregator.product_master SET shortTitle = 'Premier - AMT - Inc. USA, Canada, China, Hong Kong &amp; Japan' WHERE ProductId = 30;

/* Add new product master */
INSERT INTO aggregator.product_master (ProductId, ProductCat, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd) VALUES (191, 'TRAVEL',9,'Standard - AMT - Exc. USA, Canada, China, Hong Kong &amp; Japan','Standard - AMT - Exc. USA, Canada, China, Hong Kong &amp; Japan','2013-08-29','2040-12-31');

/* Add new product master */
INSERT INTO aggregator.product_master (ProductId, ProductCat, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd) VALUES (192, 'TRAVEL',9,'Premier - AMT - Exc. USA, Canada, China, Hong Kong &amp; Japan','Premier - AMT - Exc. USA, Canada, China, Hong Kong &amp; Japan','2013-08-29','2040-12-31');

/* Delete existing prices in product properties */
DELETE FROM aggregator.product_properties WHERE ProductId IN(29,30,191,192) AND SequenceNo > 0;

/* Insert product properties */
INSERT INTO aggregator.product_properties VALUES( 191, 'cxdfee', 0, 10000, '$10,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'excess', 0, 250, '$250', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'infoDes', 0, 0, 'Columbus Direct offers great value cover at competitive prices and is one of only two providers to have achieved a 5-star rating for international travel insurance in the 2011 survey by independent ratings agency, CANSTAR. Customer satisfaction and value-for-money are the driving forces behind Columbus and the company takes pride in delivering an efficient, hassle-free service for customers. Columbus Direct Travel Insurance Pty Limited (ABN 99 107 050 582) is an AFSL Licence holder: No. 246636.', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'liability', 0, 2500000, '$2,500,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'luggage', 0, 6000, '$6,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'maxLeisure', 0, 60, '60 Days', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'medical', 0, 12500000, '$12,500,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'multitrip', 0, 1, 'Y', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'rentalVeh', 0, 3000, '$3,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'subTitle', 0, 0, 'Family cover - &lt;br&gt;&lt;a href=http://www.columbusdirect.com/aus/docs/PDS.pdf target=_blank&gt;Click for Details&lt;/a&gt;', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'traveldelay', 0, 500, '$500', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'cxdfee', 0, 15000, '$15,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'excess', 0, 125, '$125', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'infoDes', 0, 0, 'Columbus Direct offers great value cover at competitive prices and is one of only two providers to have achieved a 5-star rating for international travel insurance in the 2011 survey by independent ratings agency, CANSTAR. Customer satisfaction and value-for-money are the driving forces behind Columbus and the company takes pride in delivering an efficient, hassle-free service for customers. Columbus Direct Travel Insurance Pty Limited (ABN 99 107 050 582) is an AFSL Licence holder: No. 246636.', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'liability', 0, 5000000, '$5,000,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'luggage', 0, 7500, '$7,500', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'maxLeisure', 0, 60, '60 Days', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'medical', 0, 20000000, '$20,000,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'multitrip', 0, 1, 'Y', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'rentalVeh', 0, 4000, '$4,000', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'subTitle', 0, 0, 'Family cover - &lt;br&gt;&lt;a href=http://www.columbusdirect.com/aus/docs/PDS.pdf target=_blank&gt;Click for Details&lt;/a&gt;', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'traveldelay', 0, 1000, '$1,000', NULL, curdate(), '2040-12-31', '', 0 );

/* Insert product properties pricing*/
INSERT INTO aggregator.product_properties VALUES( 29, 'ageMax', 1, 59, '59', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'ageMin', 1, 19, '19', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'durMin', 1, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'R1-DUO', 1, 465, '$465.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'R1-SIN', 1, 320, '$320.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'R1-FAM', 1, 540, '$540.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'durMax', 1, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'ageMax', 2, 69, '69', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'ageMin', 2, 60, '60', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'durMin', 2, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'R1-DUO', 2, 512, '$512.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'R1-SIN', 2, 352, '$352.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'R1-FAM', 2, 594, '$594.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'durMax', 2, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'ageMax', 3, 74, '74', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'ageMin', 3, 70, '70', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'durMin', 3, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'R1-DUO', 3, 870, '$870.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'R1-SIN', 3, 598, '$598.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 29, 'durMax', 3, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'ageMax', 1, 59, '59', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'ageMin', 1, 19, '19', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'durMin', 1, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'R1-DUO', 1, 535, '$535.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'R1-SIN', 1, 365, '$365.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'R1-FAM', 1, 620, '$620.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'durMax', 1, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'ageMax', 2, 69, '69', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'ageMin', 2, 60, '60', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'durMin', 2, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'R1-DUO', 2, 589, '$589.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'R1-SIN', 2, 402, '$402.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'R1-FAM', 2, 682, '$682.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'durMax', 2, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'ageMax', 3, 74, '74', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'ageMin', 3, 70, '70', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'durMin', 3, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'R1-DUO', 3, 1000, '$1,000.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'R1-SIN', 3, 688, '$688.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 30, 'durMax', 3, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'ageMax', 1, 59, '59', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'ageMin', 1, 19, '19', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'durMin', 1, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'R1-DUO', 1, 420, '$420.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'R1-SIN', 1, 290, '$290.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'R1-FAM', 1, 490, '$490.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'durMax', 1, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'ageMax', 2, 69, '69', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'ageMin', 2, 60, '60', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'durMin', 2, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'R1-DUO', 2, 462, '$462.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'R1-SIN', 2, 319, '$319.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'R1-FAM', 2, 539, '$539.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'durMax', 2, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'ageMax', 3, 74, '74', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'ageMin', 3, 70, '70', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'durMin', 3, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'R1-DUO', 3, 785, '$785.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'R1-SIN', 3, 542, '$542.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 191, 'durMax', 3, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'ageMax', 1, 59, '59', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'ageMin', 1, 19, '19', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'durMin', 1, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'R1-DUO', 1, 480, '$480.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'R1-SIN', 1, 330, '$330.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'R1-FAM', 1, 560, '$560.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'durMax', 1, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'ageMax', 2, 69, '69', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'ageMin', 2, 60, '60', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'durMin', 2, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'R1-DUO', 2, 528, '$528.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'R1-SIN', 2, 363, '$363.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'R1-FAM', 2, 616, '$616.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'durMax', 2, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'ageMax', 3, 74, '74', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'ageMin', 3, 70, '70', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'durMin', 3, 1, '1', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'R1-DUO', 3, 903, '$903.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'R1-SIN', 3, 624, '$624.00', NULL, curdate(), '2040-12-31', '', 0 );
INSERT INTO aggregator.product_properties VALUES( 192, 'durMax', 3, 365, '365', NULL, curdate(), '2040-12-31', '', 0 );