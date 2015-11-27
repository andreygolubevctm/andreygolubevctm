SET @pid:= (SELECT providerId FROM ctm.provider_master WHERE providerCode = 'WOOL');

UPDATE `ctm`.`car_product_content` SET `effectiveEnd`='2015-11-26' WHERE carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid) AND effectiveEnd = '2040-12-31' LIMIT 2;

-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE `effectiveEnd`='2015-11-26' AND carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid);
-- TEST RESULT AFTER INSERT: 2

INSERT INTO `ctm`.`car_product_content` (`carProductId`, `styleCodeId`, `allowCallMeBack`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('40', '0', 'N', '<ul> <li>24-month new for old car replacement cover if the car is a total loss</li>  <li>Cover for towing costs</li>  <li>Damage to trailer and caravan if attached to your car (belonging to you) ($1000)</li>  <li>Damage to personal property in your car ($500)</li>  <li>Child safety seats and prams replacement ($500)</li>  <li>Emergency travel and accommodation cover ($500)</li>  <li>Third party property damage cover for a substitute car</li>  <li>Locks and keys replacement ($1000)</li>  <li>Cover for your car while in transit</li>  <li>Essential repairs after an accident($300)</li> </ul>', '<ul> <li>Hire car cover</li>  <li>Excess-free windscreen cover</li><li>Roadside assistance cover</li> </ul>', '<ul>  <li>Agreed value or market value – choose your own level of cover</li>  <li>Pay monthly at no extra cost</li>  <li>24 hour emergency claims assistance helpline</li> </ul>', '2015-11-27', '2040-12-31');

SET @UPDATED_DLPL := (SELECT LAST_INSERT_ID());

INSERT INTO `ctm`.`car_product_content` (`carProductId`, `styleCodeId`, `allowCallMeBack`, `inclusions`, `optionalExtras`, `benefits`, `effectiveStart`, `effectiveEnd`) VALUES ('39', '0', 'N', '<ul> <li>24-month new for old car replacement cover if the car is a total loss</li>  <li>Cover for towing costs</li>  <li>Damage to trailer and caravan if attached to your car (belonging to you) ($1000)</li>  <li>Damage to personal property in your car ($500)</li>  <li>Child safety seats and prams replacement ($500)</li>  <li>Emergency travel and accommodation cover ($500)</li>  <li>Third party property damage cover for a substitute car</li>  <li>Locks and keys replacement ($1000)</li>  <li>Cover for your car while in transit</li>  <li>Essential repairs after an accident($300)</li> </ul>', '<ul> <li>Hire car cover</li>  <li>Excess-free windscreen cover</li><li>Roadside assistance cover</li> </ul>', '<ul>  <li>Agreed value or market value – choose your own level of cover</li>  <li>Pay monthly at no extra cost</li>  <li>24 hour emergency claims assistance helpline</li> </ul>', '2015-11-27', '2040-12-31');

SET @UPDATED_Comprehensive := (SELECT LAST_INSERT_ID());

-- SELECT count(*) FROM `ctm`.`car_product_content` WHERE carProductContentId IN (@UPDATED_Comprehensive,@UPDATED_DLPL);
-- TEST RESULT AFTER INSERT: 2


UPDATE `ctm`.`car_product_features` 
SET effectiveEnd = '2015-11-26'
WHERE carProductContentId IN 
   ( SELECT carProductContentId FROM `ctm`.`car_product_content` WHERE `effectiveEnd`='2015-11-26' AND carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid))
AND effectiveStart = '2011-03-01';

-- SELECT count(*) FROM `ctm`.`car_product_features` WHERE carProductContentId IN ( SELECT carProductContentId FROM `ctm`.`car_product_content` WHERE `effectiveEnd`='2015-11-26' AND carProductId IN (SELECT carProductId FROM `ctm`.`car_product` WHERE providerId = @pid)) AND effectiveStart = '2011-03-01' AND effectiveEnd = '2015-11-26';
-- TEST RESULT AFTER UPDATE: 32


-- =========================== CREATE car_product_feature ENTRIES FOR PRODUCT UPDATES =================
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'annKilo','Annual kilometre limit','N','This quote based on [xx,xxx] annual km\'s','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'callcentre','Australian Call Centre','N','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'carbOff','Carbon offset included','N','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'cvrTyp','Cover type','Comprehensive','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'hirecar','Accident Hire Car option available','Y','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'install','Instalment payment option available','Y','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'lifRep','Lifetime repair guarantee','Y','Guaranteed repairs by repairers appointed by Woolworths Insurance.','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'ncdPro','Maximum NCD protection option available','N','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'newRep','New for new replacement','2 Years','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'product','Product','Drive Less Pay Less Comprehensive','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'roadSide','Roadside assistance option available','Y','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'speFea','Special Feature / Offer','S','Get a $100 WISH Gift Card<sup>#</sup>','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'windscreen','Windscreen excess reduction','O','Optional cover available for the repair or replacement of the front windscreen of your car if it is accidentally broken or damaged during the insurance period. No excess will apply for the first windscreen claim made in any one period of insurance.','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'childSeat',NULL,'Y','Limit $500, includes prams','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'disclaimer',NULL,'The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_DLPL,'personalEf',NULL,'Y','Covers up to $500 for loss or damage to personal items which are designed to be worn or carried.','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'annKilo','Annual kilometre limit','Y','Unlimited','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'callcentre','Australian Call Centre','N','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'carbOff','Carbon offset included','N','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'cvrTyp','Cover type','Comprehensive','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'hirecar','Accident Hire Car option available','Y','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'install','Instalment payment option available','Y','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'lifRep','Lifetime repair guarantee','Y','Guaranteed repairs by repairers appointed by Woolworths Insurance.','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'ncdPro','Maximum NCD protection option available','N','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'newRep','New for new replacement','2 Years','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'product','Product','Comprehensive','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'roadSide','Roadside assistance option available','Y','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'speFea','Special Feature / Offer','S','Get a $100 WISH Gift Card<sup>#</sup>','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'windscreen','Windscreen excess reduction','O','Optional cover available for the repair or replacement of the front windscreen of your car if it is accidentally broken or damaged during the insurance period. No excess will apply for the first windscreen claim made in any one period of insurance.','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'childSeat',NULL,'Y','Limit $500, includes prams','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'disclaimer',NULL,'The indicative quote is subject to meeting the insurer\'s underwriting criteria. Please see below for further details.','','2015-11-27','2040-12-31');
INSERT INTO `ctm`.`car_product_features` (`carProductContentId`,`code`,`name`,`value`,`description`,`effectiveStart`,`effectiveEnd`) VALUES (@UPDATED_Comprehensive,'personalEf',NULL,'Y','Covers up to $500 for loss or damage to personal items which are designed to be worn or carried.','2015-11-27','2040-12-31');

-- SELECT count(*) FROM `ctm`.`car_product_features` WHERE carProductContentId IN (@UPDATED_DLPL, @UPDATED_Comprehensive) AND effectiveStart = '2015-11-27' AND effectiveEnd = '2040-12-31';
-- TEST RESULT AFTER INSERT: 32