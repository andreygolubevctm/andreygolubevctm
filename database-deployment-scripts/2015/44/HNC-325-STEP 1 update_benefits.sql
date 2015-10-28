-- =================================================
-- ================== HNC REAL Essential Product

SET @HNCREALEssential = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'REIN-02-01');

-- ==========================================
-- Expire the old more info content
UPDATE `ctm`.`home_product_content` SET `effectiveEnd`='2015-10-29' WHERE homeProductId = @HNCREALEssential LIMIT 3;

-- SELECT count(*) FROM `ctm`.`home_product_content` WHERE `effectiveEnd`='2015-10-29' AND homeProductId = @HNCREALEssential;
-- TEST RESULT: 3

-- ==========================================
-- Add the new more info content
INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('3', '0', 'N', 'HC', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion cover</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Legal Liability</li>  <li>Removal of debris and fees</li>  <li>Emergency accommodation</li>  <li>Replacement of locks</li>  <li>Damage to trees, plants or shrubs</li>  <li>Contents temporarily removed from your home</li>  <li>Contents in your new and old home (while moving to a new address)</li>  <li>Contents in the open air at your home</li>  <li>Contents in your home office</li>  <li>Cover for Strata Title Property owners</li>  <li>Food spoilage</li> <li>Funeral Expenses</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li>  <li>Portable Valuables</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li>  <li>Experience and reliability so you know you&#39;re in safe hands. The Hollard Insurance Group has insurance businesses throughout Africa as well as Europe, India, China, the United States and Australia. They are one of the world&#39;s leading insurers, with 7.2 million policies worldwide.</li> </ul>', '2015-10-30', '2040-12-31');
SET @HCEssentialNew = LAST_INSERT_ID();

INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('3', '0', 'N', 'C', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Legal Liability</li>  <li>Removal of debris and fees</li>  <li>Contents temporarily removed from your home</li>  <li>Contents in your new and old home (when moving to a new address)</li>  <li>Contents in the open air at your home</li>  <li>Contents in your home office</li>  <li>Cover for Strata Title Property owners</li>  <li>Food spoilage</li> <li>Funeral Expenses</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li>  <li>Portable Valuables</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li>  <li>Experience and reliability so you know you&#39;re in safe hands. The Hollard Insurance Group has insurance businesses throughout Africa as well as Europe, India, China, the United States and Australia. They are one of the world&#39;s leading insurers, with 7.2 million policies worldwide.</li> </ul>', '2015-10-30', '2040-12-31');
SET @CEssentialNew = LAST_INSERT_ID();

INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('3', '0', 'N', 'H', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Legal Liability</li>  <li>Removal of debris and fees</li>  <li>Emergency accommodation</li>  <li>Replacement of locks</li>  <li>Damage to trees, plants or shrubs</li> <li>Funeral Expenses</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li>  <li>Experience and reliability so you know you&#39;re in safe hands. The Hollard Insurance Group has insurance businesses throughout Africa as well as Europe, India, China, the United States and Australia. They are one of the world&#39;s leading insurers, with 7.2 million policies worldwide.</li> </ul>', '2015-10-30', '2040-12-31');
SET @HEssentialNew = LAST_INSERT_ID();

-- ==========================================
-- Expire the old funeral features content

UPDATE `ctm`.`home_product_features` SET `effectiveEnd`='2015-10-29' WHERE homeProductContentId IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCREALEssential) LIMIT 48;

-- ==========================================
-- Add the new funeral features content

-- Update the ticks and crosses for funerals and add copy of other benefits
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'speFea', 'Special Feature / Offer', 'S', 'Save up to 20%† when you buy a combined home and contents policy online.', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'speFea', 'Special Feature / Offer', 'S', 'Save up to 10%† when you buy a contents policy online.', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'speFea', 'Special Feature / Offer', 'S', 'Save up to 10%† when you buy a home policy online.', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'cvrTyp', 'Cover Type', 'Home & Contents', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'cvrTyp', 'Cover Type', 'Contents', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'cvrTyp', 'Cover Type', 'Home', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'callcentre', 'Australian Call Centre', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'callcentre', 'Australian Call Centre', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'callcentre', 'Australian Call Centre', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'accDam', 'Accidental damage option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'accDam', 'Accidental damage option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'accDam', 'Accidental damage option available', 'N', '2015-10-30', '2040-12-31');


-- SELECT count(*) FROM `ctm`.`home_product_features` WHERE homeProductContentId IN (@HCEssentialNew, @CEssentialNew, @HEssentialNew)  AND effectiveStart = '2015-10-30';
-- Test After Update: 48

-- ==========================================
-- Expire the old pds links
UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveEnd`='2015-10-29' WHERE `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCREALEssential) LIMIT 6;

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveEnd`='2015-10-29' AND `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCREALEssential);
-- TEST RESULT: 6

-- Add new links to pds'
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'hbkfs', 'legal/KFS_Home-Building_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HCEssentialNew, 'hckfs', 'legal/KFS_Home-Contents_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'hbkfs', 'legal/KFS_Home-Building_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@CEssentialNew, 'hckfs', 'legal/KFS_Home-Contents_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'hbkfs', 'legal/KFS_Home-Building_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HEssentialNew, 'hckfs', 'legal/KFS_Home-Contents_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveStart`='2015-10-30' AND `homeProductContentId` IN (@HCEssentialNew, @CEssentialNew, @HEssentialNew);
-- TEST RESULT: 6



-- =================================================
-- ================== HNC REAL Top Product

SET @HNCREALTop = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'REIN-02-02');

-- ==========================================
-- Expire the old more info content
UPDATE `ctm`.`home_product_content` SET `effectiveEnd`='2015-10-29' WHERE homeProductId = @HNCREALTop LIMIT 3;

-- SELECT count(*) FROM `ctm`.`home_product_content` WHERE `effectiveEnd`='2015-10-29' AND homeProductId = @HNCREALTop;
-- TEST RESULT: 3

-- ==========================================
-- Add the new more info content
INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('4', '0', 'N', 'HC', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion cover</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Accidental damage</li>  <li>Legal Liability</li>  <li>Removal of debris and fees</li>  <li>Emergency accommodation</li>  <li>Replacement of locks</li>  <li>Damage to trees, plants or shrubs</li>  <li>Contents temporarily removed from your home</li>  <li>Contents whilst in transit (while moving to a new address)</li>  <li>Contents in your new and old home (while moving to a new address)</li>  <li>Contents in the open air at your home</li>  <li>Contents in your home office</li>  <li>Cover for Strata Title Property owners</li>  <li>Food spoilage</li> <li>Funeral Expenses</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li>  <li>Portable Valuables</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li>  <li>Experience and reliability so you know you&#39;re in safe hands. The Hollard Insurance Group has insurance businesses throughout Africa as well as Europe, India, China, the United States and Australia. They are one of the world&#39;s leading insurers, with 7.2 million policies worldwide.</li> </ul>', '2015-10-30', '2040-12-31');
SET @HCTopNew = LAST_INSERT_ID();

INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('4', '0', 'N', 'C', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Accidental damage</li>  <li>Removal of debris and fees</li>  <li>Legal Liability</li>  <li>Contents temporarily removed from your home</li>  <li>Contents whilst in transit (when moving to a new address)</li>  <li>Contents in your new and old home (when moving to a new address)</li>  <li>Contents in the open air at your home</li>  <li>Contents in your home office</li>  <li>Cover for Strata Title Property owners</li>  <li>Food spoilage</li> <li>Funeral Expesnes</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li>  <li>Portable Valuables</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li>  <li>Experience and reliability so you know you&#39;re in safe hands. The Hollard Insurance Group has insurance businesses throughout Africa as well as Europe, India, China, the United States and Australia. They are one of the world&#39;s leading insurers, with 7.2 million policies worldwide.</li> </ul>', '2015-10-30', '2040-12-31');
SET @CTopNew = LAST_INSERT_ID();

INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('4', '0', 'N', 'H', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and Explosion</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Legal Liability</li>  <li>Accidental damage</li>  <li>Removal of debris and fees</li>  <li>Emergency accommodation</li>  <li>Replacement of locks</li>  <li>Damage to trees, plants or shrubs</li> <li>Funeral Expenses</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout cover</li>  <li>Choice of Excess</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li>  <li>Experience and reliability so you know you&#39;re in safe hands. The Hollard Insurance Group has insurance businesses throughout Africa as well as Europe, India, China, the United States and Australia. They are one of the world&#39;s leading insurers, with 7.2 million policies worldwide.</li> </ul>', '2015-10-30', '2040-12-31');
SET @HTopNew = LAST_INSERT_ID();


-- ==========================================
-- Expire the old funeral features content

UPDATE `ctm`.`home_product_features` SET `effectiveEnd`='2015-10-29' WHERE homeProductContentId IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCREALTop)  LIMIT 48;

-- ==========================================
-- Add the new funeral features content

-- Update the ticks and crosses for all features
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'speFea', 'Special Feature / Offer', 'S', 'Save up to 20%† when you buy a combined home and contents policy online.', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'speFea', 'Special Feature / Offer', 'S', 'Save up to 10%† when you buy a contents policy online.', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'speFea', 'Special Feature / Offer', 'S', 'Save up to 10%† when you buy a home policy online.', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'cvrTyp', 'Cover Type', 'Home & Contents', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'cvrTyp', 'Cover Type', 'Contents', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'cvrTyp', 'Cover Type', 'Home', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'callcentre', 'Australian Call Centre', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'callcentre', 'Australian Call Centre', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'callcentre', 'Australian Call Centre', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'accDam', 'Accidental damage option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'accDam', 'Accidental damage option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'accDam', 'Accidental damage option available', 'Y', '2015-10-30', '2040-12-31');


-- SELECT count(*) FROM `ctm`.`home_product_features` WHERE  homeProductContentId IN (@HCTopNew, @CTopNew, @HTopNew)  AND effectiveStart = '2015-10-30';
-- Test After Update: 48


-- ==========================================
-- Expire the old pds links
UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveEnd`='2015-10-29' WHERE `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCREALTop) LIMIT 6;

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveEnd`='2015-10-29' AND `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCREALTop);
-- TEST RESULT: 6

-- Add new links to pds'
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'hbkfs', 'legal/KFS_Home-Building_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HCTopNew, 'hckfs', 'legal/KFS_Home-Contents_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'hbkfs', 'legal/KFS_Home-Building_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@CTopNew, 'hckfs', 'legal/KFS_Home-Contents_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'hbkfs', 'legal/KFS_Home-Building_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HTopNew, 'hckfs', 'legal/KFS_Home-Contents_Real_Oct_2015.pdf', '2015-10-30', '2040-12-31');

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveStart`='2015-10-30' AND `homeProductContentId` IN (@HCTopNew, @CTopNew, @HTopNew);
-- TEST RESULT: 6


-- =================================================
-- ================== HNC WOOL Standard Building & Contents Product

SET @HNCWOOLStandard = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'WOOL-02-01');

-- ==========================================
-- Expire the old more info content
UPDATE `ctm`.`home_product_content` SET `effectiveEnd`='2015-10-29' WHERE homeProductId = @HNCWOOLStandard LIMIT 3;

-- SELECT count(*) FROM `ctm`.`home_product_content` WHERE `effectiveEnd`='2015-10-29' AND homeProductId = @HNCWOOLStandard;
-- TEST RESULT: 3

-- ==========================================
-- Add the new more info content
INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('6', '0', 'N', 'HC', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion cover</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Legal Liability</li>  <li>Removal of debris and fees</li>  <li>Emergency accommodation</li>  <li>Replacement of locks</li>  <li>Damage to trees, plants or shrubs</li>  <li>Contents temporarily removed from your home</li>  <li>Contents in your new and old home (while moving to a new address)</li>  <li>Contents in the open air at your home</li>  <li>Contents in your home office</li>  <li>Cover for Strata Title Property owners</li>  <li>Food spoilage</li> <li>Funeral Expenses</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li>  <li>Portable Valuables</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li> </ul>', '2015-10-30', '2040-12-31');
SET @HCStandardNew = LAST_INSERT_ID();

INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('6', '0', 'N', 'C', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Legal Liability</li>  <li>Removal of debris and fees</li>  <li>Contents temporarily removed from your home</li>  <li>Contents in your new and old home (when moving to a new address)</li>  <li>Contents in the open air at your home</li>  <li>Contents in your home office</li>  <li>Cover for Strata Title Property owners</li>  <li>Food spoilage</li> <li>Funeral Expenses</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li>  <li>Portable Valuables</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li> </ul>', '2015-10-30', '2040-12-31');
SET @CStandardNew = LAST_INSERT_ID();

INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('6', '0', 'N', 'H', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Legal Liability</li>  <li>Removal of debris and fees</li>  <li>Emergency accommodation</li>  <li>Replacement of locks</li>  <li>Damage to trees, plants or shrubs</li> <li>Funeral Expenses</li> </ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li> </ul>', '2015-10-30', '2040-12-31');
SET @HStandardNew = LAST_INSERT_ID();


-- ==========================================
-- Expire the old funeral features content

UPDATE `ctm`.`home_product_features` SET `effectiveEnd`='2015-10-29' WHERE homeProductContentId IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCWOOLStandard) LIMIT 48;

-- ==========================================
-- Add the new funeral features content

-- Update the ticks and crosses for funerals and copy of benefits
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'speFea', 'Special Feature / Offer', 'S', 'HHZThis price includes a discount of up to 30% when you take out a policy by 30th January 2015.', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'speFea', 'Special Feature / Offer', 'S', 'HHCThis price includes a discount of up to 30% when you take out a policy by 30th January 2015.', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'speFea', 'Special Feature / Offer', 'S', 'HBBThis price includes a discount of up to 30% when you take out a policy by 30th January 2015.', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'cvrTyp', 'Cover Type', 'Home & Contents', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'cvrTyp', 'Cover Type', 'Contents', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'cvrTyp', 'Cover Type', 'Home', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'callcentre', 'Australian Call Centre', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'callcentre', 'Australian Call Centre', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'callcentre', 'Australian Call Centre', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'accDam', 'Accidental damage option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'accDam', 'Accidental damage option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'accDam', 'Accidental damage option available', 'N', '2015-10-30', '2040-12-31');

-- SELECT count(*) FROM `ctm`.`home_product_features` WHERE homeProductContentId IN (@HCStandardNew, @CStandardNew, @HStandardNew)  AND effectiveStart = '2015-10-30';
-- Test After Update: 48


-- ==========================================
-- Expire the old pds links
UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveEnd`='2015-10-29' WHERE `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCWOOLStandard) LIMIT 6;

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveEnd`='2015-10-29' AND `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCWOOLStandard);
-- TEST RESULT: 6

-- Add new links to pds'
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'hbkfs', 'legal/KFS_Home-Building_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HCStandardNew, 'hckfs', 'legal/KFS_Home-Contents_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'hbkfs', 'legal/KFS_Home-Building_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@CStandardNew, 'hckfs', 'legal/KFS_Home-Contents_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'hbkfs', 'legal/KFS_Home-Building_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HStandardNew, 'hckfs', 'legal/KFS_Home-Contents_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveStart`='2015-10-30' AND `homeProductContentId` IN (@HCStandardNew, @CStandardNew, @HStandardNew);
-- TEST RESULT: 6



-- =================================================
-- ================== HNC WOOL Comprehensive Building & Contents Product

SET @HNCWOOLComprehensive = (SELECT homeProductId FROM ctm.home_product WHERE homeProductCode = 'WOOL-02-02');

-- ==========================================
-- Expire the old more info content
UPDATE `ctm`.`home_product_content` SET `effectiveEnd`='2015-10-29' WHERE homeProductId = @HNCWOOLComprehensive LIMIT 3;

-- SELECT count(*) FROM `ctm`.`home_product_content` WHERE `effectiveEnd`='2015-10-29' AND homeProductId = @HNCWOOLComprehensive;
-- TEST RESULT: 3

-- ==========================================
-- Add the new more info content
INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('7', '0', 'N', 'HC', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion cover</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Accidental damage</li>  <li>Legal Liability</li>  <li>Removal of debris and fees</li>  <li>Emergency accommodation</li>  <li>Replacement of locks</li>  <li>Damage to trees, plants or shrubs</li>  <li>Contents temporarily removed from your home</li>  <li>Contents whilst in transit (while moving to a new address)</li>  <li>Contents in your new and old home (while moving to a new address)</li>  <li>Contents in the open air at your home</li>  <li>Contents in your home office</li>  <li>Cover for Strata Title Property owners</li>  <li>Food spoilage</li><li>Funeral Expenses</li></ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li>  <li>Portable Valuables</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li> </ul>', '2015-10-30', '2040-12-31');
SET @HCComprehensiveNew = LAST_INSERT_ID();

INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('7', '0', 'N', 'C', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and explosion</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Accidental damage</li>  <li>Removal of debris and fees</li>  <li>Legal Liability</li>  <li>Contents temporarily removed from your home</li>  <li>Contents whilst in transit (when moving to a new address)</li>  <li>Contents in your new and old home (when moving to a new address)</li>  <li>Contents in the open air at your home</li>  <li>Contents in your home office</li>  <li>Cover for Strata Title Property owners</li>  <li>Food spoilage</li> <li>Funeral Expenses</li></ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout</li>  <li>Portable Valuables</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li> </ul>', '2015-10-30', '2040-12-31');
SET @CComprehensiveNew = LAST_INSERT_ID();

INSERT INTO `ctm`.`home_product_content` (`homeProductId`, `styleCodeId`, `allowCallMeBack`, `coverType`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('7', '0', 'N', 'H', '<h5>What&#39;s Included</h5> <ul>  <li>Fire and Explosion</li>  <li>Theft</li>  <li>Malicious damage (including vandalism)</li>  <li>Storm, rainwater and flood</li>  <li>Accidental glass breakage</li>  <li>Lightning</li>  <li>Earthquake, tsunami and volcanic eruption</li>  <li>Riot, civil commotion or industrial unrest</li>  <li>Impact</li>  <li>Bursting, leaking, discharge or overflow of water or liquids</li>  <li>Legal Liability</li>  <li>Accidental damage</li>  <li>Removal of debris and fees</li>  <li>Emergency accommodation</li>  <li>Replacement of locks</li>  <li>Damage to trees, plants or shrubs</li> <li>Funeral Expenses</li></ul>', '<h5>Optional Extras</h5> <ul>  <li>Electrical Motor Burnout cover</li>  <li>Choice of Excess</li> </ul>', '<h5>Further Benefits</h5> <ul>  <li>Pay by the month at no extra charge, or pay annually, whatever suits you.</li>  <li>Effortless claims – make a claim in minutes online 24 hours a day or over the phone.</li> </ul>', '2015-10-30', '2040-12-31');
SET @HComprehensiveNew = LAST_INSERT_ID();


-- ==========================================
-- Expire the old funeral features content

UPDATE `ctm`.`home_product_features` SET `effectiveEnd`='2015-10-29' WHERE homeProductContentId IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCWOOLComprehensive) LIMIT 48;

-- ==========================================
-- Add the new funeral features content

-- Update the ticks and crosses for funerals and a copy of extra benefits
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'funeral', 'Funeral expenses', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'tmpAccom', 'Temporary accommodation costs', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'storm', 'Storm and rainwater damage included', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'speFea', 'Special Feature / Offer', 'S', 'HHZThis price includes a discount of up to 30% when you take out a policy by 30th January 2015.', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'speFea', 'Special Feature / Offer', 'S', 'HHCThis price includes a discount of up to 30% when you take out a policy by 30th January 2015.', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `featureDescription`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'speFea', 'Special Feature / Offer', 'S', 'HHBThis price includes a discount of up to 30% when you take out a policy by 30th January 2015.', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'pets', 'Pet insurance available as a separate product', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'mtrBurn', 'Motor burnout option available', 'O', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'lifeHome', 'Lifetime building repair guarantee ', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'lifeCnts', 'Landlord insurance option available', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'guest', "Uninsured guests' contents cover", 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'flood', 'Flood cover option available', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'fireTheft', 'Fire or theft damage included', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'cvrTyp', 'Cover Type', 'Home & Contents', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'cvrTyp', 'Cover Type', 'Contents', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'cvrTyp', 'Cover Type', 'Home', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'cntsOut', 'Protect contents left outside in the open', 'Y', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'cntsAway', 'Protect contents away from the home', 'O', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'ccard', 'Credit card cover', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'callcentre', 'Australian Call Centre', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'callcentre', 'Australian Call Centre', 'N', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'callcentre', 'Australian Call Centre', 'N', '2015-10-30', '2040-12-31');

INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'accDam', 'Accidental damage option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'accDam', 'Accidental damage option available', 'Y', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_features` (`homeProductContentId`, `featureCode`, `featureName`, `featureValue`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'accDam', 'Accidental damage option available', 'Y', '2015-10-30', '2040-12-31');

 SELECT * FROM `ctm`.`home_product_features` WHERE homeProductContentId IN (@HCComprehensiveNew, @CComprehensiveNew, @HComprehensiveNew) AND effectiveStart = '2015-10-30';
-- Test After Update: 48


-- ==========================================
-- Expire the old pds links
UPDATE `ctm`.`home_product_disclosure_statements` SET `effectiveEnd`='2015-10-29' WHERE `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCWOOLComprehensive) LIMIT 6;

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveEnd`='2015-10-29' AND `homeProductContentId` IN (SELECT homeProductContentId FROM `ctm`.`home_product_content` WHERE homeProductId = @HNCWOOLComprehensive);
-- TEST RESULT: 6

-- Add new links to pds'
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'hbkfs', 'legal/KFS_Home-Building_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HCComprehensiveNew, 'hckfs', 'legal/KFS_Home-Contents_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'hbkfs', 'legal/KFS_Home-Building_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@CComprehensiveNew, 'hckfs', 'legal/KFS_Home-Contents_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'hbkfs', 'legal/KFS_Home-Building_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');
INSERT INTO `ctm`.`home_product_disclosure_statements` (`homeProductContentId`, `disclosureStatementCode`, `disclosureStatementUrl`, `effectiveStart`, `effectiveEnd`) VALUES (@HComprehensiveNew, 'hckfs', 'legal/KFS_Home-Contents_Woolworths_Oct_2015.pdf', '2015-10-30', '2040-12-31');

-- SELECT count(*) FROM `ctm`.`home_product_disclosure_statements` WHERE `effectiveStart`='2015-10-30' AND `homeProductContentId` IN (@HCComprehensiveNew, @CComprehensiveNew, @HComprehensiveNew);
-- TEST RESULT: 6