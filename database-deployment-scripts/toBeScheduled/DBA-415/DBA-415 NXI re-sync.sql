--------------------------------------------------------------------------------------------------------
-- NXI only and could not find any usage in code base
--------------------------------------------------------------------------------------------------------
DROP TABLE `aggregator`.`duplicated_leads`;
DROP TABLE `aggregator`.`export_glasses_extract`;
DROP TABLE `aggregator`.`export_product_capping_exclusions`;
DROP TABLE `aggregator`.`features_cc`;
DROP TABLE `aggregator`.`glasses_extract_PMM`;
DROP TABLE `aggregator`.`ranking_details_copy`;
DROP TABLE `aggregator`.`ranking_master_copy`;
DROP TABLE `aggregator`.`ranking_priorities`;
DROP TABLE `aggregator`.`street_number_old`;
DROP TABLE `aggregator`.`streets_old`;
DROP TABLE `aggregator`.`temp_unsub`;

--------------------------------------------------------------------------------------------------------
-- NXQ and PRO but not matching in NXI
--------------------------------------------------------------------------------------------------------
ALTER ONLINE TABLE `aggregator`.`email_master` DROP COLUMN emailPwordHash;
ALTER ONLINE TABLE `aggregator`.`email_master` ADD INDEX `SimplesSearch` (`emailAddress`);

ALTER ONLINE TABLE `aggregator`.`email_properties` CHANGE brand brand VARCHAR(5) NOT NULL;
ALTER ONLINE TABLE `aggregator`.`email_properties` CHANGE `value` `value` VARCHAR(25) NOT NULL;
ALTER ONLINE TABLE `aggregator`.`email_properties` DROP PRIMARY KEY;
ALTER ONLINE TABLE `aggregator`.`email_properties` ADD PRIMARY KEY( `emailAddress`, `propertyId`, `brand`, `vertical`);

-- It is going to be added in DBA-414
-- ALTER ONLINE TABLE `aggregator`.`fuel_sites` DROP INDEX `postcode_idx`;



CREATE TABLE `aggregator`.`export_product_capping_exclusions` (
 `productId` int(11) NOT NULL,
 `effectiveStart` date NOT NULL,
 `effectiveEnd` date NOT NULL,
 PRIMARY KEY  ( `productId`, `effectiveStart`, `effectiveEnd` )
)
ENGINE = InnoDB
CHARACTER SET = latin1
ROW_FORMAT = COMPACT;



--------------------------------------------------------------------------------------------------------
-- I'll check with Andrew
--------------------------------------------------------------------------------------------------------
CREATE TABLE `aggregator`.`product_master` (
 `ProductId` int(11) NOT NULL AUTO_INCREMENT,
 `ProductCat` char(10) NOT NULL,
 `ProviderId` int(11) NOT NULL,
 `ShortTitle` varchar(128) NOT NULL,
 `LongTitle` varchar(128) NOT NULL,
 `EffectiveStart` date NOT NULL DEFAULT '2011-03-01',
 `EffectiveEnd` date NOT NULL DEFAULT '2040-12-31',
 `Status` char(1) NOT NULL,
 PRIMARY KEY  ( `ProductId` ),
 KEY `PROVIDER_CAT` ( `ProviderId`, `ProductCat`, `ProductId` )
)
ENGINE = InnoDB
CHARACTER SET = latin1
ROW_FORMAT = COMPACT;


CREATE TABLE `aggregator`.`product_properties` (
 `ProductId` int(11) NOT NULL,
 `PropertyId` char(20) NOT NULL,
 `SequenceNo` int(11) NOT NULL DEFAULT '0',
 `Value` double DEFAULT '0',
 `Text` varchar(640) NOT NULL DEFAULT ' ',
 `Date` date DEFAULT NULL,
 `EffectiveStart` date NOT NULL DEFAULT '2011-03-01',
 `EffectiveEnd` date NOT NULL DEFAULT '2040-12-31',
 `Status` char(1) NOT NULL,
 `benefitOrder` int(2) DEFAULT NULL,
 PRIMARY KEY  ( `ProductId`, `PropertyId`, `SequenceNo` )
)
ENGINE = InnoDB
CHARACTER SET = latin1
ROW_FORMAT = COMPACT;

--------------------------------------------------------------------------------------------------------


ALTER ONLINE TABLE `aggregator`.`ranking_details` CHANGE Property Property varchar(25) NOT NULL DEFAULT '0';


CREATE TABLE `aggregator`.`rating_table` (
 `Provider` varchar(50) NOT NULL,
 `Product` varchar(50) NOT NULL,
 `DurMin` varchar(5) NOT NULL,
 `DurMax` varchar(5) NOT NULL,
 `AgeMin` varchar(5) NOT NULL,
 `AgeMax` varchar(5) NOT NULL,
 `WW-Single` varchar(10) NOT NULL,
 `WW-Duo` varchar(10) NOT NULL,
 `WW-Family` varchar(10) NOT NULL,
 `EU-Single` varchar(10) NOT NULL,
 `EU-Duo` varchar(10) NOT NULL,
 `EU-Family` varchar(10) NOT NULL,
 `AS-Single` varchar(10) NOT NULL,
 `AS-Duo` varchar(10) NOT NULL,
 `AS-Family` varchar(10) NOT NULL,
 `PA-Single` varchar(10) NOT NULL,
 `PA-Duo` varchar(10) NOT NULL,
 `PA-Family` varchar(10) NOT NULL,
 `DO-Single` varchar(10) NOT NULL,
 `DO-Dou` varchar(10) NOT NULL,
 `DO-Family` varchar(10) NOT NULL,
 `id` int(11) NOT NULL AUTO_INCREMENT,
 PRIMARY KEY  ( `id` )
)
ENGINE = InnoDB
CHARACTER SET = latin1
ROW_FORMAT = COMPACT;


ALTER ONLINE TABLE `aggregator`.`statistic_details` CHANGE ProductId ProductId varchar(127) NOT NULL;



--------------------------------------------------------------------------------------------------------
-- transaction_details is VERY different from NXQ and PROD
--------------------------------------------------------------------------------------------------------
ALTER ONLINE TABLE `aggregator`.`transaction_details` DROP INDEX `sequenceNo`;
ALTER ONLINE TABLE `aggregator`.`transaction_details` DROP INDEX `textValue`;
ALTER ONLINE TABLE `aggregator`.`transaction_details` DROP INDEX `transactionId`;
ALTER ONLINE TABLE `aggregator`.`transaction_details` DROP INDEX `transdate`;
ALTER ONLINE TABLE `aggregator`.`transaction_details` DROP INDEX `xpath`;

ALTER ONLINE TABLE `aggregator`.`transaction_details` ADD INDEX `SimplesSearchA` ( `transactionId` );
ALTER ONLINE TABLE `aggregator`.`transaction_details` ADD INDEX `SimplesSearchB` ( `sequenceNo` );
ALTER ONLINE TABLE `aggregator`.`transaction_details` ADD INDEX `textValues` ( `textValue`(767) );


ALTER ONLINE TABLE `aggregator`.`transaction_header` CHANGE styleCodeId styleCodeId tinyint(3) UNSIGNED NOT NULL;


--------------------------------------------------------------------------------------------------------
-- I could not see code base using following views
--------------------------------------------------------------------------------------------------------
DROP VIEW `aggregator`.`health_contactNumber`;
DROP VIEW `aggregator`.`health_contactNumber_mobile`;
DROP VIEW `aggregator`.`health_contactNumber_other`;

ALTER VIEW `aggregator`.`health_moreinfo_transaction_details_data`
AS
   SELECT `health_transaction_details`.`transactionId` AS `transactionId`,
          `health_transaction_details`.`xpath` AS `xpath`,
          `health_transaction_details`.`textValue` AS `textValue`
     FROM `aggregator`.`health_transaction_details`
    WHERE (   (`health_transaction_details`.`xpath` IN ('health/situation/state',
                                                        'health/situation/healthCvr',
                                                        'health/contactDetails/lastname',
                                                        'health/contactDetails/firstName',
                                                        'health/contactDetails/name',
                                                        'health/contactDetails/contactNumber',
                                                        'health/contactDetails/email',
                                                        'health/healthCover/primary/dob',
                                                        'health/healthCover/partner/dob',
                                                        'health/application/mobile',
                                                        'health/application/other',
                                                        'health/application/primary/surname',
                                                        'health/application/primary/firstname',
                                                        'health/application/primary/dob',
                                                        'health/application/partner/surname',
                                                        'health/application/partner/firstname',
                                                        'health/application/partner/dob',
                                                        'health/application/address/unitShop',
                                                        'health/application/address/houseNoSel',
                                                        'health/application/address/streetName',
                                                        'health/application/address/suburbName',
                                                        'health/application/address/state',
                                                        'health/application/address/postCode',
                                                        'health/application/email'))
           OR (`health_transaction_details`.`xpath` LIKE 'health/benefits/%'))
   ORDER BY `health_transaction_details`.`transactionId` DESC,
            `health_transaction_details`.`sequenceNo`;

ALTER VIEW `aggregator`.`health_search_transaction_details_data`
AS
   SELECT `health_transaction_details`.`transactionId` AS `transactionId`,
          `health_transaction_details`.`xpath` AS `xpath`,
          `health_transaction_details`.`textValue` AS `textValue`
     FROM `aggregator`.`health_transaction_details`
    WHERE (`health_transaction_details`.`xpath` IN ('health/contactDetails/lastname',
                                                    'health/contactDetails/firstName',
                                                    'health/contactDetails/lastname',
                                                    'health/contactDetails/name',
                                                    'health/contactDetails/contactNumber',
                                                    'health/contactDetails/email',
                                                    'health/application/mobile',
                                                    'health/application/other',
                                                    'health/application/primary/surname',
                                                    'health/application/primary/firstname',
                                                    'health/application/email'));

ALTER VIEW `aggregator`.`health_search_transaction_header`
AS
   SELECT `h`.`TransactionId` AS `TransactionId`,
          `h`.`EmailAddress` AS `EmailAddress`,
          `h`.`StartDate` AS `StartDate`,
          `h`.`StartTime` AS `StartTime`,
          `h`.`rootId` AS `rootId`,
          `h`.`ProductType` AS `ProductType`
     FROM `aggregator`.`transaction_header` `h`
    WHERE (    ((to_days(curdate()) - to_days(`h`.`StartDate`)) < 30)
           AND (`h`.`ProductType` = 'health'));



DROP VIEW `aggregator`.`street_search`;
DROP VIEW `aggregator`.`v__street_search`;
DROP VIEW `aggregator`.`vw_elastic_street_address_copy`;



DROP PROCEDURE `aggregator`.`delete_ccDetails`;
DROP PROCEDURE `aggregator`.`delete_fatal_error`;
DROP PROCEDURE `aggregator`.`restore_rankingdata`;
DROP PROCEDURE `aggregator`.`SetNewYearCarModelsTEST`;