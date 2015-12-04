INSERT INTO `aggregator`.`general` (`type`, `code`, `description`, `orderSeq`) VALUES ('healthCvrType', 'C', 'Combined', '1');
INSERT INTO `aggregator`.`general` (`type`, `code`, `description`, `orderSeq`) VALUES ('healthCvrType', 'E', 'Extras', '3');
INSERT INTO `aggregator`.`general` (`type`, `code`, `description`, `orderSeq`) VALUES ('healthCvrType', 'H', 'Hospital', '2');

INSERT INTO `aggregator`.`transaction_fields` (`fieldId`, `fieldMaster`, `fieldCategory`, `fieldCode`, `verticalId`, `fieldPriority`, `fieldProfile`, `fieldPrivate`, `fieldHidden`, `isMaster`, `effectiveEnd`) VALUES ('2489', '0', '6', 'health/situation/coverType', '4', '1', '0', '0', '0', '0', '2040-12-31 00:00:00');

-- Test - Should be 3 records
SELECT * FROM aggregator.general where type = 'healthCvrType';

-- Test - Should be 1 record
SELECT * FROM aggregator.transaction_fields where fieldcode = 'health/situation/coverType';

-- Add classnames to certain benefits so that they can get the icons
UPDATE `aggregator`.`features_details` SET `className`='CTM-acupuncture' WHERE `id`='7062';
UPDATE `aggregator`.`features_details` SET `className`='CTM-birth' WHERE `id`='6957';
UPDATE `aggregator`.`features_details` SET `className`='CTM-chiropractor' WHERE `id`='7045';
UPDATE `aggregator`.`features_details` SET `className`='CTM-dental' WHERE `id`='7002';
UPDATE `aggregator`.`features_details` SET `className`='CTM-generaldental' WHERE `id`='6991';
UPDATE `aggregator`.`features_details` SET `className`='CTM-heartsurgery' WHERE `id`='6954';
UPDATE `aggregator`.`features_details` SET `className`='CTM-joint' WHERE `id`='6966';
UPDATE `aggregator`.`features_details` SET `className`='CTM-massage' WHERE `id`='7078';
UPDATE `aggregator`.`features_details` SET `className`='CTM-naturopathy' WHERE `id`='7070';
UPDATE `aggregator`.`features_details` SET `className`='CTM-optical' WHERE `id`='7028';
UPDATE `aggregator`.`features_details` SET `className`='CTM-physiotherapy' WHERE `id`='7036';
UPDATE `aggregator`.`features_details` SET `className`='CTM-podiatry' WHERE `id`='7054';
UPDATE `aggregator`.`features_details` SET `className`='CTM-hospital' WHERE `id`='6953';
UPDATE `aggregator`.`features_details` SET `className`='CTM-psychology' WHERE `id`='6984';

-- Reorder the benefits so the icons are the first elements
UPDATE `aggregator`.`features_details` SET `sequence`='3' WHERE `id`='6954';
UPDATE `aggregator`.`features_details` SET `sequence`='4' WHERE `id`='6957';
UPDATE `aggregator`.`features_details` SET `sequence`='5' WHERE `id`='6966';
UPDATE `aggregator`.`features_details` SET `sequence`='6' WHERE `id`='6984';
UPDATE `aggregator`.`features_details` SET `sequence`='7' WHERE `id`='6952';
UPDATE `aggregator`.`features_details` SET `sequence`='8' WHERE `id`='6960';
UPDATE `aggregator`.`features_details` SET `sequence`='9' WHERE `id`='6963';
UPDATE `aggregator`.`features_details` SET `sequence`='10' WHERE `id`='6969';
UPDATE `aggregator`.`features_details` SET `sequence`='11' WHERE `id`='6972';
UPDATE `aggregator`.`features_details` SET `sequence`='12' WHERE `id`='6975';
UPDATE `aggregator`.`features_details` SET `sequence`='13' WHERE `id`='6978';
UPDATE `aggregator`.`features_details` SET `sequence`='14' WHERE `id`='6981';
UPDATE `aggregator`.`features_details` SET `sequence`='3' WHERE `id`='7028';
UPDATE `aggregator`.`features_details` SET `sequence`='4' WHERE `id`='7036';
UPDATE `aggregator`.`features_details` SET `sequence`='5' WHERE `id`='7045';
UPDATE `aggregator`.`features_details` SET `sequence`='6' WHERE `id`='7054';
UPDATE `aggregator`.`features_details` SET `sequence`='7' WHERE `id`='7062';
UPDATE `aggregator`.`features_details` SET `sequence`='8' WHERE `id`='7070';
UPDATE `aggregator`.`features_details` SET `sequence`='9' WHERE `id`='7078';
UPDATE `aggregator`.`features_details` SET `sequence`='15' WHERE `id`='7111';
UPDATE `aggregator`.`features_details` SET `sequence`='2' WHERE `id`='7002';
UPDATE `aggregator`.`features_details` SET `sequence`='10' WHERE `id`='7011';
UPDATE `aggregator`.`features_details` SET `sequence`='11' WHERE `id`='7019';
UPDATE `aggregator`.`features_details` SET `sequence`='12' WHERE `id`='7086';
UPDATE `aggregator`.`features_details` SET `sequence`='13' WHERE `id`='7095';
UPDATE `aggregator`.`features_details` SET `sequence`='14' WHERE `id`='7103';
UPDATE `aggregator`.`features_details` SET `sequence`='16' WHERE `id`='7119';
UPDATE `aggregator`.`features_details` SET `sequence`='17' WHERE `id`='7126';
UPDATE `aggregator`.`features_details` SET `sequence`='18' WHERE `id`='7134';
UPDATE `aggregator`.`features_details` SET `sequence`='19' WHERE `id`='7142';
UPDATE `aggregator`.`features_details` SET `sequence`='20' WHERE `id`='7150';
UPDATE `aggregator`.`features_details` SET `sequence`='21' WHERE `id`='7158';


