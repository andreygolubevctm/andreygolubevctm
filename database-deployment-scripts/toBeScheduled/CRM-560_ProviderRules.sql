CREATE TABLE `ctm`.`health_provider_rules` (

  `healthProviderRulesId` int(11) NOT NULL AUTO_INCREMENT,
  `providerId` smallint(5) UNSIGNED NOT NULL,

  `effectiveStart` date NOT NULL,
  `effectiveEnd` date NOT NULL,

  `middleNameAsked` TINYINT(1) NOT NULL,
  `commencementDateStartOffset`int(3) NOT NULL,
  `commencementDateEndOffset` int(3) NOT NULL,
  `receiveInformationAsked` TINYINT(1) NOT NULL,
  `emailAddressMandatory` TINYINT(1) NOT NULL,
  `ageMinimum` int(3) NOT NULL,
  `ageMaximum` int(3) NOT NULL,
  `customQuestionSet` ENUM('CBH'),
  `previousFundMemberIdRule` ENUM('MANDATORY','OPTIONAL','FALSE') NOT NULL,
  `previousFundMemberIdMaximumLength` int(3),
  `medicareDetailsMandatory` TINYINT(1) NOT NULL,
  `governmentRebateFormAsked` TINYINT(1) NOT NULL,
  `primaryPreviousFundAuthorityAsked` TINYINT(1) NOT NULL,
  `partnerPreviousFundAuthorityAsked` TINYINT(1) NOT NULL,
  `partnerFundAuthorityAsked` TINYINT(1) NOT NULL,
  `provideBankDetailsForRefundsRule` ENUM('MANDATORY','OPTIONAL','FALSE') NOT NULL,

  `aboutTheFundText` text,
  `nextStepsText` text,
  `fundWarningText` varchar(1000),

  `dependantsIntroductionText` varchar(1000),
  `dependantsAgeMinimum` int(3),
  `dependantsAgeMaximum` int(3),

  `creditCardGateway` ENUM('WESTPAC','NAB','IPP', 'INLINE'),

  PRIMARY KEY (`healthProviderRulesId`),
  FOREIGN KEY (`providerId`) REFERENCES `ctm`.`provider_master`(`ProviderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`health_provider_rules_dependant_schools` (
  `healthProviderRulesDependantSchoolsId` int(11) NOT NULL AUTO_INCREMENT,
  `healthProviderRulesId` int(11) NOT NULL,

  `mustBeFullTimeStudent` TINYINT(1) NOT NULL,
  `schoolNameInputMethod` ENUM('SELECT','TEXT_INPUT','NONE') NOT NULL,
  `schoolNameLabel` varchar(50) NOT NULL,
  `studentIdRule` ENUM('MANDATORY','OPTIONAL','FALSE') NOT NULL,
  `studentIdMaximumLength` int(3) NOT NULL,
  `commencedDateRule` ENUM('MANDATORY','OPTIONAL','FALSE') NOT NULL,
  `apprenticeRule` ENUM('MANDATORY','OPTIONAL','FALSE') NOT NULL,

  PRIMARY KEY (`healthProviderRulesDependantSchoolsId`),
  FOREIGN KEY (`healthProviderRulesId`) REFERENCES `ctm`.`health_provider_rules`(`healthProviderRulesId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`health_provider_rules_deductions` (
  `healthProviderRulesDeductionsId` int(11) NOT NULL AUTO_INCREMENT,
  `healthProviderRulesId` int(11) NOT NULL,

  `selectionLabel` ENUM('DATE','DAY','NONE') NOT NULL,
  `selectionValue` ENUM('DATE','DAY','NONE') NOT NULL,
  `optionsLength` int(3) NOT NULL,
  `dateCalculationsStartFrom` ENUM('COVER_START','TODAY') NOT NULL,
  `dateCalculationStartOffset` int(3) NOT NULL,
  `dateCalculationsAcceptableDays` ENUM('1-28','1-27','1-31','1,15') NOT NULL,
  `dateCalculationsIncludeWeekends` TINYINT(1) NOT NULL,
  `deductionText` varchar(1000) NOT NULL,

  PRIMARY KEY (`healthProviderRulesDeductionsId`),
  FOREIGN KEY (`healthProviderRulesId`) REFERENCES `ctm`.`health_provider_rules`(`healthProviderRulesId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`health_provider_rules_declarations` (
  `healthProviderRulesDeclarationsId` int(11) NOT NULL AUTO_INCREMENT,
  `healthProviderRulesId` int(11) NOT NULL,

  `label` varchar(1000) NOT NULL,
  `onlineText` text NOT NULL,
  `callCentreText` text NOT NULL,

  PRIMARY KEY (`healthProviderRulesDeclarationsId`),
  FOREIGN KEY (`healthProviderRulesId`) REFERENCES `ctm`.`health_provider_rules`(`healthProviderRulesId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `ctm`.`health_provider_rules_inline_creditcards` (
  `healthProviderRulesInlineCreditCardsId` int(11) NOT NULL AUTO_INCREMENT,
  `healthProviderRulesId` int(11) NOT NULL,

  `visa` TINYINT(1) NOT NULL,
  `mastercard` TINYINT(1) NOT NULL,
  `amex` TINYINT(1) NOT NULL,
  `diners` TINYINT(1) NOT NULL,

  PRIMARY KEY (`healthProviderRulesInlineCreditCardsId`),
  FOREIGN KEY (`healthProviderRulesId`) REFERENCES `ctm`.`health_provider_rules`(`healthProviderRulesId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ctm`.`health_provider_rules_payment_frequencies` (
  `healthProviderRulesPaymentFrequenciesId` int(11) NOT NULL AUTO_INCREMENT,
  `healthProviderRulesId` int(11) NOT NULL,

  `weekly` TINYINT(1) NOT NULL,
  `fortnightly` TINYINT(1) NOT NULL,
  `monthly` TINYINT(1) NOT NULL,
  `quarterly` TINYINT(1) NOT NULL,
  `halfYearly` TINYINT(1) NOT NULL,
  `annually` TINYINT(1) NOT NULL,

  PRIMARY KEY (`healthProviderRulesPaymentFrequenciesId`),
  FOREIGN KEY (`healthProviderRulesId`) REFERENCES `ctm`.`health_provider_rules`(`healthProviderRulesId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;